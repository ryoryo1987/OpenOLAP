/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresColorDAO.java
 *  説明：色オブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/15
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import openolap.viewer.Color;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.CommonUtils;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;

/**
 *  クラス：PostgresColorDAO<br>
 *  説明：色オブジェクトの永続化を管理するクラスです。
 */
public class PostgresColorDAO implements ColorDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresColorDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 * 色オブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresColorDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** メソッド **********

	/**
	 * データソースより色設定を求め、レポートオブジェクトに登録する。
	 * @param report レポートオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void applyColor(Report report, Connection conn) throws SQLException {

		ArrayList<Color> colorList = new ArrayList<Color>();

		// SQL生成
		String SQL = "";
		SQL += "select ";
		SQL += "    edge_id_combo, ";
		SQL += "    edge_mem_key1, ";
		SQL += "    edge_mem_key2, ";
		SQL += "    edge_mem_key3, ";
		SQL += "    edge_mem_key4, ";
		SQL += "    edge_mem_key5, ";
		SQL += "    edge_mem_key6, ";
		SQL += "    headerFLG, ";
		SQL += "    html_color ";
		SQL += "from ";
		SQL += "    oo_v_color ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID() + " ";
		SQL += "order by ";
		SQL += "    edge_id_combo";
		
		// SQL実行
		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select header and data cell color)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			while ( rs.next() ) {

				// 色づけされたセルの座標を表すTreeMapを作成
				ArrayList<String> axisIdList = StringUtil.splitString(rs.getString("edge_id_combo"),",");
				TreeMap<Integer, String> axisIDAndMemberKeyMap = new TreeMap<Integer, String>();

				Iterator<String> axisIdIt = axisIdList.iterator();
				int i = 0;
				while (axisIdIt.hasNext()) {
					String axisId = axisIdIt.next();											// 軸ID
					String axisMemberKey = rs.getString("edge_mem_key"+Integer.toString(i+1));	// 上記軸内のメンバーKey
					axisIDAndMemberKeyMap.put(Integer.decode(axisId),axisMemberKey);
					i++;
				}

				// Colorオブジェクトを生成
				Color color = new Color( axisIDAndMemberKeyMap, 		// axisIDAndMemberKeyMap 
										  CommonUtils.FLGTobool(rs.getString("headerFLG")), // isHeader
										  rs.getString("html_color"));	// HTMLColor

				// 作成したColorオブジェクトをArrayListに追加
				colorList.add(color);

			}

		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if (rs != null){
					rs.close();
				}
			} catch (SQLException e) {
				throw e;
			} finally {
				try {
					if (stmt != null){
						stmt.close();
					}
				} catch (SQLException e) {
					throw e;
				}
			}
		}
		
		// レポートオブジェクトにColorオブジェクトの集合を登録
		report.addColor(colorList);

	}

	/**
	 * クライアント側から送られてきた色情報をサーバー側のモデルに反映する。<br>
	 * クライアントから受信した情報：<br>
	 *   ・dtColorInfo  ： データテーブル部の色情報
	 *   ・hdrColorInfo ： ヘッダー部の色情報
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定をあらわすオブジェクト
	 */
	public void registColor(RequestHelper helper, CommonSettings commonSettings) {

		// クライアントから受信した情報を取得
		HttpServletRequest request = helper.getRequest();
		String dtColorInfoListString = (String)request.getParameter("dtColorInfo");
		String hdrColorInfoListString = (String)request.getParameter("hdrColorInfo");

	  	Report report = (Report)request.getSession().getAttribute("report");

		// 色情報をクリア
		report.clearColorList();

		// データテーブルの色情報をReportオブジェクトに追加
		ArrayList<Color> dtColorInfoList = changeColorList(dtColorInfoListString, false);
		report.addColor(dtColorInfoList);

		// ヘッダの色情報をReportオブジェクトに追加
		ArrayList<Color> hdrColorInfoList = changeColorList(hdrColorInfoListString, true);
		report.addColor(hdrColorInfoList);

	}


	/**
	 * 色情報を永続化する。
	 * @param report レポートオブジェクト
	 * @param reportID レポートID
	 *                ※このパラメータがNULLの場合、Reportオブジェクトが持つレポートIDで色情報を保存する。
	 *                  NULLではない場合は、reportIDパラメータの値で色情報を保存する。
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void saveColor(Report report, String reportID, Connection conn) throws SQLException {

		// 保存対象となるレポートIDを求める
		String reportIDValue = null;
		if (reportID == null) {
			reportIDValue = report.getReportID();
		} else {
			reportIDValue = reportID;
		}

		// 既存の色設定は全て削除してからinsert
		// delete
		this.deleteColor(reportIDValue, conn);

		Iterator<Color> it = report.getColorList().iterator();
		while (it.hasNext()) {
			Color color = it.next();
			String edgeIdCombo = "";
			String[] edgeMemKey = new String[6];

			TreeMap<Integer, String> axisIDAndMemberKeyTree = color.getAxisIDAndMemberKeyMap();
			Iterator<Integer> keyIt = axisIDAndMemberKeyTree.keySet().iterator();
			int i = 0;
			while (keyIt.hasNext()) {
				if(i>0){
					edgeIdCombo += ",";
				}
				Integer key = keyIt.next();
				edgeIdCombo += key.toString();
				edgeMemKey[i] = axisIDAndMemberKeyTree.get(key);
				i++;
			}

			Statement stmt = conn.createStatement();
			try {
				// insert
				String SQL = "";
				SQL =  "";
				SQL += "INSERT INTO oo_v_color ";
				SQL += "       (report_id, edge_id_combo,";
				for (int j = 0; j < edgeMemKey.length; j++) {
					SQL +=            "edge_mem_key" + (j+1) +",";
				}
				SQL += "       headerflg, html_color) ";
				SQL += "values ( ";
				SQL +=                reportIDValue + ", ";
				SQL +=          "'" + edgeIdCombo + "', ";
				
				for (int j = 0; j < edgeMemKey.length; j++) {
					SQL +=            edgeMemKey[j] + ", ";
				}

				SQL +=          "'" + CommonUtils.boolToFLG(color.isHeader()) + "', ";
				SQL +=          "'" + color.getHtmlColor() + "'"; 
	            SQL +=        ")";

				if(log.isInfoEnabled()) {
					log.info("SQL(insert header and data cell color)：\n" + SQL);
				}
				int insertCount = stmt.executeUpdate(SQL);
				if (insertCount != 1) {
					throw new IllegalStateException();
				}

			} catch (IllegalStateException e) {
				throw e;
			} catch (SQLException e) {
				throw e;
			} finally {
				if (stmt != null) {
					stmt.close();
				}
			} 
		}
	}


	/**
	 * あたえられたレポートの色情報をデータソースから削除する。
	 * @param report レポートオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteColor(Report report, Connection conn) throws SQLException {

		deleteColor(report.getReportID(), conn);

	}


	/**
	 * あたえられたレポートの色情報をデータソースから削除する。
	 * @param reportID レポートID
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteColor(String reportID, Connection conn) throws SQLException {

		String SQL = "";
		SQL =  "";
		SQL += "delete from oo_v_color ";
		SQL += "where ";
		SQL += "    report_id=" + reportID;

		Statement stmt = conn.createStatement();
		try {
			if(log.isInfoEnabled()) {
				log.info("SQL(delete header and data cell color)：\n" + SQL);
			}
			stmt.executeUpdate(SQL);
		} catch (SQLException e) {
			throw e;
		} finally {
			if (stmt != null) {
				stmt.close();
			}
		} 
	}



	// ********** privateメソッド **********

	/**
	 * カラー情報文字列よりカラーオブジェクトのリストを生成する。
	 * @param sourceString カラー情報文字列
	 * @param isHeader 行・列ヘッダー部の色であればtrue、そうでないならばfalse
	 * @return カラーオブジェクトのリスト
	 */

	private ArrayList<Color> changeColorList(String sourceString, boolean isHeader) {

		ArrayList<Color> colorList = new ArrayList<Color>();	// Colorオブジェクトのリスト
		Color color = null;

		// データテーブルセルの色設定を追加
		ArrayList<String> colorInfoList = StringUtil.splitString(sourceString, ",");	// 「ID.Key:・・・:ID.Key;color」リスト
		Iterator<String> colorInfoIt = colorInfoList.iterator();


		int i = 0;
		while (colorInfoIt.hasNext()) {
			TreeMap<Integer, String> idKeyList = new TreeMap<Integer, String>();	// 軸ID(Key)と軸メンバKey(Value)

			String colorInfo = colorInfoIt.next();						// 「ID.Key:・・・:ID.Key;color」文字列
			ArrayList<String> comboKeyColorList = StringUtil.splitString(colorInfo,";");	// 「ID.Key:・・・:ID.Key」,「color」リスト

			String comboKeyListString = comboKeyColorList.get(0);	// 「ID.Key:・・・:ID.Key」文字列
			String colorString = comboKeyColorList.get(1);			// 「color」文字列

			ArrayList<String> comboKeyList = StringUtil.splitString(comboKeyListString, ":");	// 「ID.Key」のリスト
			Iterator<String> comboKeyIte = comboKeyList.iterator();

			while (comboKeyIte.hasNext()) {
				String comboKeyString = comboKeyIte.next();

				ArrayList<String> axisIDAndKey = StringUtil.splitString(comboKeyString, ".");

				idKeyList.put(Integer.decode(axisIDAndKey.get(0)), axisIDAndKey.get(1));	// 軸ID,メンバーキー

			}

			color = new Color( idKeyList, 			// axisIDAndMemberKeyMap 
							    isHeader, 			// isHeader
							    colorString);		// HTMLColor

			colorList.add(color);
			i++;
		}

		return colorList;

	}

}

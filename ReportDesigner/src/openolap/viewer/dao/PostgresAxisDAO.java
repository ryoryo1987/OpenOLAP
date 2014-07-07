/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresAxisDAO.java
 *  説明：軸オブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/13
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.AxisMember;
import openolap.viewer.Dimension;
import openolap.viewer.Edge;
import openolap.viewer.Measure;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.CommonUtils;
import openolap.viewer.common.Constants;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;


/**
 *  クラス：PostgresAxisDAO<br>
 *  説明：軸オブジェクトの永続化を管理するクラスです。
 */
public class PostgresAxisDAO implements AxisDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresAxisDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 * 軸オブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresAxisDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** メソッド **********

	/**
	 * クライアントから送信されたパラメータをもとに、軸のメンバのセレクタ選択情報、ドリル情報を反映する。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 */
	public void registSelectedMemberAndDrillStat(RequestHelper helper, CommonSettings commonSettings) {

		HttpServletRequest request = helper.getRequest();
		Report report = (Report)helper.getRequest().getSession().getAttribute("report");

		String axisID = null;
		for (int i = 0; i < report.getTotalDimensionNumber()+1; i++ ) {	// ディメンション＋１(メジャー)回実行

			if (i == report.getTotalDimensionNumber()) {	// メジャー
				axisID = Constants.MeasureID;
			} else {										// ディメンション
				axisID = Integer.toString(i+1);				// 軸IDは1startのため、補正。
			}

			String selectedMemberAndDrillStat = (String)request.getParameter("dim" + axisID);	// クライアントからの送信されてきたパラメータを取得

			// axisが持つメンバーの選択状況を順に更新
			Axis axis = report.getAxisByID(axisID);

			// セレクタ選択情報、ドリル情報を次元オブジェクトにセット
			if (!selectedMemberAndDrillStat.equals("")) {	// セレクタ選択情報もしくはドリル情報もしくはその両方が更新された

				// ある軸の選択済みであるメンバをKey,そのドリル状態をvalueとするHashMapを生成
				HashMap<String, String> memberNameDrillMap = new HashMap<String, String>();
				ArrayList<String> selectedMemberAndDrillStatList = StringUtil.splitString(selectedMemberAndDrillStat,",");
				Iterator<String> it = selectedMemberAndDrillStatList.iterator();
				while (it.hasNext()) {
					String aSelectedMemberAndDrillStat = it.next();
					ArrayList<String> aSelectedMemberAndDrillStatList = StringUtil.splitString(aSelectedMemberAndDrillStat,":");
				
					String selectedMemberUniqueName = aSelectedMemberAndDrillStatList.get(0); // 選択済みメンバのユニーク名
					String selectedMemberDrillStat  = aSelectedMemberAndDrillStatList.get(1); // ドリル状態(1:ドリル,0:未ドリル)
					memberNameDrillMap.put(selectedMemberUniqueName, selectedMemberDrillStat);
				}

				// メンバー情報、ドリル情報を更新
				if(axis instanceof Dimension){	// ディメンション
					Dimension dim = (Dimension)axis;
					dim.setSelectedMemberDrillStat(memberNameDrillMap);
				} else if (axis instanceof Measure){// メジャー：メジャーメンバに対し、セレクタで選択されたメンバかどうかを順に設定していく
					Iterator<AxisMember> axisMemIt = axis.getAxisMemberList().iterator();
					while (axisMemIt.hasNext()) {
						AxisMember axisMember = axisMemIt.next();
						if (memberNameDrillMap.containsKey(axisMember.getUniqueName())) {	// セレクタで選択されたメンバ
							axisMember.setIsSelected(true);
						} else {															// セレクタで選択されなかったメンバ
							axisMember.setIsSelected(false);
						}
					}
				}

				// デフォルトメンバー情報を更新(デフォルトメンバがセレクタで外された場合、デフォルトメンバ設定を初期化する)
				axis.modifyDefaultMember(memberNameDrillMap);

			} else {	// この軸にたいしては、今回セレクタ選択情報、ドリル情報が更新されなかった
				// 何もしない
			}
		}
	}


	/**
	 * データソースから取得したレポート設定をモデルに反映する。
	 * @param report Reportオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void applyAxis(Report report, CommonSettings commonSettings, Connection conn) throws SQLException {

		ArrayList<String> colIdList = new ArrayList<String>();
		ArrayList<String> rowIdList = new ArrayList<String>();
		ArrayList<String> pageIdList = new ArrayList<String>();
	
		String SQL = "";
		SQL += "select ";
		SQL += "    axis_id, ";
		SQL += "    dimension_seq, ";
		SQL += "    default_mem_key, ";
		SQL += "    selecter_usedFLG, ";
		SQL += "    edge_type, ";
		SQL += "    in_edge_index, ";
		SQL += "    disp_mem_name_type ";
		SQL += "from ";
		SQL += "    oo_v_axis ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID() + " ";
		SQL += "order by ";
		SQL += "    edge_type,in_edge_index";
	
		Statement stmt = null;
		ResultSet rs = null;
	
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select axes)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
			while ( rs.next() ) {

				String axisID = rs.getString("axis_id");

				// 配置場所情報を取得
				if (Constants.Col.equals(rs.getString("edge_type"))) {
					colIdList.add(axisID);	
				} else if (Constants.Row.equals(rs.getString("edge_type"))) {
					rowIdList.add(axisID);
				} else if (Constants.Page.equals(rs.getString("edge_type"))) {
					pageIdList.add(axisID);
				} else {
					throw new IllegalStateException();
				}

				// defaultMemberKey、isUsedSelecter、dispMemberNameTypeの更新
				Axis axis = report.getAxisByID(axisID);
				axis.setDefaultMemberKey(rs.getString("default_mem_key"));
				axis.setUsedSelecter(CommonUtils.FLGTobool(rs.getString("selecter_usedFLG")));
				if(!axis.isMeasure()) {
					((Dimension)axis).setDispMemberNameType(rs.getString("disp_mem_name_type"));
				}

				// メンバ情報の更新
				AxisMemberDAO axisMemberDAO = DAOFactory.getDAOFactory().getAxisMemberDAO(conn,axis);
				axisMemberDAO.applyAxis(report, axis, commonSettings);

			}

			// 配置場所情報を更新
			DAOFactory daoFactory = DAOFactory.getDAOFactory();
			daoFactory.getReportDAO(conn).registAxisPosition(colIdList, rowIdList, pageIdList, report);

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

	}

	/**
	 * クライアントから送信されたパラメータをもとに、モデルの軸メンバーのデフォルトメンバ情報を更新する。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 */
	public void registDefaultMember(RequestHelper helper, CommonSettings commonSettings) {
		
		HttpServletRequest request = helper.getRequest();
		String defaultMembers = (String)request.getParameter("defaultMembers");
//		if ( (defaultMembers == null) || ("".equals(defaultMembers))) {
//			throw new IllegalStateException();
//		}
		// 書式：＜軸ID.軸のUNameの繰り返し(カンマ区切り、軸IDの昇順)＞
		// 　　　例：1.0,2.NA,16.0
		//　　　　　　1.0:AxisID=1のディメンションのデフォルトメンバのUName
		//　　　　　　2.NA:AxisID=2のディメンションのデフォルトメンバのUName（未設定の場合は、NAという文字列）
		//　　　　　　16.0:AxisID=16(メジャー)のデフォルトメンバのUName

		Report report = (Report)helper.getRequest().getSession().getAttribute("report");

		ArrayList<String> defaultMemberList = StringUtil.splitString(defaultMembers, ",");
		Iterator<String> it = defaultMemberList.iterator();
		int measureIndex = defaultMemberList.size();
//System.out.println("measureIndex:" + measureIndex);

		while (it.hasNext()) {

			//軸情報、デフォルトメンバ情報を取得
			String axisIdAndDefaultMemberString = it.next();
			ArrayList<String> axisIdAndDefaultMemberList = StringUtil.splitString(axisIdAndDefaultMemberString, ".");
			String axisID        = axisIdAndDefaultMemberList.get(0);
			String defaultMember = axisIdAndDefaultMemberList.get(1);
		
			//デフォルトメンバが設定されていない状態をClient側では、「NA」で表す。
			if (defaultMember.equals("NA")) {
				defaultMember = null;
			}

//System.out.println("axisDAO axisID" + axisID);
			report.getAxisByID(axisID).setDefaultMemberKey(defaultMember);	// デフォルトメンバ情報を更新

		}
	}

	/**
	 * 軸情報をデータソースへ保存する。
	 * @param report Reportオブジェクト
	 * @param reportID レポートID
	 *                ※このパラメータがNULLの場合、Reportオブジェクトが持つレポートIDで軸情報を保存する。
	 *                  NULLではない場合は、reportIDパラメータの値で軸情報を保存する。
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void saveAxis(Report report, String reportID, Connection conn) throws SQLException {

		// 保存対象となるレポートIDを求める
		String reportIDValue = null;
		if (reportID == null) {
			reportIDValue = report.getReportID();
		} else {
			reportIDValue = reportID;
		}
		
		String SQL = "";
		Statement stmt = null;
		stmt = conn.createStatement();

		try {
		
			Iterator<Edge> edgeIt = report.getEdgeList().iterator();
			while (edgeIt.hasNext()) {
				Edge edge = edgeIt.next();
				Iterator<Axis> axisIt = edge.getAxisList().iterator();
	
				int axisIndex = 0;
				while (axisIt.hasNext()) {
					Axis axis = axisIt.next();
	
					String dispMemberNameType;
					String dimensionSeq;
					if(axis instanceof Dimension){
						dispMemberNameType = "'" + ((Dimension)axis).getDispMemberNameType() + "'";
						dimensionSeq = ((Dimension)axis).getDimensionSeq();
					} else {
						dispMemberNameType = "null";
						dimensionSeq = "0";
					}
	
					SQL =  "";
					SQL += "UPDATE oo_v_axis set";	
					SQL += "    default_mem_key=" + axis.getDefaultMemberKey() + ", ";
					SQL += "    dimension_seq=" + dimensionSeq + ", ";
					SQL += "    selecter_usedFLG='" + CommonUtils.boolToFLG(axis.isUsedSelecter()) + "', ";
					SQL += "    edge_type='" + edge.getPosition() + "', ";
					SQL += "    in_edge_index=" + axisIndex + ", ";
					SQL += "    disp_mem_name_type=" + dispMemberNameType + " ";
					SQL += "WHERE ";
					SQL += "    report_id=" + reportIDValue + " and ";
					SQL += "    axis_id=" + axis.getId();

						if(log.isInfoEnabled()) {
							log.info("SQL(update report)：\n" + SQL);
						}
						int updateCount = stmt.executeUpdate(SQL);
	
						// update件数が0の場合、新たにレコード作成
						if (updateCount == 0) {
	
							SQL = "";
							SQL += "INSERT INTO ";
							SQL += "    oo_v_axis ";
							SQL += "       (report_id, axis_id, dimension_seq, name, default_mem_key, selecter_usedflg, edge_type, in_edge_index, disp_mem_name_type) ";
							SQL += "values ( ";
							SQL +=                reportIDValue + ", ";
							SQL +=                axis.getId() + ", ";
							SQL +=                dimensionSeq + ", ";
							SQL +=          "'" + axis.getName() + "', ";
							SQL +=                axis.getDefaultMemberKey() + ", ";
							SQL +=          "'" + CommonUtils.boolToFLG(axis.isUsedSelecter()) + "', ";
							SQL +=          "'" + edge.getPosition() + "', ";
							SQL +=                axisIndex + ", ";
							SQL +=                dispMemberNameType;
							SQL +=         ")";

							if(log.isInfoEnabled()) {
								log.info("SQL(insert report)：\n" + SQL);
							}
							int insertCount = stmt.executeUpdate(SQL);
							if (insertCount != 1) {
								throw new IllegalStateException();
							}
						}

					// 軸メンバーの保存
						DAOFactory daoFactory = DAOFactory.getDAOFactory();
						AxisMemberDAO axisMemDAO = daoFactory.getAxisMemberDAO(conn, axis);
						axisMemDAO.saveAxisMember(report, reportID, axis, conn);

					axisIndex++;
				}
			}

		} catch (SQLException e) {
			throw e;
		} catch (IllegalStateException e) {
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

	/**
	 * 与えられたレポートの全ての軸の情報をデータソースから削除する。
	 * @param report Reportオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteAxes(Report report, Connection conn) throws SQLException {

		// 軸情報の削除
		String SQL = "";
		SQL =  "";
		SQL += "delete from oo_v_axis ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID();

		Statement stmt = null;
		try {
			stmt = conn.createStatement();

			if(log.isInfoEnabled()) {
				log.info("SQL(delete axis)：\n" + SQL);
			}
			stmt.executeUpdate(SQL);
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

		// 軸メンバの削除
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		AxisMemberDAO axisMemDAO = daoFactory.getAxisMemberDAO(conn, null);
		axisMemDAO.deleteAxisMember(report, conn);

	}

	/**
	 * 与えられた軸の情報をデータソースから削除する。
	 * @param report レポートオブジェクト
	 * @param axis 軸オブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteAxis(Report report, Axis axis, Connection conn) throws SQLException {

		String SQL = "";
		SQL =  "";
		SQL += "delete from oo_v_axis ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID() + " and ";
		SQL += "    axis_id=" + axis.getId();

		Statement stmt = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(delete all axes)：\n" + SQL);
			}
			stmt.executeUpdate(SQL);
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

}

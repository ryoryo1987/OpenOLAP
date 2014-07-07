/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresMeasureMemberDAO.java
 *  説明：メジャーメンバーオブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/07
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.AxisMember;
import openolap.viewer.Measure;
import openolap.viewer.MeasureMember;
import openolap.viewer.MeasureMemberType;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.CommonUtils;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;

/**
 *  クラス：PostgresMeasureMemberDAO<br>
 *  説明：メジャーメンバーオブジェクトの永続化を管理するクラスです。
 */
public class PostgresMeasureMemberDAO extends PostgresAxisMemberDAO implements MeasureMemberDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresMeasureMemberDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 *  メジャーメンバーオブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresMeasureMemberDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** メソッド **********

	/**
	 * メジャーメンバーをあらわすオブジェクトの集合をデータソースより求める。
	 * @param cubeSeq キューブシーケンス番号
	 * @param commonSettings アプリケーションの共通設定
	 * @return メジャーメンバーオブジェクトのリスト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public ArrayList<MeasureMember> selectMeasureMembers(String cubeSeq, CommonSettings commonSettings)  throws SQLException {

		// メジャーメンバ情報を取得
		ArrayList<MeasureMember> measureMemberList = new ArrayList<MeasureMember>();
		MeasureMember measureMem = null;
		String SQL = "";
		Statement stmt = null;
		ResultSet rs = null;

		SQL += "select ";
		SQL += "    distinct ";
		SQL += "        c.measure_seq, ";
		SQL +=  "        m.name, ";
		SQL +=  "        CASE ";
		SQL +=  "            WHEN c.mes_type = 1 THEN 1 ";
		SQL +=  "            WHEN c.mes_type = 2 THEN 2 ";
		SQL +=  "            ELSE 3 ";
		SQL +=  "        END ";
		SQL += "from ";
		SQL += "    oo_info_mes c,(select measure_seq,name from oo_measure union select formula_seq as measure_seq,name from oo_formula) m ";
		SQL += "where ";
		SQL += "c.cube_seq = " + cubeSeq + " and  ";
		SQL += "c.measure_seq=m.measure_seq ";
		SQL += "order by ";
		SQL +=  "    CASE ";
		SQL +=  "        WHEN c.mes_type = 1 THEN 1 ";
		SQL +=  "        WHEN c.mes_type = 2 THEN 2 ";
		SQL +=  "        ELSE 3 ";
		SQL +=  "    END, ";
		SQL += "    c.measure_seq ";

//		SQL =   "";
//		SQL +=	"select ";
//		SQL +=	"    distinct c.measure_seq,m.name  ";
//		SQL +=	"from ";
//		SQL +=	"    oo_info_mes c,(select measure_seq,name from oo_measure union select formula_seq as measure_seq,name from oo_formula) m ";
//		SQL +=	"where ";
//		SQL +=	"c.cube_seq = " + cubeSeq + " and  ";
//		SQL +=	"c.measure_seq=m.measure_seq ";
//		SQL +=	"order by c.measure_seq ";

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select measure members )：\n" + SQL);
			}
			rs   = stmt.executeQuery(SQL);

			int i=0;
			while ( rs.next() ) {
				measureMem = new MeasureMember(Integer.toString(i), 						// id
												rs.getString("name"), 						// measureName
												commonSettings.getFirstMeasureMemberType(), // measureMemberType
												Integer.toString(i+1), 						// uniqueName
												rs.getString("measure_seq"));				// measureSeq
//System.out.println("ID:" + Integer.toString(i) + "\nNAME:" + rs.getString("name") + "\nTYPE:" + commonSettings.getFirstMeasureMemberType().getName() );
				i++;
				measureMemberList.add(measureMem);
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

		return measureMemberList;
	}


	/**
	 * 与えられたレポートオブジェクトのメジャーメンバーをデータソースに保存されている情報をもとにを修正する。
	 * 修正する情報を下記に記します。
	 *   ・セレクトされたかどうか
	 *   ・メジャーメンバータイプ
	 * @param report レポートオブジェクト
	 * @param axis 軸をあらわすオブジェクト
	 * @param commonSettings アプリケーションの共通設定
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void applyAxis(Report report, Axis axis, CommonSettings commonSettings) throws SQLException {

		String SQL = null;
		ResultSet rs = null;
		Statement stmt = null;
		try {
			SQL = DAOFactory.getDAOFactory().getAxisMemberDAO(conn,axis).selectSaveDataSQL(report, axis);
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select measure members )：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			Measure Mem = (Measure) axis;
			ArrayList<AxisMember> measureMemList = axis.getAxisMemberList();

			int i = 0;
			while ( rs.next() ) {

				// セレクトされたかどうか、メジャーメンバータイプを更新
				MeasureMember measureMember = (MeasureMember)measureMemList.get(i);
				measureMember.setIsSelected(CommonUtils.FLGTobool(rs.getString("selectedFLG")));
				String measureMemberTypeID = rs.getString("measure_member_type_id");
				MeasureMemberType newMeasureMemberType = commonSettings.getMeasureMemberTypeByID(measureMemberTypeID);
				measureMember.setMeasureMemberType(newMeasureMemberType);

				i++;
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

	}

	/**
	 * メジャーメンバーのメジャーメンバータイプをクライアントから与えられた情報をもとに更新する。
	 * クライアントから与えられた情報："measureMemberTypes"パラメータ
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings 軸をあらわすオブジェクト
	 */
	public void registMeasureMemberType(RequestHelper helper, CommonSettings commonSettings) {

		HttpServletRequest request = helper.getRequest();
		String measureTypes = (String)request.getParameter("measureTypes");

		Report report = (Report)helper.getRequest().getSession().getAttribute("report");
	
		ArrayList<String> measureMemberIDTypeIDPairList = StringUtil.splitString(measureTypes,",");
		Iterator<String> it = measureMemberIDTypeIDPairList.iterator();
		while (it.hasNext()) {
			String measureMemberIDTypeIDPair = it.next();
			ArrayList<String> measureMemberIDTypeIDList = StringUtil.splitString(measureMemberIDTypeIDPair,":");

			String measureMemberID     = measureMemberIDTypeIDList.get(0);
			String measureMemberTypeID = measureMemberIDTypeIDList.get(1);

			MeasureMember measureMember = (MeasureMember) report.getMeasure().getAxisMemberByUniqueName(measureMemberID);
			MeasureMemberType newMeasureMemberType = commonSettings.getMeasureMemberTypeByID(measureMemberTypeID);

			measureMember.setMeasureMemberType(newMeasureMemberType);

//System.out.println(measureMember.getMeasureMemberType().getName());
			
		}

	}

	/**
	 * メジャーメンバーオブジェクトを永続化する。
	 * @param report レポートオブジェクト
	 * @param reportID レポートID
	 *                ※このパラメータがNULLの場合、Reportオブジェクトが持つレポートIDで軸メンバー情報を保存する。
	 *                  NULLではない場合は、reportIDパラメータの値で軸メンバー情報を保存する。

	 * @param axis 軸オブジェクト
	 * @param conn Connectionオブジェクト
	 */
	public void saveAxisMember(Report report, String reportID, Axis axis, Connection conn) throws SQLException {

		// レポートIDを設定
		String reportIDValue = null;
		if (reportID == null) {
			reportIDValue = report.getReportID();
		} else {
			reportIDValue = reportID;
		}

		Measure measure = null;
		if (axis instanceof Measure) {
			measure = (Measure) axis;
		} else {
			throw new IllegalArgumentException();
		}

		String SQL = "";
		Statement stmt = conn.createStatement();

		try {
			Iterator meaIt = measure.getAxisMemberList().iterator();
			while (meaIt.hasNext()) {
				MeasureMember measureMember = (MeasureMember) meaIt.next();
				
				SQL =  "";
				SQL += "UPDATE oo_v_axis_member set";
				SQL += "    dimension_seq=" + measureMember.getMeasureSeq() + ", ";
				SQL += "    selectedFLG=" + CommonUtils.boolToFLG(measureMember.isSelected()) + ", ";
				SQL += "    measure_member_type_id=" + measureMember.getMeasureMemberType().getId();
				SQL += "WHERE ";
				SQL += "    report_id=" + reportIDValue + " and ";
				SQL += "    axis_id=" + axis.getId() + " and ";
				SQL += "    member_key=" + measureMember.getUniqueName();

				if(log.isInfoEnabled()) {
					log.info("SQL(update measure members )：\n" + SQL);
				}
				int updateCount = stmt.executeUpdate(SQL);
	
				// update件数が0の場合、新たにレコード作成
				if (updateCount == 0) {
					SQL = "";
					SQL += "INSERT INTO ";
					SQL += "    oo_v_axis_member ";
					SQL += "       (report_id, axis_id, dimension_seq, member_key, selectedflg, drilledflg, measure_member_type_id) ";
					SQL += "values ( ";
					SQL +=                reportIDValue + ", ";					// report_id
					SQL +=                axis.getId() + ", ";					// axis_id
					SQL +=                measureMember.getMeasureSeq()	+ ", ";	// measure_seq
					SQL +=                measureMember.getUniqueName() + ", ";	// member_key
					SQL +=                "'" + CommonUtils.boolToFLG(measureMember.isSelected()) +  "', ";	// selectedFLG
					SQL +=                "'0', ";								// drilledFLG 常にfalse(-)。メジャーは階層を持たない為、ドリルすることができないため
					SQL +=                measureMember.getMeasureMemberType().getId();	// measureMemberType id
					SQL +=         ")";

					if(log.isInfoEnabled()) {
						log.info("SQL(insert measure members )：\n" + SQL);
					}
					int insertCount = stmt.executeUpdate(SQL);
					if (insertCount != 1) {
						throw new IllegalStateException();
					}
	
				}
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

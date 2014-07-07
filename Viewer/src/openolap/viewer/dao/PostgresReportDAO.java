/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresReportDAO.java
 *  説明：レポートオブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/07
 */
package openolap.viewer.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import openolap.viewer.Axis;
import openolap.viewer.Cube;
import openolap.viewer.Color;
import openolap.viewer.Edge;
import openolap.viewer.Dimension;
import openolap.viewer.Measure;
import openolap.viewer.Report;
import openolap.viewer.User;
import openolap.viewer.XMLConverter;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.common.Messages;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;


/**
 *  クラス：PostgresReportDAO
 *  説明：レポートオブジェクトの永続化を管理するクラスです。
 */
public class PostgresReportDAO implements ReportDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	/** DAOFactoryオブジェクト */
	DAOFactory daoFactory = DAOFactory.getDAOFactory();

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresReportDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 * レポートオブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresReportDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** メソッド **********

	/**
	 * キューブシーケンス番号をもとに、レポートオブジェクトを生成する。
	 * @param cubeSeq キューブシーケンス番号
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return レポートオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public Report getInitialReport(String cubeSeq, String userID, CommonSettings commonSettings) throws SQLException {

		String reportId = getInitialReportID(conn);
		String reportName = Report.getInitialReportName();
		String referenceReportID = Report.basicReportReferenceReportID;	// 参考レポートID
		Report report = getReport(reportId, reportName, userID, referenceReportID, Report.basicReportOwnerFLG, cubeSeq, commonSettings);
		
		report.setNewReport(true);// 新規レポートとして設定
		
		return report;
	}

	/**
	 * レポートオブジェクトを生成する。
	 * @param reportId レポートID
	 * @param reportName レポート名
	 * @param cubeSeq キューブシーケンス番号
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return レポートオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public Report getReport(String reportId, String reportName, String userID, String referenceReportID, String reportOwnerFLG, String cubeSeq, CommonSettings commonSettings) throws SQLException {
		DimensionDAO dimDAO = daoFactory.getDimensionDAO(conn);
		ArrayList<Dimension> dimList = dimDAO.selectDimensions(cubeSeq);				// Dimension

		MeasureDAO measureDAO = daoFactory.getMeasureDAO(conn);
		Measure measure = measureDAO.findMeasureWithMember(cubeSeq, commonSettings);	// Measure

		ArrayList<Edge> edgeList = Report.initializeEdge(dimList, measure);			// Edge List

		CubeDAO cubeDAO = daoFactory.getCubeDAO(conn);
		Cube cube = cubeDAO.getCubeByID(cubeSeq);

		ReportDAO reportDAO = daoFactory.getReportDAO(conn);
		Report report = new Report(reportId,									// reportID
									reportName,									// reportName
									userID,										// userID
									referenceReportID,							// referenceReportID
									reportOwnerFLG,								// reportOwnerFLG
									cube,										// cube
									edgeList,									// edgeList
									new ArrayList<Color>(),						// colorList
									Report.investigateTimeDimension(edgeList));	// hasTimeDim

		return report;
	}


	/**
	 * レポートIDをもとに既存のレポートオブジェクトを求める。
	 * @param reportId レポートID
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return レポートオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public Report getExistingReport(String reportId, RequestHelper helper, CommonSettings commonSettings) throws SQLException {

		// 初期状態のレポート設定を取得
		ReportInfo reportInfo = this.getReportInfo(reportId);
		// キューブが存在しない場合、nullを戻す
		if(!this.isCubeExist((String) reportInfo.getCubeSeq())) {
			return null;
		}

		User user = (User)helper.getRequest().getSession().getAttribute("user");
		String userID = reportInfo.getUserID();							// ユーザID
		String referenceReportID = reportInfo.getReferenceReportID();	// 参考レポートID
		String reportOwnerFLG = reportInfo.getReportOwnerFLG();			// 「1」：基本レポート
		Report report = getReport(reportId, (String) reportInfo.getReportName(), userID, referenceReportID, reportOwnerFLG, (String) reportInfo.getCubeSeq(), commonSettings);

		// Reportオブジェクトに格納先フォルダのIDを保存
		report.setParentID(((String) reportInfo.getParentID()));
		report.setHighLightXML(((String) reportInfo.getHighLightXML()));
//System.out.println("getHighLightXML:" + (String) reportInfo.getHighLightXML());
		if (reportInfo.getDisplayScreenType() != null) { // 取得結果がNULLでなければ(nullの場合は、Reportオブジェクトで事前設定されているデフォルト値を使用)
			report.setDisplayScreenType(reportInfo.getDisplayScreenType());
		}
		if (reportInfo.getCurrentChart() != null) { // 取得結果がNULLでなければ
			report.setCurrentChart(reportInfo.getCurrentChart());
		}
		if (reportInfo.getColortype() != null) {// 取得結果がNULLでなければ
			report.setColorType((String) reportInfo.getColortype()); // colorTypeをReportオブジェクトに格納
		}


		// キューブ構成が変更されている場合、既存のレポート情報を削除し、新たなレポート情報を保存する(nullの場合は、Reportオブジェクトで事前設定されているデフォルト値を使用)
		if ( isCubeChanged(reportId, (String) reportInfo.getCubeSeq()) ) {
			if(log.isInfoEnabled()) {
				log.info("キューブ構成が変更されているため、レポート情報を初期化します。\nreportID:" + reportId + ",cubeSeq:" + reportInfo.getCubeSeq());
			}

			// 既存レポート情報クリア
			DAOFactory daoFactory = DAOFactory.getDAOFactory();
			daoFactory.getAxisDAO(conn).deleteAxes(report,conn);// 軸
			daoFactory.getAxisMemberDAO(conn).deleteAxisMember(report,conn);// 軸メンバ
			daoFactory.getColorDAO(conn).deleteColor(report, conn); // 色

			// レポート情報保存
			this.saveReport(report, conn);

			// キューブ構成変更メッセージを保存
			String message = Messages.getString("PostgresReportDAO.reportInitMSG");
			helper.getRequest().setAttribute("message", message);


		} else { // キューブ構成に変更無しの場合、軸情報・色情報を更新する

			// 軸情報を更新
			AxisDAO axisDAO = daoFactory.getAxisDAO(conn);
			axisDAO.applyAxis(report, commonSettings, conn);
		
			// 色情報を更新
			ColorDAO colorDAO = daoFactory.getColorDAO(conn);
			colorDAO.applyColor(report, conn);
			
		}

		return report;
	}

	/**
	 * 未使用のレポートIDを取得を求める。
	 * @param conn Connectionオブジェクト
	 * @return 未使用のレポートID
	 * @exception SQLException 処理中に例外が発生した
	 */
	public String getInitialReportID(Connection conn) throws SQLException {

		Statement stmt = null;
		ResultSet rs = null;

		String new_rep_id = null;
		String SQL = "";
		SQL += "SELECT ";
		SQL += "    nextval('report_id') as new_rep_id";

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select axis members)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
			while(rs.next()){
				new_rep_id = Integer.toString(rs.getInt("new_rep_id"));
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

		return new_rep_id;

	}

	/**
	 * クライアントから送信されたレポートの名称、親フォルダ情報をモデルのレポートオブジェクトに反映する。
	 *   パラメータ名）
	 *     reportName：レポート名
	 *     folderID：レポートを格納するフォルダのID
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 */
	public void registReport(RequestHelper helper, CommonSettings commonSettings) {
		HttpServletRequest request = helper.getRequest();
		String reportName = (String)request.getParameter("reportName");
		String folderID = (String)request.getParameter("folderID");
	//	String highLightXML = (String)helper.getRequest().getSession().getAttribute("highLightXML");
//System.out.println("highLightXML:"+(String)helper.getRequest().getSession().getAttribute("highLightXML"));

		Report report = (Report)helper.getRequest().getSession().getAttribute("report");

		if ((reportName == null) || (folderID == null) ) {
			throw new IllegalStateException();
		}

		if (( request.getAttribute("mode") != null ) && 
		    ( request.getAttribute("mode").equals("saveNewReport"))) {
			report.setReportName(reportName);
			report.setParentID(folderID);
		}

	//	report.setHighLightXML(highLightXML);

//System.out.println(report.getHighLightXML());


	}

	/**
	 * クライアントから送信されたデフォルトメンバー、軸の配置情報をモデルのレポートオブジェクトに反映する。
	 *   パラメータ名）
	 *     defaultMembers：全軸のデフォルトメンバー情報
	 *     colItems：列エッジに配置された軸のID
	 *     rowItems：行エッジに配置された軸のID
	 *     pageItems：ページエッジに配置された軸のID
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 */
	public void registAxisPosition(RequestHelper helper, CommonSettings commonSettings) {

		HttpServletRequest request = helper.getRequest();
		String defaultMembers = (String)request.getParameter("defaultMembers");
		Report report = (Report)helper.getRequest().getSession().getAttribute("report");


		// クライアントから軸の配置情報を取得(カンマ区切りの軸ID)
		ArrayList<String> colAxesIDListFromClient = StringUtil.splitString((String)request.getParameter("colItems"), ",");
		ArrayList<String> rowAxesIDListFromClient = StringUtil.splitString((String)request.getParameter("rowItems"), ",");
		ArrayList<String> pageAxesIDListFromClient = StringUtil.splitString((String)request.getParameter("pageItems"), ",");

		registAxisPosition(colAxesIDListFromClient, rowAxesIDListFromClient, pageAxesIDListFromClient, report);

	}

	/**
	 * レポートの軸のエッジ配置情報を更新する。
	 * @param colItemList 列に配置された軸IDリスト
	 * @param rowItemList 行に配置された軸IDリスト
	 * @param pageItemList ページに配置された軸IDリスト
	 * @param report レポートをあらわすオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 */
	public void registAxisPosition(ArrayList<String> colItemList, ArrayList<String> rowItemList, ArrayList<String> pageItemList, Report report) {

		// 既存の軸をHashMapに退避
		HashMap<String, Axis> axisMap = new HashMap<String, Axis>();
		Iterator<Edge> it = report.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			Iterator<Axis> it2 = edge.getAxisList().iterator();
			while (it2.hasNext()) {
				Axis axis = it2.next();
				axisMap.put(axis.getId(),axis);
			}
		}

		// Colの配置情報を更新
		ArrayList<Axis> colAxesListFromModel = report.getEdgeByType(Constants.Col).getAxisList();
		replaceAxisList(colItemList, colAxesListFromModel, axisMap);

		// Rowの配置情報を更新
		ArrayList<Axis> rowAxesListFromModel = report.getEdgeByType(Constants.Row).getAxisList();
		replaceAxisList(rowItemList, rowAxesListFromModel, axisMap);

		// Pageの配置情報を更新
		ArrayList<Axis> pageAxesListFromModel = report.getEdgeByType(Constants.Page).getAxisList();
		replaceAxisList(pageItemList, pageAxesListFromModel, axisMap);
		
	}

	/**
	 * 新規個人レポートをデータソースへ保存する。
	 * @param report レポートをあらわすオブジェクト
	 * @param newReportName 新規レポート名
	 * @param userID ユーザID
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void saveNewPersonalReport(Report report, String newReportName, String userID, Connection conn)  throws SQLException {

	  String SQL = "";
      Statement stmt = conn.createStatement();

	  try {

		  //レポートIDはシーケンスより新規取得
		  String newReportID = this.getInitialReportID(conn);

		  SQL =  "";
		  SQL += "INSERT INTO oo_v_report ";
		  SQL += "       (report_id, par_id, report_name, user_id, reference_report_id, report_owner_flg, cube_seq, update_date, kind_flg, report_type, highlight_xml, displayscreentype, currentchart, colortype)";
		  SQL += "values (   "+ newReportID + ", ";						// レポートID
		  SQL +=                "null, ";								// ルートフォルダ直下に作成
		  SQL +=          "'" + newReportName + "', ";					// 新規レポート名
		  SQL +=          "'" + userID + "', ";							// ユーザID（ReportのuserIDはそのレポートを作成したユーザのIDであるため、使用しない）
		  SQL +=                report.getReportID() + ", ";			
		  SQL +=          "'" + Report.personalReportOwnerFLG + "', ";	// 「２」：個人レポート
		  SQL +=                report.getCube().getCubeSeq() + ", ";	
		  SQL +=                "now(), ";								// 更新日
		  SQL +=                "'R',";									// カインドフラグ（レポートか、フォルダかをあらわす）
		  SQL +=                "'M',";									// レポートタイプ（Mのレポートか、Rのレポートかを表す）
		  SQL +=          "'" + report.getHighLightXML() + "', ";
		  SQL +=          "'" + report.getDisplayScreenType() + "', ";
		  SQL +=          "'" + report.getCurrentChart() + "', ";
		  SQL +=          "'" + report.getColorType() + "' ";
		  SQL +=          ")";

		  if(log.isInfoEnabled()) {
			  log.info("SQL(insert new personal report)：\n" + SQL);
		  }
		  int count = stmt.executeUpdate(SQL);
		  if (count != 1) {
			  throw new IllegalStateException();
		  }
	
		  // 軸情報の保存
		  DAOFactory daoFactory = DAOFactory.getDAOFactory();
		  AxisDAO axisDAO = daoFactory.getAxisDAO(conn);
		  axisDAO.saveAxis(report, newReportID, conn);
	
		  // 色情報の保存
		  ColorDAO colorDAO = daoFactory.getColorDAO(conn);
		  colorDAO.saveColor(report, newReportID, conn);

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

	/**
	 * レポート情報をデータソースへ保存する。
	 * @param report レポートをあらわすオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void saveReport(Report report, Connection conn) throws SQLException {

		String SQL = "";

		// 基本レポート、個人レポートの更新
		SQL =  "";
		SQL += "UPDATE oo_v_report set";
		SQL += "    report_name='" + report.getReportName() + "', ";
//		SQL += "    user_id='" + report.getUserID() + "', ";
//		SQL += "    reference_report_id=" + report.getReferenceReportID() + ", ";
//		SQL += "    report_owner_flg='" + report.getReportOwnerFLG() + "', ";
		SQL += "    update_date=now(), ";
		SQL += "    par_id=" + report.getParentID() + ",";
		SQL += "    highlight_xml='" + report.getHighLightXML() + "', ";
		SQL += "    displayscreentype='" + report.getDisplayScreenType() + "', ";
		SQL += "    currentchart='" + report.getCurrentChart() + "', ";
		SQL += "    colortype='" + report.getColorType() + "' ";
		SQL += "WHERE ";
		SQL += "    report_id=" + report.getReportID();

		if(log.isInfoEnabled()) {
			log.info("SQL(update basic/personal report)：\n" + SQL);
		}
		Statement stmt = conn.createStatement();
		int updateCount = stmt.executeUpdate(SQL);

		try {
			// update件数が0の場合、基本レポートのレコード作成
			if (updateCount == 0) {
				SQL =  "";
				SQL += "INSERT INTO oo_v_report ";
				SQL += "       (report_id, par_id, report_name, user_id, reference_report_id, report_owner_flg, cube_seq, update_date, kind_flg, report_type, highlight_xml, displayscreentype, currentchart, colortype) ";
				SQL += "values ( "  + report.getReportID() + ", ";
				SQL +=                report.getParentID() + ", ";
				SQL +=          "'" + report.getReportName() + "', ";
				SQL +=          "'" + Report.basicReportUserID + "', ";		// 基本レポートの、user_id
				SQL +=                report.getReferenceReportID() + ", ";
				SQL +=          "'" + report.getReportOwnerFLG() + "', ";
				SQL +=                report.getCube().getCubeSeq() + ", ";
				SQL +=                "now(), ";								// 更新日
				SQL +=                "'R',";									// カインドフラグ（レポートか、フォルダかをあらわす）
				SQL +=                "'M',";									// レポートタイプ（Mのレポートか、Rのレポートかを表す）
				SQL +=          "'" + report.getHighLightXML() + "', ";
				SQL +=          "'" + report.getDisplayScreenType() + "', ";
				SQL +=          "'" + report.getCurrentChart() + "', ";
				SQL +=          "'" + report.getColorType() + "' ";
				SQL +=          ")";

				if(log.isInfoEnabled()) {
					log.info("SQL(insert new basic report)：\n" + SQL);
				}
				int count = stmt.executeUpdate(SQL);
				if (count != 1) {
					throw new IllegalStateException();
				}

				// 基本レポート新規作成時、セキュリティ情報も登録する
				if(report.isNewReport()) {
					SQL =  "";
					SQL += "INSERT INTO oo_v_group_report (group_id, report_id, right_flg, export_flg) ";
					SQL += "select group_id," + report.getReportID() + ",'1','1' from oo_v_group";

					if(log.isInfoEnabled()) {
						log.info("SQL(insert security information for new basic report)：\n" + SQL);
					}
					count = stmt.executeUpdate(SQL);
					if (count < 1) {
						throw new IllegalStateException();
					}
				}
			}		
	
			// 軸情報の保存
			DAOFactory daoFactory = DAOFactory.getDAOFactory();
			AxisDAO axisDAO = daoFactory.getAxisDAO(conn);
			axisDAO.saveAxis(report, null, conn);
	
			// 色情報の保存
			ColorDAO colorDAO = daoFactory.getColorDAO(conn);
			colorDAO.saveColor(report, null, conn);

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


	/**
	 * レポート情報をデータソースから削除する。
	 * @param report レポートをあらわすオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteReport(Report report, Connection conn) throws SQLException {

		// レポートオブジェクト自体を削除
		String SQL = "";
		SQL =  "";
		SQL += "delete from oo_v_report ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID();

		Statement stmt = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(delete report)：\n" + SQL);
			}
			stmt.executeUpdate(SQL);
		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if(stmt != null) {
					stmt.close();
				}
			} catch (SQLException e) {
				throw e;
			}
		}

		// 軸情報の削除
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		AxisDAO axisDAO = daoFactory.getAxisDAO(conn);
		axisDAO.deleteAxes(report, conn);

		// 色情報の削除
		ColorDAO colorDAO = daoFactory.getColorDAO(conn);
		colorDAO.deleteColor(report, conn);

	}

	public HashMap<String, String> getTemplateInfo(String sourceTable, String reportID) throws SQLException {

		Statement stmt = null;
		ResultSet rs = null;
		
		// SQL 生成
		String SQL = "";
		SQL += "select ";
		SQL += "    screen_xml, ";
		SQL += "    sql_text ";
		SQL += "from ";
		SQL +=      sourceTable + " ";
		SQL += "where ";
		SQL += "    report_id=" + reportID;

		HashMap<String, String> retMap = new HashMap<String, String>();

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(get Rreport metaInfo)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
			while(rs.next()){
				String screenXML = rs.getString("screen_xml");
				String sqlText   = rs.getString("sql_text");

				retMap.put("templateXMLString", screenXML);
				retMap.put("getDataSQL", sqlText);
			}
		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if(stmt != null) {
					stmt.close();
				}
			} catch (SQLException e) {
				throw e;
			}
		}

		return retMap;
		
	}


	/**
	 * データベースより、ドリルスルー先となるレポートの情報（IDと名称を格納したHashMap）を取得する。
	 * @param reportID: sourceTable の絞込み条件（レポートID）
	 * @return ドリルスルー先となるレポート情報を格納したHashMap
	 * @exception SQLException 処理中に例外が発生した
	 * @exception ParserConfigurationException 処理中に例外が発生した
	 * @exception SAXException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 * @exception TransformerException 処理中に例外が発生した
	 */
	public HashMap<String, String> getDrillThrowInfo(String reportID) throws SQLException, ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException {
		
		HashMap<String, String> drillTargetMap = new HashMap<String, String>();

		String xmlString = getDrillThrowInfoXML(reportID);
			if (xmlString == null) {
				return drillTargetMap;
			}

		XMLConverter xmlConv = new XMLConverter();
		Document doc = xmlConv.toXMLDocument(xmlString);

		NodeList nodes = xmlConv.selectNodes(doc, "//drill");
		int nodeLength = nodes.getLength();
		for (int i=0; i<nodeLength; i++) {
			Node node = nodes.item(i);
			if ( ((Element)node).getAttribute("target_report_id") != null ) {
				String targetRepID = ((Element)node).getAttribute("target_report_id");
				ReportInfo reportInfo = getReportInfo(targetRepID);
				String targetRepName = reportInfo.getReportName();

				drillTargetMap.put(targetRepID, targetRepName);
			}
		}

		return drillTargetMap;
		
	}


	/**
	 * データベースより、ドリルスルー先となるレポートの情報（XML形式）を取得する。
	 * @param reportID: sourceTable の絞込み条件（レポートID）
	 * @return ドリルスルー先となるレポート情報を格納したXML文字列
	 * @exception SQLException 処理中に例外が発生した
	 */
	private String getDrillThrowInfoXML(String reportID) throws SQLException {
		
		Statement stmt = null;
		ResultSet rs = null;
		
		// SQL 生成(個人レポートの場合は、親レポートのドリル情報を引き継ぐ。
		String SQL =  "select ";
		       SQL += "    case report_owner_flg ";
		       SQL += "        when '1' then drill_xml ";
		       SQL += "        else (select drill_xml from oo_v_report r2 where r1.reference_report_id = r2.report_id) ";
		       SQL += "    end as drill_xml ";
		       SQL += "from ";
		       SQL += "  oo_v_report r1 ";
		       SQL += "where ";
		       SQL += "  report_id="+reportID;

		String drillThrowInfo = null;

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(get Rreport drillThrowInfo)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
			while(rs.next()){
				drillThrowInfo = rs.getString("drill_xml");
			}
		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if(stmt != null) {
					stmt.close();
				}
			} catch (SQLException e) {
				throw e;
			}
		}

		return drillThrowInfo;		

	}

	// ********** 内部クラス **********

	/**
	 *  内部クラス：PostgresAxisDAO
	 *  説明：レポート情報を受け渡すための内部クラスです。
	 */
	class ReportInfo {

		String reportName = null;
		String cubeSeq = null;
		String parentID = null;
		String userID = null;				// ユーザID
		String referenceReportID = null;	// 参照元レポートID
		String reportOwnerFLG = null;		// レポートの種類
		String highLightXML = null;
		String displayScreenType = null;	// 画面分割スタイル
		String currentChart = null;		// 表示中のグラフ名
		String colortype = null;

		public void setReportName(String reportName){
			this.reportName = reportName;
		}
		public void setCubeSeq(String cubeSeq){
			this.cubeSeq = cubeSeq;
		}
		public void setParentID(String parentID){
			this.parentID = parentID;
		}
		public void setUserID(String userID){
			this.userID = userID;
		}
		public void setReferenceReportID(String referenceReportID){
			this.referenceReportID = referenceReportID;
		}
		public void setReportOwnerFLG(String reportOwnerFLG){
			this.reportOwnerFLG = reportOwnerFLG;
		}
		public void setHighLightXML(String highLightXML){
			this.highLightXML = highLightXML;
		}
		public void setDisplayScreenType(String displayScreenType) {
			this.displayScreenType = displayScreenType;
		}
		public void setCurrentChart(String currentChart) {
			this.currentChart = currentChart;
		}
		public void setColortype(String colortype) {
			this.colortype = colortype;
			
		}

		public String getReportName() {
			return this.reportName;
		}
		public String getCubeSeq() {
			return this.cubeSeq;
		}
		public String getParentID() {
			return this.parentID;
		}
		public String getUserID() {
			return this.userID;
		}
		public String getReferenceReportID() {
			return this.referenceReportID;
		}
		public String getReportOwnerFLG() {
			return this.reportOwnerFLG;
		}
		public String getHighLightXML() {
			return this.highLightXML;
		}
		public String getDisplayScreenType() {
			return this.displayScreenType;
		}
		public String getCurrentChart() {
			return this.currentChart;
		}
		public String getColortype() {
			return this.colortype;
		}

	}

	// ********** privateメソッド **********

	/**
	 * レポート情報を格納するReportInfoクラスを求める。
	 * @param reportId レポートID
	 * @exception SQLException 処理中に例外が発生した
	 */
	private ReportInfo getReportInfo(String reportId) throws SQLException {

		String reportName = null;
		String cubeSeq = null;
		String parentID = null;
		String userID = null;
		String referenceReportID = null;
		String reportOwnerFLG = null;
		String highLightXML = null;
		String displayscreentype = null;
		String currentchart = null;
		String colortype = null;

		String SQL = "";
		SQL += "select ";
		SQL += "    report_name,";				// レポート名
		SQL += "    cube_seq, ";				// CubeSeq
		SQL += "    par_id, ";					// レポート格納先のフォルダ情報
		SQL += "    user_id, ";					// ユーザID
		SQL += "    reference_report_id, ";		// 参照元レポートID
		SQL += "    report_owner_flg, ";		// レポートの種類
		SQL += "    highlight_xml, ";			
		SQL += "    displayscreentype, ";		// 画面分割スタイル
		SQL += "    currentchart, ";			// 表示中のグラフ名
		SQL += "    colortype ";			// 表示中のグラフ名
		SQL += "from ";
		SQL += "    oo_v_report ";
		SQL += "where ";
		SQL += "    report_id=" + reportId;

		Statement stmt = null;
		ResultSet rs = null;
		ReportInfo reportInfo = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select report)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
	
			while ( rs.next() ) {
				reportName = rs.getString("report_name");
				cubeSeq = rs.getString("cube_seq");
				parentID = rs.getString("par_id");
				userID = rs.getString("user_id");
				referenceReportID = rs.getString("reference_report_id");
				reportOwnerFLG = rs.getString("report_owner_flg");			
				highLightXML = rs.getString("highlight_xml");
				displayscreentype = rs.getString("displayscreentype");
				currentchart = rs.getString("currentchart");
				colortype = rs.getString("colortype");
			}

			reportInfo = new ReportInfo();
			reportInfo.setReportName(reportName);
			reportInfo.setCubeSeq(cubeSeq);
			reportInfo.setParentID(parentID);
			reportInfo.setUserID(userID);
			reportInfo.setReferenceReportID(referenceReportID);
			reportInfo.setReportOwnerFLG(reportOwnerFLG);
			reportInfo.setHighLightXML(highLightXML);
			reportInfo.setDisplayScreenType(displayscreentype);
			reportInfo.setCurrentChart(currentchart);
			reportInfo.setColortype(colortype);

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

		return reportInfo;

	}


	/**
	 * レポートを構成するキューブが存在するか（削除されていないか）をチェックする。
	 * 存在する場合true、存在しない場合falseを戻す。
	 * @param cubeSeq キューブシーケンス番号
	 * @return レポートを構成するキューブが存在するか
	 * @exception SQLException 処理中に例外が発生した
	 */
	private boolean isCubeExist(String cubeSeq) throws SQLException {
		
		String SQL = "";
		SQL += "select  ";
		SQL += "	cube_seq ";
		SQL += "from ";
		SQL += "    oo_info_cube ";
		SQL += "where cube_seq=" + cubeSeq ;

		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select isCubeExist)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			int i = 0;
			while(rs.next()){
				i++;
				if ( i>=1 ) {	// キューブ構成が変更されている
					return true;
				}
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

		return false;	// レポートを構成するキューブが削除された
	}


	/**
	 * レポートに保存された状態からキューブ構成が変更されたかどうかをチェックする。
	 * 構成が変更された場合true、変更されていない場合falseを戻す。
	 * @param reportId レポートID
	 * @param cubeSeq キューブシーケンス番号
	 * @return 構成が変更されたか
	 * @exception SQLException 処理中に例外が発生した
	 */
	private boolean isCubeChanged(String reportId, String cubeSeq) throws SQLException {
		
		String SQL = "";
		SQL += "select  ";
		SQL += "    distinct r.cube_seq,d.dimension_seq ";
		SQL += "from  ";
		SQL += "    oo_v_report r,oo_v_axis d ";
		SQL += "where  ";
		SQL += "    r.report_id=d.report_id and  ";
		SQL += "    r.report_id=" + reportId + " and  ";
		SQL += "    d.dimension_seq!=0 ";	// メジャーではない
		SQL += "except ";
		SQL += "select ";
		SQL += "    cube_seq,dimension_seq  ";
		SQL += "from  ";
		SQL += "    oo_info_dim ";
		SQL += "where  ";
		SQL += "    cube_seq=" + cubeSeq;

		String SQL2 = "";
		SQL2 += "select ";
		SQL2 += "    cube_seq,dimension_seq  ";
		SQL2 += "from  ";
		SQL2 += "    oo_info_dim ";
		SQL2 += "where  ";
		SQL2 += "    cube_seq=" + cubeSeq + " ";
		SQL2 += "except ";
		SQL2 += "select  ";
		SQL2 += "    distinct r.cube_seq,d.dimension_seq ";
		SQL2 += "from  ";
		SQL2 += "    oo_v_report r,oo_v_axis d ";
		SQL2 += "where  ";
		SQL2 += "    r.report_id=d.report_id and  ";
		SQL2 += "    r.report_id=" + reportId + " and  ";
		SQL2 += "    d.dimension_seq!=0 ";	// メジャーではない
		
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			// SQL1実行
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select isCubeChanged 1)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
			int i = 0;
			while(rs.next()){
				i++;
				if ( i>0 ) {	// キューブ構成が変更されている
					return true;
				}
			}

			// SQL2実行
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select isCubeChanged 2)：\n" + SQL2);
			}
			rs = stmt.executeQuery(SQL2);
			i = 0;
			while(rs.next()){
				i++;
				if ( i>0 ) {	// キューブ構成が変更されている
					return true;
				}
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

		return false;	// キューブ構成が変更されていない
	}

	/**
	 * 既存のモデルから軸情報を削除し、与えられたエッジを再追加する。
	 * @param edgeAxesIDListFromClient 列、行、もしくはページエッジに配置された軸IDのリスト
	 * @param edgeAxesListFromModel レポートに配置された列、行、もしくはページエッジの軸オブジェクトリスト
	 * @param axisMap 軸IDと軸オブジェクトをあらわすMapオブジェクト
	 */
	private void replaceAxisList(ArrayList<String> edgeAxesIDListFromClient, ArrayList<Axis> edgeAxesListFromModel, HashMap<String, Axis> axisMap) {

		edgeAxesListFromModel.clear();								// エッジをクリア

		Iterator<String> it = edgeAxesIDListFromClient.iterator();	// エッジに追加
		while(it.hasNext()){
			edgeAxesListFromModel.add(axisMap.get(it.next()));
		}

	}

}

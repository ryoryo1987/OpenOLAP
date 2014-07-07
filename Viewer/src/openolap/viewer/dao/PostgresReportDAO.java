/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresReportDAO.java
 *  �����F���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/07
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
 *  �N���X�FPostgresReportDAO
 *  �����F���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresReportDAO implements ReportDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	/** DAOFactory�I�u�W�F�N�g */
	DAOFactory daoFactory = DAOFactory.getDAOFactory();

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresReportDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 * ���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresReportDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** ���\�b�h **********

	/**
	 * �L���[�u�V�[�P���X�ԍ������ƂɁA���|�[�g�I�u�W�F�N�g�𐶐�����B
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return ���|�[�g�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public Report getInitialReport(String cubeSeq, String userID, CommonSettings commonSettings) throws SQLException {

		String reportId = getInitialReportID(conn);
		String reportName = Report.getInitialReportName();
		String referenceReportID = Report.basicReportReferenceReportID;	// �Q�l���|�[�gID
		Report report = getReport(reportId, reportName, userID, referenceReportID, Report.basicReportOwnerFLG, cubeSeq, commonSettings);
		
		report.setNewReport(true);// �V�K���|�[�g�Ƃ��Đݒ�
		
		return report;
	}

	/**
	 * ���|�[�g�I�u�W�F�N�g�𐶐�����B
	 * @param reportId ���|�[�gID
	 * @param reportName ���|�[�g��
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return ���|�[�g�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
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
	 * ���|�[�gID�����ƂɊ����̃��|�[�g�I�u�W�F�N�g�����߂�B
	 * @param reportId ���|�[�gID
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return ���|�[�g�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public Report getExistingReport(String reportId, RequestHelper helper, CommonSettings commonSettings) throws SQLException {

		// ������Ԃ̃��|�[�g�ݒ���擾
		ReportInfo reportInfo = this.getReportInfo(reportId);
		// �L���[�u�����݂��Ȃ��ꍇ�Anull��߂�
		if(!this.isCubeExist((String) reportInfo.getCubeSeq())) {
			return null;
		}

		User user = (User)helper.getRequest().getSession().getAttribute("user");
		String userID = reportInfo.getUserID();							// ���[�UID
		String referenceReportID = reportInfo.getReferenceReportID();	// �Q�l���|�[�gID
		String reportOwnerFLG = reportInfo.getReportOwnerFLG();			// �u1�v�F��{���|�[�g
		Report report = getReport(reportId, (String) reportInfo.getReportName(), userID, referenceReportID, reportOwnerFLG, (String) reportInfo.getCubeSeq(), commonSettings);

		// Report�I�u�W�F�N�g�Ɋi�[��t�H���_��ID��ۑ�
		report.setParentID(((String) reportInfo.getParentID()));
		report.setHighLightXML(((String) reportInfo.getHighLightXML()));
//System.out.println("getHighLightXML:" + (String) reportInfo.getHighLightXML());
		if (reportInfo.getDisplayScreenType() != null) { // �擾���ʂ�NULL�łȂ����(null�̏ꍇ�́AReport�I�u�W�F�N�g�Ŏ��O�ݒ肳��Ă���f�t�H���g�l���g�p)
			report.setDisplayScreenType(reportInfo.getDisplayScreenType());
		}
		if (reportInfo.getCurrentChart() != null) { // �擾���ʂ�NULL�łȂ����
			report.setCurrentChart(reportInfo.getCurrentChart());
		}
		if (reportInfo.getColortype() != null) {// �擾���ʂ�NULL�łȂ����
			report.setColorType((String) reportInfo.getColortype()); // colorType��Report�I�u�W�F�N�g�Ɋi�[
		}


		// �L���[�u�\�����ύX����Ă���ꍇ�A�����̃��|�[�g�����폜���A�V���ȃ��|�[�g����ۑ�����(null�̏ꍇ�́AReport�I�u�W�F�N�g�Ŏ��O�ݒ肳��Ă���f�t�H���g�l���g�p)
		if ( isCubeChanged(reportId, (String) reportInfo.getCubeSeq()) ) {
			if(log.isInfoEnabled()) {
				log.info("�L���[�u�\�����ύX����Ă��邽�߁A���|�[�g�������������܂��B\nreportID:" + reportId + ",cubeSeq:" + reportInfo.getCubeSeq());
			}

			// �������|�[�g���N���A
			DAOFactory daoFactory = DAOFactory.getDAOFactory();
			daoFactory.getAxisDAO(conn).deleteAxes(report,conn);// ��
			daoFactory.getAxisMemberDAO(conn).deleteAxisMember(report,conn);// �������o
			daoFactory.getColorDAO(conn).deleteColor(report, conn); // �F

			// ���|�[�g���ۑ�
			this.saveReport(report, conn);

			// �L���[�u�\���ύX���b�Z�[�W��ۑ�
			String message = Messages.getString("PostgresReportDAO.reportInitMSG");
			helper.getRequest().setAttribute("message", message);


		} else { // �L���[�u�\���ɕύX�����̏ꍇ�A�����E�F�����X�V����

			// �������X�V
			AxisDAO axisDAO = daoFactory.getAxisDAO(conn);
			axisDAO.applyAxis(report, commonSettings, conn);
		
			// �F�����X�V
			ColorDAO colorDAO = daoFactory.getColorDAO(conn);
			colorDAO.applyColor(report, conn);
			
		}

		return report;
	}

	/**
	 * ���g�p�̃��|�[�gID���擾�����߂�B
	 * @param conn Connection�I�u�W�F�N�g
	 * @return ���g�p�̃��|�[�gID
	 * @exception SQLException �������ɗ�O����������
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
				log.info("SQL(select axis members)�F\n" + SQL);
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
	 * �N���C�A���g���瑗�M���ꂽ���|�[�g�̖��́A�e�t�H���_�������f���̃��|�[�g�I�u�W�F�N�g�ɔ��f����B
	 *   �p�����[�^���j
	 *     reportName�F���|�[�g��
	 *     folderID�F���|�[�g���i�[����t�H���_��ID
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
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
	 * �N���C�A���g���瑗�M���ꂽ�f�t�H���g�����o�[�A���̔z�u�������f���̃��|�[�g�I�u�W�F�N�g�ɔ��f����B
	 *   �p�����[�^���j
	 *     defaultMembers�F�S���̃f�t�H���g�����o�[���
	 *     colItems�F��G�b�W�ɔz�u���ꂽ����ID
	 *     rowItems�F�s�G�b�W�ɔz�u���ꂽ����ID
	 *     pageItems�F�y�[�W�G�b�W�ɔz�u���ꂽ����ID
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 */
	public void registAxisPosition(RequestHelper helper, CommonSettings commonSettings) {

		HttpServletRequest request = helper.getRequest();
		String defaultMembers = (String)request.getParameter("defaultMembers");
		Report report = (Report)helper.getRequest().getSession().getAttribute("report");


		// �N���C�A���g���玲�̔z�u�����擾(�J���}��؂�̎�ID)
		ArrayList<String> colAxesIDListFromClient = StringUtil.splitString((String)request.getParameter("colItems"), ",");
		ArrayList<String> rowAxesIDListFromClient = StringUtil.splitString((String)request.getParameter("rowItems"), ",");
		ArrayList<String> pageAxesIDListFromClient = StringUtil.splitString((String)request.getParameter("pageItems"), ",");

		registAxisPosition(colAxesIDListFromClient, rowAxesIDListFromClient, pageAxesIDListFromClient, report);

	}

	/**
	 * ���|�[�g�̎��̃G�b�W�z�u�����X�V����B
	 * @param colItemList ��ɔz�u���ꂽ��ID���X�g
	 * @param rowItemList �s�ɔz�u���ꂽ��ID���X�g
	 * @param pageItemList �y�[�W�ɔz�u���ꂽ��ID���X�g
	 * @param report ���|�[�g������킷�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 */
	public void registAxisPosition(ArrayList<String> colItemList, ArrayList<String> rowItemList, ArrayList<String> pageItemList, Report report) {

		// �����̎���HashMap�ɑޔ�
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

		// Col�̔z�u�����X�V
		ArrayList<Axis> colAxesListFromModel = report.getEdgeByType(Constants.Col).getAxisList();
		replaceAxisList(colItemList, colAxesListFromModel, axisMap);

		// Row�̔z�u�����X�V
		ArrayList<Axis> rowAxesListFromModel = report.getEdgeByType(Constants.Row).getAxisList();
		replaceAxisList(rowItemList, rowAxesListFromModel, axisMap);

		// Page�̔z�u�����X�V
		ArrayList<Axis> pageAxesListFromModel = report.getEdgeByType(Constants.Page).getAxisList();
		replaceAxisList(pageItemList, pageAxesListFromModel, axisMap);
		
	}

	/**
	 * �V�K�l���|�[�g���f�[�^�\�[�X�֕ۑ�����B
	 * @param report ���|�[�g������킷�I�u�W�F�N�g
	 * @param newReportName �V�K���|�[�g��
	 * @param userID ���[�UID
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void saveNewPersonalReport(Report report, String newReportName, String userID, Connection conn)  throws SQLException {

	  String SQL = "";
      Statement stmt = conn.createStatement();

	  try {

		  //���|�[�gID�̓V�[�P���X���V�K�擾
		  String newReportID = this.getInitialReportID(conn);

		  SQL =  "";
		  SQL += "INSERT INTO oo_v_report ";
		  SQL += "       (report_id, par_id, report_name, user_id, reference_report_id, report_owner_flg, cube_seq, update_date, kind_flg, report_type, highlight_xml, displayscreentype, currentchart, colortype)";
		  SQL += "values (   "+ newReportID + ", ";						// ���|�[�gID
		  SQL +=                "null, ";								// ���[�g�t�H���_�����ɍ쐬
		  SQL +=          "'" + newReportName + "', ";					// �V�K���|�[�g��
		  SQL +=          "'" + userID + "', ";							// ���[�UID�iReport��userID�͂��̃��|�[�g���쐬�������[�U��ID�ł��邽�߁A�g�p���Ȃ��j
		  SQL +=                report.getReportID() + ", ";			
		  SQL +=          "'" + Report.personalReportOwnerFLG + "', ";	// �u�Q�v�F�l���|�[�g
		  SQL +=                report.getCube().getCubeSeq() + ", ";	
		  SQL +=                "now(), ";								// �X�V��
		  SQL +=                "'R',";									// �J�C���h�t���O�i���|�[�g���A�t�H���_��������킷�j
		  SQL +=                "'M',";									// ���|�[�g�^�C�v�iM�̃��|�[�g���AR�̃��|�[�g����\���j
		  SQL +=          "'" + report.getHighLightXML() + "', ";
		  SQL +=          "'" + report.getDisplayScreenType() + "', ";
		  SQL +=          "'" + report.getCurrentChart() + "', ";
		  SQL +=          "'" + report.getColorType() + "' ";
		  SQL +=          ")";

		  if(log.isInfoEnabled()) {
			  log.info("SQL(insert new personal report)�F\n" + SQL);
		  }
		  int count = stmt.executeUpdate(SQL);
		  if (count != 1) {
			  throw new IllegalStateException();
		  }
	
		  // �����̕ۑ�
		  DAOFactory daoFactory = DAOFactory.getDAOFactory();
		  AxisDAO axisDAO = daoFactory.getAxisDAO(conn);
		  axisDAO.saveAxis(report, newReportID, conn);
	
		  // �F���̕ۑ�
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
	 * ���|�[�g�����f�[�^�\�[�X�֕ۑ�����B
	 * @param report ���|�[�g������킷�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void saveReport(Report report, Connection conn) throws SQLException {

		String SQL = "";

		// ��{���|�[�g�A�l���|�[�g�̍X�V
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
			log.info("SQL(update basic/personal report)�F\n" + SQL);
		}
		Statement stmt = conn.createStatement();
		int updateCount = stmt.executeUpdate(SQL);

		try {
			// update������0�̏ꍇ�A��{���|�[�g�̃��R�[�h�쐬
			if (updateCount == 0) {
				SQL =  "";
				SQL += "INSERT INTO oo_v_report ";
				SQL += "       (report_id, par_id, report_name, user_id, reference_report_id, report_owner_flg, cube_seq, update_date, kind_flg, report_type, highlight_xml, displayscreentype, currentchart, colortype) ";
				SQL += "values ( "  + report.getReportID() + ", ";
				SQL +=                report.getParentID() + ", ";
				SQL +=          "'" + report.getReportName() + "', ";
				SQL +=          "'" + Report.basicReportUserID + "', ";		// ��{���|�[�g�́Auser_id
				SQL +=                report.getReferenceReportID() + ", ";
				SQL +=          "'" + report.getReportOwnerFLG() + "', ";
				SQL +=                report.getCube().getCubeSeq() + ", ";
				SQL +=                "now(), ";								// �X�V��
				SQL +=                "'R',";									// �J�C���h�t���O�i���|�[�g���A�t�H���_��������킷�j
				SQL +=                "'M',";									// ���|�[�g�^�C�v�iM�̃��|�[�g���AR�̃��|�[�g����\���j
				SQL +=          "'" + report.getHighLightXML() + "', ";
				SQL +=          "'" + report.getDisplayScreenType() + "', ";
				SQL +=          "'" + report.getCurrentChart() + "', ";
				SQL +=          "'" + report.getColorType() + "' ";
				SQL +=          ")";

				if(log.isInfoEnabled()) {
					log.info("SQL(insert new basic report)�F\n" + SQL);
				}
				int count = stmt.executeUpdate(SQL);
				if (count != 1) {
					throw new IllegalStateException();
				}

				// ��{���|�[�g�V�K�쐬���A�Z�L�����e�B�����o�^����
				if(report.isNewReport()) {
					SQL =  "";
					SQL += "INSERT INTO oo_v_group_report (group_id, report_id, right_flg, export_flg) ";
					SQL += "select group_id," + report.getReportID() + ",'1','1' from oo_v_group";

					if(log.isInfoEnabled()) {
						log.info("SQL(insert security information for new basic report)�F\n" + SQL);
					}
					count = stmt.executeUpdate(SQL);
					if (count < 1) {
						throw new IllegalStateException();
					}
				}
			}		
	
			// �����̕ۑ�
			DAOFactory daoFactory = DAOFactory.getDAOFactory();
			AxisDAO axisDAO = daoFactory.getAxisDAO(conn);
			axisDAO.saveAxis(report, null, conn);
	
			// �F���̕ۑ�
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
	 * ���|�[�g�����f�[�^�\�[�X����폜����B
	 * @param report ���|�[�g������킷�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteReport(Report report, Connection conn) throws SQLException {

		// ���|�[�g�I�u�W�F�N�g���̂��폜
		String SQL = "";
		SQL =  "";
		SQL += "delete from oo_v_report ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID();

		Statement stmt = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(delete report)�F\n" + SQL);
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

		// �����̍폜
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		AxisDAO axisDAO = daoFactory.getAxisDAO(conn);
		axisDAO.deleteAxes(report, conn);

		// �F���̍폜
		ColorDAO colorDAO = daoFactory.getColorDAO(conn);
		colorDAO.deleteColor(report, conn);

	}

	public HashMap<String, String> getTemplateInfo(String sourceTable, String reportID) throws SQLException {

		Statement stmt = null;
		ResultSet rs = null;
		
		// SQL ����
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
				log.info("SQL(get Rreport metaInfo)�F\n" + SQL);
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
	 * �f�[�^�x�[�X���A�h�����X���[��ƂȂ郌�|�[�g�̏��iID�Ɩ��̂��i�[����HashMap�j���擾����B
	 * @param reportID: sourceTable �̍i���ݏ����i���|�[�gID�j
	 * @return �h�����X���[��ƂȂ郌�|�[�g�����i�[����HashMap
	 * @exception SQLException �������ɗ�O����������
	 * @exception ParserConfigurationException �������ɗ�O����������
	 * @exception SAXException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 * @exception TransformerException �������ɗ�O����������
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
	 * �f�[�^�x�[�X���A�h�����X���[��ƂȂ郌�|�[�g�̏��iXML�`���j���擾����B
	 * @param reportID: sourceTable �̍i���ݏ����i���|�[�gID�j
	 * @return �h�����X���[��ƂȂ郌�|�[�g�����i�[����XML������
	 * @exception SQLException �������ɗ�O����������
	 */
	private String getDrillThrowInfoXML(String reportID) throws SQLException {
		
		Statement stmt = null;
		ResultSet rs = null;
		
		// SQL ����(�l���|�[�g�̏ꍇ�́A�e���|�[�g�̃h�������������p���B
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
				log.info("SQL(get Rreport drillThrowInfo)�F\n" + SQL);
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

	// ********** �����N���X **********

	/**
	 *  �����N���X�FPostgresAxisDAO
	 *  �����F���|�[�g�����󂯓n�����߂̓����N���X�ł��B
	 */
	class ReportInfo {

		String reportName = null;
		String cubeSeq = null;
		String parentID = null;
		String userID = null;				// ���[�UID
		String referenceReportID = null;	// �Q�ƌ����|�[�gID
		String reportOwnerFLG = null;		// ���|�[�g�̎��
		String highLightXML = null;
		String displayScreenType = null;	// ��ʕ����X�^�C��
		String currentChart = null;		// �\�����̃O���t��
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

	// ********** private���\�b�h **********

	/**
	 * ���|�[�g�����i�[����ReportInfo�N���X�����߂�B
	 * @param reportId ���|�[�gID
	 * @exception SQLException �������ɗ�O����������
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
		SQL += "    report_name,";				// ���|�[�g��
		SQL += "    cube_seq, ";				// CubeSeq
		SQL += "    par_id, ";					// ���|�[�g�i�[��̃t�H���_���
		SQL += "    user_id, ";					// ���[�UID
		SQL += "    reference_report_id, ";		// �Q�ƌ����|�[�gID
		SQL += "    report_owner_flg, ";		// ���|�[�g�̎��
		SQL += "    highlight_xml, ";			
		SQL += "    displayscreentype, ";		// ��ʕ����X�^�C��
		SQL += "    currentchart, ";			// �\�����̃O���t��
		SQL += "    colortype ";			// �\�����̃O���t��
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
				log.info("SQL(select report)�F\n" + SQL);
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
	 * ���|�[�g���\������L���[�u�����݂��邩�i�폜����Ă��Ȃ����j���`�F�b�N����B
	 * ���݂���ꍇtrue�A���݂��Ȃ��ꍇfalse��߂��B
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @return ���|�[�g���\������L���[�u�����݂��邩
	 * @exception SQLException �������ɗ�O����������
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
				log.info("SQL(select isCubeExist)�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			int i = 0;
			while(rs.next()){
				i++;
				if ( i>=1 ) {	// �L���[�u�\�����ύX����Ă���
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

		return false;	// ���|�[�g���\������L���[�u���폜���ꂽ
	}


	/**
	 * ���|�[�g�ɕۑ����ꂽ��Ԃ���L���[�u�\�����ύX���ꂽ���ǂ������`�F�b�N����B
	 * �\�����ύX���ꂽ�ꍇtrue�A�ύX����Ă��Ȃ��ꍇfalse��߂��B
	 * @param reportId ���|�[�gID
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @return �\�����ύX���ꂽ��
	 * @exception SQLException �������ɗ�O����������
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
		SQL += "    d.dimension_seq!=0 ";	// ���W���[�ł͂Ȃ�
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
		SQL2 += "    d.dimension_seq!=0 ";	// ���W���[�ł͂Ȃ�
		
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			// SQL1���s
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select isCubeChanged 1)�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
			int i = 0;
			while(rs.next()){
				i++;
				if ( i>0 ) {	// �L���[�u�\�����ύX����Ă���
					return true;
				}
			}

			// SQL2���s
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select isCubeChanged 2)�F\n" + SQL2);
			}
			rs = stmt.executeQuery(SQL2);
			i = 0;
			while(rs.next()){
				i++;
				if ( i>0 ) {	// �L���[�u�\�����ύX����Ă���
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

		return false;	// �L���[�u�\�����ύX����Ă��Ȃ�
	}

	/**
	 * �����̃��f�����玲�����폜���A�^����ꂽ�G�b�W���Ēǉ�����B
	 * @param edgeAxesIDListFromClient ��A�s�A�������̓y�[�W�G�b�W�ɔz�u���ꂽ��ID�̃��X�g
	 * @param edgeAxesListFromModel ���|�[�g�ɔz�u���ꂽ��A�s�A�������̓y�[�W�G�b�W�̎��I�u�W�F�N�g���X�g
	 * @param axisMap ��ID�Ǝ��I�u�W�F�N�g������킷Map�I�u�W�F�N�g
	 */
	private void replaceAxisList(ArrayList<String> edgeAxesIDListFromClient, ArrayList<Axis> edgeAxesListFromModel, HashMap<String, Axis> axisMap) {

		edgeAxesListFromModel.clear();								// �G�b�W���N���A

		Iterator<String> it = edgeAxesIDListFromClient.iterator();	// �G�b�W�ɒǉ�
		while(it.hasNext()){
			edgeAxesListFromModel.add(axisMap.get(it.next()));
		}

	}

}

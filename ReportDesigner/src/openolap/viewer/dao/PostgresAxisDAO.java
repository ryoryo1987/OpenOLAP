/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresAxisDAO.java
 *  �����F���I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/13
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
 *  �N���X�FPostgresAxisDAO<br>
 *  �����F���I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresAxisDAO implements AxisDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresAxisDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 * ���I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresAxisDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** ���\�b�h **********

	/**
	 * �N���C�A���g���瑗�M���ꂽ�p�����[�^�����ƂɁA���̃����o�̃Z���N�^�I�����A�h�������𔽉f����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 */
	public void registSelectedMemberAndDrillStat(RequestHelper helper, CommonSettings commonSettings) {

		HttpServletRequest request = helper.getRequest();
		Report report = (Report)helper.getRequest().getSession().getAttribute("report");

		String axisID = null;
		for (int i = 0; i < report.getTotalDimensionNumber()+1; i++ ) {	// �f�B�����V�����{�P(���W���[)����s

			if (i == report.getTotalDimensionNumber()) {	// ���W���[
				axisID = Constants.MeasureID;
			} else {										// �f�B�����V����
				axisID = Integer.toString(i+1);				// ��ID��1start�̂��߁A�␳�B
			}

			String selectedMemberAndDrillStat = (String)request.getParameter("dim" + axisID);	// �N���C�A���g����̑��M����Ă����p�����[�^���擾

			// axis���������o�[�̑I���󋵂����ɍX�V
			Axis axis = report.getAxisByID(axisID);

			// �Z���N�^�I�����A�h�������������I�u�W�F�N�g�ɃZ�b�g
			if (!selectedMemberAndDrillStat.equals("")) {	// �Z���N�^�I�����������̓h�������������͂��̗������X�V���ꂽ

				// ���鎲�̑I���ς݂ł��郁���o��Key,���̃h������Ԃ�value�Ƃ���HashMap�𐶐�
				HashMap<String, String> memberNameDrillMap = new HashMap<String, String>();
				ArrayList<String> selectedMemberAndDrillStatList = StringUtil.splitString(selectedMemberAndDrillStat,",");
				Iterator<String> it = selectedMemberAndDrillStatList.iterator();
				while (it.hasNext()) {
					String aSelectedMemberAndDrillStat = it.next();
					ArrayList<String> aSelectedMemberAndDrillStatList = StringUtil.splitString(aSelectedMemberAndDrillStat,":");
				
					String selectedMemberUniqueName = aSelectedMemberAndDrillStatList.get(0); // �I���ς݃����o�̃��j�[�N��
					String selectedMemberDrillStat  = aSelectedMemberAndDrillStatList.get(1); // �h�������(1:�h����,0:���h����)
					memberNameDrillMap.put(selectedMemberUniqueName, selectedMemberDrillStat);
				}

				// �����o�[���A�h���������X�V
				if(axis instanceof Dimension){	// �f�B�����V����
					Dimension dim = (Dimension)axis;
					dim.setSelectedMemberDrillStat(memberNameDrillMap);
				} else if (axis instanceof Measure){// ���W���[�F���W���[�����o�ɑ΂��A�Z���N�^�őI�����ꂽ�����o���ǂ��������ɐݒ肵�Ă���
					Iterator<AxisMember> axisMemIt = axis.getAxisMemberList().iterator();
					while (axisMemIt.hasNext()) {
						AxisMember axisMember = axisMemIt.next();
						if (memberNameDrillMap.containsKey(axisMember.getUniqueName())) {	// �Z���N�^�őI�����ꂽ�����o
							axisMember.setIsSelected(true);
						} else {															// �Z���N�^�őI������Ȃ����������o
							axisMember.setIsSelected(false);
						}
					}
				}

				// �f�t�H���g�����o�[�����X�V(�f�t�H���g�����o���Z���N�^�ŊO���ꂽ�ꍇ�A�f�t�H���g�����o�ݒ������������)
				axis.modifyDefaultMember(memberNameDrillMap);

			} else {	// ���̎��ɂ������ẮA����Z���N�^�I�����A�h������񂪍X�V����Ȃ�����
				// �������Ȃ�
			}
		}
	}


	/**
	 * �f�[�^�\�[�X����擾�������|�[�g�ݒ�����f���ɔ��f����B
	 * @param report Report�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
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
				log.info("SQL(select axes)�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
			while ( rs.next() ) {

				String axisID = rs.getString("axis_id");

				// �z�u�ꏊ�����擾
				if (Constants.Col.equals(rs.getString("edge_type"))) {
					colIdList.add(axisID);	
				} else if (Constants.Row.equals(rs.getString("edge_type"))) {
					rowIdList.add(axisID);
				} else if (Constants.Page.equals(rs.getString("edge_type"))) {
					pageIdList.add(axisID);
				} else {
					throw new IllegalStateException();
				}

				// defaultMemberKey�AisUsedSelecter�AdispMemberNameType�̍X�V
				Axis axis = report.getAxisByID(axisID);
				axis.setDefaultMemberKey(rs.getString("default_mem_key"));
				axis.setUsedSelecter(CommonUtils.FLGTobool(rs.getString("selecter_usedFLG")));
				if(!axis.isMeasure()) {
					((Dimension)axis).setDispMemberNameType(rs.getString("disp_mem_name_type"));
				}

				// �����o���̍X�V
				AxisMemberDAO axisMemberDAO = DAOFactory.getDAOFactory().getAxisMemberDAO(conn,axis);
				axisMemberDAO.applyAxis(report, axis, commonSettings);

			}

			// �z�u�ꏊ�����X�V
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
	 * �N���C�A���g���瑗�M���ꂽ�p�����[�^�����ƂɁA���f���̎������o�[�̃f�t�H���g�����o�����X�V����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 */
	public void registDefaultMember(RequestHelper helper, CommonSettings commonSettings) {
		
		HttpServletRequest request = helper.getRequest();
		String defaultMembers = (String)request.getParameter("defaultMembers");
//		if ( (defaultMembers == null) || ("".equals(defaultMembers))) {
//			throw new IllegalStateException();
//		}
		// �����F����ID.����UName�̌J��Ԃ�(�J���}��؂�A��ID�̏���)��
		// �@�@�@��F1.0,2.NA,16.0
		//�@�@�@�@�@�@1.0:AxisID=1�̃f�B�����V�����̃f�t�H���g�����o��UName
		//�@�@�@�@�@�@2.NA:AxisID=2�̃f�B�����V�����̃f�t�H���g�����o��UName�i���ݒ�̏ꍇ�́ANA�Ƃ���������j
		//�@�@�@�@�@�@16.0:AxisID=16(���W���[)�̃f�t�H���g�����o��UName

		Report report = (Report)helper.getRequest().getSession().getAttribute("report");

		ArrayList<String> defaultMemberList = StringUtil.splitString(defaultMembers, ",");
		Iterator<String> it = defaultMemberList.iterator();
		int measureIndex = defaultMemberList.size();
//System.out.println("measureIndex:" + measureIndex);

		while (it.hasNext()) {

			//�����A�f�t�H���g�����o�����擾
			String axisIdAndDefaultMemberString = it.next();
			ArrayList<String> axisIdAndDefaultMemberList = StringUtil.splitString(axisIdAndDefaultMemberString, ".");
			String axisID        = axisIdAndDefaultMemberList.get(0);
			String defaultMember = axisIdAndDefaultMemberList.get(1);
		
			//�f�t�H���g�����o���ݒ肳��Ă��Ȃ���Ԃ�Client���ł́A�uNA�v�ŕ\���B
			if (defaultMember.equals("NA")) {
				defaultMember = null;
			}

//System.out.println("axisDAO axisID" + axisID);
			report.getAxisByID(axisID).setDefaultMemberKey(defaultMember);	// �f�t�H���g�����o�����X�V

		}
	}

	/**
	 * �������f�[�^�\�[�X�֕ۑ�����B
	 * @param report Report�I�u�W�F�N�g
	 * @param reportID ���|�[�gID
	 *                �����̃p�����[�^��NULL�̏ꍇ�AReport�I�u�W�F�N�g�������|�[�gID�Ŏ�����ۑ�����B
	 *                  NULL�ł͂Ȃ��ꍇ�́AreportID�p�����[�^�̒l�Ŏ�����ۑ�����B
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void saveAxis(Report report, String reportID, Connection conn) throws SQLException {

		// �ۑ��ΏۂƂȂ郌�|�[�gID�����߂�
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
							log.info("SQL(update report)�F\n" + SQL);
						}
						int updateCount = stmt.executeUpdate(SQL);
	
						// update������0�̏ꍇ�A�V���Ƀ��R�[�h�쐬
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
								log.info("SQL(insert report)�F\n" + SQL);
							}
							int insertCount = stmt.executeUpdate(SQL);
							if (insertCount != 1) {
								throw new IllegalStateException();
							}
						}

					// �������o�[�̕ۑ�
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
	 * �^����ꂽ���|�[�g�̑S�Ă̎��̏����f�[�^�\�[�X����폜����B
	 * @param report Report�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteAxes(Report report, Connection conn) throws SQLException {

		// �����̍폜
		String SQL = "";
		SQL =  "";
		SQL += "delete from oo_v_axis ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID();

		Statement stmt = null;
		try {
			stmt = conn.createStatement();

			if(log.isInfoEnabled()) {
				log.info("SQL(delete axis)�F\n" + SQL);
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

		// �������o�̍폜
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		AxisMemberDAO axisMemDAO = daoFactory.getAxisMemberDAO(conn, null);
		axisMemDAO.deleteAxisMember(report, conn);

	}

	/**
	 * �^����ꂽ���̏����f�[�^�\�[�X����폜����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis ���I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
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
				log.info("SQL(delete all axes)�F\n" + SQL);
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

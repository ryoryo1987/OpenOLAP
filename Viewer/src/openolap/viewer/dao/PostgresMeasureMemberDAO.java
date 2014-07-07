/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresMeasureMemberDAO.java
 *  �����F���W���[�����o�[�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/07
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
 *  �N���X�FPostgresMeasureMemberDAO<br>
 *  �����F���W���[�����o�[�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresMeasureMemberDAO extends PostgresAxisMemberDAO implements MeasureMemberDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresMeasureMemberDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 *  ���W���[�����o�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresMeasureMemberDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** ���\�b�h **********

	/**
	 * ���W���[�����o�[������킷�I�u�W�F�N�g�̏W�����f�[�^�\�[�X��苁�߂�B
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�
	 * @return ���W���[�����o�[�I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<MeasureMember> selectMeasureMembers(String cubeSeq, CommonSettings commonSettings)  throws SQLException {

		// ���W���[�����o�����擾
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
				log.info("SQL(select measure members )�F\n" + SQL);
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
	 * �^����ꂽ���|�[�g�I�u�W�F�N�g�̃��W���[�����o�[���f�[�^�\�[�X�ɕۑ�����Ă���������Ƃɂ��C������B
	 * �C������������L�ɋL���܂��B
	 *   �E�Z���N�g���ꂽ���ǂ���
	 *   �E���W���[�����o�[�^�C�v
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis ��������킷�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�
	 * @exception SQLException �������ɗ�O����������
	 */
	public void applyAxis(Report report, Axis axis, CommonSettings commonSettings) throws SQLException {

		String SQL = null;
		ResultSet rs = null;
		Statement stmt = null;
		try {
			SQL = DAOFactory.getDAOFactory().getAxisMemberDAO(conn,axis).selectSaveDataSQL(report, axis);
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select measure members )�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			Measure Mem = (Measure) axis;
			ArrayList<AxisMember> measureMemList = axis.getAxisMemberList();

			int i = 0;
			while ( rs.next() ) {

				// �Z���N�g���ꂽ���ǂ����A���W���[�����o�[�^�C�v���X�V
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
	 * ���W���[�����o�[�̃��W���[�����o�[�^�C�v���N���C�A���g����^����ꂽ�������ƂɍX�V����B
	 * �N���C�A���g����^����ꂽ���F"measureMemberTypes"�p�����[�^
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings ��������킷�I�u�W�F�N�g
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
	 * ���W���[�����o�[�I�u�W�F�N�g���i��������B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param reportID ���|�[�gID
	 *                �����̃p�����[�^��NULL�̏ꍇ�AReport�I�u�W�F�N�g�������|�[�gID�Ŏ������o�[����ۑ�����B
	 *                  NULL�ł͂Ȃ��ꍇ�́AreportID�p�����[�^�̒l�Ŏ������o�[����ۑ�����B

	 * @param axis ���I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 */
	public void saveAxisMember(Report report, String reportID, Axis axis, Connection conn) throws SQLException {

		// ���|�[�gID��ݒ�
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
					log.info("SQL(update measure members )�F\n" + SQL);
				}
				int updateCount = stmt.executeUpdate(SQL);
	
				// update������0�̏ꍇ�A�V���Ƀ��R�[�h�쐬
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
					SQL +=                "'0', ";								// drilledFLG ���false(-)�B���W���[�͊K�w�������Ȃ��ׁA�h�������邱�Ƃ��ł��Ȃ�����
					SQL +=                measureMember.getMeasureMemberType().getId();	// measureMemberType id
					SQL +=         ")";

					if(log.isInfoEnabled()) {
						log.info("SQL(insert measure members )�F\n" + SQL);
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

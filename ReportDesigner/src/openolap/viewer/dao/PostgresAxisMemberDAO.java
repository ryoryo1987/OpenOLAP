/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresAxisMemberDAO.java
 *  �����F�������o�[�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/14
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;


/**
 *  �N���X�FPostgresAxisMemberDAO<br>
 *  �����F�������o�[�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 */
public abstract class PostgresAxisMemberDAO implements AxisMemberDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresAxisMemberDAO.class.getName());

	// ********** ���ۃ��\�b�h **********

	/**
	 * �^����ꂽ���̃f�B�����V���������o�[���i��������B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param reportID ���|�[�gID
	 *                �����̃p�����[�^��NULL�̏ꍇ�AReport�I�u�W�F�N�g�������|�[�gID�Ŏ������o�[����ۑ�����B
	 *                  NULL�ł͂Ȃ��ꍇ�́AreportID�p�����[�^�̒l�Ŏ������o�[����ۑ�����B
	 * @param axis ���I�u�W�F�N�g
	 * @param conn Connecion�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public abstract void saveAxisMember(Report report, String reportID, Axis axis, Connection conn) throws SQLException;

	/**
	 * �f�B�����V���������o�[�����f�[�^�\�[�X�̏������Ƃɐ������A�f�B�����V�����I�u�W�F�N�g��"selectedMemberDrillStat"�ɐݒ肷��B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis ���I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ������킷�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public abstract void applyAxis(Report report, Axis axis, CommonSettings commonSettings) throws SQLException;

	// ********** ���\�b�h **********

	/**
	 * �f�[�^�\�[�X�ɕۑ��ς���Ă��鎲�����o�[�����擾����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis ���I�u�W�F�N�g
	 */
	public String selectSaveDataSQL(Report report, Axis axis ) {

		String SQL = "";
		SQL =  "";
		SQL += "select ";
		SQL += "    report_id, ";
		SQL += "    axis_id, ";
		SQL += "    dimension_seq, ";
		SQL += "    member_key, ";
		SQL += "    selectedFLG, ";
		SQL += "    drilledFLG, ";
		SQL += "    measure_member_type_id ";
		SQL += "from ";
		SQL += "    oo_v_axis_member ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID() + " and ";
		SQL += "    axis_id=" + axis.getId() + " ";
		SQL += "order by ";
		SQL += "    member_key";

		return SQL;
	}

	/**
	 * �w�肳�ꂽ���|�[�g�̂��ׂĂ̎��̎������o�����폜����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteAxisMember(Report report, Connection conn) throws SQLException {

		String SQL = "";
		SQL =  "";
		SQL += "delete from oo_v_axis_member ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID();

		Statement stmt = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(delete all axes members)�F\n" + SQL);
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
	}

	/**
	 * �w�肳�ꂽ���|�[�g�̎w�肳�ꂽ���̃����o�����폜����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis ���I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteAxisMember(Report report, Axis axis, Connection conn) throws SQLException {

		deleteAxisMember(report.getReportID(), axis.getId(), conn);

	}


	/**
	 * �w�肳�ꂽ���|�[�g�̎w�肳�ꂽ���̃����o�����폜����B
	 * @param reportID ���|�[�gID
	 * @param axis ���I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteAxisMember(String reportID, String axisID, Connection conn) throws SQLException {

		String SQL = "";
		SQL =  "";
		SQL += "delete from oo_v_axis_member ";
		SQL += "where ";
		SQL += "    report_id=" + reportID + " and ";
		SQL += "    axis_id=" + axisID;

		Statement stmt = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(delete specified axis members)�F\n" + SQL);
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
	}





}

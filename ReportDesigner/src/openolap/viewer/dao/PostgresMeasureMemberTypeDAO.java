/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresMeasureMemberTypeDAO.java
 *  �����F���W���[�����o�[�^�C�v�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/12
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.apache.log4j.Logger;

import openolap.viewer.MeasureMemberType;

/**
 *  �N���X�FPostgresMeasureMemberTypeDAO<br>
 *  �����F���W���[�����o�[�^�C�v�̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresMeasureMemberTypeDAO implements MeasureMemberTypeDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresMeasureMemberTypeDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 *  ���W���[�����o�[�^�C�v�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresMeasureMemberTypeDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** ���\�b�h **********

	/**
	 * �f�[�^�\�[�X�ɓo�^����Ă��郁�W���[�����o�[�^�C�v�̃��X�g�����߂�<br>
	 * @return ���W���[�����o�[�^�C�v�I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<MeasureMemberType> getMeasureMemberTypeList() throws SQLException {
		
		ArrayList<MeasureMemberType> measureMemberTypeList = new ArrayList<MeasureMemberType>();
		
		String SQL = "";
		SQL += "select ";
		SQL += "    measure_member_type_id, ";
		SQL += "    name, ";
		SQL += "    comment, ";
		SQL += "    group_name, ";
		SQL += "    image_url, ";
		SQL += "    xml_spreadsheet_format, ";
		SQL += "    function_name, ";
		SQL += "    unit_function_id ";
		SQL += "from ";
		SQL += "    oo_v_measure_member_type ";
		SQL += "order by measure_member_type_id ";

		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select measure member types )�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			while ( rs.next() ) {
				MeasureMemberType measureMemberType = new MeasureMemberType(rs.getString("measure_member_type_id"),
																			 rs.getString("name"),
																			 rs.getString("comment"),
																			 rs.getString("group_name"),
																			 rs.getString("image_url"),
																			 rs.getString("xml_spreadsheet_format"),
																			 rs.getString("function_name"),
																			 rs.getString("unit_function_id"));

				measureMemberTypeList.add(measureMemberType);
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

		return measureMemberTypeList;
	}

}

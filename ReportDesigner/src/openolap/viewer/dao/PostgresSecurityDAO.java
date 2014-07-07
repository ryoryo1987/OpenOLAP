/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresSecurityDAO.java
 *  �����F�Z�L�����e�B���̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/30
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import openolap.viewer.Security;
import openolap.viewer.common.CommonUtils;

/**
 *  �N���X�FPostgresUserDAO<br>
 *  �����F���[�U�[���̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresSecurityDAO implements SecurityDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresSecurityDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 *  ���[�U�[���̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	public PostgresSecurityDAO (Connection conn) {
		this.conn = conn;
	}


	// ********** ���\�b�h **********
	
	/**
	 * �^����ꂽ���[�U�[ID�A���|�[�gID�����ƂɃZ�L�����e�B�I�u�W�F�N�g�����߂�B<br>
	 * @param userID ���[�U�[ID
	 * @param reportID ���|�[�gID
	 * @return �Z�L�����e�B�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public Security getSecurity(String userID, String reportID) throws SQLException {

		Security security = null;

		String SQL = "";
		SQL += "select ";
		SQL += "    right_flg,";		// �{������         1�F����A0�F�Ȃ�
		SQL += "    export_flg ";		// �G�N�X�|�[�g����  1�F����A0�F�Ȃ�
		SQL += "from ";
		SQL += "    oo_sec_func(" + userID + "," + reportID + ")";

		Statement stmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select security SQL:)�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			while ( rs.next() ) {
				security = new Security(CommonUtils.FLGTobool(rs.getString("right_flg")),
										 CommonUtils.FLGTobool(rs.getString("export_flg")));
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
		
		return security;
	}

}

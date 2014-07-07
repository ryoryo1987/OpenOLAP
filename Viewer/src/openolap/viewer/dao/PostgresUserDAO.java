/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresUserDAO.java
 *  �����F���[�U�[���̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/30
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import openolap.viewer.User;

/**
 *  �N���X�FPostgresUserDAO<br>
 *  �����F���[�U�[���̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresUserDAO implements UserDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresUserDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 *  ���[�U�[���̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	public PostgresUserDAO (Connection conn) {
		this.conn = conn;
	}


	// ********** ���\�b�h **********
	
	/**
	 * �^����ꂽ���[�U�[���A�p�X���[�h�����ƂɃ��[�U�[�I�u�W�F�N�g�����߂�B<br>
	 * �o�^����Ă��Ȃ��ꍇ�̓��O�C�����s�Ƃ݂Ȃ��Anull��߂��B
	 * @param userName ���[�U�[��
	 * @param password �p�X���[�h
	 * @return ���[�U�[�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public User getUser(String userName, String password) throws SQLException {

		User user = null;

		String SQL = "";
		SQL += "select ";
		SQL += "    u.user_id,";					// id
		SQL += "    u.name,";						// ���[�U��
		SQL += "    u.adminflg, ";					// �Ǘ��҃t���O
		SQL += "    u.export_file_type, ";			// �G�N�X�|�[�g�^�C�v
		SQL += "    s.name as color_style_name, ";	// �J���[�X�^�C����
		SQL += "    s.spreadstyle_file, ";			// �J���[�X�^�C���ispreadStyle�̃t�@�C�����j
		SQL += "    s.cellcolortable_file ";		// �J���[�X�^�C���icellColorTable�̃t�@�C�����j
		SQL += "from ";
		SQL += "    oo_v_user u, oo_v_color_style s ";
		SQL += "where ";
		SQL += "    u.color_style_id = s.id and ";
		SQL += "    u.name='" + userName + "' and ";
		SQL += "    u.password='" + password + "'";

		Statement stmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select user(by name, passwd))�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			while ( rs.next() ) {
				user = new User(rs.getString("user_id"),
								 rs.getString("name"),
								 rs.getString("adminflg"),
								 rs.getString("export_file_type"),
								 rs.getString("color_style_name"),
								 rs.getString("spreadstyle_file"),
								 rs.getString("cellcolortable_file")
								 );
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
		
		return user;
	}

}

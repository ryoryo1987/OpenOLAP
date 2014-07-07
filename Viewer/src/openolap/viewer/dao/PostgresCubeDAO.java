/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresCubeDAO.java
 *  �����F�L���[�u�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/08
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import openolap.viewer.Cube;

/**
 *  �N���X�FPostgresCubeDAO<br>
 *  �����F�L���[�u�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresCubeDAO implements CubeDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresCubeDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 * �L���[�u�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresCubeDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** ���\�b�h **********

	/**
	 * �t�@�N�g�e�[�u���������߂�B
	 * @param cubeSeq �L���[�u�̃V�[�P���X�ԍ�
	 * @return �t�@�N�g�e�[�u����
	 */
	public String getFactTableName(String cubeSeq) {
		String factTableName = "v_CUBE_" + cubeSeq;
		return factTableName;
	}

	/**
	 * �L���[�u�V�[�P���X�ԍ������ƂɃL���[�u�I�u�W�F�N�g�����߂�B
	 * @param cubeSeq �L���[�u�̃V�[�P���X�ԍ�
	 * @return �L���[�u�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public Cube getCubeByID(String cubeSeq) throws SQLException {
		String cubeName = this.getCubeName(cubeSeq);
		Cube cube = new Cube(	cubeSeq,					// cubeSeq
								cubeName);					// cubeName
		return cube;
	}

	/**
	 * �L���[�u�V�[�P���X�ԍ������ƂɃL���[�u�������߂�B
	 * @param cubeSeq �L���[�u�̃V�[�P���X�ԍ�
	 * @return �L���[�u��
	 * @exception SQLException �������ɗ�O����������
	 */
	public String getCubeName(String cubeSeq) throws SQLException {

		String cubeName = null;

		String SQL = "";
		Statement stmt = null;
		ResultSet rs = null;
		SQL =   "";
		SQL +=	" select ";
		SQL +=	"    NAME ";
		SQL +=	" from ";
		SQL +=	"    oo_cube ";
		SQL +=	" where ";
		SQL +=	"    cube_seq = " + cubeSeq;

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select axis members)�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			while ( rs.next() ) {
				cubeName = rs.getString("NAME");
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

		if(log.isDebugEnabled()) {
			log.debug("cubeName:" + cubeName);
		}

		return cubeName;
	}

}

/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresDAOFactory.java
 *  �����F�i�����Ǘ��N���X�Q��Postgres�p�����I�u�W�F�N�g�𐶐�����N���X�ł��B
 *
 *  �쐬��: 2004/01/06
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.Dimension;
import openolap.viewer.Measure;

/**
 *  �N���X�FPostgresDAOFactory<br>
 *  �����F�i�����Ǘ��N���X�Q��Postgres�p�����I�u�W�F�N�g�𐶐�����N���X�ł��B
 */
public class PostgresDAOFactory extends DAOFactory {

	// ********** �C���X�^���X�ϐ� **********

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresDAOFactory.class.getName());

	// ********** ���\�b�h **********

	/**
	 * Connection Pool���Connection���擾���AConnection�����������܂��B
	 * @param connectionPoolName �R�l�N�V�����Ձ[�����O�̖���
	 * @param attr1 search_path���B null�̏ꍇ�́A�ݒ肵�Ȃ��B
	 * @return Connection �I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 */
	public Connection getConnection(String connectionPoolName, String attr1) throws SQLException, NamingException {
		Connection conn = null;
		try {
			InitialContext initCtx = new InitialContext();

			DataSource ds = null;

			ds = (DataSource)initCtx.lookup("java:/comp/env/" + connectionPoolName); //$NON-NLS-1$

			conn = ds.getConnection();
			conn = initialyzeConnection(conn, attr1);
		} catch (SQLException e) {
			throw e;
		} catch (NamingException e) {
			throw e;
		}

		return conn;
	}



	/**
	 * �^����ꂽConnection�I�u�W�F�N�g�����������Ė߂��܂��B
	 *   �������F�v���p�e�B�[�t�@�C���Ɏw�肳�ꂽ�������Ƃ�search path��ݒ肷��B
	 * @param conn Connection �I�u�W�F�N�g
	 * @param searchPath search_path���B null�̏ꍇ�́A�ݒ肵�Ȃ��B
	 * @return Connection �I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	private Connection initialyzeConnection(Connection conn, String searchPath) throws SQLException {

		// search_path���B null�̏ꍇ�́A�ݒ肵�Ȃ�
		if (searchPath == null) {
			return conn;
		}

		// search_path��ݒ�B
		Statement stmt = null;
		String SQL = "";
		SQL =   "";
		SQL +=	"set search_path to " + searchPath + ",public";

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(set search_path)�F\n" + SQL);
			}
			int retNum = stmt.executeUpdate(SQL);
		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if (stmt != null) {
					stmt.close();
				}
			} catch (SQLException e) {
				throw e;
			}
		}
		return conn;
	}


	// DAO�擾�p���\�b�h

	/**
	 * �f�B�����V�����I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return DimensionDAO �I�u�W�F�N�g
	 */
	public DimensionDAO getDimensionDAO(Connection conn) {
		return new PostgresDimensionDAO(conn);
	}

	/**
	 * ���W���[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return MeasureDAO �I�u�W�F�N�g
	 */
	public MeasureDAO getMeasureDAO(Connection conn) {
		return new PostgresMeasureDAO(conn);
	}

	/**
	 * ���W���[�����o�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return MeasureMemberDAO �I�u�W�F�N�g
	 */
	public MeasureMemberDAO getMeasureMemberDAO(Connection conn) {
		return new PostgresMeasureMemberDAO(conn);
	}

	/**
	 * ���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return ReportDAO �I�u�W�F�N�g
	 */
	public ReportDAO getReportDAO(Connection conn) {
		return new PostgresReportDAO(conn);
	}

	/**
	 * �L���[�u�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return CubeDAO �I�u�W�F�N�g
	 */
	public CubeDAO getCubeDAO(Connection conn) {
		return new PostgresCubeDAO(conn);
	}

	/**
	 * �����x���I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return AxisLevelDAO �I�u�W�F�N�g
	 */
	public AxisLevelDAO getAxisLevelDAO(Connection conn) {
		return new PostgresAxisLevelDAO(conn);
	}

	/**
	 * �f�B�����V���������o�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return DimensionMemberDAO �I�u�W�F�N�g
	 */
	public DimensionMemberDAO getDimensionMemberDAO(Connection conn) {
		return new PostgresDimensionMemberDAO(conn);
	}

	/**
	 * �Z���f�[�^�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return CellDataDAO �I�u�W�F�N�g
	 */
	public CellDataDAO getCellDataDAO(Connection conn){
		return new PostgresCellDataDAO(conn);
	}

	/**
	 * ���W���[�����o�[�^�C�v�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return MeasureMemberTypeDAO �I�u�W�F�N�g
	 */
	public MeasureMemberTypeDAO getMeasureMemberTypeDAO(Connection conn) {
		return new PostgresMeasureMemberTypeDAO(conn);
	}

	/**
	 * ���I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return AxisDAO �I�u�W�F�N�g
	 */
	public AxisDAO getAxisDAO(Connection conn) {
		return new PostgresAxisDAO(conn);
	}

	/**
	 * �������o�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return AxisMemberDAO �I�u�W�F�N�g
	 */
	public AxisMemberDAO getAxisMemberDAO(Connection conn) {
		return new PostgresDimensionMemberDAO(conn);
	}

	/**
	 * �������o�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return AxisMemberDAO �I�u�W�F�N�g
	 */
	public AxisMemberDAO getAxisMemberDAO(Connection conn, Axis axis) {
		if (axis == null) {
			return new PostgresDimensionMemberDAO(conn);
		} else if(axis instanceof Measure){
			return new PostgresMeasureMemberDAO(conn);
		} else if (axis instanceof Dimension){
			return new PostgresDimensionMemberDAO(conn);
		} else {
			throw new IllegalStateException();
		}
	}

	/**
	 * �F�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return ColorDAO �I�u�W�F�N�g
	 */
	public ColorDAO getColorDAO(Connection conn){
		return new PostgresColorDAO(conn);
	}

	/**
	 * ���[�U�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return UserDAO �I�u�W�F�N�g
	 */
	public UserDAO getUserDAO(Connection conn) {
		return new PostgresUserDAO(conn);
	}

	/**
	 * �Z�L�����e�B�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return SecurityDAO �I�u�W�F�N�g
	 */
	public SecurityDAO getSecurityDAO(Connection conn) {
		return new PostgresSecurityDAO(conn);
	}

	/**
	 * RReport�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return RReportDAO �I�u�W�F�N�g
	 */
	public RReportDAO getRReportDAO(Connection conn) {
		return new PostgresRReportDAO(conn);
	}


}

/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FDAOFactory.java
 *  �����F�i�����Ǘ��N���X�Q�̃I�u�W�F�N�g�𐶐����钊�ۃN���X�ł��B
 *
 *  �쐬��: 2004/01/06
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;

import openolap.viewer.Axis;
import openolap.viewer.common.Messages;
import openolap.viewer.controller.RequestHelper;

/**
 *  ���ۃN���X�FDAOFactory<br>
 *  �����F�i�����Ǘ��N���X�Q�̃I�u�W�F�N�g�𐶐����钊�ۃN���X�ł��B
 */
public abstract class DAOFactory {

	// ********** �C���X�^���X�ϐ� **********

    // RequestHelper
	protected RequestHelper helper = null;

	// ********** ���ۃ��\�b�h **********

	/**
	 * Connection Pool���Connection���擾���AConnection�����������܂��B
	 * @param connectionPoolName server.xml�Aweb.xml�Őݒ肵�Ă���R�l�N�V�����v�[����
	 * @param attr1 �C�ӂ̈���
	 * @return Connection �I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 */
	public abstract Connection getConnection(String connectionPoolName, String attr1) throws SQLException, NamingException;

	/**
	 * �f�B�����V�����I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return DimensionDAO �I�u�W�F�N�g
	 */
	public abstract DimensionDAO getDimensionDAO(Connection conn);

	/**
	 * ���W���[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return MeasureDAO �I�u�W�F�N�g
	 */
	public abstract MeasureDAO getMeasureDAO(Connection conn);

	/**
	 * ���W���[�����o�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return MeasureMemberDAO �I�u�W�F�N�g
	 */
	public abstract MeasureMemberDAO getMeasureMemberDAO(Connection conn);

	/**
	 * ���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return ReportDAO �I�u�W�F�N�g
	 */
	public abstract ReportDAO getReportDAO(Connection conn);

	/**
	 * �L���[�u�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return CubeDAO �I�u�W�F�N�g
	 */
	public abstract CubeDAO getCubeDAO(Connection conn);

	/**
	 * �����x���I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return AxisLevelDAO �I�u�W�F�N�g
	 */
	public abstract AxisLevelDAO getAxisLevelDAO(Connection conn);

	/**
	 * �f�B�����V���������o�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return DimensionMemberDAO �I�u�W�F�N�g
	 */
	public abstract DimensionMemberDAO getDimensionMemberDAO(Connection conn);

	/**
	 * �Z���f�[�^�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return CellDataDAO �I�u�W�F�N�g
	 */
	public abstract CellDataDAO getCellDataDAO(Connection conn);

	/**
	 * ���W���[�����o�[�^�C�v�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return MeasureMemberTypeDAO �I�u�W�F�N�g
	 */
	public abstract MeasureMemberTypeDAO getMeasureMemberTypeDAO(Connection conn);

	/**
	 * ���I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return PostgresAxisDAO �I�u�W�F�N�g
	 */
	public abstract AxisDAO getAxisDAO(Connection conn);

	/**
	 * �������o�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return AxisMemberDAO �I�u�W�F�N�g
	 */
	public abstract AxisMemberDAO getAxisMemberDAO(Connection conn);

	/**
	 * �������o�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @param axis ��������킷�I�u�W�F�N�g
	 * @return AxisMemberDAO �I�u�W�F�N�g
	 */
	public abstract AxisMemberDAO getAxisMemberDAO(Connection conn, Axis axis);

	/**
	 * �F�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return ColorDAO �I�u�W�F�N�g
	 */
	public abstract ColorDAO getColorDAO(Connection conn);

	/**
	 * ���[�U�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return UserDAO �I�u�W�F�N�g
	 */
	public abstract UserDAO getUserDAO(Connection conn); 

	/**
	 * �Z�L�����e�B�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return SecurityDAO �I�u�W�F�N�g
	 */
	public abstract SecurityDAO getSecurityDAO(Connection conn); 

	/**
	 * RReport�̉i�������Ǘ�����I�u�W�F�N�g�����߂�B
	 * @param conn Connection �I�u�W�F�N�g
	 * @return RReportDAO �I�u�W�F�N�g
	 */
	public abstract RReportDAO getRReportDAO(Connection conn); 

	// ********** ���\�b�h **********

	/**
	 * �f�[�^�\�[�X�̃^�C�v�ɉ�����Factory�I�u�W�F�N�g�����߂܂��B
	 *   �f�[�^�\�[�X�̃^�C�v�Fviewer.properties��"DAOFactory.sourceName"�Ŏw��
	 * @return DAOFactory �I�u�W�F�N�g
	 */
	public static DAOFactory getDAOFactory() {
		String sourceName = Messages.getString("DAOFactory.sourceName"); //$NON-NLS-1$
		if (sourceName.equals("postgres")) { //$NON-NLS-1$
			return new PostgresDAOFactory();
		} else {
			throw new UnsupportedOperationException();
		}
	}

}

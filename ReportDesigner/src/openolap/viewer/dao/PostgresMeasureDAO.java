/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresMeasureDAO.java
 *  �����F���W���[�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/07
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;

import openolap.viewer.AxisLevel;
import openolap.viewer.Measure;
import openolap.viewer.MeasureMember;
import openolap.viewer.common.Messages;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;

/**
 *  �N���X�FPostgresMeasureDAO<br>
 *  �����F���W���[�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł�
 */
public class PostgresMeasureDAO implements MeasureDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	// ********** �R���X�g���N�^ **********

	/**
	 *  ���W���[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresMeasureDAO() {}	

	/**
	 *  ���W���[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresMeasureDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** ���\�b�h **********

	/**
	 * ���W���[�I�u�W�F�N�g�����߂�B<br>
	 *   ���W���[�I�u�W�F�N�g�̏�ԁF<br>
	 *     ���W���[�����o�[�I�u�W�F�N�g�F�����Ȃ�
	 * @return ���W���[�I�u�W�F�N�g
	 */
	public Measure findMeasureWithoutMember() {
	
		final boolean measureFLG = true;
		boolean isUsedSelecterFLG = false;

		Measure measure = new Measure(Constants.MeasureID, 
										Messages.getString("PostgresMeasureDAO.MeasureName"),  //$NON-NLS-1$
										Messages.getString("PostgresMeasureDAO.MeasureComment"),  //$NON-NLS-1$
										new ArrayList<AxisLevel>(),		// axisLevelList
										null, 							// defaultMemberKey
										measureFLG, 					// isMeasure
										isUsedSelecterFLG);				// isUsedSelecter

		return measure;
	}

	/**
	 * ���W���[�I�u�W�F�N�g�����߂�B<br>
	 *   ���W���[�I�u�W�F�N�g�̏�ԁF<br>
	 *     ���W���[�����o�[�I�u�W�F�N�g�F����
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�
	 * @return ���W���[�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public Measure findMeasureWithMember(String cubeSeq, CommonSettings commonSettings) throws SQLException  {

		// Measure �I�u�W�F�N�g�擾
		Measure measure = this.findMeasureWithoutMember();

		// Measure �I�u�W�F�N�g�� AxisLevel �I�u�W�F�N�g��ǉ�
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		AxisLevelDAO axisLevelDAO = daoFactory.getAxisLevelDAO(this.conn);
		Iterator<AxisLevel> it = axisLevelDAO.selectAxisLevels(cubeSeq,measure).iterator();
		while (it.hasNext()) {
			AxisLevel axisLevel = it.next();
			measure.addAxisLevelList(axisLevel);
		}

		// Measure �I�u�W�F�N�g�� MeasureMember �I�u�W�F�N�g��ǉ�

		MeasureMemberDAO measureMemberDAO = daoFactory.getMeasureMemberDAO(this.conn);
		ArrayList<MeasureMember> measureMemberList = measureMemberDAO.selectMeasureMembers(cubeSeq, commonSettings);
		Iterator<MeasureMember> it2 = measureMemberList.iterator();

		while (it2.hasNext()) {
			MeasureMember measureMem = it2.next();
			measure.addAxisMember(measureMem);
		}

		return measure;
	}

}

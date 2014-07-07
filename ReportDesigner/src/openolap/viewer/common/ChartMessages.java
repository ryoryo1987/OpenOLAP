/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FChartMessages.java
 *  �����F�`���[�g�v���p�e�B�[�t�@�C���ɃA�N�Z�X����N���X�ł��B
 *
 *  �쐬��: 2004/08/06
 */
package openolap.viewer.common;

import java.util.MissingResourceException;
import java.util.ResourceBundle;

import org.apache.log4j.Logger;

/**
 *  �N���X�FChartMessages<br>
 *  �����F�`���[�g�v���p�e�B�[�t�@�C���ɃA�N�Z�X����N���X�ł��B
 */
public class ChartMessages {

	// ********** �N���X�ϐ� **********

	/** �o���h���� */
	private static final String BUNDLE_NAME = "openolap.viewer.common.chart";

	/** �o���h���I�u�W�F�N�g */
	private static final ResourceBundle RESOURCE_BUNDLE =
		ResourceBundle.getBundle(BUNDLE_NAME);

	// ********** �R���X�g���N�^ **********

	/**
	 * �C���X�^���X�����s�v�ȃN���X�ł��邽�߁A�R���X�g���N�^��private�Œ�`����B
	 */
	private ChartMessages() {
	}

	// ********** static���\�b�h **********

	/**
	 * �v���p�e�B�[�t�@�C����蕶������擾����B
	 * �v���p�e�B�[�t�@�C���Ɍ�����Ȃ��ꍇ�A�L�[�̑O��Ɂu!�v�������������߂��B
	 * @param key �v���p�e�B�[�t�@�C���ɓo�^����Ă���KEY
	 * @return ������
	 */
	public static String getString(String key) {
		try {
			return RESOURCE_BUNDLE.getString(key);
		} catch (MissingResourceException e) {

			Logger log = Logger.getLogger(ChartMessages.class.getName());
			log.error("�v���p�e�B�t�@�C���ɍ��ڂ����݂��Ȃ��B\n���\�[�X���F" + BUNDLE_NAME + "\nKEY:" + key, e);

			throw e;
		}
	}
}

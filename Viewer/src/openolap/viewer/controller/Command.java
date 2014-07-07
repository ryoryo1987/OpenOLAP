/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FCommand.java
 *  �����F�R�}���h������킷�C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/05
 */

package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  �C���^�[�t�F�[�X�FCommand<br>
 *  �����F�R�}���h������킷�C���^�[�t�F�[�X�ł��B
 */
public interface Command {

	// ********** ���\�b�h **********

	/**
	 * ���������s���Adispatch���JSP/HTML�̃p�X��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 * @exception Exception �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings) throws ServletException, IOException, Exception;

}

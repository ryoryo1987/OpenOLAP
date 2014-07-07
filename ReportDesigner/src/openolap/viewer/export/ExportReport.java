/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.export
 *  �t�@�C���FExportReport.java
 *  �����F���|�[�g�̃G�N�X�|�[�g�������s�����ۃN���X�ł��B
 *
 *  �쐬��: 2004/01/31
 */
package openolap.viewer.export;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.xml.sax.SAXException;


import openolap.viewer.Axis;
import openolap.viewer.Edge;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;

/**
 *  ���ۃN���X�FExportReport<br>
 *  �����F���|�[�g�̃G�N�X�|�[�g�������s�����ۃN���X�ł��B
 */
public abstract class ExportReport {

	// ********** ���\�b�h **********

	/**
	 * �G�N�X�|�[�g���������s����
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception SQLException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 * @exception FileNotFoundException �������ɗ�O����������
	 * @exception UnsupportedEncodingException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������UnsupportedEncodingException
	 */
	public abstract String exportReport(RequestHelper helper) throws SQLException, NamingException, FileNotFoundException, UnsupportedEncodingException, IOException, ParserConfigurationException, SAXException, TransformerException, XPathExpressionException;


	// ********** protected���\�b�h **********

	/**
	 * @param edge
	 * @param axis
	 * @param rowIndex
	 * @return �o�͂������
	 */
	protected boolean isPrintPoint(Edge edge, Axis axis, int rowIndex) {
		Integer nextComboNums = edge.getNextAxesMembersComboNums(axis);
		
		if (nextComboNums == null) {// �ŏI�i�̏ꍇ�A��ɕ\���Ώ�
			return true;
		} else { // �ŏI�i�ȊO�̏ꍇ
			if ( (rowIndex % nextComboNums.intValue() == 0)) {//�����Z���̐擪��Index
				return true;
			} else {
				return false;
			}
		}
	}

	/**
	 * �s�E�񃁃��o�̃Z�������������߂�B
	 * @param edge �G�b�W������킷�I�u�W�F�N�g
	 * @param axis ��������킷�I�u�W�F�N�g
	 * @return �Z���������K�v�Ȑ�
	 */
	protected int getCellMergeNum(Edge edge, Axis axis) {

		Integer cellMergeNumber = edge.getNextAxesMembersComboNums(axis);
		int mergeNum;
		if (cellMergeNumber != null) {
			mergeNum = cellMergeNumber.intValue()-1;
		} else {
			mergeNum = 0;
		}
		
		return mergeNum;
	}

	/**
	 * �������o�[��SpreadIndex�����߂�B
	 * @param edge �G�b�W������킷�I�u�W�F�N�g
	 * @param axis ��������킷�I�u�W�F�N�g
	 * @param x �n�_�ƂȂ�SpreadIndex
	 * @return �Z���������K�v�Ȑ�
	 */
	protected int getNextSpreadIndex(Edge edge, Axis axis, int x) {

		Integer cellMergeNumber = edge.getNextAxesMembersComboNums(axis);
		int mergeNum;
		if (cellMergeNumber != null) {
			mergeNum = cellMergeNumber.intValue();
		} else {
			mergeNum = 1;
		}
		return ( x + mergeNum );
	}

	/**
	 * �^����ꂽ�����ȑO�̒i�̑g�ݍ��킹�������߂�B
	 * @param edge �G�b�W������킷�I�u�W�F�N�g
	 * @param axis ��������킷�I�u�W�F�N�g
	 * @return �Z���������K�v�Ȑ�
	 */
	protected int getBeforeComboNum(Edge edge, Axis axis) {

		Integer axisMemRepeatNumber = edge.getBeforeAxesMembersComboNums(axis);

		int axisMemRepeatNum;
		if (axisMemRepeatNumber != null) {
			axisMemRepeatNum = axisMemRepeatNumber.intValue();
		} else {
			axisMemRepeatNum = 1;	// 0�i�̏ꍇ�A��x�����J��Ԃ�
		}
		return axisMemRepeatNum;
	}

	/**
	 * �w�肳�ꂽ�i�̎������o�����������Ώہi�\���ΏۊO�j���ǂ������m�F����B<br>
	 * ��O�̍s/��ɔz�u���ꂽ�������o��Key�̑g�ݍ��킹�Ǝ�����Key�̑g�ݍ��킹���r���A
	 * �w�肳�ꂽ�i����т������ʂ̒i��Key���قȂ�ꍇ�͕\���ΏہA�������ꍇ�͕\���ΏۊO�Ƃ���
	 * @param beforeKeys �ȑO�̃����o�[�L�[�̑g�ݍ��킹
	 * @param keys �����o�[�L�[�̑g�ݍ��킹
	 * @param hieIndex �G�b�W�̒i�C���f�b�N�X
	 * @return �����Ώۂł����true�A�Ȃ����false��߂�
	 */
	protected boolean isJoinMember(String beforeKeys, String keys, int hieIndex) {

		if (beforeKeys == null) {
			return false;
		}

		ArrayList<String> keyList = StringUtil.splitString(keys, ";");
		ArrayList<String> beforeKeyList = StringUtil.splitString(beforeKeys, ";");

		for (int i = 0; i < hieIndex+1; i++) {	// �w�肳�ꂽ�i����т��̏�i��Key�͓��������m�F
			String key = keyList.get(i);
			String beforeKey = beforeKeyList.get(i);
			if (!key.equals(beforeKey)){
				return false;
			}
		}
		return true;
	}


}

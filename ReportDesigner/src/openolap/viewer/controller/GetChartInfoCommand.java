/* OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FGetChartInfoCommand.java
 *  �����FJFreeChart�p��XML�h�L�������g�𐶐�����N���X�ł��B
 *  �쐬��: 2004/08/05
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import org.w3c.dom.Document;

import openolap.viewer.Report;
import openolap.viewer.chart.ChartCreator;
import openolap.viewer.chart.ChartXMLCreator;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.manager.CellDataManager;

/**
 *  �N���X�FGetChartInfoCommand<br>
 *  �����FJFreeChart�p��XML�h�L�������g�𐶐�����N���X�ł��B
 */
public class GetChartInfoCommand implements Command {

	/*
	 * �Z�b�V������Report�I�u�W�F�N�g�����A�`���[�g����ʃ^�C�v�E�f�t�H���g�`���[�g�^�C�v�����X�V��A
	 * JFreeChart�p��XML�h�L�������g�𐶐�����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, Exception {

		// Session����Report�I�u�W�F�N�g���X�V
		Report report = (Report)helper.getRequest().getSession().getAttribute("report");

		// �`���[�g����ʃ^�C�v���X�V
		String dispScreenType = (String)helper.getRequest().getParameter("displayScreenType");
		report.setDisplayScreenType(dispScreenType);

		// �f�t�H���g�`���[�g�^�C�v�����X�V
		String chartID = (String)helper.getRequest().getParameter("chartID");
		String chartName = (new ChartXMLCreator()).chartIdToName(ChartXMLCreator.getChartXMLFilePath(helper), chartID);
		report.setCurrentChart(chartName);

		// ��ʃ^�C�v���A�S��ʁi�\�j�ł���΁A����ȍ~�̃`���[�g���������͍s�Ȃ�Ȃ�
		// �i�������A�����܂ł̏����ŁA�Z�b�V�������͍X�V�ł����B�j
		if ("0".equals(dispScreenType)) {
			return "/spread/blank.html";
		}
		

		// �f�B�����V���������o�A�Z���f�[�^�擾������Session�Ɉꎞ�ۑ�
		// �i�Z���f�[�^�擾���������|�[�g�̒l�擾�����Ƌ��ʉ����邽�߁j
		CellDataManager.saveRequestParamsToSession(helper);

		// Chart�����pXML�h�L�������g�𐶐��A�擾
		Document chartXMLDoc = (new ChartXMLCreator()).createXML(helper, commonSettings);

		// ChartCreator���g�p���AXML�h�L�������g���`���[�g��ݒ�
		ChartCreator chartCreator = new ChartCreator();
		chartCreator.createChart(chartXMLDoc);

		// ChartCreator�I�u�W�F�N�g���Arequest �I�u�W�F�N�g�ɕۑ�
		helper.getRequest().setAttribute("chartCreator", chartCreator);

		// Session����A�f�[�^�擾�p�̃��^�����폜
//		CellDataManager.clearRequestParamForGetDataInfo(helper); 

		return "/spread/chartInfo.jsp";
	}

}

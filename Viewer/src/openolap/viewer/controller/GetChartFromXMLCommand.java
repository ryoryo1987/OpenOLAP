/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FRequestHelper.java
 *  �����F�N���C�A���g����̃��N�G�X�g�Ə�����R�t����N���X�ł��B
 *
 *  �쐬��: 2004/01/05
 */

package openolap.viewer.controller;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import openolap.viewer.XMLConverter;
import openolap.viewer.chart.ChartCreator;
import openolap.viewer.common.CommonSettings;

/**
 *  �N���X�FGetChartFromXMLCommand<br>
 *  �����F�N���C�A���g��著�M����Ă���JFreeChart�p��XML�h�L�������g���O���t�𐶐�����N���X�ł��B
 *        <�K�v��Request�p�����[�^>
 * 	      strCode:       Chart�����pXML�h�L�������g�̕����R�[�h
 *        chartXML:      Chart�����pXML�h�L�������g
 *        chartDispMode: �`���[�g�\�����[�h 
 *                         �l = xml   �F XML ���o�͂��A�C���[�W�t�@�C���\���pJSP���Ăяo�����[�h
 *                         �l = image �F �C���[�W�t�@�C���𒼐ڏo�͂��郂�[�h
 */
public class GetChartFromXMLCommand implements Command {

	final private String outXMLMode   = "xml";		// XML ���o�͂��A�C���[�W�t�@�C���\���pJSP���Ăяo�����[�h
	final private String outImageMode = "image";		// �C���[�W�t�@�C���𒼐ڏo�͂��郂�[�h
	final private String outJSPPage   = "/spread/chartInfo.jsp";	// �C���[�W�t�@�C���\���pJSP

	// ********** ���\�b�h **********

	/*
	 * JFreeChart��\������B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 *         XML��value�����l�ł͂Ȃ��Ȃǂ̗��R�ŁANumberFormatException�����������ꍇ�́A
	 *         �u�����N�y�[�W��߂�
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, Exception {

			// Chart�����pXML�h�L�������g�̕����R�[�h���擾
			String sourceStrCode = helper.getRequest().getParameter("strCode");

			// Chart�����pXML�h�L�������g�𐶐��A�擾
			String tmpChartXML = helper.getRequest().getParameter("chartXML");
//			String chartXML = new String(tmpChartXML.getBytes(sourceStrCode), "Shift_JIS");
			String chartXML = URLDecoder.decode(tmpChartXML , "UTF-8");

			XMLConverter xmlConverter = new XMLConverter();
			Document chartXMLDoc = xmlConverter.toXMLDocument(chartXML);

			// XML��Value�v�f���A�t�H�[�}�b�g�����i�J���}�i,�j�A���p�ʉ݋L���i\�j�A�S�p�ʉ݋L���i���j�A�����i%�j�j���폜
			NodeList values =  xmlConverter.selectNodes(chartXMLDoc, "//Value");
			for (int i=0; i<values.getLength(); i++) {
				Node node = values.item(i);
				String value = node.getFirstChild().getNodeValue();
				String numberValue = value.replaceAll(",", "");
				numberValue = numberValue.replaceAll("\\\\", "");
				numberValue = numberValue.replaceAll("��", "");
				numberValue = numberValue.replaceAll("%", "");
				node.getFirstChild().setNodeValue(numberValue);	
			}


			// ChartCreator���g�p���AXML�h�L�������g���`���[�g��ݒ�
			ChartCreator chartCreator = new ChartCreator();
			try {
				chartCreator.createChart(chartXMLDoc);
			} catch (NumberFormatException e) {
				// XML��Value��������łȂ������ꍇ�ɂ́A�u�����N�y�[�W��߂��B
				return "/spread/blank.html";
			}
			

			// ���[�h��I��
			// 1. Chart�C���[�W�t�@�C���\���pJSP���Ăяo���AHTML���ŃC���[�W��\��������@
			// 2. Chart�C���[�W�t�@�C���𒼐ڏo�͂�����@
			String chartDispMode = helper.getRequest().getParameter("chartDispMode");
			if(outXMLMode.equals(chartDispMode)) {
				// ChartCreator�I�u�W�F�N�g���Arequest �I�u�W�F�N�g�ɕۑ�
				helper.getRequest().setAttribute("chartCreator", chartCreator);
				return outJSPPage;				
			} else if (outImageMode.equals(chartDispMode)) {
				// �C���[�W�𒼐ڏo��
				chartCreator.outDirectPNGChart(helper.getResponse());
				return null;	
			} else {
				throw new IllegalArgumentException();
			}

	}
}

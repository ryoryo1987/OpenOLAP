/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.jspHelper
 *  �t�@�C���FDisplaySelecter.java
 *  �����F�Z���N�^�\����⍲����N���X�ł��B
 *
 *  �쐬��: 2004/01/12
 */
package openolap.viewer.jspHelper;

import java.io.IOException;
import java.util.Iterator;

import javax.servlet.jsp.JspWriter;

import openolap.viewer.Axis;
import openolap.viewer.AxisLevel;
import openolap.viewer.Report;

/**
 *  �N���X�FDisplaySelecter<br>
 *  �����F�Z���N�^�\����⍲����N���X�ł��B
 */
public class DisplaySelecter {

	// ********** ���\�b�h **********

	/**
	 * �^����ꂽ���̃��x�����̂�<option>�^�O�ɖ��ߍ��܂ꂽ�`���ŏo�͂���B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param targetAxisID ��ID
	 * @param out JspWriter�I�u�W�F�N�g
	 * @exception IOException �����ŗ�O����������
	 */
	 public void outLevelName( Report report, String targetAxisID, JspWriter out ) throws IOException {

		 Axis axis = report.getAxisByID(targetAxisID);
		 Iterator<AxisLevel> it = axis.getAxisLevelList().iterator();
		 while (it.hasNext()) {
			 AxisLevel axisLevel = it.next();
			 out.println("<option value='" + axisLevel.getLevelNumber() + "'>");
				 out.println(axisLevel.getName());
			 out.println("</option>");
		 }
	 }

}

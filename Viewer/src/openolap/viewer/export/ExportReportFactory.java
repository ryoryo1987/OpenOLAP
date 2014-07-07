/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.export
 *  �t�@�C���FExportReportFactory.java
 *  �����F���|�[�g���G�N�X�|�[�g����I�u�W�F�N�g�𐶐�����N���X
 *
 *  �쐬��: 2004/01/31
 */
package openolap.viewer.export;

import openolap.viewer.User;

/**
 *  �N���X�FExportReportFactory<br>
 *  �����F���|�[�g���G�N�X�|�[�g����I�u�W�F�N�g�𐶐�����N���X
 */
public class ExportReportFactory {

	/**
	 * ���|�[�g���G�N�X�|�[�g����I�u�W�F�N�g�����߂�B
	 * @param ���[�U�[������킷�I�u�W�F�N�g
	 * @return ���|�[�g���G�N�X�|�[�g����I�u�W�F�N�g
	 */
	public ExportReport getExportReport(User user) {

		if (user.getExportFileType().equals("CSV")){
			return new ExportReportAsCSV();
		} else if (user.getExportFileType().equals("XMLSpreadSheet")) {
			return new ExportReportAsXMLSpreadsheetSchema();
		} else {
			return null;
		}

	}

}

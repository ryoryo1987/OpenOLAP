/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.export
 *  ファイル：ExportReportFactory.java
 *  説明：レポートをエクスポートするオブジェクトを生成するクラス
 *
 *  作成日: 2004/01/31
 */
package openolap.viewer.export;

import openolap.viewer.User;

/**
 *  クラス：ExportReportFactory<br>
 *  説明：レポートをエクスポートするオブジェクトを生成するクラス
 */
public class ExportReportFactory {

	/**
	 * レポートをエクスポートするオブジェクトを求める。
	 * @param ユーザーをあらわすオブジェクト
	 * @return レポートをエクスポートするオブジェクト
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

/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：GetCannotDispReportMSGCommand.java
 *  説明：レポートの表示権限が無い旨のメッセージを表示する処理を行なうクラスです。
 *
 *  作成日: 2004/09/16
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  クラス：GetCannotDispReportMSGCommand<br>
 *  説明：レポートの表示権限が無い旨のメッセージを表示する処理を行なうクラスです。
 */
public class GetCannotDispReportMSGCommand implements Command {

	/**
	 * レポートの表示権限が無い旨のメッセージをRequestに登録し、message.jspへディスパッチする。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		helper.getRequest().setAttribute("message", "レポートの表示権限がありません。");

		return "/spread/message.jsp";
	}

}

/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：InvalidateSessionCommand.java
 *  説明：セッションが無効である旨をあらわすメッセージを表示するクラスです。
 *
 *  作成日: 2004/02/13
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;
//import openolap.viewer.common.Messages;

/**
 *  クラス：InvalidateSessionCommand<br>
 *  説明：セッションが無効である旨をあらわすメッセージを表示するクラスです。
 */
public class InvalidateSessionCommand implements Command {

	/**
	 * セッションが無効である旨をあらわすメッセージを取得・設定し、
	 * メッセージ表示用ページへdispatchする。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

//		String message = Messages.getString("InvalidateSessionCommand.invalidateSessionMessage"); //$NON-NLS-1$
//		helper.getRequest().setAttribute("message", message);


		String nextPage = "/spread/redirectTo.jsp";
		helper.getRequest().setAttribute("redirectTo", "/login.jsp");
		helper.getRequest().setAttribute("targetFrame", "TOP");
		
		return nextPage;
	}

}

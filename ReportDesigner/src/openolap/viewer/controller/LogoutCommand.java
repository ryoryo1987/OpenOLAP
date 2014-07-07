/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：LogoutCommand.java
 *  説明：ログアウト処理を行うクラスです。
 *
 *  作成日: 2004/01/26
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Messages;

/**
 *  クラス：LogoutCommand<br>
 *  説明：ログアウト処理を行うクラスです。
 */
public class LogoutCommand implements Command {

	/**
	 * ログアウト処理を行う。<br>
	 * Sessionオブジェクトを初期化し、ログアウトメッセージを取得・設定してメッセージページを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		// session の初期化
		helper.getRequest().getSession().invalidate(); 

		String message = Messages.getString("LogoutCommand.logoutMessage"); //$NON-NLS-1$
		helper.getRequest().setAttribute("message", message);

		return "/spread/message.jsp";
	}

}

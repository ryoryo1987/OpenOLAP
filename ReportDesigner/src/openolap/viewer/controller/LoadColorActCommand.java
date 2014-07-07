/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：LoadColorActCommand.java
 *  説明：色情報XML取得および色情報のSpreadへの適用を行うページを戻すクラスです。
 *
 *  作成日: 2004/01/18
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  クラス：LoadColorActCommand<br>
 *  説明：色情報XML取得および色情報のSpreadへの適用を行うページを戻すクラスです。
 */
public class LoadColorActCommand implements Command {

	/**
	 * 色情報XML取得および色情報のSpreadへの適用を行うページを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {


		return "/spread/colorSetAct.jsp";
	}

}

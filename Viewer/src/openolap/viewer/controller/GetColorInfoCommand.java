/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：GetColorInfoCommand.java
 *  説明：色情報をXMLで出力するページへdispatchするクラスです。
 *
 *  作成日: 2004/01/18
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  クラス：GetColorInfoCommand<br>
 *  説明：色情報をXMLで出力するページへdispatchするクラスです。
 */
public class GetColorInfoCommand implements Command {

	/**
	 * 色情報をあらわすXMLを出力する。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		return "/spread/colorInfo.jsp";
	}

}

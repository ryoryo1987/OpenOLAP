/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Command.java
 *  説明：コマンドをあらわすインターフェースです。
 *
 *  作成日: 2004/01/05
 */

package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  インターフェース：Command<br>
 *  説明：コマンドをあらわすインターフェースです。
 */
public interface Command {

	// ********** メソッド **********

	/**
	 * 処理を実行し、dispatch先のJSP/HTMLのパスを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 * @exception Exception 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings) throws ServletException, IOException, Exception;

}

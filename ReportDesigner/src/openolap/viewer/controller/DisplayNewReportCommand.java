/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：DisplayNewReportCommand.java
 *  説明：レポートのフレームファイルをクライアント側に戻すクラスです。
 *
 *  作成日: 2004/01/05
 */

package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 * クラス：DisplayNewReportCommand<br>
 * 説明：レポートのフレームファイルをクライアント側に戻すクラスです。
 */
public class DisplayNewReportCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	// ********** メソッド **********

	/**
	 * レポートのフレームファイルをクライアント側に戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		this.requestHelper = helper;
		
		return "/spread/spread_frm.jsp";
	}
}

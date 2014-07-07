/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：LoadDataActCommand.java
 *  説明：値情報XML取得および値情報のSpreadへの挿入を行うページを戻すクラスです。
 *
 *  作成日: 2004/01/20
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.dao.AxisDAO;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.manager.CellDataManager;

/**
 *  クラス：LoadDataActCommand<br>
 *  説明：値情報XML取得および値情報のSpreadへの挿入を行うページを戻すクラスです。
 */
public class LoadDataActCommand implements Command {

	/**
	 * 軸のデフォルトメンバ情報の更新を行った後、値情報XML取得および値情報のSpreadへの適用を行うページを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		// 軸のデフォルトメンバ情報を更新
		AxisDAO axisDAO = DAOFactory.getDAOFactory().getAxisDAO(null);
		axisDAO.registDefaultMember(helper, commonSettings);

		// セルデータ取得条件をSessionに一時保存
		CellDataManager.saveRequestParamsToSession(helper);

		return "/spread/dataSetAct.jsp";
	}


}

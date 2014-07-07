/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：RegistColorOnlyCommand.java
 *  説明：色情報のセッションへの追加処理を行うクラスです。
 *
 *  作成日: 2004/09/17
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.dao.ColorDAO;
import openolap.viewer.dao.DAOFactory;

/**
 *  クラス：RegistColorOnlyCommand<br>
 *  説明：色情報のセッションへの追加処理を行うクラスです。
 */
public class RegistColorOnlyCommand implements Command {

	// ********** メソッド **********
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		// 色設定情報を更新
		String mode = (String)helper.getRequest().getParameter("mode");
		ColorDAO colorDAO = DAOFactory.getDAOFactory().getColorDAO(null);
		colorDAO.registColor(helper, commonSettings);

		return "/spread/blank.html";
	}

}

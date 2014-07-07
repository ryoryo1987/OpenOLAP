/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：InitializeStatus.java
 *  説明：アプリケーションの初期化を行うクラスです。
 *
 *  作成日: 2004/01/12
 */
package openolap.viewer.controller;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.MeasureMemberTypeDAO;
import openolap.viewer.MeasureMemberType;

/**
 *  クラス：InitializeStatus<br>
 *  説明：アプリケーションの初期化を行うクラスです。
 */
public class InitializeStatus {

	/**
	 * アプリケーションの初期化を行い、共通設定をServletContextへ登録する。
	 * @param context ServletContextオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 */
	public static void initApStatus(HttpServletRequest request, ServletContext context) throws SQLException, NamingException {

		Connection conn = null;

		if ( context.getAttribute("apCommonSettings") == null ) {

			DAOFactory daoFactory = DAOFactory.getDAOFactory();
			if (conn == null){
				conn = daoFactory.getConnection((String)request.getSession().getAttribute("connectionPoolName"),
												(String)request.getSession().getAttribute("searchPathName"));
			}

			CommonSettings commonSettings = CommonSettings.getCommonSettings();

			try {
				MeasureMemberTypeDAO measureMemberTypeDAO = daoFactory.getMeasureMemberTypeDAO(conn);
				ArrayList<MeasureMemberType> measureMemberTypeList = measureMemberTypeDAO.getMeasureMemberTypeList();

				commonSettings.addMeasureMemberTypeList(measureMemberTypeList);

				// ServletContextへ登録
				context.setAttribute("apCommonSettings", commonSettings);
				
			} catch (SQLException e) {
				throw e;
			} finally {
				try {
					if (conn != null) {
						conn.close();
					}
				} catch (SQLException e) {
					throw e;
				}
			}
		}
	}
}

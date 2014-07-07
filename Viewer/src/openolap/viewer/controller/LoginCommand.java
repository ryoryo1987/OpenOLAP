/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：LoginCommand.java
 *  説明：ログイン処理を行うクラスです。
 *
 *  作成日: 2004/01/30
 */
package openolap.viewer.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import openolap.viewer.User;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.UserDAO;

/**
 *  クラス：LoginCommand<br>
 *  説明：ログイン処理を行うクラスです。
 */
public class LoginCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	// ********** メソッド **********

	/**
	 * ログイン処理を行う。<br>
	 * 与えられた「ユーザー名」、「パスワード」パラメータをDBに保存されている情報を比較し、等しい場合はログイン成功とする。<br>
	 * ログイン成功すると、ユーザーオブジェクトをセッションに登録し、「ツリーとホーム」画面へリダイレクトさせるページを戻す。<br>
	 * ログイン失敗の場合は、ログイン失敗ステータスつきでログインページを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 * @exception SQLException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, SQLException, NamingException {

		String nextPage = null;

		this.requestHelper = helper;
		HttpServletRequest request = this.requestHelper.getRequest();
		HttpSession session = this.requestHelper.getRequest().getSession();

		// ユーザチェック
		String userName = request.getParameter("user");
		String password = request.getParameter("password");

		if ( (userName == null) && (password == null) ) {
			return "/jsp/login.jsp";
		}

		// ユーザ認証開始
		Connection conn = null;
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
										(String)helper.getRequest().getSession().getAttribute("searchPathName"));
	
		UserDAO userDAO =  daoFactory.getUserDAO(conn);
		User user = null;
		try {
			user = userDAO.getUser(userName, password);
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

		if ( user == null ) {
			nextPage = "/login.jsp";
			request.setAttribute("loginResult", "failed");
		} else {

			// UserオブジェクトをSessionに登録
			request.getSession().setAttribute("user", user);
			nextPage = "/spread/redirectTo.jsp";
			request.setAttribute("redirectTo", "/OpenOLAP.jsp");
			request.setAttribute("targetFrame", "TOP");
		}

		return nextPage;
	}

}

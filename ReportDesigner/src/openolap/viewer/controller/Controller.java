/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Controller.java
 *  説明：クライアントからの要求を処理するServletクラスです。
 *
 *  作成日: 2004/01/05
 */

package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Messages;
import openolap.viewer.common.StringUtil;

/**
 * クラス：Controller<br>
 * 説明：コマンドをあらわすインターフェースです。
 */
public class Controller extends HttpServlet {

	// ********** 静的変数 **********
	// default Error 情報
	static final String defaultErrorPage = "/spread/error.jsp";

	// クライアント側に、指定したページへリダイレクトさせるためのページ
	static final String defaultRedirectPage = "/spread/redirectTo.jsp";


	// ********** メソッド **********

	/**
	 * サーブレットの初期化処理を行う。
	 * @param config ServletConfigオブジェクト
	 * @exception ServletException Servletの初期化処理で例外が発生した
	 */
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}

	/**
	 * サーブレットの終了処理を行う。
	 */
	public void destroy() {
	}

	/**
	 * HTTPリクエストを受けて処理を実行する。
	 * @param request HttpServletRequestオブジェクト
	 * @param response HttpServletResponseオブジェクト
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	protected void processRequest(
		HttpServletRequest request,HttpServletResponse response) 
		throws ServletException,java.io.IOException {

		String page;
		try {

			// 文字コード設定
			request.setCharacterEncoding("Shift_JIS");

			// コネクションプールを設定
			String connectionPoolName = request.getParameter("poolName");
			if (connectionPoolName != null) { // リクエストが無い
				if (!"".equals(connectionPoolName)) { // 空文字ではない
					request.getSession().setAttribute("connectionPoolName", connectionPoolName);
				} else {
					if (request.getSession().getAttribute("connectionPoolName") == null) {
						throw new IllegalStateException();
					}
				}
			}

			// サーチパスを設定（Postgres用）
			String sourceName = Messages.getString("DAOFactory.sourceName"); //$NON-NLS-1$
			if (sourceName.equals("postgres")) { //$NON-NLS-1$
				String searchPathName = request.getParameter("schemaName");
				if (searchPathName != null) { // リクエストが無い
					if (!"".equals(searchPathName)) { // 空文字ではない
						request.getSession().setAttribute("searchPathName", searchPathName);
					} else {
						if (request.getSession().getAttribute("searchPathName") == null) {
							throw new IllegalStateException();
						}
					}
				}
			}

			// 初期化
			ServletContext context = getServletConfig().getServletContext();
			if ( context.getAttribute("apCommonSettings") == null ) {
				InitializeStatus.initApStatus(request, context);
			}

			// 呼び出す業務処理を選択
			RequestHelper helper = new RequestHelper(request, response, getServletConfig());
			Command command = helper.getCommand();
	
			if (command == null) { throw new IllegalStateException(); }
			if (context == null) { throw new IllegalStateException();	}

			// 業務処理呼び出し
			page = command.execute(helper, (CommonSettings) context.getAttribute("apCommonSettings"));

		} catch(Exception e) {

			Logger log = Logger.getLogger(Controller.class.getName());
			log.error("Controller において、Exceptionがcatchされました。", e);

			e.printStackTrace();

			// エラーページへリダイレクトさせる。
			page = defaultRedirectPage;

			String tmpMsg = StringUtil.regReplaceAll("\"", "'",e.toString());
			request.setAttribute("errorMessage", StringUtil.regReplaceAll("\n", "", tmpMsg));
			request.setAttribute("redirectTo", defaultErrorPage);
			request.setAttribute("targetFrame", "VIEW");

		}

		//制御をリクエストに対応するページにディスパッチする
		if(page != null) {
			dispatch(request,response,page);
		}

	}

	/**
	 * HTTP GETをハンドリングする。
	 * @param request HttpServletRequestオブジェクト
	 * @param response HttpServletResponseオブジェクト
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	protected void doGet(
		HttpServletRequest request,
		HttpServletResponse response)
		throws ServletException, IOException {

		processRequest(request,response);
	}

	/**
	 * HTTP POSTをハンドリングする。
	 * @param request HttpServletRequestオブジェクト
	 * @param response HttpServletResponseオブジェクト
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	protected void doPost(
		HttpServletRequest request,
		HttpServletResponse response)
		throws ServletException, IOException {

		processRequest(request,response);
	}

	/**
	 * JSP/HTMLへのdispatch処理を実行する。
	 * @param request HttpServletRequestオブジェクト
	 * @param response HttpServletResponseオブジェクト
	 * @param page dispatch先のJSP/HTMLへのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	protected void dispatch(
		HttpServletRequest request,
		HttpServletResponse response,
		String page) 
		throws ServletException,java.io.IOException {

		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(page);
		dispatcher.forward(request,response);
	}

}

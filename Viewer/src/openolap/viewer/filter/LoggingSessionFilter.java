/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.filter
 *  ファイル：LoggingSessionFilter.java
 *  説明：セッション情報をロギングするクラスです。
 *
 *  作成日: 2004/10/19
 */
package openolap.viewer.filter;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;

import openolap.viewer.common.CommonUtils;

import org.apache.log4j.Logger;

/**
 *  クラス：LoggingSessionFilter<br>
 *  説明：セッション情報をロギングするクラスです。
 */
public class LoggingSessionFilter implements Filter {


	// ********** インスタンス変数 **********

	/** ロギングオブジェクト */
	private static final Logger logger = Logger.getLogger(LoggingSessionFilter.class);

	/** FilterConfig オブジェクト */
	private FilterConfig filterConfig = null;


	// ********** メソッド **********

	public void init(FilterConfig filterConfig)
	   throws ServletException {

	   this.filterConfig = filterConfig;
	}

	public void destroy() {

	   this.filterConfig = null;
	}


	/**
	 * リクエスト時にセッションをロギングする。
	 * @param request リクエストオブジェクト
	 * @param response レスポンスオブジェクト
	 * @param chain フィルターチェーンオブジェクト
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
	  throws IOException, ServletException {

		if (filterConfig == null) {
			return;
		}

		if (request instanceof HttpServletRequest) {

			if(logger.isDebugEnabled()) {

				// 文字コード設定
				request.setCharacterEncoding("Shift_JIS");

				HttpServletRequest req = (HttpServletRequest) request;
				String sep = System.getProperty("line.separator");

				// セッションをロギングする。
				logger.debug(CommonUtils.getSessionParameters(req).toString());

			}

		}

	  // 次のフィルタまたは元々要求されていたリソースを呼び出します。
	  chain.doFilter(request, response);
	}

}

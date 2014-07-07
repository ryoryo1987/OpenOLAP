/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.filter
 *  ファイル：LoggingRequestFilter.java
 *  説明：リクエスト情報をロギングするクラスです。
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
 *  クラス：LoggingRequestFilter<br>
 *  説明：リクエスト情報をロギングするクラスです。
 */
public class LoggingRequestFilter implements Filter {

	// ********** インスタンス変数 **********

	/** ロギングオブジェクト */
	private static final Logger logger = Logger.getLogger(LoggingRequestFilter.class);

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
	 * リクエスト時に送信されてきたパラメーターのキーと値をロギングする。
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

			if(logger.isInfoEnabled()) {

				HttpServletRequest req = (HttpServletRequest) request;
				String sep = System.getProperty("line.separator");
				logger.info("    RequestURL:" + req.getRequestURL());

				if(logger.isDebugEnabled()) {

					// 文字コード設定
					request.setCharacterEncoding("Shift_JIS");

					logger.debug("    Remote Host:" + req.getRemoteHost() + sep + 
								 "    Remote Addr:" + req.getRemoteAddr() + sep + 
								 "    Query String:" + req.getQueryString());

					// クライアントからのリクエストをロギングする。
					logger.debug(CommonUtils.getRequestParameters(req).toString());

				}
			}
		}

	  // 次のフィルタまたは元々要求されていたリソースを呼び出します。
	  chain.doFilter(request, response);
	}

}

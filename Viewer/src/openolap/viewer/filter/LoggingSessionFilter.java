/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.filter
 *  �t�@�C���FLoggingSessionFilter.java
 *  �����F�Z�b�V�����������M���O����N���X�ł��B
 *
 *  �쐬��: 2004/10/19
 */
package openolap.viewer.filter;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;

import openolap.viewer.common.CommonUtils;

import org.apache.log4j.Logger;

/**
 *  �N���X�FLoggingSessionFilter<br>
 *  �����F�Z�b�V�����������M���O����N���X�ł��B
 */
public class LoggingSessionFilter implements Filter {


	// ********** �C���X�^���X�ϐ� **********

	/** ���M���O�I�u�W�F�N�g */
	private static final Logger logger = Logger.getLogger(LoggingSessionFilter.class);

	/** FilterConfig �I�u�W�F�N�g */
	private FilterConfig filterConfig = null;


	// ********** ���\�b�h **********

	public void init(FilterConfig filterConfig)
	   throws ServletException {

	   this.filterConfig = filterConfig;
	}

	public void destroy() {

	   this.filterConfig = null;
	}


	/**
	 * ���N�G�X�g���ɃZ�b�V���������M���O����B
	 * @param request ���N�G�X�g�I�u�W�F�N�g
	 * @param response ���X�|���X�I�u�W�F�N�g
	 * @param chain �t�B���^�[�`�F�[���I�u�W�F�N�g
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
	  throws IOException, ServletException {

		if (filterConfig == null) {
			return;
		}

		if (request instanceof HttpServletRequest) {

			if(logger.isDebugEnabled()) {

				// �����R�[�h�ݒ�
				request.setCharacterEncoding("Shift_JIS");

				HttpServletRequest req = (HttpServletRequest) request;
				String sep = System.getProperty("line.separator");

				// �Z�b�V���������M���O����B
				logger.debug(CommonUtils.getSessionParameters(req).toString());

			}

		}

	  // ���̃t�B���^�܂��͌��X�v������Ă������\�[�X���Ăяo���܂��B
	  chain.doFilter(request, response);
	}

}

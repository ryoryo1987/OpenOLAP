/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FController.java
 *  �����F�N���C�A���g����̗v������������Servlet�N���X�ł��B
 *
 *  �쐬��: 2004/01/05
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
 * �N���X�FController<br>
 * �����F�R�}���h������킷�C���^�[�t�F�[�X�ł��B
 */
public class Controller extends HttpServlet {

	// ********** �ÓI�ϐ� **********
	// default Error ���
	static final String defaultErrorPage = "/spread/error.jsp";

	// �N���C�A���g���ɁA�w�肵���y�[�W�փ��_�C���N�g�����邽�߂̃y�[�W
	static final String defaultRedirectPage = "/spread/redirectTo.jsp";


	// ********** ���\�b�h **********

	/**
	 * �T�[�u���b�g�̏������������s���B
	 * @param config ServletConfig�I�u�W�F�N�g
	 * @exception ServletException Servlet�̏����������ŗ�O����������
	 */
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}

	/**
	 * �T�[�u���b�g�̏I���������s���B
	 */
	public void destroy() {
	}

	/**
	 * HTTP���N�G�X�g���󂯂ď��������s����B
	 * @param request HttpServletRequest�I�u�W�F�N�g
	 * @param response HttpServletResponse�I�u�W�F�N�g
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	protected void processRequest(
		HttpServletRequest request,HttpServletResponse response) 
		throws ServletException,java.io.IOException {

		String page;
		try {

			// �����R�[�h�ݒ�
			request.setCharacterEncoding("Shift_JIS");

			// �R�l�N�V�����v�[����ݒ�
			String connectionPoolName = request.getParameter("poolName");
			if (connectionPoolName != null) { // ���N�G�X�g������
				if (!"".equals(connectionPoolName)) { // �󕶎��ł͂Ȃ�
					request.getSession().setAttribute("connectionPoolName", connectionPoolName);
				} else {
					if (request.getSession().getAttribute("connectionPoolName") == null) {
						throw new IllegalStateException();
					}
				}
			}

			// �T�[�`�p�X��ݒ�iPostgres�p�j
			String sourceName = Messages.getString("DAOFactory.sourceName"); //$NON-NLS-1$
			if (sourceName.equals("postgres")) { //$NON-NLS-1$
				String searchPathName = request.getParameter("schemaName");
				if (searchPathName != null) { // ���N�G�X�g������
					if (!"".equals(searchPathName)) { // �󕶎��ł͂Ȃ�
						request.getSession().setAttribute("searchPathName", searchPathName);
					} else {
						if (request.getSession().getAttribute("searchPathName") == null) {
							throw new IllegalStateException();
						}
					}
				}
			}

			// ������
			ServletContext context = getServletConfig().getServletContext();
			if ( context.getAttribute("apCommonSettings") == null ) {
				InitializeStatus.initApStatus(request, context);
			}

			// �Ăяo���Ɩ�������I��
			RequestHelper helper = new RequestHelper(request, response, getServletConfig());
			Command command = helper.getCommand();
	
			if (command == null) { throw new IllegalStateException(); }
			if (context == null) { throw new IllegalStateException();	}

			// �Ɩ������Ăяo��
			page = command.execute(helper, (CommonSettings) context.getAttribute("apCommonSettings"));

		} catch(Exception e) {

			Logger log = Logger.getLogger(Controller.class.getName());
			log.error("Controller �ɂ����āAException��catch����܂����B", e);

			e.printStackTrace();

			// �G���[�y�[�W�փ��_�C���N�g������B
			page = defaultRedirectPage;

			String tmpMsg = StringUtil.regReplaceAll("\"", "'",e.toString());
			request.setAttribute("errorMessage", StringUtil.regReplaceAll("\n", "", tmpMsg));
			request.setAttribute("redirectTo", defaultErrorPage);
			request.setAttribute("targetFrame", "VIEW");

		}

		//��������N�G�X�g�ɑΉ�����y�[�W�Ƀf�B�X�p�b�`����
		if(page != null) {
			dispatch(request,response,page);
		}

	}

	/**
	 * HTTP GET���n���h�����O����B
	 * @param request HttpServletRequest�I�u�W�F�N�g
	 * @param response HttpServletResponse�I�u�W�F�N�g
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	protected void doGet(
		HttpServletRequest request,
		HttpServletResponse response)
		throws ServletException, IOException {

		processRequest(request,response);
	}

	/**
	 * HTTP POST���n���h�����O����B
	 * @param request HttpServletRequest�I�u�W�F�N�g
	 * @param response HttpServletResponse�I�u�W�F�N�g
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	protected void doPost(
		HttpServletRequest request,
		HttpServletResponse response)
		throws ServletException, IOException {

		processRequest(request,response);
	}

	/**
	 * JSP/HTML�ւ�dispatch���������s����B
	 * @param request HttpServletRequest�I�u�W�F�N�g
	 * @param response HttpServletResponse�I�u�W�F�N�g
	 * @param page dispatch���JSP/HTML�ւ̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
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

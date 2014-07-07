/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FLoginCommand.java
 *  �����F���O�C���������s���N���X�ł��B
 *
 *  �쐬��: 2004/01/30
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
 *  �N���X�FLoginCommand<br>
 *  �����F���O�C���������s���N���X�ł��B
 */
public class LoginCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	// ********** ���\�b�h **********

	/**
	 * ���O�C���������s���B<br>
	 * �^����ꂽ�u���[�U�[���v�A�u�p�X���[�h�v�p�����[�^��DB�ɕۑ�����Ă�������r���A�������ꍇ�̓��O�C�������Ƃ���B<br>
	 * ���O�C����������ƁA���[�U�[�I�u�W�F�N�g���Z�b�V�����ɓo�^���A�u�c���[�ƃz�[���v��ʂփ��_�C���N�g������y�[�W��߂��B<br>
	 * ���O�C�����s�̏ꍇ�́A���O�C�����s�X�e�[�^�X���Ń��O�C���y�[�W��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 * @exception SQLException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, SQLException, NamingException {

		String nextPage = null;

		this.requestHelper = helper;
		HttpServletRequest request = this.requestHelper.getRequest();
		HttpSession session = this.requestHelper.getRequest().getSession();

		// ���[�U�`�F�b�N
		String userName = request.getParameter("user");
		String password = request.getParameter("password");

		if ( (userName == null) && (password == null) ) {
			return "/jsp/login.jsp";
		}

		// ���[�U�F�؊J�n
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

			// User�I�u�W�F�N�g��Session�ɓo�^
			request.getSession().setAttribute("user", user);
			nextPage = "/spread/redirectTo.jsp";
			request.setAttribute("redirectTo", "/OpenOLAP.jsp");
			request.setAttribute("targetFrame", "TOP");
		}

		return nextPage;
	}

}

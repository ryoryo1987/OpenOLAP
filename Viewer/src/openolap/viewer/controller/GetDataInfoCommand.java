/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FGetDataInfoCommand.java
 *  �����F�l����XML�ŏo�͂���y�[�W��dispatch����N���X�ł��B
 *
 *  �쐬��: 2004/01/05
 */

package openolap.viewer.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.CellData;
import openolap.viewer.dao.CellDataDAO;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.manager.CellDataManager;

/**
 *  �N���X�FGetColorInfoCommand<br>
 *  �����F�l����XML�ŏo�͂���y�[�W��dispatch����N���X�ł��B
 */
public class GetDataInfoCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	/** DAOFactory�I�u�W�F�N�g */
	private DAOFactory daoFactory = null;

	// ********** ���\�b�h **********

	/**
	 * �l����XML�ŏo�͂���y�[�W��dispatch���܂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, SQLException, NamingException {

		this.requestHelper = helper;
		this.daoFactory = DAOFactory.getDAOFactory();

		Connection conn = null;
		conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
										(String)helper.getRequest().getSession().getAttribute("searchPathName"));

		try {
			// �^����ꂽ�擾���������Ƃ�CellData�I�u�W�F�N�g���X�g(�l�̓t�H�[�}�b�g�t)���擾��request�I�u�W�F�N�g�Ɉꎞ�ۑ�
			//  �iSQL�^�C�v�Ƃ��Ă͕W����I���j
			ArrayList<CellData> cellDataList = CellDataManager.selectCellDatas(this.requestHelper, conn, true, CellDataDAO.normalSQLTypeString);

			helper.getRequest().setAttribute("cellDataList", cellDataList);

		} catch (SQLException e) {
			throw e;
		} finally {
			// �R�l�N�V�����̊J��
			try {
				if(conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				throw e;
			}

		}

		// Session����A�f�[�^�擾�p�̃��^�����폜
		CellDataManager.clearRequestParamForGetDataInfo(this.requestHelper); 

		return "/spread/dataInfo.jsp";
	}

}

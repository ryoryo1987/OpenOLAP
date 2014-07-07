/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：GetDataInfoCommand.java
 *  説明：値情報をXMLで出力するページへdispatchするクラスです。
 *
 *  作成日: 2004/01/05
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
 *  クラス：GetColorInfoCommand<br>
 *  説明：値情報をXMLで出力するページへdispatchするクラスです。
 */
public class GetDataInfoCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	/** DAOFactoryオブジェクト */
	private DAOFactory daoFactory = null;

	// ********** メソッド **********

	/**
	 * 値情報をXMLで出力するページへdispatchします。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, SQLException, NamingException {

		this.requestHelper = helper;
		this.daoFactory = DAOFactory.getDAOFactory();

		Connection conn = null;
		conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
										(String)helper.getRequest().getSession().getAttribute("searchPathName"));

		try {
			// 与えられた取得条件をもとにCellDataオブジェクトリスト(値はフォーマット付)を取得しrequestオブジェクトに一時保存
			//  （SQLタイプとしては標準を選択）
			ArrayList<CellData> cellDataList = CellDataManager.selectCellDatas(this.requestHelper, conn, true, CellDataDAO.normalSQLTypeString);

			helper.getRequest().setAttribute("cellDataList", cellDataList);

		} catch (SQLException e) {
			throw e;
		} finally {
			// コネクションの開放
			try {
				if(conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				throw e;
			}

		}

		// Sessionから、データ取得用のメタ情報を削除
		CellDataManager.clearRequestParamForGetDataInfo(this.requestHelper); 

		return "/spread/dataInfo.jsp";
	}

}

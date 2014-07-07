/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：DisplaySelecterBodyCommand.java
 *  説明：指定された軸オブジェクトに軸メンバーをセットし、セレクタボディーフレーム部表示ページへdispatchするクラスです。
 *
 *  作成日: 2004/01/09
 */
package openolap.viewer.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletException;

import openolap.viewer.Dimension;
import openolap.viewer.Report;
import openolap.viewer.AxisMember;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionMemberDAO;

/**
 *  クラス：DisplaySelecterBodyCommand<br>
 *  説明：指定された軸オブジェクトに軸メンバーをセットし、セレクタボディーフレーム部表示ページへdispatchするクラスです。
 */
public class DisplaySelecterBodyCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	// ********** メソッド **********

	/**
	 * "dimNumber"パラメーターで与えられた軸IDがディメンションの場合、<br>
	 * 軸オブジェクトに軸メンバーをセットし、セレクタボディーフレーム部表示ページへdispatchする。<br>
	 * メジャーの場合は、何もせずにセレクタボディー部表示ページへdispatchする。
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

			this.requestHelper = helper;
			Report report = (Report) this.requestHelper.getRequest().getSession().getAttribute("report");

			// 軸がディメンションの場合、メンバーを取得（メジャーの場合はReportオブジェクト生成時に取得済み）
			String AxisID = this.requestHelper.getRequest().getParameter("dimNumber");
			if(!AxisID.equals(Constants.MeasureID)) {
				Dimension dim = (Dimension) report.getAxisByID(AxisID);
	
				Connection conn = null;
				DAOFactory daoFactory = DAOFactory.getDAOFactory();
				conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
												(String)helper.getRequest().getSession().getAttribute("searchPathName"));
	
				try {
					DimensionMemberDAO dimMemberDAO =  daoFactory.getDimensionMemberDAO(conn);
					ArrayList<AxisMember> dimMemberList = dimMemberDAO.selectDimensionMembers(dim,		// メンバを取得するディメンション
																				  null,	// short_nameによる絞込み条件
																				  null,	// long_nameによる絞込み条件
																				  null, 	// レベルによる絞込条件
																				  null);	// 検索対象キーリスト
					dim.setAxisMemberList(dimMemberList);
				} catch (SQLException e) {
					throw e;
				} finally {
					if(conn != null){
						try {
							conn.close();
						} catch (SQLException e) {
							throw e;
						}
					}
				}
			}
			return "/spread/SelecterBody.jsp";
	}
}

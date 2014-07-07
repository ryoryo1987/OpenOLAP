/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：SearchDimensionMemberCommand.java
 *  説明：ディメンションメンバーを与えられた条件で検索するクラスです。
 *
 *  作成日: 2004/01/09
 */
package openolap.viewer.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;

import openolap.viewer.Dimension;
import openolap.viewer.Report;
import openolap.viewer.AxisMember;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionMemberDAO;


/**
 *  クラス：SearchDimensionMemberCommand<br>
 *  説明：ディメンションメンバーを与えられた条件で検索するクラスです。
 */
public class SearchDimensionMemberCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	// ********** メソッド **********

	/**
	 * 下記条件でメンバー検索する<br>
	 *   －"dimNumber" パラメータで指定された軸<br>
	 *   －"listMemberName" メンバーの名称（ワイルドカード：*、_）<br>
	 *   －"listLevel" メンバーのレベル<br>
	 * 検索結果でセレクタボディーを書き換えるページを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, Exception {

			this.requestHelper = helper;

			Report report = (Report) this.requestHelper.getRequest().getSession().getAttribute("report");

			String AxisID = this.requestHelper.getRequest().getParameter("dimNumber");
			if(AxisID.equals(Constants.MeasureID)){	// 次元メンバの検索なので、メジャーであることはありえない
				throw new IllegalStateException();
			}

			Dimension dim = (Dimension) report.getAxisByID(AxisID);

			Connection conn = null;
			DAOFactory daoFactory = DAOFactory.getDAOFactory();
			conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
											(String)helper.getRequest().getSession().getAttribute("searchPathName"));

			DimensionMemberDAO dimMemberDAO =  daoFactory.getDimensionMemberDAO(conn);

			String searchMemName = this.requestHelper.getRequest().getParameter("listMemberName");
			String searchLevel   = this.requestHelper.getRequest().getParameter("listLevel");

			String shortNameCondition = null;
			String longNameCondition = null;

			if(dim.getDispMemberNameType().equals(Dimension.DISP_SHORT_NAME)){
				shortNameCondition = searchMemName;
			} else if(dim.getDispMemberNameType().equals(Dimension.DISP_LONG_NAME)){
				longNameCondition = searchMemName;
			} else {
				throw new IllegalStateException();
			}
			
			try {
				ArrayList<AxisMember> dimMemberList;
				dimMemberList =	dimMemberDAO.selectDimensionMembers(
								dim,
								shortNameCondition,
								longNameCondition,
								searchLevel,
								null);
				dim.setAxisMemberList(dimMemberList);

			} catch (SQLException e) {
				throw e;
			} catch (Exception e) {
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

			return "/spread/SelecterSearch.jsp";

	}
}

/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：RegistSelecterInfoCommand.java
 *  説明：セレクタで行われた設定を登録するクラスです。
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
import javax.servlet.http.HttpServletRequest;

import openolap.viewer.Axis;
import openolap.viewer.Dimension;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.common.StringUtil;
import openolap.viewer.dao.*;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionDAO;
import openolap.viewer.dao.MeasureMemberDAO;

/**
 *  クラス：RegistSelecterInfoCommand<br>
 *  説明：セレクタで行われた設定を登録するクラスです。
 */
public class RegistSelecterInfoCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	// ********** メソッド **********

	/**
	 * 下記、セレクタ情報の登録処理を行う。<br>
	 *   －軸メンバのセレクタによる絞込み情報、ドリル状況<br>
	 *   －軸の絞込み/ドリル状態<br>
	 *   －軸がセレクタによりメンバーが絞り込まれているかをあらわすフラグ<br>
	 *   －ディメンションのメンバー名の表示タイプ<br>
	 *   －メジャーメンバーのメジャーメンバータイプ<br>
	 *   －色設定情報<br>
	 * 設定の登録完了を意味し、Spreadの再表示を行うページを戻す。
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

			DAOFactory daoFactory = DAOFactory.getDAOFactory();

			// 軸のメンバのセレクタによる絞込み情報、ドリル状況を更新
			AxisDAO axisDAO = daoFactory.getAxisDAO(null);
			axisDAO.registSelectedMemberAndDrillStat(helper, commonSettings);

			// 軸がセレクタによりメンバーが絞り込まれているかをあらわすフラグを更新
			this.modifyAxisUsedSelecterCondition(helper);

			// ディメンションのメンバ名の表示タイプを更新
			DimensionDAO dimensionDAO = daoFactory.getDimensionDAO(null);
			dimensionDAO.registDimensionMemberDispType(helper, commonSettings);

			// メジャーメンバーのメジャーメンバータイプ設定を更新
			MeasureMemberDAO measureMemberDAO = daoFactory.getMeasureMemberDAO(null);
			measureMemberDAO.registMeasureMemberType(helper, commonSettings);

			// 色設定情報を更新
			ColorDAO colorDAO = daoFactory.getColorDAO(null);
			colorDAO.registColor(helper, commonSettings);

			return "/spread/SelecterFinalize.html";
	}

	// ********** privateメソッド **********

	/**
	 * 軸がセレクタによりメンバーが絞り込まれているかをあらわすフラグを更新する。<br>
	 * 軸が本来持つ総メンバー数とクライアントから選択されたメンバとして渡されたメンバーの総数が等しければ絞り込まれていなく、後者が少ないならば絞られていることになる。
	 * @param helper RequestHelperオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 */
	private void modifyAxisUsedSelecterCondition(RequestHelper helper) throws SQLException, NamingException  {

		HttpServletRequest request = helper.getRequest();
		Report report = (Report)helper.getRequest().getSession().getAttribute("report");		

		String axisID = null;
		for (int i = 0; i < report.getTotalDimensionNumber()+1; i++ ) {	// ディメンション＋１(メジャー)回実行

			if (i == report.getTotalDimensionNumber()) {	// メジャー
				axisID = Constants.MeasureID;
			} else {										// ディメンション
				axisID = Integer.toString(i+1);				// 軸IDは1startのため、補正。
			}

			String selectedMemberAndDrillStat = (String)request.getParameter("dim" + axisID);	// クライアントからの送信されてきたパラメータを取得
			ArrayList<String> selectedMemberAndDrillStatList = StringUtil.splitString(selectedMemberAndDrillStat,",");
			Axis axis = report.getAxisByID(axisID);

			// 軸メンバの総メンバ数を求める
			int memberCount = 0;
			if (axisID == Constants.MeasureID) {
				memberCount = report.getTotalMeasureMemberNumber();
			} else {
				Connection conn = DAOFactory.getDAOFactory().getConnection((String)request.getSession().getAttribute("connectionPoolName"),
																		   (String)helper.getRequest().getSession().getAttribute("searchPathName"));
				try {
					memberCount = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn).getDimensionMemberNumber((Dimension)axis);
				} catch (SQLException e) {
					throw e;
				} finally {
					if (conn != null) {
						try {
							conn.close();
						} catch (SQLException e) {
							throw e;
						}
					}
				}
			}

			if (memberCount > selectedMemberAndDrillStatList.size()) {
				axis.setUsedSelecter(true);				// 軸に対してセレクタで絞込み/ドリル状態の更新が行われた
			} else if (memberCount == selectedMemberAndDrillStatList.size()) {
				axis.setUsedSelecter(false);
			} else {
				throw new IllegalStateException();
			}
		}
	}
}

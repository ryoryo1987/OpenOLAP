/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：GetAxisMemberInfoByAxisIDCommand.java
 *  説明：指定されたディメンションとそのメンバーの情報をXML形式で出力するクラスです。
 *
 *  作成日: 2004/02/13
 */
package openolap.viewer.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;
import javax.servlet.ServletException;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionMemberDAO;

/**
 *  クラス：GetAxisMemberInfoByAxisIDCommand<br>
 *  説明：指定されたディメンションとそのメンバーの情報をXML形式で出力するクラスです。
 */
public class GetAxisMemberInfoByAxisIDCommand implements Command {

	// ********** インスタンス変数 **********

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(GetReportInfoCommand.class.getName());


	// ********** メソッド **********

	/**
	 * 指定されたディメンションとそのメンバーの情報をXML形式で生成する。<br>
	 * JSPへdispatchを行わずに直接XMLを出力するため、nullを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return null
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 * @exception SQLException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, SQLException, NamingException {

		Report report = (Report) helper.getRequest().getSession().getAttribute("report");
		String targetAxisID = (String) helper.getRequest().getParameter("axisID");
		if(Constants.MeasureID.equals(targetAxisID)) {	// 次元メンバのXML生成なので、メジャーであることはありえない
			throw new IllegalArgumentException();
		}

		Axis axis = report.getAxisByID(targetAxisID);

		Connection conn = null;
		DAOFactory daoFactory = DAOFactory.getDAOFactory();

		try {
			conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
											(String)helper.getRequest().getSession().getAttribute("searchPathName"));
	
			StringBuilder axisMemberXML = new StringBuilder(512);
	
			// XML 生成
			axisMemberXML.append("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>");				// XML ヘッダ
			DimensionMemberDAO dimMemberDAO =  daoFactory.getDimensionMemberDAO(conn);
			axisMemberXML.append(dimMemberDAO.getDimensionMemberXML(report, axis , false));	// ディメンションメンバーリストXML

			// XML 出力準備
			helper.getResponse().setContentType("text/xml; charset=Shift_JIS");
			PrintWriter out = helper.getResponse().getWriter();

			// 出力
			out.println(axisMemberXML.toString());
				if(log.isInfoEnabled()) {	// ログ出力
					log.info("XML(selected axisInfo)：\n" + axisMemberXML.toString());
				}

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

		return null;
	}

}

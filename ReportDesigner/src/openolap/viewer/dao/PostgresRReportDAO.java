/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresRReportDAO.java
 *  説明：レポートオブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2005/01/07
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;

import org.apache.log4j.Logger;

import openolap.viewer.common.StringTool;
import openolap.viewer.common.StringTool2;
import openolap.viewer.controller.RequestHelper;

/**
 *  クラス：PostgresRReportDAO
 *  説明：レポートオブジェクトの永続化を管理するクラスです。
 */
public class PostgresRReportDAO implements RReportDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	/** DAOFactoryオブジェクト */
	DAOFactory daoFactory = DAOFactory.getDAOFactory();

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresRReportDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 * レポートオブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresRReportDAO(Connection conn) {
		this.conn = conn;
	}

	/**
	 * RレポートオブジェクトXMLを生成する。
	 * @return Rレポート生成用のXMLを格納したStringBufferオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public StringBuffer getRReportXML(RequestHelper helper) throws SQLException {

		// テンプレートXML、実行するSQL文字列を取得
		String templateXMLString = null;	// テンプレートXML
		String getDataSQL        = null;	// SQL文字列取得


		  // source の値により、テンプレートXML、SQLの取得元を変更する

		  String source = helper.getRequest().getParameter("source"); // テンプレートXML、SQLの取得元
	
		  if ( "post".equals(source) ) { // 取得元：ポスト
			  templateXMLString = helper.getRequest().getParameter("templateXML");
			  getDataSQL = helper.getRequest().getParameter("getDataSQL");
		  } else if ( "session".equals(source) ) { // 取得元：セッション
			  templateXMLString = (String) helper.getRequest().getSession().getAttribute("RsourceXML");
			  getDataSQL        = (String) helper.getRequest().getSession().getAttribute("Rsql");
		  } else if ( "db".equals(source) ) { // 取得元：データベース

			  String sourceTable = "oo_v_report";// テンプレートXML,SQL の取得元テーブル名
			  String reportID    = helper.getRequest().getParameter("rId"); // sourceTable の絞込み条件（レポートID）

			  ReportDAO reportDAO = daoFactory.getReportDAO(conn);
			  HashMap<String, String> hashMap = reportDAO.getTemplateInfo(sourceTable, reportID);

			  templateXMLString = hashMap.get("templateXMLString");
			  getDataSQL        = hashMap.get("getDataSQL");

		  } else {
			  throw new UnsupportedOperationException();
		  }
		

//System.out.println("==========================================================================================================");
//System.out.println("templateXMLString:" + templateXMLString);
//System.out.println("getDataSQL:" + getDataSQL);
//System.out.println("==========================================================================================================");

		  StringTool2 stTool2 = new StringTool2(templateXMLString);
	
		  // XMLより置換対象部のみを切り出し
		  String replaceString = stTool2.getInnerDataNodeString();
  //		String replaceString = "<row クラスID='%%クラスID%%' クラス名ショート='%%クラス名ショート%%'/>";
  //		String replaceString = "<row クラスID--11--='%%クラスID--11--%%' クラス名ショート--2--='%%クラス名ショート--2--%%' ファミリーID='%%ファミリーID%%' ファミリー名ショート='%%ファミリー名ショート%%' プロダクトID='%%プロダクトID%%' プロダクト名ショート='%%プロダクト名ショート%%'/>";
		  StringTool stTool = new StringTool(replaceString);
//System.out.println(replaceString);
	
		  // 検索SQL実行
		  Statement stmt = conn.createStatement();
		  ResultSet rset = stmt.executeQuery (getDataSQL);
	
		  // テンプレートＸＭＬに取得結果を埋め込んだＸＭＬを生成し、JSPでの出力用にrequestオブジェクトへ保存。
		  StringBuffer dataXMLText = new StringBuffer();
	
		  // 置換部分以前を格納
		  dataXMLText.append(stTool2.getBeforeDataNodeString());
		  dataXMLText.append(StringTool2.dataMarkStartStr);
	
		  // 置換部分(dataタグ内)を格納
		  int cnt = stTool.getdivCount();
		  String[] divXMLStr = stTool.getXMLString();
		  String[] divSQLStr = stTool.getSQLString();
	
		  while (rset.next ()){
			  String resultXML="";
			  for(int i=0;i<cnt;i++){
				  resultXML+=divXMLStr[i]+rset.getString(divSQLStr[i]);
			  }
			  resultXML+=divXMLStr[cnt];
			  dataXMLText.append(resultXML);
		  }
//	  dataXMLText.append(stTool.dispStr());

		  // 置換部分以降を格納
		  dataXMLText.append(StringTool2.dataMarkEndStr);
		  dataXMLText.append(stTool2.getAfterDataNodeString());
			
		return dataXMLText;
	}

}

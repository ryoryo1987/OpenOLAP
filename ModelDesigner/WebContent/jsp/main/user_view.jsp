<%@ page language="java" contentType="text/xml;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<?xml version="1.0" encoding="Shift_JIS"?>
<?xml:stylesheet type="text/xsl" href="view.xsl" ?>

<%@ include file="../../connect.jsp"%>


<rows>
<%
	//********ファイル設定***********
	String fileName="schema_view.csv";
	String strPath=application.getRealPath(request.getServletPath());
	if(System.getProperty("os.name").substring(0,4).equals("Wind")) {
		strPath=strPath.substring(0,strPath.lastIndexOf("\\") + 1)+fileName;
	} else {  
		strPath=strPath.substring(0,strPath.lastIndexOf("/") + 1)+fileName;
	}
	FileOutputStream fs = new FileOutputStream(strPath,false);
	OutputStreamWriter osw = null;
	osw = new OutputStreamWriter(fs,"Shift_JIS");
	PrintWriter pw = new PrintWriter(osw);
	String tempLine="";
	out.println("<csv>" + fileName + "</csv>");
	out.println("<objectname>スキーマ</objectname>");
	//区切りカラム
	out.println("<separatecol>1</separatecol>");



	ResultSetMetaData rsmd=null;
	String Sql ="";
	String strError ="";
	int i=0;
	int recordCount= 0;
	int colCount = 0;
	String strScript = "";

	//SQL設定
	strScript+="SELECT ";
	strScript+=" user_seq AS スキーマＩＤ";
	strScript+=",name AS スキーマ名";
	strScript+=",comment AS コメント";
	strScript+=",CASE WHEN table_flg = '1' THEN 'V' ELSE '' END AS テーブル";
	strScript+=",CASE WHEN view_flg = '1' THEN 'V' ELSE '' END AS ビュー";
	strScript+=" FROM oo_user";
	strScript+=" ORDER BY user_seq";



	Sql = "SELECT COUNT(*) AS cnt FROM (" + strScript + ") AS SQL";
	try{
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			recordCount=rs.getInt("cnt");
		}
		rs.close();
	}catch(SQLException e){
		strError=e.toString()+"";
	}

	try{
		rs = stmt.executeQuery(strScript);
		rsmd = rs.getMetaData();
		colCount=rsmd.getColumnCount();
	}catch(SQLException e){
		strError=e.toString()+"";
	}




	if("".equals(strError)){
		out.println("<coldef>");
			tempLine="";
			for(i=1;i<=colCount;i++){
				out.println("<column>");
				out.println("<heading>"+rsmd.getColumnName(i)+"</heading>");
				out.println("<type>Text</type>");
				out.println("</column>");
				if(i!=1){
					tempLine+=",";
				}
				tempLine+=rsmd.getColumnName(i);
			}
			pw.println(tempLine);
		out.println("</coldef>");

		while(rs.next()){
			out.println("<row>");
				//ポジション設定
				out.println("<value group='1' pos='left'>"+rs.getString(1)+"</value>");
				out.println("<value group='1' pos='left'>"+rs.getString(2)+"</value>");
				out.println("<value group='1' pos='left'>"+rs.getString(3)+"</value>");
				out.println("<value group='1' pos='center'>"+rs.getString(4)+"</value>");
				out.println("<value group='1' pos='center'>"+rs.getString(5)+"</value>");
			out.println("</row>");

			tempLine="";
			for(i=1;i<=colCount;i++){
				if(i!=1){
					tempLine+=",";
				}
				tempLine+="\"" + rs.getString(i) + "\"";
			}
			pw.println(tempLine);
		}
		rs.close();

		osw.flush();
		fs.close();


	}else{
		out.println("<error>" + strError + "</error>");
	}





%>
</rows>



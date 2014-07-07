<%@ page language="java" contentType="text/xml;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<?xml version="1.0" encoding="Shift_JIS"?>
<?xml:stylesheet type="text/xsl" href="view.xsl" ?>

<%@ include file="../../connect.jsp"%>


<rows>


<%
	//********ファイル設定***********
	String fileName="custom_mes_view.csv";
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
	out.println("<objectname>カスタムメジャー</objectname>");
	//区切りカラム
	out.println("<separatecol>1</separatecol>");



	int cubeSeq = Integer.parseInt(request.getParameter("cubeSeq"));
	ResultSetMetaData rsmd=null;
	String Sql ="";
	String strError ="";
	int i=0;
	int recordCount= 0;
	int colCount = 0;
	String strScript = "";



	//SQL設定
	strScript+="SELECT ";
	strScript+=" f.formula_seq AS カスタムメジャーＩＤ";
	strScript+=",f.name AS カスタムメジャー名";
	strScript+=",f.comment AS コメント";
	strScript+=",CASE WHEN f.data_flg = '1' THEN 'フォーミュラ' ELSE '実データ' END AS データの持ち方";
	strScript+=",f.formula_text AS 計算式";
	strScript+=" FROM oo_formula f";
	strScript+=" ,oo_cube c";
	strScript+=" WHERE";
	strScript+=" f.cube_seq=c.cube_seq";
	strScript+=" AND f.cube_seq=" + cubeSeq;
	strScript+=" ORDER BY f.formula_seq";



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
				out.println("<value group='1' pos='left'>"+ood.replace(ood.replace(ood.replace(ood.replace(rs.getString(5),"&","&amp;"),"<","&lt;"),">","&gt;"),"\n","<br/>")+"</value>");
			out.println("</row>");
			tempLine="";
			for(i=1;i<=colCount;i++){
				if(i!=1){
					tempLine+=",";
				}
			//	tempLine+=rs.getString(i);
			//	tempLine+=ood.replace(rs.getString(i),"\n","\\");
				tempLine+=ood.replace(ood.replace(rs.getString(i),"\n",""),"\r","");
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



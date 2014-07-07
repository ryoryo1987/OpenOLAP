<%@ page language="java" contentType="text/xml;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<?xml version="1.0" encoding="Shift_JIS"?>
<?xml:stylesheet type="text/xsl" href="view.xsl" ?>

<%@ include file="../../connect.jsp"%>


<rows>

<%!

	private static String getString(String strArg,Statement stmt2){

		
		String tempValue="";
		String Sql="";
		ResultSet rs2=null;
		try{
			StringTokenizer st = new StringTokenizer(strArg, "," );
			Sql = "SELECT method_name";
			Sql = Sql + " FROM oo_calc_method";
			Sql = Sql + " WHERE method_no = '" + strArg + "'";
			rs2 = stmt2.executeQuery(Sql);
			if(rs2.next()){
				tempValue+=rs2.getString("method_name");
			}
			rs2.close();
		}catch(Exception e){
		}
		return tempValue;

	}
%>

<%
	//********ファイル設定***********
	String fileName="mes_view.csv";
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
	out.println("<objectname>メジャー</objectname>");

	//区切りカラム
	out.println("<separatecol>1</separatecol>");



	int userSeq = Integer.parseInt(request.getParameter("userSeq"));
	ResultSetMetaData rsmd=null;
	String Sql ="";
	String strError ="";
	int i=0;
	int recordCount= 0;
	int colCount = 0;
	String strScript = "";





	//SQL設定
	strScript+="SELECT ";
	strScript+=" m.measure_seq AS メジャーＩＤ";
	strScript+=",m.name AS メジャー名";
	strScript+=",m.fact_table AS ファクトテーブル";
	strScript+=",m.fact_col AS ファクトカラム";
	strScript+=",m.fact_calc_method AS 集計方法";
	strScript+=",CASE WHEN m.time_dim_flg = '1' THEN 'V' ELSE '' END AS 時間ディメンション";
	strScript+=",d.name AS ディメンション名";
	strScript+=" FROM oo_measure m";
	strScript+=" ,oo_measure_link l";
	strScript+=" ,oo_dimension d";
	strScript+=" ,oo_user u";
	strScript+=" WHERE";
	strScript+=" m.measure_seq=l.measure_seq";
	strScript+=" AND l.dimension_seq=d.dimension_seq";
	strScript+=" AND m.user_seq=u.user_seq";
	strScript+=" AND u.user_seq=" + userSeq;
	strScript+=" ORDER BY m.measure_seq";





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
				out.println("<value group='1' pos='left'>"+rs.getString(4)+"</value>");
				out.println("<value group='1' pos='left'>"+getString(rs.getString(5),stmt2)+"</value>");
				out.println("<value group='1' pos='center'>"+rs.getString(6)+"</value>");
				out.println("<value group='1' pos='left'>"+rs.getString(7)+"</value>");
			out.println("</row>");

			tempLine="";
		//	for(i=1;i<=colCount;i++){
		//		if(i!=1){
		//			tempLine+=",";
		//		}
		//		tempLine+="\"" + rs.getString(i) + "\"";
		//	}
			tempLine+="\""+rs.getString(1)+"\"";
			tempLine+=",\""+rs.getString(2)+"\"";
			tempLine+=",\""+rs.getString(3)+"\"";
			tempLine+=",\""+rs.getString(4)+"\"";
			tempLine+=",\""+getString(rs.getString(5),stmt2)+"\"";
			tempLine+=",\""+rs.getString(6)+"\"";
			tempLine+=",\""+rs.getString(7)+"\"";

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



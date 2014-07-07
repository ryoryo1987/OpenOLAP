<%@ page language="java" contentType="text/xml;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<?xml version="1.0" encoding="Shift_JIS"?>
<?xml:stylesheet type="text/xsl" href="view.xsl" ?>

<%@ include file="../../connect.jsp"%>
<%!

	private static String getFormatValue(String strArg,String strTimeKindCd,Statement stmt2){

		
		String tempValue="";
		String Sql="";
		ResultSet rs2=null;
		try{
			StringTokenizer st = new StringTokenizer(strArg, "," );
			Sql = "SELECT time_name FROM oo_time_format WHERE time_kind_cd = '" + strTimeKindCd + "' AND time_name_format_cd = '" + st.nextToken() + "'";
			rs2 = stmt2.executeQuery(Sql);
			if(rs2.next()){
				tempValue+=rs2.getString("time_name");
			}
			rs2.close();
			Sql = "SELECT time_name FROM oo_time_format WHERE time_kind_cd = '" + strTimeKindCd + "' AND time_name_format_cd = '" + st.nextToken() + "'";
			rs2 = stmt2.executeQuery(Sql);
			if(rs2.next()){
				tempValue+=","+rs2.getString("time_name");
			}
			rs2.close();
		}catch(Exception e){
		}
		return tempValue;

	}
%>


<rows>



<%
	//********�t�@�C���ݒ�***********
	String fileName="time_view.csv";
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
	out.println("<objectname>���ԃf�B�����V����</objectname>");

	//��؂�J����
	out.println("<separatecol>1</separatecol>");



//	int userSeq = Integer.parseInt(request.getParameter("userSeq"));
	ResultSetMetaData rsmd=null;
	String Sql ="";
	String strError ="";
	int i=0;
	int recordCount= 0;
	int colCount = 0;
	String strScript = "";



	//SQL�ݒ�
	strScript+="SELECT ";
	strScript+=" time_seq AS ���ԃf�B�����V�����h�c";
	strScript+=",name AS ���ԃf�B�����V������";
	strScript+=",start_month AS �J�n��";
	strScript+=",CASE WHEN total_flg = '1' THEN 'V' ELSE '' END AS ���v�l";
	strScript+=",CASE WHEN year_flg = '1' THEN year_long_name||','||year_short_name ELSE '' END AS �N";
	strScript+=",CASE WHEN half_flg = '1' THEN half_long_name||','||half_short_name ELSE '' END AS ����";
	strScript+=",CASE WHEN quarter_flg = '1' THEN quarter_long_name||','||quarter_short_name ELSE '' END AS �l����";
	strScript+=",CASE WHEN month_flg = '1' THEN month_long_name||','||month_short_name ELSE '' END AS ��";
	strScript+=",CASE WHEN week_kind_flg = 'Y' THEN week_long_name||','||week_short_name ELSE '' END AS �T�i�N�j";
	strScript+=",CASE WHEN week_kind_flg = 'M' THEN week_long_name||','||week_short_name ELSE '' END AS �T�i���j";
	strScript+=",CASE WHEN day_flg = '1' THEN day_long_name||','||day_short_name ELSE '' END AS ��";
	strScript+=",CASE WHEN time_length='12' THEN '�N' WHEN time_length='6' THEN '����' WHEN time_length='3' THEN '�l����' WHEN time_length='1' THEN '��' END ||'  '||'�ߋ�:'||time_past_span||'����:'||time_future_span AS �f�[�^�ێ�����";
	strScript+=" FROM oo_time";
	strScript+=" ORDER BY time_seq";





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
				//�|�W�V�����ݒ�
				out.println("<value group='1' pos='left'>"+rs.getString(1)+"</value>");
				out.println("<value group='1' pos='left'>"+rs.getString(2)+"</value>");
				out.println("<value group='1' pos='left'>"+rs.getString(3)+"</value>");
				out.println("<value group='1' pos='center'>"+rs.getString(4)+"</value>");
				out.println("<value group='1' pos='left'>"+getFormatValue(rs.getString(5),"YEAR",stmt2)+"</value>");
				out.println("<value group='1' pos='left'>"+getFormatValue(rs.getString(6),"HALF",stmt2)+"</value>");
				out.println("<value group='1' pos='left'>"+getFormatValue(rs.getString(7),"QUARTER",stmt2)+"</value>");
				out.println("<value group='1' pos='left'>"+getFormatValue(rs.getString(8),"MONTH",stmt2)+"</value>");
				out.println("<value group='1' pos='left'>"+getFormatValue(rs.getString(9),"WEEK_Y",stmt2)+"</value>");
				out.println("<value group='1' pos='left'>"+getFormatValue(rs.getString(10),"WEEK_M",stmt2)+"</value>");
				out.println("<value group='1' pos='left'>"+getFormatValue(rs.getString(11),"DAY",stmt2)+"</value>");
				out.println("<value group='1' pos='left'>"+rs.getString(12)+"</value>");
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
			tempLine+=",\""+getFormatValue(rs.getString(5),"YEAR",stmt2)+"\"";
			tempLine+=",\""+getFormatValue(rs.getString(6),"HALF",stmt2)+"\"";
			tempLine+=",\""+getFormatValue(rs.getString(7),"QUARTER",stmt2)+"\"";
			tempLine+=",\""+getFormatValue(rs.getString(8),"MONTH",stmt2)+"\"";
			tempLine+=",\""+getFormatValue(rs.getString(9),"WEEK_Y",stmt2)+"\"";
			tempLine+=",\""+getFormatValue(rs.getString(10),"WEEK_M",stmt2)+"\"";
			tempLine+=",\""+getFormatValue(rs.getString(11),"DAY",stmt2)+"\"";
			tempLine+=",\""+rs.getString(12)+"\"";
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



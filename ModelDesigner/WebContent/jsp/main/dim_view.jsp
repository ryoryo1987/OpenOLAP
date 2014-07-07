<%@ page language="java" contentType="text/xml;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<?xml version="1.0" encoding="Shift_JIS"?>
<?xml:stylesheet type="text/xsl" href="view.xsl" ?>

<%@ include file="../../connect.jsp"%>

<rows>
<%
	//********�t�@�C���ݒ�***********
	String fileName="dim_view.csv";
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
	out.println("<objectname>�f�B�����V����</objectname>");
	//��؂�J����
	out.println("<separatecol>1</separatecol>");



	int userSeq = Integer.parseInt(request.getParameter("userSeq"));
	ResultSetMetaData rsmd=null;
	String Sql ="";
	String strError ="";
	int i=0;
	int recordCount= 0;
	int colCount = 0;
	String strScript = "";

	//SQL�ݒ�
	strScript+="SELECT ";
	strScript+=" d.dimension_seq AS �f�B�����V�����h�c";
	strScript+=",d.name AS �f�B�����V������";
//	strScript+=",d.comment AS �R�����g";
	strScript+=",CASE WHEN d.total_flg = '1' THEN 'V' ELSE '' END AS ���v�l";
	strScript+=",l.level_no AS ���x���ԍ�";
	strScript+=",l.level_seq AS ���x���h�c";
	strScript+=",l.name AS ���x����";
//	strScript+=",l.comment AS �R�����g";
	strScript+=",l.table_name AS �e�[�u��";
	strScript+=",l.long_name_col AS �����O�l�[��";
	strScript+=",l.short_name_col AS �V���[�g�l�[��";
	strScript+=",l.sort_col AS �\�[�g�J����";
//	strScript+=",l.key_col1||','||l.key_col2||','||l.key_col3||','||l.key_col4||','||l.key_col5 AS �L�[�J����";
	strScript+=",l.key_col1";
	strScript+=" ||CASE WHEN l.key_col2 = '' THEN '' ELSE ','||l.key_col2 END";
	strScript+=" ||CASE WHEN l.key_col3 = '' THEN '' ELSE ','||l.key_col3 END";
	strScript+=" ||CASE WHEN l.key_col4 = '' THEN '' ELSE ','||l.key_col4 END";
	strScript+=" ||CASE WHEN l.key_col5 = '' THEN '' ELSE ','||l.key_col5 END";
	strScript+=" AS �L�[�J����";
	strScript+=" FROM oo_dimension d";
	strScript+=" ,oo_level l";
	strScript+=" ,oo_user u";
	strScript+=" WHERE";
	strScript+=" d.dimension_seq=l.dimension_seq";
	strScript+=" AND d.user_seq=u.user_seq";
	strScript+=" AND u.user_seq=" + userSeq;
	strScript+=" AND d.dimension_seq>0";
	strScript+=" AND d.dim_type='1'";
	strScript+=" ORDER BY d.dimension_seq,l.level_no";





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
				out.println("<value pos='left' group='1'>"+rs.getString(1)+"</value>");
				out.println("<value pos='left' group='1'>"+rs.getString(2)+"</value>");
				out.println("<value pos='center' group='1'>"+rs.getString(3)+"</value>");
				out.println("<value pos='left' group='1'>"+rs.getString(4)+"</value>");
				out.println("<value pos='left' group='5'>"+rs.getString(5)+"</value>");
				out.println("<value pos='left' group='5'>"+rs.getString(6)+"</value>");
				out.println("<value pos='left' group='5'>"+rs.getString(7)+"</value>");
				out.println("<value pos='left' group='5'>"+rs.getString(8)+"</value>");
				out.println("<value pos='left' group='5'>"+rs.getString(9)+"</value>");
				out.println("<value pos='left' group='5'>"+rs.getString(10)+"</value>");
				out.println("<value pos='left' group='5'>"+rs.getString(11)+"</value>");
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



<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="openolap.viewer.XMLConverter" %>
<%	
	request.setCharacterEncoding("Shift_JIS");
	response.setHeader("Cache-Control", "no-cache");//�L���b�V�������Ȃ�

	String csvData=request.getParameter("csvData");
//	XMLConverter xmlCon = new XMLConverter();

	String strPath=application.getRealPath(request.getServletPath());
	strPath = strPath.substring(0,strPath.lastIndexOf("/"));

//	String csvStr=xmlCon.transformDocument(strPath+"/xml/table/simpleCsv.xsl",xmlCon.toXMLDocument(csvData));

	String saveFilePath=strPath.substring(0,strPath.lastIndexOf("/"));
	saveFilePath=saveFilePath.substring(0,saveFilePath.lastIndexOf("/"));
	saveFilePath=saveFilePath.substring(0,saveFilePath.lastIndexOf("/"));
	saveFilePath=saveFilePath+"/export/"+request.getSession().getId() + ".csv";


	FileOutputStream fs = null;
	OutputStreamWriter osw = null;
	PrintWriter pw = null;

	fs = new FileOutputStream(saveFilePath, false);	//�����̃t�@�C��������ꍇ�A�㏑������
	osw = new OutputStreamWriter(fs,"Shift_JIS");
	pw = new PrintWriter(new BufferedWriter(osw));

	pw.println(csvData);
	pw.flush();
	osw.flush();
	fs.close();

//	out.println(csvData);
//	out.println(saveFilePath);

	response.sendRedirect("../../../export/"+request.getSession().getId() + ".csv");

%>


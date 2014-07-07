<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ include file="../../../connect.jsp" %>
<%

	String XMLString = request.getParameter("hid_xml");
//	XMLString=ood.replace(XMLString,"<?xml version=\"1.0\"?>","<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>");
//	XMLString=ood.replace(XMLString,"<?xml version=\"1.0\"?>","");
//	session.putValue("tempChartXML",XMLString);

	String Sql="";
	int exeCount=0;
	Sql = "UPDATE oo_r_model SET ";
	Sql = Sql + " model_flg='1'";
	Sql = Sql + " ,model_xml = '" + ood.replace(XMLString,"'","''") + "'";
	Sql = Sql + " WHERE model_seq = " + session.getValue("modelSeq");
	exeCount = stmt.executeUpdate(Sql);
//out.println(Sql);
%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="javascript">
		function load(){
			alert("<%=session.getValue("RModelName")%>を保存しました。");
		//	parent.window.close()
		}
	</script>
</head>
<body onload="load()">
<br><br>
</body>
</html>

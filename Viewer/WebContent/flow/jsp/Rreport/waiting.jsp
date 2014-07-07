<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ include file="../../connect.jsp"%>
<%

	String seqId = request.getParameter("seqId");


%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<link rel="stylesheet" type="text/css" href="../../../css/common.css"/>
<title><%=(String)session.getValue("aplName")%></title>
<script language="JavaScript">

function load(){
<%if(seqId!=null){%>
	window.location="dispFrm.jsp?kind=db&amp;rId=<%=seqId%>";
<%}%>
}
</script>
</head>
<body onload="load()">

<BR>
<BR>
<BR>
<BR>
<BR>
<BR>
<BR>
<center>
<img src="../../../images/logo_anime2.gif">
<BR>
<BR>
<BR>
<%if((String)session.getValue("aplName")=="OpenOLAP Report Designer"){%>
	<span style="color:orange;font-size:16px;font-weight:bold">
<% } else { %>
	<span style="color:blue;font-size:16px;font-weight:bold">
<% } %>

</font>
</center>
</body>
</html>
<%@ include file="../../connect_close.jsp"%>

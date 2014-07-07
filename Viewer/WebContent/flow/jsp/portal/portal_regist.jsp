<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="openolap.viewer.User"%> 
<%@ include file="../../connect.jsp" %>
<%

	User user = (User)session.getAttribute("user");
	boolean isAdmin = user.isAdmin();
	String adminFlg = user.getAdminFLG();
	String userSeq = user.getUserID();


	String XMLString = request.getParameter("hid_xml");
	session.putValue("tempPortalXML",XMLString);

	String Sql="";
	int exeCount=0;
/*
	Sql = "UPDATE oo_r_model SET ";
	Sql = Sql + " model_flg='1'";
	Sql = Sql + " ,model_xml = '" + ood.replace(XMLString,"'","''") + "'";
	Sql = Sql + " WHERE model_seq = " + session.getValue("modelSeq");
	exeCount = stmt.executeUpdate(Sql);
*/
//out.println(Sql);

//	if((isAdmin)||(!"null".equals(request.getParameter("seqId")))){//共有レポート
	if((isAdmin)||("2".equals(request.getParameter("strReportOwnerFlg")))){//共有レポート

		Sql = "UPDATE oo_v_report SET ";
		Sql = Sql + " screen_xml = '" + replace(request.getParameter("hid_xml"),"'","\"") + "'";
		Sql = Sql + " WHERE report_id = " + request.getParameter("seqId");
		exeCount = stmt.executeUpdate(Sql);


	}else{//個人レポート

		Sql = " insert into oo_v_report (report_id,report_name,par_id,user_id,reference_report_id,report_owner_flg,update_date,kind_flg,report_type,screen_xml) values (";
		Sql = Sql + "(SELECT NEXTVAL('report_id'))";
		Sql = Sql + ",'" + request.getParameter("hid_report_name") + "（個人レポート）'";
	//	if("root".equals(request.getParameter("hid_par_id"))){
			Sql = Sql + ",null";
	//	}else{
	//		Sql = Sql + " ," + request.getParameter("hid_par_id") + "";
	//	}
		Sql = Sql + " ,'" + userSeq + "'";	// 共通レポートの場合は0（個人レポートの場合は個人のuser_id）
	//	Sql = Sql + ",'" + Report.personalReportOwnerFLG + "' ";	// 「２」：個人レポート
		Sql = Sql + " ,'" + request.getParameter("seqId") + "'";
		Sql = Sql + " ,'2'";	// 「2」：個人レポート
		Sql = Sql + " ,NOW()";
		Sql = Sql + " ,'R'";
		Sql = Sql + " ,'P'";
		Sql = Sql + " ,'" + replace(request.getParameter("hid_xml"),"'","\"") + "'";
		Sql = Sql + ")";
		exeCount = stmt.executeUpdate(Sql);


	}

//	out.println(Sql);


%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">
		function load(){
			alert("<%=request.getParameter("hid_report_name")%>を保存しました。");
			top.frames[1].document.navi_form.change_flg.value = 0;
		//	parent.window.close()
		}
	</script>
</head>
<body onload="load()">
<br><br>
</body>
</html>

<%@ include file="../../connect_close.jsp" %>

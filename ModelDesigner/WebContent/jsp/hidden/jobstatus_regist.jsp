<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%> 
<%@ page import = "java.util.*"%>
<%@ page errorPage="ErrorPage.jsp"%>
<%@ include file="../../connect.jsp" %>

<%
String Sql="";
int exeCount=0;
int objSeq=Integer.parseInt(request.getParameter("objSeq"));
int updateFlg=0;
String strJobName="";

	Sql = "UPDATE oo_job SET ";
	Sql = Sql + "status = '5'";
	Sql = Sql + " WHERE job_seq = " + objSeq;
	Sql = Sql + " AND status = '9'";
	exeCount = stmt.executeUpdate(Sql);
	if(exeCount!=0){
		updateFlg=1;
	}else{
		Sql = "UPDATE oo_job SET ";
		Sql = Sql + "stop_flg = '1'";
		Sql = Sql + " WHERE job_seq = " + objSeq;
		Sql = Sql + " AND status = '1'";
		exeCount = stmt.executeUpdate(Sql);
		if(exeCount!=0){
			updateFlg=2;
		}
	}


	Sql = "SELECT ";
	Sql = Sql + " c.cube_seq||':'||c.name||' (ƒvƒƒZƒX '||j.process||')' AS name";
	Sql = Sql + " FROM oo_job j";
	Sql = Sql + " ,oo_cube c";
	Sql = Sql + " WHERE j.cube_seq=c.cube_seq";
	Sql = Sql + " AND j.job_seq=" + objSeq;
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		strJobName=rs.getString("name");
	}
	rs.close();


%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript">
		function load(){
<%
			if(updateFlg==1){//íœ
				out.println("showMsg('JRG4','" + strJobName + "')");
			//	out.println("parent.frm_main.document.getElementById(\"" + objSeq + "\").parentNode.removeChild(parent.frm_main.document.getElementById(\"" + objSeq + "\"));");


			}else if(updateFlg==2){//’†Ž~
				out.println("showMsg('JRG5','" + strJobName + "')");
			}else{//Ž¸”s
				out.println("showMsg('JRG6','" + strJobName + "')");
			}
%>
			location.replace("blank.jsp");

		}
	</script>
</head>

<body onload="load();">
</body>

</html>
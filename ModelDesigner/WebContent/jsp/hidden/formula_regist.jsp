<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%> 
<%@ page import = "java.util.*"%>
<%//@ page errorPage="ErrorPage.jsp"%>
<%@ include file="../../connect.jsp" %>

<%
String Sql="";
int tp = Integer.parseInt(request.getParameter("tp"));
int exeCount=0;
int i=0;

String strName = request.getParameter("txt_name");
String strComment = request.getParameter("txt_comment");
String strDataFlg = request.getParameter("rdo_data_flg");
String strFormulaText = request.getParameter("are_formula");


String strCubeSeq = request.getParameter("hid_cube_seq");
String objSeq = request.getParameter("hid_obj_seq");
String objKind=request.getParameter("hid_obj_kind");

%>

<%




	Sql = "DELETE FROM oo_formula";
	Sql = Sql + " WHERE formula_seq = " + objSeq;
	exeCount = stmt.executeUpdate(Sql);


	if(tp==0){

		//SEQUENCE Žæ“¾
		Sql = "SELECT nextval('oo_measure_seq') as seq_no";
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			objSeq = rs.getString("seq_no");
		}
		rs.close();

	}

	if(tp!=2){

		//V‹K“o˜^
		Sql = "INSERT INTO oo_formula (";
		Sql = Sql + "formula_seq";
		Sql = Sql + ",cube_seq";
		Sql = Sql + ",name";
		Sql = Sql + ",comment";
		Sql = Sql + ",data_flg";
		Sql = Sql + ",formula_text";
		Sql = Sql + ")VALUES(";
		Sql = Sql + "" + objSeq;
		Sql = Sql + "," + strCubeSeq;
		Sql = Sql + ",'" + strName + "'";
		Sql = Sql + ",'" + strComment + "'";
		Sql = Sql + ",'" + strDataFlg + "'";
		Sql = Sql + ",'" + strFormulaText + "'";
		Sql = Sql + ")";
//out.println(Sql);
		exeCount = stmt.executeUpdate(Sql);
	}


%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript">
	function load(){
		parent.parent.navi_frm.addObjects("<%=objKind%>",<%=tp%>,"<%=strCubeSeq%>,<%=objSeq%>","<%=strName%>");
		location.replace("blank.jsp");
	}
	</script>
</head>
<body onload="load()">
</body>
</html>
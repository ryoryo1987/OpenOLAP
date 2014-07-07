<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ page errorPage="ErrorPage.jsp"%>
<%@ include file="../../connect.jsp"%>


<%
String tableName = request.getParameter("table_name");
String type = request.getParameter("type");

String Sql = "";
Sql += " SELECT";
Sql += " oo_fun_columnList('" + tableName + "','" + session.getValue("strUserName") + "') AS columnlist";



%>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript">
<!--
	function load(){
		//カラムリストのクローンを初期化
		if(parent.frm_main.document.form_main.elements["<%=tableName%>"]==undefined){
			parent.frm_main.document.all.div_hid.innerHTML += '<select name="<%=tableName%>"><option value="">---------------</option></select>';
		}else{
			parent.frm_main.resetList(parent.frm_main.document.form_main.elements["<%=tableName%>"]);
		}

		<%if(type.equals("dim")){%>
		parent.frm_main.resetList(parent.frm_main.document.form_main.lst_longname);
		parent.frm_main.resetList(parent.frm_main.document.form_main.lst_shortname);
		parent.frm_main.resetList(parent.frm_main.document.form_main.lst_sortcol);
		parent.frm_main.resetList(parent.frm_main.document.form_main.lst_keycol1);
		parent.frm_main.resetList(parent.frm_main.document.form_main.lst_keycol2);
		parent.frm_main.resetList(parent.frm_main.document.form_main.lst_keycol3);
		parent.frm_main.resetList(parent.frm_main.document.form_main.lst_keycol4);
		parent.frm_main.resetList(parent.frm_main.document.form_main.lst_keycol5);
		<%}%>
		<%if(type.equals("seg")){%>
		parent.frm_main.resetList(parent.frm_main.document.form_main.lst_seg_keycol);
		<%}%>
		<%if(type.equals("mes")){%>
		parent.frm_main.resetList(parent.frm_main.document.form_main.lst_fact_col);
		<%}%>


		<%
		rs = stmt.executeQuery(Sql);
		while(rs.next()){
			StringTokenizer st = new StringTokenizer(rs.getString("columnlist"),",");
			while(st.hasMoreTokens()) {

				String columnText = st.nextToken();
				StringTokenizer st2 = new StringTokenizer(columnText," ");
				String columnName = st2.nextToken();

		%>
		var tempOpValue = "<%=columnName%>";
		var tempOpText = "<%=columnText%>";

		//カラムリストのクローンを作成
		addOption = document.createElement("OPTION");
		addOption.value = tempOpValue;
		addOption.text = tempOpText;
		parent.frm_main.document.form_main.elements["<%=tableName%>"].options.add(addOption);


		<%if(type.equals("dim")){%>
		addOption = document.createElement("OPTION");
		addOption.value = tempOpValue;
		addOption.text = tempOpText;
		parent.frm_main.document.form_main.lst_longname.options.add(addOption);
		addOption = document.createElement("OPTION");
		addOption.value = tempOpValue;
		addOption.text = tempOpText;
		parent.frm_main.document.form_main.lst_shortname.options.add(addOption);
		addOption = document.createElement("OPTION");
		addOption.value = tempOpValue;
		addOption.text = tempOpText;
		parent.frm_main.document.form_main.lst_sortcol.options.add(addOption);
		addOption = document.createElement("OPTION");
		addOption.value = tempOpValue;
		addOption.text = tempOpText;
		parent.frm_main.document.form_main.lst_keycol1.options.add(addOption);
		addOption = document.createElement("OPTION");
		addOption.value = tempOpValue;
		addOption.text = tempOpText;
		parent.frm_main.document.form_main.lst_keycol2.options.add(addOption);
		addOption = document.createElement("OPTION");
		addOption.value = tempOpValue;
		addOption.text = tempOpText;
		parent.frm_main.document.form_main.lst_keycol3.options.add(addOption);
		addOption = document.createElement("OPTION");
		addOption.value = tempOpValue;
		addOption.text = tempOpText;
		parent.frm_main.document.form_main.lst_keycol4.options.add(addOption);
		addOption = document.createElement("OPTION");
		addOption.value = tempOpValue;
		addOption.text = tempOpText;
		parent.frm_main.document.form_main.lst_keycol5.options.add(addOption);
		<%}%>
		<%if(type.equals("seg")){%>
		addOption = document.createElement("OPTION");
		addOption.value = tempOpValue;
		addOption.text = tempOpText;
		parent.frm_main.document.form_main.lst_seg_keycol.options.add(addOption);
		<%}%>
		<%if(type.equals("mes")){%>
		addOption = document.createElement("OPTION");
		addOption.value = tempOpValue;
		addOption.text = tempOpText;
		parent.frm_main.document.form_main.lst_fact_col.options.add(addOption);
		<%}%>



		<%
			}
		}
		rs.close();
		%>
//alert(parent.frm_main.document.all.div_hid.innerHTML);
	}
 -->
	</script>
</head>

<body onload="load();">
</body>
</html>
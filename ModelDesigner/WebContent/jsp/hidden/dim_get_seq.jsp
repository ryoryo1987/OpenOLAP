<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page errorPage="ErrorPage.jsp"%>
<%@ include file="../../connect.jsp"%>


<%
String strType = request.getParameter("type");

//SEQUENCE 取得
String Sql = "SELECT NEXTVAL('oo_level_seq') as dim_seq";
rs = stmt.executeQuery(Sql);
String objId="";
if(rs.next()){
	objId = rs.getString("dim_seq");
}
rs.close();

%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript">
<!--
	function load(){
		parent.frm_main.showDiv(<%=objId%>,'<%=strType%>');

		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_name" mON="レベル名" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_comment" mON="コメント" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_table" mON="テーブル" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_longname" <%if("level".equals(strType)){out.print("mON=\"ロングネーム\"");}%> value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_shortname"  <%if("level".equals(strType)){out.print("mON=\"ショートネーム\"");}%> value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_sortcol"  <%if("level".equals(strType)){out.print("mON=\"ソートカラム\"");}%> value="">';
	//	parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_sorttype"  <%if("level".equals(strType)){out.print("mON=\"ソートタイプ\"");}%> value="1">';
	//	parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_sortorder"  <%if("level".equals(strType)){out.print("mON=\"ソート順\"");}%> value="1">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_keycol1" mON="キーカラム" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_keycol2" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_keycol3" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_keycol4" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_keycol5" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_m_linkcol1" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_m_linkcol2" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_m_linkcol3" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_m_linkcol4" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_m_linkcol5" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_level_no" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_where_clause"  <%if("level".equals(strType)){out.print("mON=\"WHERE句\"");}%> value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_x_point" value="">';
		parent.frm_main.document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=objId%>_y_point" value="">';

		location.replace("blank.jsp");


	}
 -->
	</script>
</head>

<body onload="load();">
</body>
</html>
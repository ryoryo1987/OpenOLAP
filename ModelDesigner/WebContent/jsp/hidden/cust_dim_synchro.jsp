<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%> 
<%@ page import = "java.util.*"%>
<%//@ page errorPage="ErrorPage.jsp"%>

<%
Connection connMeta_Session = null;
connMeta_Session = (Connection)session.getValue(session.getId()+"Conn");
if (connMeta_Session!=null){
	connMeta_Session.commit();
}
%>


<%@ include file="../../connect.jsp" %>

<%
String Sql="";
int exeCount=0;

int dimSeq = Integer.parseInt(request.getParameter("hid_dim_seq"));
int objSeq = Integer.parseInt(request.getParameter("hid_obj_seq"));

String strAddMemberFlg = request.getParameter("lst_add_flg");
String strDeleteMemberFlg = request.getParameter("lst_delete_flg");
String strRenameMemberFlg = request.getParameter("lst_rename_flg");



Sql = "UPDATE oo_dimension_part SET ";
if(strAddMemberFlg==null){
	Sql = Sql + " add_member_flg = add_member_flg";
}else{
	Sql = Sql + " add_member_flg = '" + strAddMemberFlg + "'";
}
if(strRenameMemberFlg!=null){
	Sql = Sql + ",rename_member_flg = '" + strRenameMemberFlg + "'";
}
if(strDeleteMemberFlg!=null){
	Sql = Sql + ",delete_member_flg = '" + strDeleteMemberFlg + "'";
}
Sql = Sql + " WHERE dimension_seq = " + dimSeq;
Sql = Sql + " AND part_seq = " + objSeq;
//out.println(Sql);
exeCount = stmt.executeUpdate(Sql);


//スキーマ名取得
String userName="";
Sql = "SELECT u.name FROM oo_user u,oo_dimension d WHERE u.user_seq=d.user_seq AND d.dimension_seq = " + dimSeq;
rs = stmt.executeQuery(Sql);
if(rs.next()){
	userName = rs.getString("name");
}
rs.close();

Sql = "select oo_dim_member(" + dimSeq + ",'" + userName + "') as a";
rs = stmt.executeQuery(Sql);

Sql = "select oo_dim_parts(" + dimSeq + ",'" + objSeq + "') as a";
rs = stmt.executeQuery(Sql);

Sql = "select oo_dim_level_adjust(" + dimSeq + "," + objSeq + ") as a";
rs = stmt.executeQuery(Sql);


%>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript">
	function load(){
		location.href="../frm_cust_dim_control.jsp?dimSeq=<%=dimSeq%>&objSeq=<%=objSeq%>";
	}
	</script>
</head>
<body onload="load()">
</body>
</html>
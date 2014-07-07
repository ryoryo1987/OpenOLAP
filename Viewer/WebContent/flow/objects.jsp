<%@ page language="java" contentType="text/html;charset=Shift_JIS"%> 
<%@ page import="openolap.viewer.User"%> 
<%
out.println("<?xml version=\"1.0\" encoding=\"Shift-JIS\"?>");
out.println("<?xml:stylesheet type=\"text/xsl\" href=\"tree.xsl\"?>");
%>
<%@ include file="connect.jsp" %>
<%




// Common Variables
String SQL;
String closeTag="";
String preRecordData="";
%>
<OpenOlap ID='root' id='root'>OpenOlap
<ReportTop ID='ReportTop'>レポート


<%
User user = (User)session.getAttribute("user");
boolean isAdmin = user.isAdmin();
String adminFlg = user.getAdminFLG();
String userSeq = user.getUserID();

%>



<%
//	SQL = "SELECT report_id,level,report_name,kind_flg as kind FROM oo_report_tree('oo_v_report',null,null)";
//	SQL = "SELECT report_id,level,report_name,kind_flg as kind FROM oo_report_tree('oo_v_report',null,null," + userSeq + ",'0')";
	SQL = "SELECT report_id,level,report_name,kind_flg as kind,report_type FROM oo_report_tree('oo_v_report',null,null," + userSeq + ",'0')";
	rs = stmt.executeQuery(SQL);


	int BeforeLevel=0;
	while(rs.next()) {
		for(int j=BeforeLevel;j>=rs.getInt("level");j--){
			out.println("</category>");
		}
		out.println("<category ID='" + rs.getString("report_id") + "' KI='" + rs.getString("kind") + "' RTYPE='" + rs.getString("report_type") + "' >" + rs.getString("report_name") + "");
		BeforeLevel=rs.getInt("level");
	}
	rs.close();

	for(int j=BeforeLevel;j>0;j--){
		out.println("</category>");
	}

%>
</ReportTop>




<%
if("2".equals(adminFlg)){
	out.println("<KojinReportTop2 ID='"+userSeq+"'>個人レポート");

	SQL = "SELECT report_id,level,report_name,kind_flg as kind,report_type FROM oo_report_tree('oo_v_report',null,null," + userSeq + ",'1')";
	rs = stmt.executeQuery(SQL);


	BeforeLevel=0;
	while(rs.next()) {
		for(int j=BeforeLevel;j>=rs.getInt("level");j--){
			out.println("</category2>");
		}
		out.println("<category2 ID='" + rs.getString("report_id") + "' KI='" + rs.getString("kind") + "' RTYPE='" + rs.getString("report_type") + "'>" + rs.getString("report_name") + "");
		BeforeLevel=rs.getInt("level");
	}
	rs.close();

	for(int j=BeforeLevel;j>0;j--){
		out.println("</category2>");
	}

	out.println("</KojinReportTop2>");

}
%>





<%if(isAdmin){%>
<%	if("OpenOLAP Report Designer".equals((String)session.getValue("aplName"))){%>

<Admin ID='Admin'>レポート管理
	<CreateMReport ID='CreateMReport'>MOLAPレポート作成</CreateMReport>
	<CreateRReport ID='CreateRReport'>ROLAPレポート作成</CreateRReport>
	<CreatePortalReport ID='CreatePortalReport'>ポータルレポート作成</CreatePortalReport>
	<AdminFolderReport ID='AdminFolderReport'>フォルダ・レポート管理</AdminFolderReport>
</Admin>

<CreateEdit ID='CreateEdit'>ユーザーとグループ
	<User ID='User'>ユーザー</User>
	<Group ID='Group'>グループ</Group>
</CreateEdit>

<Authority ID='Authority'>権限設定
<%
	SQL = "SELECT group_id,name as group_name FROM oo_v_group order by 1,2";
	rs = stmt.executeQuery(SQL);
	while(rs.next()) {
		out.println("<SEC ID='" + rs.getString("group_id") + "'>" + rs.getString("group_name") + "</SEC>");
	}
	rs.close();
%>
</Authority>



<%	}%>

<%}else{%>
<Admin ID='<%=userSeq%>'>レポート管理
	<AdminFolderReport ID='<%=userSeq%>'>フォルダ・レポート管理</AdminFolderReport>
</Admin>
<UserConfig ID='UserConfig'>ユーザー設定
	<ChangePassword ID='<%=userSeq%>'>
		パスワード変更
	</ChangePassword>
	<Export ID='<%=userSeq%>'>
		各種設定
	</Export>
</UserConfig>
<%}%>




</OpenOlap>



<%@ include file="connect_close.jsp" %>

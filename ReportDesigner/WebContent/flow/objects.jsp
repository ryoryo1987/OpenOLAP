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
<ReportTop ID='ReportTop'>���|�[�g


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
	out.println("<KojinReportTop2 ID='"+userSeq+"'>�l���|�[�g");

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

<Admin ID='Admin'>���|�[�g�Ǘ�
	<CreateMReport ID='CreateMReport'>MOLAP���|�[�g�쐬</CreateMReport>
	<CreateRReport ID='CreateRReport'>ROLAP���|�[�g�쐬</CreateRReport>
	<CreatePortalReport ID='CreatePortalReport'>�|�[�^�����|�[�g�쐬</CreatePortalReport>
	<AdminFolderReport ID='AdminFolderReport'>�t�H���_�E���|�[�g�Ǘ�</AdminFolderReport>
</Admin>

<CreateEdit ID='CreateEdit'>���[�U�[�ƃO���[�v
	<User ID='User'>���[�U�[</User>
	<Group ID='Group'>�O���[�v</Group>
</CreateEdit>

<Authority ID='Authority'>�����ݒ�
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
<Admin ID='<%=userSeq%>'>���|�[�g�Ǘ�
	<AdminFolderReport ID='<%=userSeq%>'>�t�H���_�E���|�[�g�Ǘ�</AdminFolderReport>
</Admin>
<UserConfig ID='UserConfig'>���[�U�[�ݒ�
	<ChangePassword ID='<%=userSeq%>'>
		�p�X���[�h�ύX
	</ChangePassword>
	<Export ID='<%=userSeq%>'>
		�e��ݒ�
	</Export>
</UserConfig>
<%}%>




</OpenOlap>



<%@ include file="connect_close.jsp" %>

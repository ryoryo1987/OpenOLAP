<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>

<%@ include file="../../connect.jsp" %>
<%
	String SQL = "";
	int exeCount = 0;
	boolean userExistFlg = false;

	String userID = request.getParameter("hid_user_id");
	String oldPwd = request.getParameter("txt_old_pwd");
	String newPwd = request.getParameter("txt_new_pwd1");


	SQL = "select * from oo_v_user";
	SQL = SQL + " where";
	SQL = SQL + " user_id = " + userID;
	SQL = SQL + " and password = '" + oldPwd + "'";

	rs = stmt.executeQuery(SQL);
	if (rs.next()) {
		userExistFlg=true;
	}
	rs.close();


	//���[�U�[�E���܂ł̃p�X���[�h�ɍ��v���郌�R�[�h������ꍇ�̂݁A�p�X���[�h���X�V����
	if(userExistFlg){

		SQL = " update oo_v_user ";
		SQL = SQL + " set";
		SQL = SQL + " password = '" + newPwd + "'";
		SQL = SQL + " where";
		SQL = SQL + " user_id = " + userID;
		exeCount = stmt.executeUpdate(SQL);

	}








%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">
		function load(){
		//	alert("�o�^���܂����B");

<%
	if(userExistFlg){
		out.println("alert('�p�X���[�h���X�V���܂����B');");
		out.println("parent.frm_main.document.form_main.reset();");
	}else{
		out.println("alert('���݂̃p�X���[�h���Ԉ���Ă��܂��B���݂̃p�X���[�h���m�F���Ă��������B');");
		out.println("parent.frm_main.document.form_main.txt_old_pwd.focus();");
		out.println("parent.frm_main.document.form_main.txt_old_pwd.select();");
	}
%>
			top.frames[1].document.navi_form.change_flg.value = 0;

		}
	</script>
</head>
<body onload="load()">
<br><br>
<%//=SQL%>
</body>
</html>
<%@ include file="../../connect_close.jsp" %>

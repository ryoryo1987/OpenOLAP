<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.io.*"%>
<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/standard.js"></script>
	<script language="JavaScript" src="jsp/js/registration.js"></script>
	<link rel="stylesheet" type="text/css" href="jsp/css/common.css">
	<LINK REL="SHORTCUT ICON" href="images/favicon.ico"> 
	<style type="text/css">
	<!--
		body {
			text-align : center;
		}
		
		th {
			color : green;
			text-align:left;
			white-space:nowrap;
			font-weight:bold;
			padding-left:5;
		}
		
		td {
			padding-left : 20px;
		}

		/* Button Login*/
		input.normal_login, input.up_login, input.out_login{
			width : 136;
			height : 44;
			background : url("images/login/login.gif") no-repeat;
			border-style : none;
			font-family : Arial;
			color : navy;
		}

		input.over_login, input.down_login{
			width : 136;
			height : 44;
			background : url("images/login/login_r.gif") no-repeat;
			border-style : none;
			font-family : Arial;
			color : white;
		}

		/* Button Reset */
		input.normal_reset, input.up_reset, input.out_reset{
			width : 136;
			height : 44;
			background : url("images/login/reset.gif") no-repeat;
			border-style : none;
			font-family : Arial;
			color : navy;
		}

		input.over_reset, input.down_reset{
			width : 136;
			height : 44;
			background : url("images/login/reset_r.gif") no-repeat;
			border-style : none;
			font-family : Arial;
			color : white;
		}


	-->
	</style>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form_main" id="form_main" method="post" action="">

<table style="margin-top:140">
	<tr>
		<td>
			<img src="images/login/logo.jpg">
		</td>
		<td style="background:url('images/login/login_window.gif') no-repeat;width:400;height:277">

		<table id="tableForm" style="display:block;margin-top:20;margin-left:55">
			<tr>
				<th>アプリケーション</th>
				<td>
					<select name="lst_apl">
						<option value="1">MOLAP</option>
						<option value="2">ROLAP</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>メタユーザー</th>
				<td>
					<input type="text" name="txt_name" value="olap" size="20">
				</td>
			</tr>
			<tr>
				<th>パスワード</th>
				<td>
					<input type="password" name="txt_pwd" value="olap" size="20">
				</td>
			</tr>
			<tr>
				<th>メタスキーマ</th>
				<td>
					<input type="text" name="txt_schema" value="oo_meta" size="20">
				</td>
			</tr>
			<tr>
				<th>コネクトソース</th>
				<td>
					<input type="text" name="txt_dsn" value="jdbc:postgresql://192.168.100.30:5432/openolap" size="40">
				</td>
			</tr>
			<tr>
				<th>接続先</th>
				<td>
					<select name="loginInfoList" id="loginInfoList" style='' onChange='JavaScript:onloadSet();'>
	<%
		String fileName="login.ini";
		String strPath=application.getRealPath(request.getServletPath());
		if(System.getProperty("os.name").substring(0,4).equals("Wind")) {
			strPath=strPath.substring(0,strPath.lastIndexOf("\\") + 1)+fileName;
		} else {  
			strPath=strPath.substring(0,strPath.lastIndexOf("/") + 1)+fileName;
		}

		try{
			FileInputStream fis = new FileInputStream(strPath);
			InputStreamReader isr = new InputStreamReader(fis,"Shift_JIS");
			BufferedReader br = new BufferedReader(isr);

			String line="";
			String ListName="";
			String UserName="";
			String SchemaName="";
			String ConnectDSN="";

			line = br.readLine();
			while(line != null){
				line = br.readLine();
				if (line!=null || ("").equals(line)){

					if(line.indexOf("DESIGNER_CLASSES_PATH")==0){
						session.putValue("DESIGNER_CLASSES_PATH",line.substring(22));
					}
					if(line.indexOf("JDBC_DRIVER")==0){
						session.putValue("JDBC_DRIVER",line.substring(12));
					}

					if(line.indexOf("LIST_NAME")==0){
						ListName=line.substring(10);
					}
					if(line.indexOf("USER_NAME")==0){
						UserName=line.substring(10);
					}
					if(line.indexOf("SCHEMA_NAME")==0){
						SchemaName=line.substring(12);
					}
					if(line.indexOf("CONNECT_SOURCE")==0){
						ConnectDSN=line.substring(15);
						out.println("<option userName='"+UserName+"' loginDsn='"+ConnectDSN+"' schemaName='"+SchemaName+"'>"+ListName+"</option>");
					}


				}
			}
			br.close();

		}catch(FileNotFoundException e){
			out.println("<option userName='' loginDsn='' schemaName=''>---------------</option>");
		}catch(IOException e){
			out.println("<option userName='' loginDsn='' schemaName=''>---------------</option>");
		}
	%>

					</select>
				</td>
			</tr>
		</table>
	<table style="width:100%;text-align:center;margin-left:42;margin-top:5">
		<tr>
			</td>
				<div id="divSubmitBtn" style="display;block">
					<input type="button" name="" value="" class="normal_login" onClick="login();" onMouseOver="className='over_login'" onMouseDown="className='down_login'" onMouseUp="className='up_login'" onMouseOut="className='out_login'">
					<input type="button" name="" value="" class="normal_reset" onClick="resetText();" onMouseOver="className='over_reset'" onMouseDown="className='down_reset'" onMouseUp="className='up_reset'" onMouseOut="className='out_reset'">
				</div>
			</td>
		</tr>
	</table>
		</td>
	</tr>
</table>
</td>
</tr>
</table>
</form>
</body>
</html>

<script language="JavaScript">
function IE6check(){
	if(navigator.appVersion.indexOf("MSIE 6")==-1){
		document.all.tableForm.style.display="none";
		document.all.divSubmitBtn.innerHTML="OpenOLAPのサポートブラウザは<br>Microsoft Internet Explorer 6　となっております。";
	}
}



function login(){

//navigator.appName == "Microsoft Internet Explorer") && (parseInt(navigator.appVersion) 


		if(document.form_main.txt_name.value==""){
			showMsg("LOG01");
			document.form_main.txt_name.focus();
			document.form_main.txt_name.select();
			return;
	//	}else if(document.form_main.txt_pwd.value==""){
	//		document.form_main.txt_pwd.focus();
	//		document.form_main.txt_pwd.select();
	//		return;
		}else if(document.form_main.txt_schema.value==""){
			showMsg("LOG02");
			document.form_main.txt_schema.focus();
			document.form_main.txt_schema.select();
			return;
		}else if(document.form_main.txt_dsn.value==""){
			showMsg("LOG03");
			document.form_main.txt_dsn.focus();
			document.form_main.txt_dsn.select();
			return;
		}

		document.form_main.action = "loginCertify.jsp";
		document.form_main.target = "_self";
		document.form_main.submit();
//location.href="OpenOLAP.html";

}

function resetText(){
		document.form_main.txt_name.value = "";
		document.form_main.txt_pwd.value = "";
		document.form_main.txt_schema.value = "";
		document.form_main.txt_dsn.value = "";
		document.form_main.txt_name.focus();
		document.form_main.txt_name.select();
}

function onloadSet(){
		if(document.form_main.loginInfoList.selectedIndex!=-1){
			document.form_main.txt_name.value=document.form_main.loginInfoList.options[document.form_main.loginInfoList.selectedIndex].userName;
			document.form_main.txt_pwd.value="";
			document.form_main.txt_schema.value=document.form_main.loginInfoList.options[document.form_main.loginInfoList.selectedIndex].schemaName;
			document.form_main.txt_dsn.value=document.form_main.loginInfoList.options[document.form_main.loginInfoList.selectedIndex].loginDsn;
			if(document.form_main.txt_name.value==""){
				document.form_main.txt_name.focus();
				document.form_main.txt_name.select();
			}else{
				document.form_main.txt_pwd.focus();
				document.form_main.txt_pwd.select();
			}
		}else{
			document.form_main.txt_name.focus();
			document.form_main.txt_name.select();
		}
}
</script>


<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="java.util.*,java.io.*,openolap.viewer.common.Messages"
%>
<%!

    /** ======================================================================= 
  	    デフォルトのプール名、スキーマ名の設定部
		=====================================================================*/
//	private String defaultSchemaName = "oo_meta";
//	private String defaultPoolName = "jdbc/WroxTC41";


	/** デフォルトのスキーマ名、コネクションプール名をセッションへ登録する */
	public void setConnectInfo(HttpServletRequest request) {
	
		request.getSession().setAttribute("searchPathName", Messages.getString("PostgresDAOFactory.meta"));
		request.getSession().setAttribute("connectionPoolName", Messages.getString("PostgresDAOFactory.poolName"));
	}

%>
<%
	session.putValue("aplName","OpenOLAP Report Designer");




	String loginErrorMessage = "";
	if ( (request.getAttribute("loginResult") != null) && 
         (request.getAttribute("loginResult").equals("failed")) ) {
		loginErrorMessage = Messages.getString("loginJSP.loginFailMSG");

	}

%>

<html>
<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script type="text/javascript" src="./spread/js/spreadFunc.js"></script>
	<link rel="stylesheet" href="css/common.css" type="text/css">
		<style type="text/css">
	<!--
		body {
/*			background-image : url("images/bg.gif");*/
			text-align : center;
		}
		
		th,td{
			color : navy;
		}
		th {
			text-align : right;
		}
		
		td {
			padding-left : 20px;
		}

		input.normal_login, input.up_login, input.out_login{
			width : 136;
			height : 44;
			background : url("images/login/login.gif") no-repeat;
			border-style : none;
		}

		input.over_login, input.down_login{
			width : 136;
			height : 44;
			background : url("images/login/login_r.gif") no-repeat;
			border-style : none;
		}

		input.normal_reset, input.up_reset, input.out_reset{
			width : 136;
			height : 44;
			background : url("images/login/reset.gif") no-repeat;
			border-style : none;
		}

		input.over_reset, input.down_reset{
			width : 136;
			height : 44;
			background : url("images/login/reset_r.gif") no-repeat;
			border-style : none;
		}


	-->
	</style>

</head>
<body onload="init();" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form_main" method="post" action="">

<table style="margin-top:140">
	<tr>
		<td>
			<img src="images/login/logo.jpg">
		</td>
		<td style="background:url('images/login/login_window.gif') no-repeat;width:400;height:277">

			<table id="tableForm" style="display:block;margin-left:45;margin-top:20">
				<tr>
					<td height="25" valign="middle"><img src="images/login/user.gif"></td>
					<td valign="middle">
						<input name="user" type="text" value="admin" style="border:1 solid #819CB9">
					</td>
				</tr>
				<tr>
					<td height="25" valign="middle"><img src="images/login/password.gif"></td>
					<td valign="middle">
						<input name="password"  type="password" value="admin" style="border:1 solid #819CB9">
					</td>
				</tr>
				<tr>
		<%
			String fileName="login.ini";
			String strPath=application.getRealPath(request.getServletPath());
			if(System.getProperty("os.name").substring(0,4).equals("Wind")) {
				strPath=strPath.substring(0,strPath.lastIndexOf("\\") + 1)+fileName;
			} else {  
				strPath=strPath.substring(0,strPath.lastIndexOf("/") + 1)+fileName;
			}

			boolean dispListFLG = true; // コネクションの選択リストを表示するか？

			BufferedReader br = null;

			try{
				FileInputStream fis = new FileInputStream(strPath);
				InputStreamReader isr = new InputStreamReader(fis,"Shift_JIS");
				br = new BufferedReader(isr);

				String line="";
				String UseList="";
				String ListName="";
				String SchemaName="";
				String PoolName="";

				line = br.readLine();
				int selectCount = 0;
				while(line != null){
					line = br.readLine();
					if (line!=null || ("").equals(line)){

						if(line.indexOf("USE_LIST")==0){
							UseList=line.substring(9);
							if ("true".equals(UseList)) {
								if(selectCount == 0) { // 初期の場合のみ表示
									out.println("<td height='25' valign='middle'><img src='images/login/connection.gif'></td>");
									out.println("<td  valign='middle'>");
									out.println("<select name='connectSource' id='connectSource' style='border:1 solid #819CB9' useList='"+UseList+"'>");
									selectCount++;
								}
							} else if ("false".equals(UseList)) { // UES_LISTにfalseが設定されていた
								dispListFLG = false;
								setConnectInfo(request);	// セッションにデフォルト値を登録
								break;
							}

						}
						
						if(line.indexOf("LIST_NAME")==0){
							ListName=line.substring(10);
						}
						if(line.indexOf("SCHEMA_NAME")==0){
							SchemaName=line.substring(12);
						}
						if(line.indexOf("POOL_NAME")==0){
							PoolName=line.substring(10);

							// エラーチェックを行い、エラー時はセッションにデフォルト値を登録する
							if ((ListName == null) || (SchemaName == null) || (PoolName == null)) {
								setConnectInfo(request);
								out.println("<option schemaName='' poolName=''></option>");
								break;
							}

							out.println("<option schemaName='"+SchemaName+"' poolName='"+PoolName+"'>"+ListName+"</option>");
						}


					}

				}

				br.close();

			}catch(FileNotFoundException e){
				setConnectInfo(request);	// セッションにデフォルト値を登録
				dispListFLG = false;
			}catch(IOException e){
				setConnectInfo(request);	// セッションにデフォルト値を登録
				dispListFLG = false;
				e.printStackTrace();
			}catch(Exception e) {
				setConnectInfo(request);	// セッションにデフォルト値を登録
				dispListFLG = false;
				e.printStackTrace();
			}

			if (dispListFLG) {
				out.println("</select>");
				out.println("</td>");
				out.println("</tr>");
			}
		%>
		<tr>
	</table>
	<table style="width:100%;text-align:center;margin-left:42;margin-top:20">
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

	<!-- 接続先情報送信用エリア -->
	<input type="hidden" name="schemaName" id="schemaName" value="">
	<input type="hidden" name="poolName" name="schemaName" value="">

	<input type="hidden" name="aplName" id="aplName" value="ReportDesigner">

</form>
</body>
</html>

<script language="JavaScript">

	var errorMessage = "<%= loginErrorMessage %>";
	var dispListFLG = <%= dispListFLG %>;

	function IE6check(){
		if(navigator.appVersion.indexOf("MSIE 6")==-1){
			document.all.tableForm.style.display="none";
			document.all.divSubmitBtn.innerHTML="OpenOLAPのサポートブラウザは<br>Microsoft Internet Explorer 6　となっております。";
		}
	}

	function init() {
		document.form_main.user.focus();
		document.form_main.user.select();

		if (errorMessage != "") {
			showErrorMessage(errorMessage);
		}
	}

	function showErrorMessage(message) {
		alert(message);
	}

	function login() {

		if ( ( document.form_main.user.value == "" ) && ( document.form_main.password.value == "" ) ) {
			showMessage("8");
			document.form_main.user.focus();
			document.form_main.user.select();
			return;
		} else if ( document.form_main.user.value == "" ) {
			showMessage("9");
			document.form_main.user.focus();
			document.form_main.user.select();
			return;
		} else if( document.form_main.password.value == "" ) {
			showMessage("10");
			document.form_main.password.focus();
			document.form_main.password.select();
			return;
		}

		// コネクション情報を設定
		if(dispListFLG == true) {
			
			var selectedOption = document.form_main.connectSource.options[document.form_main.connectSource.selectedIndex];
			var schemaNameString = selectedOption.schemaName;
			var poolNameString   = selectedOption.poolName;

			document.form_main.schemaName.value = schemaNameString;
			document.form_main.poolName.value   = poolNameString;

		} else {
			// クライアントからは、コネクション情報は送信しない
		}

		document.form_main.action = "Controller?action=login";
		document.form_main.target = "_self";
		document.form_main.submit();
	}


	function resetText() {
		document.form_main.user.value = "";
		document.form_main.password.value = "";

		document.form_main.user.focus();
		document.form_main.user.select();
	}

</script>

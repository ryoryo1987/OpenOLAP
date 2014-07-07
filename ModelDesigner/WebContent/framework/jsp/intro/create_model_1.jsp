<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.io.*"%>
<%@ include file="../../../connect.jsp" %>

<%
if("yes".equals((String)request.getParameter("new"))){
	session.putValue("name","");
	session.putValue("schema","");
	session.putValue("model_type","0");
	session.putValue("ref_model","");
	session.putValue("ref_measures","");
	session.putValue("ref_dimensions","");
//	session.putValue("ref_tables","");
	session.putValue("menu_selected_seq",null);
}


%>
<html>
<head>
<title>ROLAP���f���V�K�쐬�E�B�U�[�h</title>
<link REL="stylesheet" TYPE="text/css" HREF="../../../jsp/css/common.css">
<script language="JavaScript" src="../js/common.js"></script>
<script language="JavaScript" src="../js/registration.js"></script>
<script language="JavaScript">
function changeSchema(obj){
	if(obj.value!=""){
		document.form_main.action="create_model_hidden.jsp";
		document.form_main.target="frm_hidden2";
		document.form_main.submit();
	}
}

function changeValue(){
	document.form_main.action="create_model_hidden.jsp";
	document.form_main.target="frm_hidden2";
	document.form_main.submit();
}


function changeConnectSource(){
	var obj=document.form_main.lst_connect_source;
	if(obj.value==""){return;}
	document.form_main.hid_user_name.value=obj.options[obj.selectedIndex].userName;
	document.form_main.hid_user_pwd.value=obj.options[obj.selectedIndex].loginPassword;

	document.form_main.action="change_connection.jsp";
	document.form_main.target="frm_hidden2";
	document.form_main.submit();


}



</script>
</head>
<body onload="changeConnectSource(this);">
<form name="form_main" id="form_main" method="post" action="">

	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">
				ROLAP���f���V�K�쐬
			</td>
		</tr>
	</table>
	<div style="margin:10;height:250">
		<div style="margin-left:3;margin-top:5;margin-bottom:5">���f���̃X�L�[�}�ƍ쐬���@��I�����Ă��������B</div>
		<table>
			<tr>
				<th class="standard">���f����</th>
				<td class="standard">
						<input type="text" name="txt_name" mON="���f����" size="50" maxlength="30" value="<%=(String)session.getValue("name")%>" onchange="changeValue()">
				</td>
			</tr>
			<tr>
				<th class="standard">�R�l�N�g�\�[�X</th>
				<td class="standard">

					<select name="lst_connect_source" style='' onChange='changeConnectSource();'>
	<%
	//	out.println("<option value=''>--�R�l�N�g�\�[�X��I��--</option>");
		out.println("<option userName='"+session.getValue("loginName")+"' loginPassword='"+session.getValue("loginPassword")+"' value='"+session.getValue("loginDsn")+"' value='LocalDB'>Local DB</option>");
	/*
		String fileName="rmodel_connection.ini";
		String strPath=application.getRealPath(request.getServletPath());
		if(System.getProperty("os.name").substring(0,4).equals("Wind")) {
			strPath=strPath.substring(0,strPath.lastIndexOf("\\") - 1);
			strPath=strPath.substring(0,strPath.lastIndexOf("\\") - 1);
			strPath=strPath.substring(0,strPath.lastIndexOf("\\") - 1);
			strPath=strPath.substring(0,strPath.lastIndexOf("\\") + 1)+fileName;
		} else {  
			strPath=strPath.substring(0,strPath.lastIndexOf("/") - 1);
			strPath=strPath.substring(0,strPath.lastIndexOf("/") - 1);
			strPath=strPath.substring(0,strPath.lastIndexOf("/") - 1);
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


					if(line.indexOf("LIST_NAME")==0){
						ListName=line.substring(10);
					}
					if(line.indexOf("USER_NAME")==0){
						UserName=line.substring(10);
					}
					if(line.indexOf("CONNECT_SOURCE")==0){
						ConnectDSN=line.substring(15);
						out.println("<option userName='"+UserName+"' value='"+ConnectDSN+"'>"+ListName+"</option>");
					}


				//	if(line.indexOf("CONNECT_SOURCE")==0){
				//		ConnectDSN=line.substring(15);
				//		out.println("<option value='"+ConnectDSN+"'>"+ConnectDSN+"</option>");
				//	}
				}
			}
			br.close();

		}catch(FileNotFoundException e){
		//	out.println("<option value=''>--�R�l�N�g�\�[�X��I��--</option>");
		}catch(IOException e){
		//	out.println("<option value=''>--�R�l�N�g�\�[�X��I��--</option>");
		}

	*/

	%>

					</select>

				</td>
			</tr>


				</td>
			</tr>
			<tr>
				<th class="standard">�X�L�[�}</th>
				<td class="standard" id="td_schema">
						<select name="lst_schema" mON="�X�L�[�}" onchange="changeSchema(this)">
							<option value=''>--�X�L�[�}��I��--</option>
	<%
	/*
		String Sql;
		Sql = "select nspname from pg_namespace order by nspname";
		rs = stmt.executeQuery(Sql);
		while (rs.next()) {
			String tempStr="";
			if(rs.getString("nspname").equals((String)session.getValue("schema"))){tempStr="selected";}
			out.println("<option value='" + rs.getString("nspname") + "'" + tempStr + ">" + rs.getString("nspname") + "</option>");
		}
		rs.close();
	*/
	%>
						</select>
				</td>
			</tr>
			<tr>
				<td style="height:15px"><br></td>
			</tr>
			<tr>
				<th class="standard" colspan="3">���f���̍쐬���@</th>
			</tr>
			<tr>
				<td class="standard" colspan="3">
					<input type="radio" name="radio" value="0" onclick="flagCheck(this)" <%if("0".equals((String)session.getValue("model_type"))){out.print("checked");}%>><span class="title">��̃��f�����쐬����</span>
					<br>
					<input type="radio" name="radio" value="1" onclick="flagCheck(this)" <%if("1".equals((String)session.getValue("model_type"))){out.print("checked");}%>><span class="title">�������f�����R�s�[����</span>
					<br>
					<input type="radio" name="radio" value="2" onclick="flagCheck(this)" <%if("2".equals((String)session.getValue("model_type"))){out.print("checked");}%>><span class="title">���W���[����уf�B�����V������I������</span>
				</td>
			</tr>
		</table>
	</div>

	<div style="text-align:right;padding-right:20px;padding-top:8px;margin-top:15px;border-top:1 solid #CCCCCC">
		<input type="button" value="" onclick="parent.window.close();" class="normal_cancel_mini" onMouseOver="className='over_cancel_mini'" onMouseDown="className='down_cancel_mini'" onMouseUp="className='up_cancel_mini'" onMouseOut="className='out_cancel_mini'">
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" value="" onclick="next()" class="normal_next" onMouseOver="className='over_next'" onMouseDown="className='down_next'" onMouseUp="className='up_next'" onMouseOut="className='out_next'">
	</div>

				<input type="hidden" id="flag" name="flag" value="<%=(String)session.getValue("model_type")%>">
				<input type="hidden" id="fileName" name="fileName" value="create_model_1.jsp">
				<input type="hidden" id="hid_user_name" name="hid_user_name" value="">
				<input type="hidden" id="hid_user_pwd" name="hid_user_pwd" value="">

</form>
</body>
</html>

<script language="JavaScript">
	function flagCheck(obj)
	{
		document.form_main.flag.value=obj.value;
		changeValue();

	}

	function next()
	{

		//���ʃG���[�`�F�b�N���ɍs��
		if(!checkData()){return;}

		var v = document.form_main.flag.value;
		switch (v)
		{
			case "0":
				url = "create_model_confirm.jsp"
				break;
			case "1":
				url = "create_model_copy.jsp"
				break;
			case "2":
				url = "create_model_measure.jsp"
				break;
		}

		movePage(url);

	}

</script>
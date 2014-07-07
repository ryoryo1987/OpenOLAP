<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page import = "designer.GenerateSql"%>
<%@ include file="../../connect.jsp" %>

<%
	String Sql;
	String objKind = request.getParameter("objKind");
//	int userSeq = Integer.parseInt(request.getParameter("userSeq"));
	int objSeq = Integer.parseInt(request.getParameter("objSeq"));
	String stepNo = request.getParameter("stepNo");

	Connection connConnect=(Connection)session.getValue("METAConnect");
	String strloginSchema=(String)session.getValue("loginSchema");
	String strObjSeq=Integer.toString(objSeq);

	String customFlg="0";
	String strScript="";
	String strLoad="";
	String strRows="";





%>
<%
Hashtable sHash=null;
String generatedSql="";
try{
	sHash = new GenerateSql().main(connConnect,strloginSchema,strObjSeq,stepNo,"ALL",0,0,1);
	String[] arrSql=(String[])sHash.get("arrSql");
	String[] arrMsg=(String[])sHash.get("arrMsg");
	for(int i=0;i<arrSql.length;i++){
		if(arrSql[i]!=null){
			generatedSql+="-- " + arrMsg[i] + "\n";
			generatedSql+=arrSql[i] + ";\n\n";
		}
	}
}catch(Exception e){
	generatedSql="SQL�쐬�G���[";
	generatedSql+="\n\n" + e;
}


%>
<html>

<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js"></script>
	<link rel=STYLESHEET type="text/css" href="../css/common.css">
	<script language="JavaScript">

<%
if("0".equals(stepNo)){
	strLoad="";
	strRows="30";
}else if(!"0".equals(stepNo)){
	strLoad="load()";
	strRows="25";
%>

	document.onkeypress=customized_check;
	document.onkeyup=customized_check;
	document.onmousedown=customized_check;
	document.onmouseup=customized_check;


	function load(){
		customized_check();
	}


	function customize(obj){
		if(obj.checked==true){
			document.form_main.textfield2.value=document.form_main.textfield1.value;
		}else{
			if(showConfirm("CFM2")){
				document.form_main.textfield2.value="";
			}else{
				obj.checked=true;
			}
		}
		customized_check();
	}

	function customized_check(){

		var normalTextColor="#000000";
		var normalBgColor="#ffffff";
		var disabledTextColor="#777777";
		var disabledBgColor="#cccccc";
		var customizedColor="#ffddff";

		if(document.form_main.checkbox.checked==true){//�J�Y�^�}�C�Y�`�F�b�NON�A�㉺���l
			if(document.form_main.textfield1.value==document.form_main.textfield2.value){
				document.form_main.textfield2.disabled=false;
				//��A����
				document.form_main.textfield1.style.backgroundColor=disabledBgColor;
				document.form_main.textfield1.style.color=disabledTextColor;
				//���A�L���i�w�i�F�F���j
				document.form_main.textfield2.style.backgroundColor=normalBgColor;
				document.form_main.textfield2.style.color=normalTextColor;
			}else{//�J�Y�^�}�C�Y�`�F�b�NON�A�㉺����
				//��A����
				document.form_main.textfield1.style.backgroundColor=disabledBgColor;
				document.form_main.textfield1.style.color=disabledTextColor;
				//���A�L���i�w�i�F�F�s���N�j
				document.form_main.textfield2.style.backgroundColor=customizedColor;
				document.form_main.textfield2.style.color=normalTextColor;
			}
		}else if(document.form_main.checkbox.checked==false){//�J�Y�^�}�C�Y�`�F�b�NOFF
			document.form_main.textfield2.disabled=true;
			//��A�L���i�w�i�F�F���j
			document.form_main.textfield1.style.backgroundColor=normalBgColor;
			document.form_main.textfield1.style.color=normalTextColor;
			//���A����
			document.form_main.textfield2.style.backgroundColor=disabledBgColor;
			document.form_main.textfield2.style.color=disabledTextColor;
		}
	}




	function regist(){

		var tp;
		if(document.form_main.checkbox.checked==true){
			tp="1";
			document.form_main.txt_name.value="�J�X�^�}�C�YSQL";
		}else if(document.form_main.checkbox.checked==false){
			tp="0";
			document.form_main.txt_name.value="�f�t�H���g��SQL";
		}
		
	//	submitData("sqltng_regist.jsp",tp,'sqltng');
		submitData("sqltng_regist.jsp",tp,"<%=objKind%>","<%=objSeq%>");
	}


<%}%>


</script>


</head>

<body onload="<%=strLoad%>">
<form name="form_main" method="post" action="">

	<!-- ���C�A�E�g�p -->
	<div class="main">
	<table class="frame">
		<tr>
			<td class="left_top"></td>
			<td class="top"></td>
			<td class="right_top"></td>
		</tr>
		<tr>
			<td class="left"></td>
			<td class="main">
				<!-- �R���e���c -->
				<div style="width:520;text-align:left">SQL�F</div>
				
				<textarea name="textfield1" cols="100" rows="<%=strRows%>" readonly mON="readonly area" chkVal='99' style="border:1 solid gray"><%=generatedSql%></textarea>
				<br><br>

<%if(!"0".equals(stepNo)){%>
<%
	Sql="SELECT script FROM oo_custom_sql" ;
	Sql=Sql+" WHERE cube_seq = " + objSeq;
	Sql=Sql+" AND step = " + stepNo;
	rs3 = stmt3.executeQuery(Sql);
	if (rs3.next()) {
		customFlg="1";
		strScript = rs3.getString("script");
	}
	rs3.close();
%>
				<div align="center">
				<input type="checkbox" name="checkbox" value="checkbox" onclick="customize(this)" onChange="setChangeFlg();" <%if(customFlg.equals("1")){out.print("checked");}%>>�J�X�^�}�C�Y
				</div>

				<br>
				<textarea name="textfield2" cols="100" rows="<%=strRows%>" STYLE="background-color:#ffffff" onclick="customized_check()" onChange="setChangeFlg();" onmousemove="customized_check()" mON="�J�X�^�}�C�Y�G���A"><%=strScript%></textarea><!--����onmousemove�C�x���g�̓}�E�X�ŃR�s�y�������̂��߂ɕK�v-->
				<br>
				<br>
				<input type="button" name="submit_btn" value="" class="normal_save" onMouseOver="className='over_save'" onMouseDown="className='down_save'" onMouseUp="className='up_save'" onMouseOut="className='out_save'" onClick="javascript:regist();">
				<br><br>
<%}%>
			</td>
			<td class="right"></td>
		</tr>
		<tr>
			<td class="left_bottom"></td>
			<td class="bottom"></td>
			<td class="right_bottom"></td>
		</tr>
	</table>
	</div>


	<input type="hidden" name="hid_obj_seq" value="<%=objSeq%>">
	<input type="hidden" name="hid_step_no" value="<%=stepNo%>">

	<input type="hidden" name="txt_name" value="">

</form>

</body>
</html>

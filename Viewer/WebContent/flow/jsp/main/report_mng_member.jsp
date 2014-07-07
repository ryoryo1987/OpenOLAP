<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>

<%@ include file="../../connect.jsp"%>

<%



	String Sql="";
	String strKey=request.getParameter("key");
	String addFlg="";
	if(strKey.equals("-999")){
		addFlg="1";
	}else{
		addFlg="0";
	}
	
	String strReportName="";
	String strKindFlg="F";

	Sql = "SELECT update_date,report_name,kind_flg ";
	Sql = Sql + " FROM oo_v_report WHERE report_id = " + strKey;
	rs = stmt.executeQuery(Sql);
	if(rs.next()) {
		strReportName=rs.getString("report_name");
		strKindFlg=rs.getString("kind_flg");
	}
	rs.close();


	if(addFlg.equals("1")){
		Sql = "SELECT NEXTVAL('report_id') AS new_seq";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			strKey=rs.getString("new_seq");
		}
		rs.close();
	}

	String strNow="";
	Sql = "SELECT to_char(NOW(),'YYYY/MM/DD') AS now";
	rs = stmt.executeQuery(Sql);
	if (rs.next()) {
		strNow=rs.getString("now");
	}
	rs.close();

%>

<html>
<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link REL="stylesheet" TYPE="text/css" HREF="../../../css/common.css">
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript">
	var arrArg;


	function changefocus(){

		arrArg = dialogArguments;

	//	window.focus();
		document.form_main.txt_report_name.focus();
		document.form_main.txt_report_name.select();
	}




	function regist(){

			//共通エラーチェックを先に行う
			if(!checkData()){return;}

			if(showConfirm("CFM2",document.form_main.txt_report_name.value)){
				<%if(addFlg.equals("1")){%>//追加
				arrArg[0].SpreadForm.action = "../hidden/report_mng_tree_regist.jsp?opr=add&key=" + document.form_main.hid_key.value + "&par_key=" + arrArg[0].SpreadForm.hid_par_key.value + "&txt_report_name=" + document.form_main.txt_report_name.value;
				<%}else{%>//名前の変更
				arrArg[0].SpreadForm.action = "../hidden/report_mng_tree_regist.jsp?opr=rename&key=" + document.form_main.hid_key.value + "&par_key=" + arrArg[0].SpreadForm.hid_par_key.value + "&txt_report_name=" + document.form_main.txt_report_name.value;
				<%}%>
			//	arrArg[0].SpreadForm.target = arrArg[0].parentNode.parent.frames[0].name;
				arrArg[0].SpreadForm.target = "update_tree_frm";
				arrArg[0].SpreadForm.submit();
			}else{
				return;
			}





			<%if(addFlg.equals("1")){%>//追加
			var newRow = arrArg[0].getElementById("DataTable").rows[0].cloneNode(true);
			arrArg[0].getElementById("DataTable").childNodes[1].appendChild(newRow);
			var selectedRow = arrArg[0].getElementById("DataTable").childNodes[1].lastChild;
			selectedRow.style.display="block";
			selectedRow.id="<%=strKey%>";
			selectedRow.cells[0].firstChild.childNodes[1].innerHTML=document.form_main.txt_report_name.value;
			selectedRow.cells[1].firstChild.innerHTML="<%=strKey%>";
			if("<%=strKindFlg%>"=="F"){
				selectedRow.cells[2].firstChild.innerHTML="フォルダ";
			}else if("<%=strKindFlg%>"=="R"){
				selectedRow.cells[2].firstChild.innerHTML="レポート";
			}
			selectedRow.cells[4].firstChild.innerHTML="<%=strNow%>";

			//左側ツリーへメンバ追加
		//	arrArg[0].parentNode.parent.frames[1].addMember(document.form_main.txt_report_name.value,document.form_main.txt_report_name.value,<%=strKey%>);
			arrArg[1].addMember(document.form_main.txt_report_name.value,document.form_main.txt_report_name.value,<%=strKey%>);


			<%}else{%>//名前の変更
			var selectedRow = arrArg[0].getElementById("<%=strKey%>");
			selectedRow.cells[0].firstChild.childNodes[1].innerHTML=document.form_main.txt_report_name.value;
			selectedRow.cells[4].firstChild.innerHTML="<%=strNow%>";

			arrArg[1].renMember(<%=strKey%>,document.form_main.txt_report_name.value);

			<%}%>



			//Window Close
			self.window.close();


	}

	function cancel(){
		self.window.close();
	}


	</script>
</head>

<body style="text-align:center" onload="changefocus()">
	<form id="form_main" method="post" name="form_main">
	<table class="Header" style="border-collapse:collapse;border:none">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">フォルダ情報
			</td>
		</tr>
	</table>
	<div style="margin-top:40">
		<span class="title">名前：</span> <input type='text' name='txt_report_name' value='<%=strReportName%>' size='30' maxlength='30' mON='名前'>
	</div>
		<div class="command" style="margin-top:40px">
			<input type = 'button' value='' onclick="regist();" class="normal_ok_mini" onMouseOver="className='over_ok_mini'" onMouseDown="className='down_ok_mini'" onMouseUp="className='up_ok_mini'" onMouseOut="className='out_ok_mini'" >
			<input type = 'button' value='' onclick="cancel();" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'">
		</div>

		<input type = 'hidden' name = 'hid_key' value='<%=strKey%>'>
		<input type='text' name='dummy' value='dummy' style="display:none;">

	</form>
</body>
</html>


<%@ include file="../../connect_close.jsp" %>

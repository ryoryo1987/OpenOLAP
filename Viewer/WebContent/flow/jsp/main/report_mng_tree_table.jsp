<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>
<%@ page import="openolap.viewer.User"%> 
<%//@ include file="../../connect.jsp" %>
<%@ include file="../../connect.jsp" %>

<HTML>
<HEAD>
<title><%=(String)session.getValue("aplName")%></title>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<link rel="stylesheet" type="text/css" href="../../../css/xmlTable.css">
<link rel="stylesheet" type="text/css" href="../../../css/rightclick.css"/>
<link rel="stylesheet" type="text/css" href="../../../css/tree.css"/>
<script type="text/javascript" src="../../../css/colorStyle.js"></script>
<script type="text/javascript" src="../js/spread.js"></script>
<script type="text/javascript" src="../js/colRange.js"></script>
<%
String objSeq = (String)session.getValue("objSeq");
%>
<script type="text/javascript" src="../js/tableRightclick.js"></script>
<script type="text/javascript" src="../js/registration.js"></script>
</HEAD>
<BODY id="explorerBody" onload="loadSpread();createMenu();" onselectstart="return false" onresize="resizeArea()" onContextmenu="return false" ondrop="return false" ondragenter="return false" ondragover="return false" topmargin="0" leftmargin="0">

<FORM name="SpreadForm" method="post" action="">
<SPAN onmousedown="mouseDown();" onmouseup="mouseUp();">
<TABLE id="SpreadTable" class="SpreadTable">
<TR>
<TD>
<SPAN id="ColumnHeaderArea" class="ColumnHeaderArea" onmousemove="mouseMove();">
<TABLE class="ColumnHeaderTable" cellspacing="0" cellpadding="2">
<COLGROUP id="CH_CG">
<COL id="CH_CG0" style="width:150;">
<COL id="CH_CG1" style="width:30;">
<COL id="CH_CG2" style="width:50;">
<%
if("AdminFolderReport".equals((String)session.getValue("userId"))){//管理者用フォルダ・レポート管理の場合
	out.println("<COL id=\"CH_CG3\" style=\"width:180;\">");
}else if(!"AdminFolderReport".equals((String)session.getValue("userId"))){//個人用フォルダ・レポート管理の場合
	out.println("<COL id=\"CH_CG3\" style=\"width:0;\">");
}
%>
<COL id="CH_CG4" style="width:75;">
<COL width="80">
</COLGROUP>
<TR ID="CH_R0" Spread="ColumnHeaderRow">
<TD id="CH_R0C0">名前</TD>
<TD id="CH_R0C1">ID</TD>
<TD id="CH_R0C2">種類</TD>
<TD id="CH_R0C3">グループ</TD>
<TD id="CH_R0C4">更新日時</TD>
<TD>　</TD>
</TR>
</TABLE></SPAN></TD>
</TR>
<TR>
<TD>
<DIV id="DataTableArea" class="DataTableArea">
<TABLE id="DataTable" class="DataTable" cellspacing="0" cellpadding="2">
<COLGROUP>
<COL id="DT_CG0" style="width:150;">
<COL id="DT_CG1" style="width:30;">
<COL id="DT_CG2" style="width:50;">
<%
if("AdminFolderReport".equals((String)session.getValue("userId"))){//管理者用フォルダ・レポート管理の場合
	out.println("<COL id=\"DT_CG3\" style=\"width:180;\">");
}else if(!"AdminFolderReport".equals((String)session.getValue("userId"))){//個人用フォルダ・レポート管理の場合
	out.println("<COL id=\"DT_CG3\" style=\"width:0;\">");
}
%>
<COL id="DT_CG4" style="width:75;">
</COLGROUP>


<%

String dimSeq = (String)session.getValue("dimSeq");


	String keyStr = request.getParameter("id");
	String SQL ="";





	SQL = 		" select ";
	SQL = SQL + " report_id,'---' AS code,report_name,to_char(update_date,'YYYY/MM/DD') as long_name,'---' as min_val,'---' as max_val,kind_flg AS kind,report_type,screen_name";
	SQL = SQL + " from oo_v_report";
	if ((keyStr.equals("null"))||(keyStr.equals("root"))) {
		SQL = SQL + " where par_id is null ";
	} else {
		SQL = SQL + " where par_id= " + keyStr;
	}
	if("AdminFolderReport".equals((String)session.getValue("userId"))){//管理者用フォルダ・レポート管理の場合
		SQL = SQL + " and report_owner_flg<>'2'";
	}else if(!"AdminFolderReport".equals((String)session.getValue("userId"))){//個人用フォルダ・レポート管理の場合
		SQL = SQL + " and user_id = " + (String)session.getValue("userId");
	}

	SQL = SQL + " ORDER BY kind_flg,report_name";


	rs = stmt.executeQuery(SQL);


	//クローンバーチャルフォルダ
	out.println("<TR id='clone' kind='F' selectflg='0' style='display:none;'>");
	out.println("<TD><nobr><IMG SRC='../../../images/tree/folder2.gif'/><A href='javascript:return false;' onclick='objClick(this);return false;' ondragstart='JavaScript:startDrag()' ondragend='JavaScript:endDrag();' ondrop='JavaScript:drop();'  ondragover='JavaScript:overDrag();' ondragleave='JavaScript:leaveDrag();' ondragenter='JavaScript:enterDrag();' ondblclick='JavaScript:dblclickClickNode(this);'></A></nobr></TD>");
	out.println("<TD><nobr></nobr></TD>");
	out.println("<TD><nobr></nobr></TD>");
	out.println("<TD><nobr></nobr></TD>");
	out.println("<TD><nobr></nobr></TD>");
	out.println("</TR>");

	while(rs.next()) {


		String imgKind="";
		String report_id=rs.getString("report_id");
		String kind=rs.getString("kind");
		String report_type=rs.getString("report_type");
		String screen_name=rs.getString("screen_name");

		if("AdminFolderReport".equals((String)session.getValue("userId"))){//管理者用フォルダ・レポート管理の場合
			if ("R".equals(kind)) {
				if("M".equals(report_type)){
					imgKind = "../../../images/tree/m_report.gif";
				}else if("R".equals(report_type)){
					imgKind = "../../../images/tree/r_report.gif";
				}else if("P".equals(report_type)){
					imgKind = "../../../images/tree/p_report.gif";
				}
			} else if ("F".equals(kind)) {
				imgKind = "../../../images/tree/folder2.gif";
			} else {
				imgKind = "../../../images/foldericon2.gif";
			}
		}else if(!"AdminFolderReport".equals((String)session.getValue("userId"))){//個人用フォルダ・レポート管理の場合
			if ("R".equals(kind)) {
				if("M".equals(report_type)){
					imgKind = "../../../images/tree/m_report.gif";
				}else if("R".equals(report_type)){
					imgKind = "../../../images/tree/r_report.gif";
				}else if("P".equals(report_type)){
					imgKind = "../../../images/tree/p_report.gif";
				}
			} else if ("F".equals(kind)) {
				imgKind = "../../../images/tree/folder_p2.gif";
			} else {
				imgKind = "../../../images/foldericon_p2.gif";
			}
		}




			out.println("<TR id='"+report_id+"' kind='"+kind+"' selectflg='0'>");
			out.println("<TD><nobr><IMG SRC='" + imgKind + "'/><A href='javascript:return false;' report_type='"+report_type+"' screen_name='"+screen_name+"' onclick='objClick(this);return false;' ondragstart='JavaScript:startDrag()' ondragend='JavaScript:endDrag();' ondrop='JavaScript:drop();'  ondragover='JavaScript:overDrag();' ondragleave='JavaScript:leaveDrag();' ondragenter='JavaScript:enterDrag();' ondblclick='JavaScript:dblclickClickNode(this);'>"+rs.getString("report_name")+"</A></nobr></TD>");
			out.println("<TD><nobr>"+report_id+"</nobr></TD>");
			if ("R".equals(kind)) {
				out.println("<TD><nobr>レポート</nobr></TD>");
			} else if ("F".equals(kind)) {
				out.println("<TD><nobr>フォルダ</nobr></TD>");
			}

			String groupId="";
			String groupName="";
			SQL = 		" select ";
			SQL = SQL + " gr.group_id";
			SQL = SQL + " ,g.name as group_name";
			SQL = SQL + " ,gr.report_id";
			SQL = SQL + " from oo_v_group_report gr";
			SQL = SQL + " ,oo_v_group g";
			SQL = SQL + " where gr.group_id = g.group_id";
			SQL = SQL + " and gr.report_id = " + report_id;
			SQL = SQL + " and gr.right_flg = '1'";
			SQL = SQL + " order by 1";
			rs2 = stmt2.executeQuery(SQL);
			while(rs2.next()) {
				if(!"".equals(groupId)){
					groupId+=",";
					groupName+=",";
				}
				groupId+=rs2.getString("group_id");
				groupName+=rs2.getString("group_name");
			}
			rs2.close();

			out.println("<TD><nobr>"+groupName+"</nobr></TD>");


			out.println("<TD><nobr>"+rs.getString("long_name")+"</nobr></TD>");

			out.println("</TR>");




	}
	rs.close();
//	out.println("</TABLE>");


%>

</TABLE>
</DIV>
</TD>
</TR>
</TABLE></SPAN>

<input type="hidden" name="hid_par_key" value="<%=keyStr%>"/>
<input type="hidden" name="hid_delete_key" value="<%=keyStr%>"/>
</FORM>
</BODY>
</HTML>

<script language="JavaScript">



function dblclickClickNode(obj){

<%
User user = (User)session.getAttribute("user");
boolean isAdmin = user.isAdmin();
if(!isAdmin){
	out.println("return;");
}
%>



	var DataTable = document.getElementById("DataTable");
	var nodeId = DataTable.rows[obj.parentNode.parentNode.parentNode.rowIndex].id;

	if(obj.parentNode.parentNode.parentNode.kind=="F"){


	//	if (th.att=="F"){//Fileだったら、何もしない。
	//		return;
	//	}

		var preClickObj;
		var preClickAhref;
		preClickObj=parent.navi_frm2.getpreClickObj();

		if (preClickObj.lastChild.style.display=='none'){
			parent.navi_frm2.reversePreNextImage(preClickObj);
			parent.navi_frm2.reversePM(preClickObj);
			parent.navi_frm2.reverseDisplay(preClickObj);
		}
		for(i=0;i<preClickObj.lastChild.childNodes.length;i++){
			if(preClickObj.lastChild.childNodes[i].id==nodeId){
				parent.navi_frm2.Toggle('f',preClickObj.lastChild.childNodes[i].lastChild.previousSibling.previousSibling,'report_mng_tree_table.jsp?id='+nodeId);
				return;
			}
		}

	}else if(obj.parentNode.parentNode.parentNode.kind=="R"){

		if((obj.report_type=="M")||(obj.screen_name=="条件設定")){
			setChangeFlg();
		//	newWin = window.open("drill_prpt.jsp?objId=" + nodeId,"_blank","menubar=no,toolbar=no,width=820px,height=610px,resizable");
			window.showModalDialog("drill_prpt.jsp?objId=" + nodeId,self,"dialogHeight:700px; dialogWidth:850px;");
		}else{
			alert("このレポートにドリルスルー設定はできません。");
		}
		
	}

}



var srcObj = new Object;

var dummyObj;
var dragData;

function startDrag(){
	window.event.srcElement.parentNode.parentNode.parentNode.selectflg="1";
	window.event.srcElement.style.backgroundColor=selectedColor;
	window.event.srcElement.style.color=defaultColor;

	parent.navi_frm2.strDragStart = "TABLE_FRAME";


	var strSelectedKey="";

	var DataTable = document.getElementById("DataTable");
	for(i=0;i<DataTable.rows.length;i++){
		if(DataTable.rows[i].selectflg=="1"){
			if(strSelectedKey!=""){
				strSelectedKey+=",";
			}
			strSelectedKey+=DataTable.rows[i].id;
		}
	}

    dragData = window.event.dataTransfer;

    dragData.setData('Text', strSelectedKey);

    dragData.effectAllowed = 'linkMove';

    dragData.dropEffect = 'move';
}



function enterDrag() {
    window.event.dataTransfer.getData('Text');
}

function endDrag() {
    window.event.dataTransfer.clearData();
}

function overDrag() {
}

function leaveDrag() {
}

function drop() {
}










function addMember(arg1,arg2,arg3,arg4){
}




var lastSelectRow;
function objClick(obj){
	setChangeFlg();
	if(!window.event.ctrlKey){
		resetRow();
	}
	if(window.event.shiftKey){
		var DataTable = document.getElementById("DataTable");
		for(i=lastSelectRow;i<=obj.parentNode.parentNode.parentNode.rowIndex;i++){
			DataTable.rows[i].selectflg="1";
			DataTable.rows[i].cells[0].firstChild.childNodes[1].style.backgroundColor=selectedColor;
			DataTable.rows[i].cells[0].firstChild.childNodes[1].style.color=defaultColor;
		}
		for(i=obj.parentNode.parentNode.parentNode.rowIndex;i<=lastSelectRow;i++){
			DataTable.rows[i].selectflg="1";
			DataTable.rows[i].cells[0].firstChild.childNodes[1].style.backgroundColor=selectedColor;
			DataTable.rows[i].cells[0].firstChild.childNodes[1].style.color=defaultColor;
		}
	}else{
		obj.parentNode.parentNode.parentNode.selectflg="1";
		obj.style.backgroundColor=selectedColor;
		obj.style.color=defaultColor;
	}
	lastSelectRow=obj.parentNode.parentNode.parentNode.rowIndex;

}


function resetRow(){
	var DataTable = document.getElementById("DataTable");
	for(i=0;i<DataTable.rows.length;i++){
		DataTable.rows[i].selectflg="0";
		DataTable.rows[i].cells[0].firstChild.childNodes[1].style.backgroundColor=defaultColor;
		DataTable.rows[i].cells[0].firstChild.childNodes[1].style.color=defaultTextColor;
	}
}
</script>

<%@ include file="../../connect_close.jsp" %>

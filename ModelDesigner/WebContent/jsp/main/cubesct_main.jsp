<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../connect.jsp" %>

<%
	String Sql;
	String objKind = request.getParameter("objKind");
	int objSeq = Integer.parseInt(request.getParameter("objSeq"));



	String strName = "";
	Sql = "select name from oo_cube where cube_seq=" + objSeq;
	rs = stmt.executeQuery(Sql);
	while (rs.next()) {
		strName = rs.getString(1);
	}
	rs.close();

%>

<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/common.js"></script>
	<script language="JavaScript" src="../js/registration.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/common.css">
</head>
<body>
<form name="form_main" method="post" action="">
	<!-- レイアウト用 -->
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
				<!-- コンテンツ -->
				<!-- **************************  MAIN TABLE <1>***************************** -->
				<table class="standard">
					<tr>
						<th width="150" class="standard">キューブID</th>
						<td class="standard">
							<%=objSeq%>
						</td>
					</tr>
					<tr>
						<th width="150" class="standard">キューブ名</th>
						<td class="standard">
							<%=strName%>
						</td>
					</tr>
				</table>
				<!-- **************************  MAIN TABLE <2>***************************** -->
				<table class="standard">
					<tr>
						<td width="100%">
							キューブ構成
							<iframe name="tree_frm" src="cubesct_tree.jsp?objSeq=<%out.print(objSeq);%>" width="100%" hight="300"></iframe>
						</td>
					</tr>
				</table>
				<!-- **************************  MAIN TABLE <3>***************************** -->
				<table class="standard">
					<tr>
						<td id="td_left_move" name="td_left_move" width="250">
							利用可能オブジェクト
							<div id="div_left_move">
								<select name='lst_left' id='lst_left' size='7' multiple style='width : 250;margin : 0' onChange="setChangeFlg();">
								</select>
							</div>
						</td>
						<td align="center">
							<input type="button" name="addBtn" value="" onclick="addElmnt();setChangeFlg();" class="normal_add" onMouseOver="className='over_add'" onMouseDown="className='down_add'" onMouseUp="className='up_add'" onMouseOut="className='out_add'">
							<br><br>
							<input type="button" name="removeBtn" value="" onclick="removeElmnt();setChangeFlg();" class="normal_remove" onMouseOver="className='over_remove'" onMouseDown="className='down_remove'" onMouseUp="className='up_remove'" onMouseOut="className='out_remove'">
						</td>
						<td id="td_right_move" name="td_right_move" width="250">
							選択オブジェクト
							<div id="div_right_move">
								<select name='lst_right' id='lst_right' size='7' multiple style='width : 250;margin : 0' onChange="setChangeFlg();">
								</select>
							</div>
						</td>
					</tr>
				</table>
				<!-- **************************  ボタン ***************************** -->
				<div class="command">
					<input type="button" name="create" value="" class="normal_update" onMouseOver="className='over_update'" onMouseDown="className='down_update'" onMouseUp="className='up_update'" onMouseOut="className='out_update'" onClick = "JavaScript:cubeSet();">
				</div>
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
<!-- parameters for registing cube -->
<input type='hidden' name='CubId' value='<%=objSeq%>'>
<input type='hidden' name='DimId' value=''>
<input type='hidden' name='ParId' value=''>
<!-- name of cube for displaying messages -->
<input type='hidden' name='txt_name' value='<%=strName%>のキューブ構成'>

<input type='hidden' name='hid_obj_seq' value='<%=objSeq%>'>
</form>
</body>
</html>

<script>
function addElmnt(){
	var l_cnt = document.form_main.lst_left.options.length;
	var r_cnt = document.form_main.lst_right.options.length;
	var i;
	var iSelected = 0;

	var tempCurParentNode;
	var tempId;
	var tempKind;
	var tempAllParentNode;
	var iCount;
	var workNode;
	var refreshNode;

	var tempText;
	var tempId2;
	var tempText2;


	// left
	for (i = 0; i < l_cnt; i++) {
		if (document.form_main.lst_left.options[i].selected==true){
			iSelected++;
		}
	}

	//未選択時には、何もしない 
	if (iSelected==0){
		return;
	}

	//workNode:全ノード
	//refreshNode:選択ノード

	tempCurParentNode = tree_frm.preClickObj;
	if (tempCurParentNode.id == "root") {
	//	tempKind = tempCurParentNode.lastChild.previousSibling.objkind;
		tempKind = tempCurParentNode.childNodes[1].objkind;
	} else {
		tempKind = tempCurParentNode.objkind;
	}
	if (tempKind == "Measure") {
		for (i = 0; i < l_cnt; i++) {
			if (document.form_main.lst_left.options[i].selected==true){
				tempId = document.form_main.lst_left.options[i].value;
				tempAllParentNode = tree_frm.allIncRootNode;
				workNode = tempAllParentNode.lastChild.firstChild;
				refreshNode = tempCurParentNode;
				while (true) {
					if (workNode.id == tempId) {
						var wkNode = workNode.cloneNode(true);
						wkNode = setStdParts(wkNode);
						tempCurParentNode.lastChild.insertAdjacentElement("BeforeEnd",wkNode);
						// 
						tree_frm.thisAndPreviousNode(refreshNode,'ALL');
						break; // LOOP OUT (OK)
					}
					workNode = workNode.nextSibling; // NEXT TRY
					if(workNode==null){break;}
				}
			}
		}
	} else if (tempKind == "Dimension" || tempKind == "TimeDim") {
		var SearchElmnt = "Parts";
		var CurrentHierNode = tempCurParentNode;
		//CurrentHierNode = CurrentHierNode.parentNode.parentNode;
		tempAllParentNode = tree_frm.searchNode(tempKind, CurrentHierNode.id);
		for (i = 0; i < l_cnt; i++) { // one time loop
			if (document.form_main.lst_left.options[i].selected==true){
				tempId = document.form_main.lst_left.options[i].value;
				workNode = tempAllParentNode.lastChild.firstChild;
				refreshNode = tempCurParentNode;
				while (true) {
					if (workNode.id == tempId) {
						tempCurParentNode.lastChild.insertAdjacentElement("BeforeEnd",workNode.cloneNode(true));
						// 
						tree_frm.thisAndPreviousNode(refreshNode,'ALL');
						tempCurParentNode.lastChild.removeChild(tempCurParentNode.lastChild.firstChild);
						// 
						tree_frm.thisAndPreviousNode(refreshNode,'ALL');
						break; // LOOP OUT (OK)
					}
					workNode = workNode.nextSibling; // NEXT TRY
					if(workNode==null){break;}
				}
			}
		}
		// パーツは１つしか選択できない
		//左右入れ替え
		exchangeElmntRL();
		return;
	}
	// tp = 0 : 右→左 追加
	//Elmnt_Move_Click(0);
	moveDim(0);
}



function setStdParts(orgNode) {
	var wkNode = orgNode;
	var wkDimNode;
	var wkHieNode;
	var wkParNode;
	var copyNode;
	var wkDimId;
	var wkHieId;
	var wkParId;

	var newNode;
	if (wkNode.objkind == "Dimension" || wkNode.objkind == "TimeDim") {
		if (wkNode.lastChild.hasChildNodes()) {
			wkParNode = wkNode.lastChild.lastChild;
			while (true) {
				if(wkParId==null){copyNode = wkParNode.cloneNode(true);}//SEQが一番若いパーツを選択済みにセットする
				wkParId = wkParNode.id;
			//	if (wkParId == "1") {
			//		copyNode = wkParNode.cloneNode(true);
			//	}
				if (wkParId == wkNode.lastChild.firstChild.id) {
					wkNode.lastChild.insertAdjacentElement("BeforeEnd",copyNode);
					wkNode.lastChild.removeChild(wkParNode);
					break;
				} else {
					wkParNode = wkParNode.previousSibling;
					wkNode.lastChild.removeChild(wkParNode.nextSibling);
				}
			}
		}
	}
	newNode = wkNode;
	return newNode;
}


function removeElmnt(){
	var l_cnt = document.form_main.lst_right.options.length;
	var i;
	var iSelected = 0;

	var tempCurParentNode;
	var tempId;
	var tempKind;
	var iCount;
	var workNode;
	var refreshNode;

	var tempText;
	var tempId2;
	var tempText2;

	for (i = 0; i < l_cnt; i++) {
		if (document.form_main.lst_right.options[i].selected==true){
			iSelected++;
			tempId = document.form_main.lst_right.options[i].value;
		}
	}

	//未選択時には、何もしない 
	if (iSelected==0){
		return;
	}

	if (iSelected == l_cnt) {
		// 論理エラー：設定要素がすべて削除されることは認めない
		showMsg("CST1");
		return;
	}



	for (i = 0; i < l_cnt; i++) {
		if (document.form_main.lst_right.options[i].selected==true){

			tempCurParentNode = tree_frm.preClickObj;
			tempId = document.form_main.lst_right.options[i].value;

			if (tempCurParentNode.id == "root") {
			//	tempKind = tempCurParentNode.lastChild.previousSibling.objkind;
				tempKind = tempCurParentNode.childNodes[1].objkind;
			} else {
				tempKind = tempCurParentNode.objkind;
			}

			workNode = tempCurParentNode.lastChild.firstChild;
			refreshNode = workNode.parentNode.parentNode;
			while (true) {
				if (workNode.id == tempId) {
					tempCurParentNode.lastChild.removeChild(workNode);
					//
					tree_frm.thisAndPreviousNode(refreshNode,'ALL');
					break; // LOOP OUT (OK)
				}
				if (workNode.id == tempCurParentNode.lastChild.lastChild.id) {
					break; // LOOP OUT (No match)
				} else {
					workNode = workNode.nextSibling; // NEXT TRY
					refreshNode = workNode.previousSibling;
				}
			}
		}
	}
	// tp = 1 : 右←左 削除
	moveDim(1);
}

function cubeSet() {
	var curRootNode = tree_frm.preClickObj;

	while (curRootNode.id != "root") {
		curRootNode = curRootNode.parentNode.parentNode;
	}

	var curCubSeq = "";
	var curDimSeq = "";
	var curParSeq = "";

	var wkCubSeq = document.form_main.CubId.value;

	var workNode = curRootNode;
	var preObjKind = "";
	var preId = "";
	var wkDimNode;
	var wkDimSeq = "";
	var wkParNode;
	var wkParSeq = "";

	if (workNode.lastChild.hasChildNodes()) {
		wkDimNode = workNode.lastChild.firstChild;
		while (true) {
			wkDimSeq = wkDimNode.id;
			if (wkDimNode.lastChild.hasChildNodes()) {
				wkParNode = wkDimNode.lastChild.firstChild;
				while (true) {
					wkParSeq = wkParNode.id;
					curCubSeq = curCubSeq + wkCubSeq + ",";
					curDimSeq = curDimSeq + wkDimSeq + ",";
					curParSeq = curParSeq + wkParSeq + ",";
					if (wkParSeq == wkDimNode.lastChild.lastChild.id) {
						break;
					} else {
						wkParNode = wkParNode.nextSibling;
					}
				}
			}
			if (wkDimSeq == workNode.lastChild.lastChild.id) {
				break;
			} else {
				wkDimNode = wkDimNode.nextSibling;
			}
		}
	}

	curCubSeq = curCubSeq.substr(0,curCubSeq.length-1);
	curDimSeq = curDimSeq.substr(0,curDimSeq.length-1);
	curParSeq = curParSeq.substr(0,curParSeq.length-1);

	document.form_main.CubId.value=curCubSeq;
	document.form_main.DimId.value=curDimSeq;
	document.form_main.ParId.value=curParSeq;


	submitData("cubesct_regist.jsp",1);

	// 設定を戻す
//	document.form_main.CubId.value="<%=objSeq%>";
}

function exchangeElmntRL() {
	//左右入れ替え
	if( document.form_main.lst_left.selectedIndex >= 0 ){
		var opt = document.createElement("OPTION");
		opt.value = document.form_main.lst_left.options(document.form_main.lst_left.selectedIndex).value;
		opt.text = document.form_main.lst_left.options(document.form_main.lst_left.selectedIndex).text;
		document.form_main.lst_right.options.add(opt,document.form_main.lst_right.length);
		document.form_main.lst_left.options.remove(document.form_main.lst_left.selectedIndex);
	}
	var opt2 = document.createElement("OPTION");
	opt2.value = document.form_main.lst_right.options(0).value;
	opt2.text = document.form_main.lst_right.options(0).text;
	document.form_main.lst_left.options.add(opt2,document.form_main.lst_left.length);
	document.form_main.lst_right.options.remove(document.form_main.lst_right.options(0));
}
</script>

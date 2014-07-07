//*****************************************************
//*******           Create Object         *************
//*****************************************************
function createDivObj(createId){
	var tempObj;
	tempObj = document.createElement("<div id='"+createId+"' class='treeItem' objkind='Vcategory'></div>");
	return tempObj;
}

function createImageObj(createId){
	var tempObj;
//	tempObj = document.createElement("<img objkind='Vcategory' id='"+createId+"' src=\"../../../images/RankingDimension2.gif\" onclick=\"javascript:Toggle('f',this,'report_mng_tree_table.jsp?kh=" + document.navi_form.kh.value + "&id="+createId+"')\" ondragstart=\"javascript:startDrag(); return false;\">");
	tempObj = document.createElement("<img objkind='Vcategory' id='"+createId+"' src=\"../../../images/tree/folder2.gif\" onclick=\"javascript:Toggle('f',this,'report_mng_tree_table.jsp?id="+createId+"')\">");
	return tempObj;
}

function createAhrefObj(createId,createName){
	var tempObj;
	tempObj = document.createElement("<a href=\"return false;\" onclick=\"javascript:Toggle('f',this,'report_mng_tree_table.jsp?id="+ createId + "'); return false;\" id='"+createId+"' name='"+createId+"' ondrop='drop();' ondragover='overDrag();' ondragleave='leaveDrag();' ondragenter='enterDrag();' ondragend='endDrag();' ondragstart='startDrag();' ondblclick=\"javascript:ToggleDblClick('f',this,'report_mng_tree_table.jsp?id="+ createId + "'); return false;\" objkind='Vcategory'></a>");
	tempObj.innerHTML=createName;
	return tempObj;
}

function createDivC_Obj(createId){
	var tempObj;
	tempObj = document.createElement("<div id='"+createId+"-C' style='display:none;' class='container'></div>");
	return tempObj;
}



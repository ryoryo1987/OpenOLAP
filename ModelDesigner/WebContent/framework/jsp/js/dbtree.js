// ドラッグ開始オブジェクトの所属オブジェクト id(judge navi_form or else)
var strDragStart = "";
var preClickObj=null;
var preClickXMLNode=null;
var gamenId="";

function setPreClickObj(th){
	preClickObj=th;
//	var RmodelXML = new ActiveXObject("MSXML2.DOMDocument");
//	RmodelXML.load(parent.opener.XMLDom.xml);
//	var RmodelXML2 = new ActiveXObject("MSXML2.DOMDocument");
//	RmodelXML2.loadXML(parent.opener.XMLDom.xml);
//	alert(parent.opener.XMLDom.xml);
//	alert(RmodelXML2.xml);

//	alert(RmodelXML.xml);
//	alert(th.objkind);
//	alert(preClickObj.outerHTML);
//	alert(th.id);
//	preClickXMLNode = parent.RmodelXML.selectSingleNode("//"+th.objkind+"[@id='"+th.id+"']");

	var tempXML = parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']");
	if(tempXML!=null){
		gamenId="Table";
		if(th.objkind!="logical_model"){
			preClickXMLNode = tempXML.selectSingleNode(".//"+th.objkind+"[@id='"+th.id+"']");
		}else{
			preClickXMLNode = tempXML.selectSingleNode(".//"+th.objkind);
		}
	}else{
		gamenId="All";
		var tempXML = parent.RmodelXML.selectSingleNode("RDBModel");
	//	if(th.objkind=="logical_model"){
			preClickXMLNode = tempXML.selectSingleNode("//db_table[@name='"+th.id+"']");
	//	}
	}


}

function reverseImage(node) {
	var nodeImage = node.lastChild.previousSibling.previousSibling;
    //                  .-C       .A              .image
	if(node.lastChild.style.display=='none'){//show child ?
		nodeImage.src = nodeImage.src.replace('2.gif','1.gif');
	}else{
		nodeImage.src = nodeImage.src.replace('1.gif','2.gif');
	}
}

function reversePM(node) {//Plus Minus change//未使用
//XMLとHTMLで違う。(XML-HTML)
	var pmLTimage = node.lastChild.previousSibling.previousSibling.previousSibling;
    //                  .-C                                     .A              .image          .pmLTimage
	if(node.lastChild.style.display=='none'){//show child ?
		pmLTimage.src=pmLTimage.src.replace('plus.gif','minus.gif');
	}else{
		pmLTimage.src=pmLTimage.src.replace('minus.gif','plus.gif');
	}
}

function reverseDisplay(node) {//style.display change
	if(node.lastChild.style.display=='none'){//show child ?
		node.lastChild.style.display='block';
	}else{
		node.lastChild.style.display='none';
	}
}

function reversePreNextImage(th){
	if(preClickObj!=th){//最初は、PreClickに何も入っていない。
		if(preClickObj!=null){
			var preImage = preClickObj.lastChild.previousSibling.previousSibling;
		    //                 .-C       .A              .image
			preImage.src=preImage.src.replace('1.gif','2.gif');
		}

		var thImage = th.lastChild.previousSibling.previousSibling;
	    //                 .-C       .A              .image
		thImage.src=thImage.src.replace('2.gif','1.gif');
	}

}


//******************************************
function Toggle(kind,node,file_name){



	var ret;
	divNode = node.parentNode;
//	alert(divNode.outerHTML);
	// Unfold the branch if it isn't visible
	if(node.tagName=='IMG'){
		if(kind=='f' || kind=='0'){
			reversePreNextImage(divNode);
			reversePM(divNode);
			reverseDisplay(divNode);
		}else if(kind=='r'){//ROOT
			reversePreNextImage(divNode);
			reverseDisplay(divNode);
		}else{//プラスマイナスクリック
			reversePM(divNode);
			reverseDisplay(divNode);
			return;
		}
		node.nextSibling.focus();
	}else{// A href
		reversePreNextImage(divNode);
	}
//	alert("aaa:"+divNode.outerHTML);
	setPreClickObj(divNode);


	if(gamenId=="Table"){
		if(divNode.objkind=='logical_column'){
			dispNodeInfo(divNode,1);
		}else if(divNode.objkind=='logical_condition'){
			dispNodeInfo(divNode,2);
		}else if(divNode.objkind=='where_clause' || divNode.objkind=='select_clause'){
			dispNodeInfo(divNode,3);
		}else if(divNode.objkind=='logical_model'){
			dispNodeInfo(divNode,4);
		}else{
			dispNodeInfo(divNode,5);
		}
	}

}

function ToggleDblClick(kind,node,file_name){
	divNode = node.parentNode;
	reversePreNextImage(divNode);
	reversePM(divNode);
	reverseDisplay(divNode);
}



function change_lst_att1(obj){
	if(obj.value=="Number"){
		inputCalcMethod(parent.document.all.lst_att2);
	}
}

//*********************************************************
function dispNodeInfo(th,no){
//	dropNode=window.event.srcElement.parentNode;//fukai 追加
	var xmlNode=preClickXMLNode;

	var strHTML="";
	if(no=="1"){
		strHTML+="<table>";
		strHTML+="<tr>";
		strHTML+="<th class='standard'>論理カラム名</th>";
		strHTML+="<td class='standard'><input type='text' name='txt_name' nodeNo='0' mON='論理カラム名' value=\""+xmlNode.childNodes[0].text+"\" onblur='frm_model.writeNodeInfo(this)' size='30'/></td>";
		strHTML+="</tr>";
		strHTML+="<tr>";
		strHTML+="<th class='standard'>カラム名</th>";
		strHTML+="<td class='standard'>"+xmlNode.childNodes[1].text+"</td>";
		strHTML+="</tr>";
		strHTML+="<tr>";
		strHTML+="<th class='standard'>SQL</th>";
		strHTML+="<td class='standard'><input type='text' name='txt_sql' id='txt_sql' nodeNo='2' mON='SQL' value=\""+xmlNode.childNodes[2].text+"\" onblur='frm_model.disabledCheck();frm_model.writeNodeInfo(this);' ondragleave='frm_model.drop()' size='30'/></td>";
		strHTML+="</tr>";
		strHTML+="<tr>";
		strHTML+="<th class='standard'>種類</th>";
		strHTML+="<td class='standard'>";
		strHTML+="<select name='lst_att1' nodeNo='3' onchange='frm_model.writeNodeInfo(this);frm_model.change_lst_att1(this);frm_model.disabledCheck();frm_model.refreshTree();'>";
		strHTML+="<option value='Text'>文字列</option>";
		strHTML+="<option value='Number'>数値</option>";
		strHTML+="<option value='Date'>日付</option>";
		strHTML+="</select>";
		strHTML+="<select name='lst_att2' id='lst_att2' nodeNo='3' onchange='frm_model.inputCalcMethod(this);'>";
		strHTML+="<option value='SUM'>集計</option>";
		strHTML+="<option value='AVG'>平均</option>";
		strHTML+="<option value='MAX'>最大</option>";
		strHTML+="<option value='MIN'>最小</option>";
		strHTML+="<option value='COUNT'>カウント</option>";
		strHTML+="<option value='NONE'>何もしない</option>";
		strHTML+="</select>";
		strHTML+="</td>";
		strHTML+="</tr>";
		strHTML+="<tr>";
		strHTML+="<th class='standard'>GroupBy</th>";
		strHTML+="<td class='standard'><input type='checkbox' name='chk_groupbyflg' id='chk_groupbyflg' onclick='frm_model.wrigtChkGroupbyflg()'/></td>";
		strHTML+="</tr>";
		strHTML+="<tr>";
		strHTML+="<th class='standard'>表示</th>";
		strHTML+="<td class='standard'><input type='checkbox' name='chk_dispflg' id='chk_dispflg' onclick='frm_model.wrigtChkDispflg()'/></td>";
		strHTML+="</tr>";

		strHTML+="</table>";
		strHTML+="<input type='button' value='削除' onclick='frm_model.delNode(1)'/>";
		strHTML+="<input type='button' value='↑' onclick='frm_model.moveNode(\"+\")'/>";
		strHTML+="<input type='button' value='↓' onclick='frm_model.moveNode(\"-\")'/>";
	}else if(no=="2"){
		strHTML+="<table>";
		strHTML+="<tr>";
		strHTML+="<th class='standard'>論理条件名</th>";
		strHTML+="<td class='standard'><input type='text' name='txt_name' nodeNo='0' mON='論理条件名' value=\""+xmlNode.childNodes[0].text+"\" onblur='frm_model.writeNodeInfo(this)' size='30'/></td>";
		strHTML+="</tr>";
		strHTML+="<tr>";
		strHTML+="<th class='standard'>カラム名</th>";
		strHTML+="<td class='standard'>"+xmlNode.childNodes[1].text+"</td>";
		strHTML+="</tr>";
		strHTML+="<tr>";
		strHTML+="<th class='standard'>SQL</th>";

//		strHTML+="<td class='standard'><input type='text' name='txt_sql' id='txt_sql' nodeNo='2' mON='SQL' value=\""+parent.getTableName()+"."+xmlNode.childNodes[2].text+"\" onblur='frm_model.writeNodeInfo(this)' size='30'/></td>";
		var tempStr=xmlNode.childNodes[2].text;
		if(tempStr.indexOf(parent.getTableName()+".")==-1){
			tempStr=parent.getTableName()+"."+tempStr;
		}
		strHTML+="<td class='standard'><input type='text' name='txt_sql' id='txt_sql' nodeNo='2' mON='SQL' value=\""+tempStr+"\" onblur='frm_model.writeNodeInfo(this)' size='30'/></td>";
		strHTML+="</tr>";

		strHTML+="</table>";
		strHTML+="<input type='button' value='削除' onclick='frm_model.delNode(2)'/>";

	}else if(no=="4"){
		strHTML+="<table>";
		strHTML+="<tr>";
		strHTML+="<th class='standard'>論理テーブル名</th>";
		strHTML+="<td class='standard'><input type='text' name='txt_name' mON='論理テーブル名' value=\""+xmlNode.getAttribute("name")+"\" onblur='frm_model.writeLogicalName(this)' size='30'/></td>";
		strHTML+="</tr>";
		strHTML+="<tr>";
		strHTML+="<th class='standard'>表示タイプ</th>";
		strHTML+="<td class='standard'>";
		strHTML+="<select name='lst_table_type' onchange='frm_model.writeTableType(this);'>";
		strHTML+="<option value='dim'>ディメンション</option>";
		strHTML+="<option value='fact'>ファクト</option>";
		strHTML+="</select>";
		strHTML+="</td>";
		strHTML+="</tr>";
		strHTML+="</table>";

	}

	var attDispDiv = parent.document.getElementById("attributeDispDiv");
	attDispDiv.innerHTML=strHTML;
	if(no=="1"){
		var att1Value=parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/select_clause/logical_column[@id='" + preClickXMLNode.getAttribute("id") + "']").childNodes[3].text;
		parent.document.all.lst_att1.options[selectedValue(parent.document.all.lst_att1,att1Value)].selected=true;
		var att2Value=parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/select_clause/logical_column[@id='" + preClickXMLNode.getAttribute("id") + "']").childNodes[3].getAttribute("calcmethod");
		parent.document.all.lst_att2.options[selectedValue(parent.document.all.lst_att2,att2Value)].selected=true;

		disabledCheck();


		var groupByFlg=parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/select_clause/logical_column[@id='" + preClickXMLNode.getAttribute("id") + "']").getAttribute("groupbyflg");

		if(groupByFlg==""){
			if(att1Value=='Number'){
				groupByFlg=false;
			}else{
				groupByFlg=true;
			}
		}else if(groupByFlg=="true"){
			groupByFlg=true;
		}else if(groupByFlg=="false"){
			groupByFlg=false;
		}

		parent.document.all.chk_groupbyflg.checked=groupByFlg;
		wrigtChkGroupbyflg();


		var dispFlg=parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/select_clause/logical_column[@id='" + preClickXMLNode.getAttribute("id") + "']").getAttribute("dispflg");

		if(dispFlg==""){
			dispFlg=true;
		}else if(dispFlg=="true"){
			dispFlg=true;
		}else if(dispFlg=="false"){
			dispFlg=false;
		}

		parent.document.all.chk_dispflg.checked=dispFlg;
		wrigtChkDispflg();


	}else if(no=="2"){
		writeNodeInfo(parent.document.all.txt_sql);//テーブル名自動付加の場合の変更もXMLに反映させる
	}else if(no=="4"){
		parent.document.all.lst_table_type.options[selectedValue(parent.document.all.lst_table_type,parent.tableType)].selected=true;
	}


}

function wrigtChkGroupbyflg(){
	var groupByFlg2=null;
	if(parent.document.all.chk_groupbyflg.checked){
		groupByFlg2="true";
	}else{
		groupByFlg2="false";
	}
	parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/select_clause/logical_column[@id='" + preClickXMLNode.getAttribute("id") + "']").setAttribute("groupbyflg",groupByFlg2);
}

function wrigtChkDispflg(){
	var dispFlg2=null;
	if(parent.document.all.chk_dispflg.checked){
		dispFlg2="true";
	}else{
		dispFlg2="false";
	}
	parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/select_clause/logical_column[@id='" + preClickXMLNode.getAttribute("id") + "']").setAttribute("dispflg",dispFlg2);
}


function disabledCheck(){
	var xmlNode=preClickXMLNode;

	var tempArr=xmlNode.childNodes[1].text.split(" ");
	var columnName=tempArr[0];

	if(parent.document.all.lst_att1.value=="Number"){
		parent.document.all.lst_att2.disabled=false;

		if((parent.document.all.txt_sql.value==parent.getTableName()+"."+columnName)||
		(parent.document.all.txt_sql.value=="SUM("+parent.getTableName()+"."+columnName+")")||
		(parent.document.all.txt_sql.value=="AVG("+parent.getTableName()+"."+columnName+")")||
		(parent.document.all.txt_sql.value=="MAX("+parent.getTableName()+"."+columnName+")")||
		(parent.document.all.txt_sql.value=="MIN("+parent.getTableName()+"."+columnName+")")||
		(parent.document.all.txt_sql.value=="COUNT("+parent.getTableName()+"."+columnName+")")){
			parent.document.all.chk_groupbyflg.checked=false;
			wrigtChkGroupbyflg();
		}else{
			parent.document.all.lst_att2.disabled=true;//SQLカスタマイズ時は集計方法リストを選ばせない
		}

	}else{
		parent.document.all.lst_att2.disabled=true;

		if((parent.document.all.txt_sql.value=="SUM("+parent.getTableName()+"."+columnName+")")||
		(parent.document.all.txt_sql.value=="AVG("+parent.getTableName()+"."+columnName+")")||
		(parent.document.all.txt_sql.value=="MAX("+parent.getTableName()+"."+columnName+")")||
		(parent.document.all.txt_sql.value=="MIN("+parent.getTableName()+"."+columnName+")")||
		(parent.document.all.txt_sql.value=="COUNT("+parent.getTableName()+"."+columnName+")")){
			parent.document.all.txt_sql.value=parent.getTableName()+"."+columnName;
			writeNodeInfo(parent.document.all.txt_sql);
			parent.document.all.chk_groupbyflg.checked=true;
			wrigtChkGroupbyflg();
		}

	}

	var tempArr=xmlNode.childNodes[1].text.split(" ");
	var columnName=tempArr[0];


}


function moveNode(type){
	var xmlNode=preClickXMLNode;
	var childNum=0;

	if(xmlNode==null){
		return;
	}


	for(i=0;i<xmlNode.parentNode.childNodes.length;i++){
		if(xmlNode.parentNode.childNodes[i]==xmlNode){
			childNum=i;
		}
	}
	if(type=='+'){
		if(childNum!=0){//最前列の場合は何もしない
			childNum=childNum-1;
			xmlNode.parentNode.insertBefore(xmlNode,xmlNode.parentNode.childNodes[childNum]);
		}
	}else if(type=='-'){
		childNum=childNum+2;
		xmlNode.parentNode.insertBefore(xmlNode,xmlNode.parentNode.childNodes[childNum]);
	}
	refreshTree();
//alert(xmlNode.parentNode.xml);
}

/*
function moveTableNode(type){
	var xmlNode=preClickXMLNode;
	var childNum=0;
	for(i=0;i<xmlNode.parentNode.childNodes.length;i++){
		if(xmlNode.parentNode.childNodes[i]==xmlNode){
			childNum=i;
		}
	}
	if(type=='+'){
		if(childNum!=0){//最前列の場合は何もしない
			childNum=childNum-1;
			xmlNode.parentNode.insertBefore(xmlNode,xmlNode.parentNode.childNodes[childNum]);
		}
	}else if(type=='-'){
		childNum=childNum+2;
		xmlNode.parentNode.insertBefore(xmlNode,xmlNode.parentNode.childNodes[childNum]);
	}
	refreshTree();
//alert(xmlNode.parentNode.xml);
}
*/


//リストボックスを選択状態にする為のモジュール
function selectedValue(obj,objValue){
	for(i=0;i<obj.length;i++){
		if(obj.options[i].value==objValue){
			return i;
		}
	}
	return 0;
}



function writeNodeInfo(obj){

	//共通エラーチェックを先に行う
	if(!parent.checkData()){return;}


	var xmlNode=preClickXMLNode;
	xmlNode.childNodes[obj.nodeNo].text=obj.value;
	if(obj.nodeNo=="0"){//論理名変更時
		refreshTree();//ツリーの更新
	}

}


function writeLogicalName(obj){
	var xmlNode=preClickXMLNode;
	xmlNode.setAttribute("name",obj.value);
	refreshTree();//ツリーの更新
}

function writeTableType(obj){
	parent.tableType=obj.value;
}




function inputCalcMethod(obj){
	var xmlNode=preClickXMLNode;
	var tempString="";

	var tempArr=xmlNode.childNodes[1].text.split(" ");
	var columnName=tempArr[0];

	tempString=parent.getTableName()+"."+columnName;
	if(obj.value!="NONE"){
		tempString=obj.value+"("+tempString+")";
	}
	parent.document.all.txt_sql.value=tempString;
	writeNodeInfo(parent.document.all.txt_sql);



	xmlNode.childNodes[obj.nodeNo].setAttribute("calcmethod",obj.value);
//	alert(xmlNode.xml);
}



function delNode(no){

	var xmlNode2=preClickXMLNode;
	var tempNode1 = null;
	var tempNode2 = null;
	if(no=="1"){
		tempNode1 = parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/select_clause");
		tempNode2 = parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/select_clause/logical_column[@id='" + preClickXMLNode.getAttribute("id") + "']");
	}else if(no=="2"){
		tempNode1 = parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/where_clause");
		tempNode2 = parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/where_clause/logical_condition[@id='" + preClickXMLNode.getAttribute("id") + "']");
	}
	tempNode1.removeChild(xmlNode2);
//	reloadTree(parent.RmodelXML,1);


	var attDispDiv = parent.document.getElementById("attributeDispDiv");
	attDispDiv.innerHTML="";


	refreshTree();//ツリーの更新
}


function refreshTree(){

//	alert("refreshTree:"+preClickObj);
	if(preClickObj!=null){
		var preClickObjID=preClickObj.id;
	}


	var RmodelXSL = new ActiveXObject("MSXML2.DOMDocument");
	RmodelXSL.async = false;
	if(gamenId=="Table"){
		RmodelXSL.load("db_model.xsl");
		var dbHTML = parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model").transformNode(RmodelXSL);
	}else{
		RmodelXSL.load("mapping_db.xsl");
		var dbHTML = parent.RmodelXML.transformNode(RmodelXSL);
	}
	document.getElementById("root").innerHTML=dbHTML;

	if(preClickObjID!=null){
		preClickObj=null;
	//	setPreClickObj(document.getElementById("a_"+preClickObjID));
	//	Toggle('f',document.getElementById("a_"+preClickObjID),'');
		if(document.getElementById("a_"+preClickObjID)!=undefined){//削除の場合以外はpreClickObjを再セット
			document.getElementById("a_"+preClickObjID).focus();
			preClickObj=document.getElementById("a_"+preClickObjID).parentNode;
		}
	}


}

//*********************************************************
function startDrag(){

//alert(window.event.srcElement.outerText);

    // get what is being dragged:
    srcObj = window.event.srcElement;

    // store the source of the object into a string acting as a dummy object so we don't ruin the original object:
    dummyObj = srcObj.outerHTML;

    // post the data for Windows:
    var dragData = window.event.dataTransfer;

    // set the type of data for the clipboard:
//	var argStr;
//	argStr  = "";
//	argStr += window.event.srcElement.outerText;
//	argStr += ':'+ window.event.srcElement.objkind;

//	dragData.setData('Text',argStr);
//	alert("bbb:"+window.event.srcElement.parentNode);
	setPreClickObj(window.event.srcElement.parentNode);

    // allow only dragging that involves moving the object:
    dragData.effectAllowed = 'linkMove';

    // use the special 'move' cursor when dragging:
    dragData.dropEffect = 'move';
}


function enterDrag() {
    // allow target object to read clipboard:
    window.event.dataTransfer.getData('Text');
}

function endDrag() {

    // when done remove clipboard data
    window.event.dataTransfer.clearData();
}

function overDrag() {
    // tell onOverDrag handler not to do anything:
	window.event.srcElement.className = 'dragOver';
}
function leaveDrag() {
	//window.event.srcElement.style.color = 'black';
	window.event.srcElement.className = 'dragEnd';
}

var dropNode=null;
function drop() {

	if(window.event!=null){
		dropNode=window.event.srcElement.parentNode;
		window.event.srcElement.className = 'dragEnd';


	//	addLogicalModel(window.event.srcElement.parentNode.objkind,parent.frm_db.preClickXMLNode.childNodes[0].text,parent.frm_db.preClickXMLNode.childNodes[1].text);
		var DataTable = parent.document.getElementById("DataTable");
		for(i=0;i<DataTable.rows.length;i++){
			if(DataTable.rows[i].selectflg=="1"){
			//	alert(DataTable.rows[i].cells[0].firstChild.childNodes[2].innerHTML);
				var  newXMLNode= addLogicalModel(window.event.srcElement.parentNode.objkind,DataTable.rows[i].cells[0].firstChild.childNodes[2].innerHTML,DataTable.rows[i].cells[1].firstChild.innerHTML);
			}
		}

		if(newXMLNode!=null){
			reloadTree(newXMLNode);
			parent.resetRow();
		}

	}else if(window.event==null){
		parent.event.srcElement.className = 'dragEnd';

		var DataTable = parent.document.getElementById("DataTable");
		for(i=0;i<DataTable.rows.length;i++){
			if(DataTable.rows[i].selectflg=="1"){
				parent.document.all.txt_sql.value+=parent.getTableName()+"."+DataTable.rows[i].cells[0].firstChild.childNodes[2].innerHTML;
			}
		}

	}


}




/*
function addButton(locationKind,name,type){
	dropNode=document.getElementById(locationKind);
	addLogicalModel(locationKind,name,type);
}
*/

function getNewID(){

	var tempNode1 = parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/select_clause");
	var tempNode2 = parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/where_clause");

	var maxId = 0;


	for(x=0;x<tempNode1.childNodes.length;x++){
		maxId=parseInt(Math.max(parseInt(maxId),parseInt(tempNode1.childNodes[x].getAttribute("id").replace(parent.getTableName()+"_",""))));
	}
	for(x=0;x<tempNode2.childNodes.length;x++){
		maxId=parseInt(Math.max(parseInt(maxId),parseInt(tempNode2.childNodes[x].getAttribute("id").replace(parent.getTableName()+"_",""))));
	}

//	return (maxId+1);
	return (parent.getTableName()+"_"+(maxId+1));
}


//*********************************************************
function addLogicalModel(locationKind,name,type){
	var xmlNode = parent.RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model/"+locationKind);

//	if(document.getElementById(name)!=null){
//		alert(name + "は既に存在します。");
//		return;
//	}


	var tagName = "";
	var sqlValue = "";
	var groupByFLg = "";
	var dispFLg = "";
	var fileName="";

	var newID=getNewID();

	if(locationKind=="select_clause"){
		tagName="logical_column";
		sqlValue=parent.getTableName()+"."+name;
		groupByFLg = " groupbyflg='true'";
		dispFLg = " dispflg='true'";

		if(type.indexOf("char")!=-1){
			fileName="Text";
		}else if(type.indexOf("varchar")!=-1){
			fileName="Text";
		}else if(type.indexOf("text")!=-1){
			fileName="Text";
		}else if(type.indexOf("numeric")!=-1){
			fileName="Number";
			sqlValue="SUM(" + sqlValue + ")";//数値の時はSUMを付ける
			groupByFLg = " groupbyflg='false'";//数値の時はgroupbyflgを変更

		}else if(type.indexOf("date")!=-1){
			fileName="Date";
		}else if(type.indexOf("timestamp")!=-1){
			fileName="Date";
		}else{
			fileName="Text";
		} 

	}else if(locationKind=="where_clause"){
		tagName="logical_condition";
	//	sqlValue=name+" in ('@@"+newID+"@@')";
		sqlValue=parent.getTableName()+"."+name+" in ('@@"+newID+"@@')";
	}

	var strXml="";
	strXml+="<"+tagName+" id='"+newID+"'" + groupByFLg + " " + dispFLg + ">";
	strXml+="	<name>"+name+"</name>";
	strXml+="	<type>"+name+" ("+type+")</type>";
	strXml+="	<sql>"+sqlValue+"</sql>";
	if(locationKind=="select_clause"){
		strXml+="	<att1 calcmethod='SUM'>" + fileName + "</att1>";
	}
	strXml+="</"+tagName+">";

	var addXMLDom = new ActiveXObject("MSXML2.DOMDocument");
	addXMLDom.async = false;
	addXMLDom.loadXML(strXml);
	xmlNode.appendChild(addXMLDom.selectSingleNode("//"));

	return xmlNode;
//	reloadTree(xmlNode,2);

//	alert(parent.opener.XMLDom.xml);
//	alert(logicalXML.xml);
//	alert(addXMLDom.xml);
}

function reloadTree(xmlNode,argDropNode){
//	alert(preClickObj);
//	if(preClickObj!=null){
//		var preClickObjID=preClickObj.id;
//	}

	if(argDropNode!=null){
		dropNode=argDropNode;
	}
	if(dropNode!=null){
		var tempNode = dropNode.parentNode;
	}

	var nonDisp = document.getElementById("nonDisp");
	var strHTML = xmlNode.transformNode(RmodelXSL);
	nonDisp.innerHTML=strHTML;

	var addNode = nonDisp.firstChild;

	tempNode.insertBefore(addNode,dropNode);
	tempNode.removeChild(dropNode);

//	if(preClickObjID!=null){
//		setPreClickObj(frm_model.document.getElementByID(preClickObjID));
//	}

}


//XMLとXSLTを合わせページ更新（DOMを書き換えた後）
function domReload(frmXML,frmReload){//XMLページ再読み込み
	frmReload.document.open();//ドキュメントの初期化
	var strResult = frmXML.XMLData.transformNode(frmXML.objXSL);
	frmReload.document.write(strResult);
}

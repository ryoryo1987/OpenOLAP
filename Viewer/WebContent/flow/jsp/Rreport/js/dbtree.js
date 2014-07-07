// ドラッグ開始オブジェクトの所属オブジェクト id(judge navi_form or else)
var strDragStart = "";
var preClickObj=null;

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
// エラー処理追加(登録前に左ツリー操作禁止)
	var ret;
//	if ((document.navi_form.change_flg.value == 1)&&(file_name!='noSubmit')) {
//		//破棄確認メッセージ表示
//		ret = showConfirm("CFM1");
//
//		//破棄します=Yesの時,画面制御用フラグ=0にResetする
//		if (ret == true) {
//			document.navi_form.change_flg.value = 0;
//		} else {
//			//破棄しない場合処理抜ける
//			return;
//		}
//	}

//alert(node.outerHTML);
//alert(node.parentNode.outerHTML);

	document.navi_form.seqId.value=node.id;
	document.navi_form.objKind.value=node.objkind;

	divNode = node.parentNode;


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

//	//if preClickNode == clickNode then none
//	if(preClickObj!=divNode){
//		preClickObj = divNode;
//		preClickParentObj = preClickObj.parentNode.parentNode;
//
//		if(file_name!='noSubmit'){
//			document.navi_form.target = "right_frm";
//			document.navi_form.action = folderName + file_name;
//			document.navi_form.submit();
//		}
//	}

	if((file_name=='noSubmit')&&(parent.document.all.div_path!=undefined)){
		var thisNode = divNode;
		var selectNode = divNode;

		var strPath = "";
		while(thisNode.parentNode != undefined){
			if(thisNode.reportname!=undefined){
				if(strPath!=""){strPath+=",";}
				strPath+=thisNode.reportname.replace("\n","");
			}
			thisNode=thisNode.parentNode;
		}
		var arrReport = strPath.split(",");
		strPath="";
		for(i=0;i<arrReport.length;i++){
			strPath = arrReport[i] + "/" + strPath;
		}
		parent.document.all.div_path.innerHTML=strPath.replace("root/","レポート/");
		parent.document.form_main.hid_path.value=strPath;
		parent.document.form_main.hid_par_id.value=selectNode.id;
	}

}

function ToggleDblClick(kind,node,file_name){
	divNode = node.parentNode;
	reversePreNextImage(divNode);
	reversePM(divNode);
	reverseDisplay(divNode);
}


//*********************************************************
function startDrag(){
//alert(nodeAtt);
//alert(window.event.srcElement.outerText);

    // get what is being dragged:
    srcObj = window.event.srcElement;

    // store the source of the object into a string acting as a dummy object so we don't ruin the original object:
    dummyObj = srcObj.outerHTML;

    // post the data for Windows:
    var dragData = window.event.dataTransfer;

    // set the type of data for the clipboard:
	var argStr;
	argStr  = "fromDB";
	argStr += ':'+ window.event.srcElement.id;
	argStr += ':'+ window.event.srcElement.outerText;
	argStr += ':'+ window.event.srcElement.objkind;
    dragData.setData('Text',argStr);

    // allow only dragging that involves moving the object:
    dragData.effectAllowed = 'linkMove';

    // use the special 'move' cursor when dragging:
    dragData.dropEffect = 'move';
}



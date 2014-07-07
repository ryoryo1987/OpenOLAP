// *****************************************************************************
//  メニュー表示、スライス 処理
// *****************************************************************************

// *********************************************************
//  変数宣言部
// *********************************************************
	var dimListMaxHeight = 200;	// スライサーボタン押下で表示される次元メンバ表示領域の
								// 縦の高さの規定値。これを超えると縦スクロールバーを表示

	var activeSlicer = null;	// 現在押下状態にあるスライサーボタン

// *********************************************************
//  関数部
// *********************************************************

	// *********************************************************
	//  Spread初期表示
	// *********************************************************

	// スライサーボタン表示
	function showSlicerButton() {
		bodyNode=document.getElementById("SpreadBody");
		var pageTable=document.getElementById("pageEdgeTable");
		pageTable=pageTable.rows[0].cells;

		dimList=axesXMLData.getElementsByTagName("Members");

		// もし、ページエッジに次元が無い場合は、挿入エリアを表示し、return
		if ( pageTable[0].id == "insertArea" ) {
			document.getElementById("pageEdgeTable").rows[0].style.visibility='visible';
			return;
		}

		var i,j;
		var buttonHTML='';
		var axis;
		var selectedMemberID;
		var selectedMemberIndex;
		for(j=0;j<pageTable.length;j++){
			for(i=0;i<dimList.length;i++){

				if(dimList[i].attributes.getNamedItem("id").text==pageTable[j].dimId){

					// 軸情報をあらわすノード
					axis = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/HierarchyInfo[@id=\"" + dimList[i].attributes.getNamedItem("id").text + "\"]");

					// デフォルトメンバのKey(=UName)を求める
					selectedMemberID = axis.selectSingleNode("DefaultMemberKey").text;
					if ( selectedMemberID == "NA" ) {
						selectedMemberID = axesXMLData.selectSingleNode("/root/Axes/Members[@id=\"" + dimList[i].attributes.getNamedItem("id").text + "\"]//Member[1]/UName").text;
					}

					// デフォルトメンバのIDを求める
					selectedMemberIndex = axesXMLData.selectSingleNode("/root/Axes/Members[@id=\"" + dimList[i].attributes.getNamedItem("id").text + "\"]//Member[UName=\"" + selectedMemberID + "\"]").getAttribute("id");

					// 軸に対して設定されているメンバ名表示タイプ
					var dispMemberType = axis.selectSingleNode("DisplayMemberType").text;

					buttonHTML=buttonHTML+"<div style='display:inline;'>";
					buttonHTML=buttonHTML+"<NOBR>";

					var styleStr = ""; // メジャーの場合は、イメージを変更
					if (dimList[i].attributes.getNamedItem("id").text == "16") {
						styleStr = "style=\"background:url('./images/measureLeft.gif') no-repeat;\"";
					}

					buttonHTML=buttonHTML+"<div class='axisIMG' onmousedown='axisTitleDown(this);openSelector("+dimList[i].attributes.getNamedItem('id').text+",2)' "+styleStr+" ></div>";

					buttonHTML=buttonHTML+"<div id='axisCenter' class='axisCenter'>"+"\n";
					buttonHTML=buttonHTML+"<a class='dimListButton' href='' onclick=\"return clickSlicerButton(event,"+(i+1)+"," + selectedMemberIndex + ");\" onmouseover=\"slicerMouseover(event, "+(i+1)+",0);\">";
					buttonHTML=buttonHTML+dimList[i].selectSingleNode(".//Member[@id=\"" + selectedMemberIndex + "\"]/" + dispMemberType).text;
					buttonHTML=buttonHTML+"</a>"+"\n";
					buttonHTML=buttonHTML+"</div>"+"\n";
					buttonHTML=buttonHTML+"<div id='axisRight' class='axisRight'></div>"+"\n";
					buttonHTML=buttonHTML+"</NOBR>"+"\n";
					buttonHTML=buttonHTML+"</div>"+"\n";

					// スタイル変更のため、コメント化（20041125）
//					buttonHTML=buttonHTML+"<div class='pageAxisIMG' style='cursor:hand;background-image:url(./images/dim_change.gif);' onmousedown='axisTitleDown(this);openSelector("+dimList[i].attributes.getNamedItem('id').text+",2)' ></div>";
//					buttonHTML=buttonHTML+"<div class='dimListBar' style='display:inline'>"+"\n";
//					buttonHTML=buttonHTML+"<a class='dimListButton' href='' onclick=\"return clickSlicerButton(event,"+(i+1)+"," + selectedMemberIndex + ");\" onmouseover=\"slicerMouseover(event, "+(i+1)+",0);\">";
//					buttonHTML=buttonHTML+dimList[i].selectSingleNode(".//Member[@id=\"" + selectedMemberIndex + "\"]/" + dispMemberType).text;
//					buttonHTML=buttonHTML+"</a>"+"\n";
//					buttonHTML=buttonHTML+"</div>"+"\n";
//					buttonHTML=buttonHTML+"</NOBR>"+"\n";
//					buttonHTML=buttonHTML+"</div>"+"\n";
					pageTable[j].innerHTML=buttonHTML;
					buttonHTML="";
					break;
				}
			}
		}

//alert(pageTable[0].outerHTML);

		// ページエッジの動的生成完了。ページエッジ行を表示する。
		document.getElementById("pageEdgeTable").rows[0].style.visibility='visible';

		return;
	}

	// *********************************************************
	//  イベント（スライサーボタン）
	// *********************************************************

	//スライサーボタンクリック
	//	dimNo:軸Index(XMLではHierarchyInfoタグおよびMembersタグの並び順(1start)に対応)
	//		 メジャーが「16」固定とならないことに注意 
	//	memNo:軸メンバのID(XMLではMemberタグの属性「ID」に対応)
	function clickSlicerButton(event, dimNo,memNo) {

		var button;
		button = window.event.srcElement;

		clickButtonNode=button;//クリックしたボタンをいれておく。
		button.blur();//選択囲みをなくす。

		// 軸の表示名称タイプを取得
		var axis = getAxisByDimNo(dimNo); // 軸情報をあらわすノード
		var dispMemberType = axis.selectSingleNode("DisplayMemberType").text;

		if (button.dimList == null) {

			var memberNode;
			var memberHTML="";
			var tempAhrefElement;
			var tempElement;
			var tempParentNode;
			var firstChildNodes;

			memberNode=axesXMLData.selectSingleNode("/root/Axes/Members[" + dimNo + "]//Member[@id=" + memNo + "]");
			button.dimList = document.createElement("<div id='toolsdimList' class='dimList' onmouseover='dimListMouseover(event)'>");

			tempParentNode=memberNode;

			tempParentNode=memberNode.parentNode;
			//自分より親のレベルを表示
			while(tempParentNode.tagName!="Members"){

				tempAhrefElement=document.createElement("<a class='dimListItem' onclick=\"clickDimMember("+dimNo+","+tempParentNode.attributes.getNamedItem("id").text+",'"+tempParentNode.selectSingleNode(dispMemberType).text+"')\" onmouseover=\"dimListItemMouseover(event,"+dimNo+","+tempParentNode.attributes.getNamedItem("id").text+","+memNo+");\">");
				tempElement=document.createElement("<span class='dimListItemText'>longName</span>");
				tempElement.innerHTML=tempParentNode.selectSingleNode(dispMemberType).text;
				tempAhrefElement.appendChild(tempElement);
				tempElement=document.createElement("<span class='dimListItemArrow'>&#9654;</span>");
				tempElement.innerHTML="&#9654;";
				tempAhrefElement.appendChild(tempElement);

				if(button.dimList.hasChildNodes()){
					firstChildNodes=button.dimList.childNodes[0];
					tempElement=document.createElement("<div class='dimListItemSep'></div>");
					firstChildNodes.insertAdjacentElement('BeforeBegin',tempElement);
					tempElement.insertAdjacentElement('BeforeBegin',tempAhrefElement);
				}else{
					button.dimList.appendChild(tempAhrefElement);

					tempElement=document.createElement("<div class='dimListItemSep'></div>");
					button.dimList.appendChild(tempElement);
				}
				if(tempParentNode.parentNode.tagName!="Members"){
					tempParentNode=tempParentNode.parentNode;
				}else{
					break;
				}

			}

			//自分と同じレベルを表示（一番親の場合は、Membersタグに他の情報がないため、０から）
			if(memberNode.parentNode.tagName=="Members"){
				i=0;
			}else{
				i=memberElementsNum;
			}
			tempParentNode=memberNode.parentNode;
			for(;i<tempParentNode.childNodes.length;i++){
				if(tempParentNode.childNodes[i].childNodes.length>memberElementsNum){
					tempAhrefElement=document.createElement("<a class='dimListItem' onclick=\"clickDimMember("+dimNo+","+tempParentNode.childNodes[i].attributes.getNamedItem("id").text+",'"+tempParentNode.childNodes[i].selectSingleNode(dispMemberType).text+"')\" onmouseover=\"dimListItemMouseover(event,"+dimNo+","+tempParentNode.childNodes[i].attributes.getNamedItem("id").text+","+memNo+");\">");

					tempElement=document.createElement("<span class='dimListItemText'>longName</span>");

					if ( tempParentNode.childNodes[i].attributes.getNamedItem("id").text == memNo ) {
						tempElement.innerHTML="<B>" + tempParentNode.childNodes[i].selectSingleNode(dispMemberType).text + "</B>";
					} else {
						tempElement.innerHTML=tempParentNode.childNodes[i].selectSingleNode(dispMemberType).text;
					}

					tempAhrefElement.appendChild(tempElement);
					tempElement=document.createElement("<span class='dimListItemArrow'>&#9654;</span>");
					tempElement.innerHTML="&#9654;";
					tempAhrefElement.appendChild(tempElement);

					button.dimList.appendChild(tempAhrefElement);
				}else{
					tempAhrefElement=document.createElement("<a class='dimListItem'  onclick=\"clickDimMember("+dimNo+","+tempParentNode.childNodes[i].attributes.getNamedItem("id").text+",'"+tempParentNode.childNodes[i].selectSingleNode(dispMemberType).text+"')\" onmouseover=\"dimListItemMouseover(event,null,null,"+memNo+");\">");

					tempElement=document.createElement("<span class='dimListItemText'></span>");

					if ( tempParentNode.childNodes[i].attributes.getNamedItem("id").text == memNo ) {
						tempElement.innerHTML="<B>" + tempParentNode.childNodes[i].selectSingleNode(dispMemberType).text + "</B>";
					} else {
						tempElement.innerHTML=tempParentNode.childNodes[i].selectSingleNode(dispMemberType).text;
					}

					tempAhrefElement.appendChild(tempElement);

					button.dimList.appendChild(tempAhrefElement);
				}
			}

	/*
			//あれば、自分の子供を表示
			if(memberNode.childNodes.length>memberElementsNum){
				tempParentNode=memberNode;
				tempElement=document.createElement("<div class='dimListItemSep'></div>");
				button.dimList.appendChild(tempElement);

				for(i=memberElementsNum;i<tempParentNode.childNodes.length;i++){
					if(tempParentNode.childNodes[i].childNodes.length>memberElementsNum){
						tempAhrefElement=document.createElement("<a class='dimListItem' onclick=\"clickDimMember("+dimNo+","+tempParentNode.childNodes[i].attributes.getNamedItem("id").text+",'"+tempParentNode.childNodes[i].selectSingleNode(dispMemberType).text+"')\" onmouseover=\"dimListItemMouseover(event,"+dimNo+","+tempParentNode.childNodes[i].attributes.getNamedItem("id").text+","+memNo+");\">");

						tempElement=document.createElement("<span class='dimListItemText'>longName</span>");
						tempElement.innerHTML=tempParentNode.childNodes[i].selectSingleNode(dispMemberType).text;
						tempAhrefElement.appendChild(tempElement);

						tempElement=document.createElement("<span class='dimListItemArrow'>&#9654;</span>");
						tempElement.innerHTML="&#9654;";
						tempAhrefElement.appendChild(tempElement);

						button.dimList.appendChild(tempAhrefElement);
					}else{
						tempAhrefElement=document.createElement("<a class='dimListItem'  onclick=\"clickDimMember("+dimNo+","+tempParentNode.childNodes[i].attributes.getNamedItem("id").text+",'"+tempParentNode.childNodes[i].selectSingleNode(dispMemberType).text+"')\" onmouseover=\"dimListItemMouseover(event,null,null,"+memNo+");\">");

						tempElement=document.createElement("<span class='dimListItemText'></span>");
						tempElement.innerHTML=tempParentNode.childNodes[i].selectSingleNode(dispMemberType).text;
						tempAhrefElement.appendChild(tempElement);

						button.dimList.appendChild(tempAhrefElement);
					}
				}
			}
	*/

			bodyNode.appendChild(button.dimList);
			if (button.dimList.isInitialized == null){
				initializeDimList(button.dimList);
			}
		}

		// 初期化
		if (activeSlicer != null){
			resetSlicer(activeSlicer);
		}

		// クリックされたスライサーボタンをアクティブに設定
		if (button != activeSlicer) {
			changeSlicerStyle(button);
			activeSlicer = button;
		}else{
			activeSlicer = null;
		}

		// スタイルの初期化イベントを追加
		document.attachEvent( "onmouseup", sliceStatusClear );

		return false;
	}


	//スライサーボタンのマウスOver
	function slicerMouseover(event, dimNo,memNo) {
		var button;
		button = window.event.srcElement;

		// スライサーをアクティブに設定
		if (activeSlicer != null && activeSlicer != button){
			clickSlicerButton(event,dimNo,memNo);
		}
	}

	// *********************************************************
	//  イベント（軸メンバーリスト表示ボックス）
	// *********************************************************

	// スライサーにより表示された軸リスト表示ボックスのマウスオーバー
	function dimListMouseover(event) {
		var dimList;
		dimList = getNodeBox(window.event.srcElement, "DIV", "dimList");

		// 表示された次元/メジャーのメンバリストを非表示にする
		if (dimList.activeItem != null){
		    closeSubDimList(dimList);
		}
	}

	// *********************************************************
	//  イベント（軸メンバーリスト表示ボックス、軸メンバー）
	// *********************************************************

	// 軸メンバーがクリックされた
	function clickDimMember(dimNo,memNo,memberName){

		var tempNode;
		tempNode=document.createElement("<a class='dimListButton' href='' onclick=\"return clickSlicerButton(event,"+dimNo+","+memNo+");\" onmouseover=\"slicerMouseover(event, "+dimNo+","+memNo+");\">");

		tempNode.innerHTML=memberName;
		clickButtonNode.parentNode.appendChild(tempNode);
		clickButtonNode.parentNode.removeChild(clickButtonNode);

		if(activeSlicer!=null) {
			resetSlicer(activeSlicer);
		}
		activeSlicer = null;

		var clickNode = axesXMLData.selectSingleNode("/root/Axes/Members[" + dimNo + "]//Member[@id=" + memNo + "]");

		// ***** ページエッジ選択状況を更新 **************************************
		// 1.次元データXMLのデフォルトメンバ情報を更新
		//   (/root/OlapInfo/AxesInfo/HierarchyInfo/DefaultMemberKey)
		// 2.ページエッジ軸ID、メンバKeyの組み合わせリスト情報(HTMLのhidden)を更新
		// 3.デフォルトメンバ情報を更新
		// ***********************************************************************

		// 1.次元データXMLのデフォルトメンバ情報を更新
		var selectedMemberID = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/HierarchyInfo[" + dimNo + "]" + "/DefaultMemberKey");

		// 選択されたメンバのインデックスをKey(=UName)に変換
		var memUName = axesXMLData.selectSingleNode("/root/Axes/Members[" + dimNo + "]//Member[@id=\"" + memNo + "\"]/UName").text;

		// 選択されたメンバのKey(=UName)でデフォルトメンバ情報を更新
		selectedMemberID.text = memUName;

		// 2.ページエッジ軸ID、メンバKeyの組み合わせリスト情報(HTMLのhidden)を更新
		var pageEdgeIDValueList = document.SpreadForm.pageEdgeIDValueList_hidden.value;
		var pageEdgeIDValueArray = pageEdgeIDValueList.split(",");

		var pageEdgeIDValue;
		var pageEdgeID;
		var pageEdgeValue;
		var tmpArray;
		for ( var i = 0; i < pageEdgeIDValueArray.length; i++ ) {
			pageEdgeIDValue = pageEdgeIDValueArray[i];
			tmpArray = pageEdgeIDValue.split(":");
			pageEdgeID = tmpArray[0];
			if ( pageEdgeID == dimList[dimNo-1].attributes.getNamedItem("id").text ) {
				pageEdgeIDValueArray[i] = pageEdgeID + ":" + clickNode.firstChild.text;
				break;
			}
		}

		document.SpreadForm.pageEdgeIDValueList_hidden.value = pageEdgeIDValueArray.join(",");

		document.SpreadForm.viewCol0KeyList_hidden.value  = viewedColSpreadKeyList[0];
		document.SpreadForm.viewCol1KeyList_hidden.value  = viewedColSpreadKeyList[1];
		document.SpreadForm.viewCol2KeyList_hidden.value  = viewedColSpreadKeyList[2];
		document.SpreadForm.viewColIndexKey_hidden.value  = viewedColSpreadIndexKeyList;

		document.SpreadForm.viewRow0KeyList_hidden.value  = viewedRowSpreadKeyList[0];
		document.SpreadForm.viewRow1KeyList_hidden.value  = viewedRowSpreadKeyList[1];
		document.SpreadForm.viewRow2KeyList_hidden.value  = viewedRowSpreadKeyList[2];
		document.SpreadForm.viewRowIndexKey_hidden.value  = viewedRowSpreadIndexKeyList;

		// 3.デフォルトメンバ情報を更新
		var defaultMemberString = "";
		var axesInfoNodes = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/HierarchyInfo");
		var defaultMembers = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/HierarchyInfo/DefaultMemberKey");
		for ( var i = 0; i < defaultMembers.length; i++ ) {
			var defaultID = axesInfoNodes[i].selectSingleNode("DefaultMemberKey").text;	// デフォルトメンバID
			var axisID = axesInfoNodes[i].getAttributeNode("id").value;					// 軸ID

			if ( i > 0 ) {
				defaultMemberString += ",";
			}
			defaultMemberString += axisID + "." + defaultID;
		}

		document.SpreadForm.defaultMembers.value = defaultMemberString;

		// ＝＝＝＝＝ SpreadTableのデータを更新 ＝＝＝＝＝
		refreshTableData();
	}

	// 軸リスト表示ボックス内の軸メンバーのマウスオーバー
	// dimNo:軸Index(XMLではHierarchyInfoタグおよびMembersタグの並び順(1start)に対応)
	//		 メジャーが「16」固定とならないことに注意 
	// memNo:軸メンバのID(XMLではMemberタグの属性「ID」に対応)
	function dimListItemMouseover(event, dimNo, memNo, selectedMemNo) {
		var item, dimList, x, y;
		// マウスオーバーされたメンバの要素およびその親要素を取得
		item = getNodeBox(window.event.srcElement, "A", "dimListItem");
		dimList = getNodeBox(item, "DIV", "dimList");

		if (dimList.activeItem != null){
			closeSubDimList(dimList);
		}
		dimList.activeItem = item;

		// マウスオーバーされたメンバを色づけする
		item.className += " dimListItemHighlight";

		if(dimNo==null){
			window.event.cancelBubble = true;
			return;
		}

		// 軸の表示名称タイプを取得
		var axis = getAxisByDimNo(dimNo); // 軸情報をあらわすノード
		var dispMemberType = axis.selectSingleNode("DisplayMemberType").text;

		// subdimListが初期化されていなければ、初期化する
		if (item.subdimList == null && dimNo!=null) {

			var memberNode;
			var memberHTML="";
			var tempAhrefElement;
			var tempElement;
			memberNode=axesXMLData.selectSingleNode("/root/Axes/Members[" + dimNo + "]//Member[@id=" + memNo + "]");

			item.subdimList = document.createElement("<div id='toolsdimList' class='dimList' onmouseover='dimListMouseover(event)'>");
			if(memberNode.childNodes.length>=memberElementsNum){
				for(i=memberElementsNum;i<memberNode.childNodes.length;i++){
					if(memberNode.childNodes[i].childNodes.length>memberElementsNum){
						tempAhrefElement=document.createElement("<a class='dimListItem'  onclick=\"clickDimMember("+dimNo+","+memberNode.childNodes[i].attributes.getNamedItem("id").text+",'"+memberNode.childNodes[i].selectSingleNode(dispMemberType).text+"')\" onmouseover=\"dimListItemMouseover(event,"+dimNo+","+memberNode.childNodes[i].attributes.getNamedItem("id").text+","+selectedMemNo+");\">");

						tempElement=document.createElement("<span class='dimListItemText'>longName</span>");
						if ( memberNode.childNodes[i].attributes.getNamedItem("id").text == selectedMemNo ) {
							tempElement.innerHTML="<B>" + memberNode.childNodes[i].selectSingleNode(dispMemberType).text + "</B>";
						} else {
							tempElement.innerHTML=memberNode.childNodes[i].selectSingleNode(dispMemberType).text;
						}
						tempAhrefElement.appendChild(tempElement);

						tempElement=document.createElement("<span class='dimListItemArrow'>&#9654;</span>");
						tempElement.innerHTML="&#9654;";
						tempAhrefElement.appendChild(tempElement);

						item.subdimList.appendChild(tempAhrefElement);
					}else{
						tempAhrefElement=document.createElement("<a class='dimListItem'  onclick=\"clickDimMember("+dimNo+","+memberNode.childNodes[i].attributes.getNamedItem("id").text+",'"+memberNode.childNodes[i].selectSingleNode(dispMemberType).text+"')\" onmouseover=\"dimListItemMouseover(event,null,null,"+selectedMemNo+");\">");

						tempElement=document.createElement("<span class='dimListItemText'></span>");
						if ( memberNode.childNodes[i].attributes.getNamedItem("id").text == selectedMemNo ) {

							tempElement.innerHTML="<B>" + memberNode.childNodes[i].selectSingleNode(dispMemberType).text + "</B>";
						} else {
							tempElement.innerHTML=memberNode.childNodes[i].selectSingleNode(dispMemberType).text;
						}
						tempAhrefElement.appendChild(tempElement);
						item.subdimList.appendChild(tempAhrefElement);
					}
				}
				bodyNode.appendChild(item.subdimList);
			}

			if (item.subdimList.isInitialized == null){
				initializeDimList(item.subdimList);
			}
		}

		// subdimListの位置を求める
		x = getPositionX(item) + item.offsetWidth;
		y = getPositionY(item);

		// 子メンバ表示エリアの表示位置をdocumentエリアのサイズにより補正
		var maxX;
		var maxY;
		maxX = (document.documentElement.scrollLeft   != 0 ? document.documentElement.scrollLeft    : document.body.scrollLeft)
			+ (document.documentElement.clientWidth   != 0 ? document.documentElement.clientWidth   : document.body.clientWidth);
		maxY = (document.documentElement.scrollTop    != 0 ? document.documentElement.scrollTop    : document.body.scrollTop)
			+ (document.documentElement.clientHeight  != 0 ? document.documentElement.clientHeight : document.body.clientHeight);
		maxX -= item.subdimList.offsetWidth;
		maxY -= item.subdimList.offsetHeight;
		if (x > maxX){
		// 子メンバ表示エリアを折り返す
			x = Math.max(0, x - item.offsetWidth - item.subdimList.offsetWidth + (dimList.offsetWidth - item.offsetWidth));
		} else {
		// 子メンバ表示エリアをメンバ表示エリアの右側に表示
			// 子メンバ表示エリアのX座標を補正し、メンバリスト表示エリアの
			// スクロールバーより左側に表示
			x -= getScrollBarWidth(dimList);
		}
		y = Math.max(0, Math.min(y, maxY));

		// 選択されているメンバのY座標と子メンバ表示エリアのY座標をあわせる
		y -= dimList.scrollTop;

		// 表示
		item.subdimList.style.left = x + "px";
		item.subdimList.style.top  = y + "px";
		item.subdimList.style.visibility = "visible";


//alert(item.subdimList.outerHTML);
//alert(item.subdimList.offsetWidth + "," + item.subdimList.offsetHeight);
		item.subdimList.style.width = item.subdimList.offsetWidth;
		item.subdimList.style.height = item.subdimList.offsetHeight;
		item.subdimList.style.filter = "shadow(color=silver,direction=143)";
		// 後処理
		window.event.cancelBubble = true;
	}

	// *********************************************************
	//  イベント（その他）
	// *********************************************************

	// マウスダウンオブジェクト（スタイルのクリア）
	function sliceStatusClear() {

		// スタイルの初期化イベント（この関数を呼ぶイベント）を削除
		document.detachEvent( "onmouseup", sliceStatusClear );

		var el;
		if (activeSlicer == null){// アクティブなスライサーボタンが無い
			return;
		}

		el = window.event.srcElement;// アクティブなスライサーボタンがクリックされた
		if (el == activeSlicer){
			return;
		}

		if (getNodeBox(el, "DIV", "dimList") == null) { // スライサーボタン、メニュー以外がクリックされた
			if(activeSlicer != null) {
				resetSlicer(activeSlicer);
			}
			activeSlicer = null;

		}
	}

	// *********************************************************
	//  スタイル（スライサーボタン）
	// *********************************************************

	// スライサーボタンのスタイルを変更
	function changeSlicerStyle(button,position) {
		var x, y;

		if (position==null){
			position=0;
		}
		// スライサーボタンのスタイルを「押されている」状態に変更
		button.className += " dimListButtonActive";//CSSと関係

		// 選択された軸のメンバリストを表示
		x = getPositionX(button);
		y = getPositionY(button) + button.offsetHeight;
		x += button.offsetParent.clientLeft;
		y += button.offsetParent.clientTop;
		button.dimList.style.left = (x-position) + "px";
		button.dimList.style.top  = y + "px";
		button.dimList.style.visibility = "visible";
	}

	// スライサーボタンのスタイルをクリア
	function resetSlicer(button) {
		removeClassName(button, "dimListButtonActive");

		// 表示された次元/メジャーのメンバリストを非表示にする
		if (button.dimList != null) {
			closeSubDimList(button.dimList);
			button.dimList.style.visibility = "hidden";
		}
	}

	// *********************************************************
	//  スタイル（メンバーリスト表示ボックス）
	// *********************************************************
	// メンバーリスト表示ボックスのクローズ
	function closeSubDimList(dimList) {
		if (dimList == null || dimList.activeItem == null){
			return;
		}

		// メンバリストをクローズ（再帰）
		if (dimList.activeItem.subdimList != null) {
			closeSubDimList(dimList.activeItem.subdimList);
			dimList.activeItem.subdimList.style.visibility = "hidden";
			dimList.activeItem.subdimList = null;
		}
		removeClassName(dimList.activeItem, "dimListItemHighlight");
		dimList.activeItem = null;
	}

	// 軸メンバーリスト表示ボックスの初期化
	function initializeDimList(dimList) {
		var itemList, spanList;
		var textEl, arrowEl;
		var itemWidth;
		var w, dw;
		var i, j;

		dimList.style.lineHeight = "2.5ex";
		spanList = dimList.getElementsByTagName("SPAN");
		for (i = 0; i < spanList.length; i++){
			if (hasClassName(spanList[i], "dimListItemArrow")) {
				spanList[i].style.fontFamily = "Webdings";
				spanList[i].firstChild.nodeValue = "4";
			}
		}

		var scrollBarWidth = 0;

		if ( needScrollBarY(dimList) ) {
			// 高さを固定
			fixHeight(dimList);

			// 縦スクロールバーの幅を求める
			scrollBarWidth = getScrollBarWidth(dimList);
		}

		// dimListの幅を取得
		itemList = dimList.getElementsByTagName("A");
		if (itemList.length > 0) {
			itemWidth = itemList[0].offsetWidth + scrollBarWidth;
		}else{
			return;
		}

		// メンバが子メンバを持つ場合に表示される矢印を右端に表示されるように調整
		for (i = 0; i < itemList.length; i++) {
			spanList = itemList[i].getElementsByTagName("SPAN");
			textEl  = null;
			arrowEl = null;
			imageEl = null;

			for (j = 0; j < spanList.length; j++) {
				if (hasClassName(spanList[j], "dimListItemImage")){
					imageEl = spanList[j];
				}
				if (hasClassName(spanList[j], "dimListItemText")){
					textEl = spanList[j];
				}
				if (hasClassName(spanList[j], "dimListItemArrow")){
					arrowEl = spanList[j];
				}
			}
			if (textEl != null && arrowEl != null){
				if(imageEl!=null){//Image付きのメニューの場合
					textEl.style.paddingRight = (itemWidth - (textEl.offsetWidth + arrowEl.offsetWidth+imageEl.offsetWidth)) + "px";
				}else{
					textEl.style.paddingRight = (itemWidth - (textEl.offsetWidth + arrowEl.offsetWidth)) + "px";
				}
			}
		}

		// 表示を補正(IE)
		w = itemList[0].offsetWidth;
		itemList[0].style.width = w + scrollBarWidth + "px";

		// dimListが初期化された
		dimList.isInitialized = true;
	}


	// *********************************************************
	//  スタイル（大きさ、座標、スクロール）
	// *********************************************************

	// 縦スクロールバーの表示が必要か？
	//   高さが規定値(dimListMaxHeight)を超えた場合、true
	//   超えていない場合、false
	function needScrollBarY(dimList) {

		if ( dimList.offsetHeight > dimListMaxHeight ) {
			return true;
		} else {
			return false;
		}
	}

	// 縦スクロールバーを表示時するため、高さを固定する
	function fixHeight(dimList) {
		dimList.style.height = dimListMaxHeight;
	}

	// 縦スクロールバー表示時には、スクロールバー分だけ横幅を広げる
	function getScrollBarWidth(dimList) {
		var	scrollBarWidth = dimList.offsetWidth - dimList.clientWidth;
		return scrollBarWidth;
	}

	// X座標(表示領域からの相対座標)を返す
	// ※スタイル（座標）
	function getPositionX(el) {
		var positionX;
	//ページエッジ表示部の横スクロールに対応
	//	positionX = el.offsetLeft;
		positionX = el.offsetLeft - el.scrollLeft;
		if (el.offsetParent != null){
			positionX += getPositionX(el.offsetParent);
		}
		return positionX;
	}

	// Y座標(表示領域からの相対座標)を返す
	// ※スタイル（座標）
	function getPositionY(el) {
		var positionY;
		positionY = el.offsetTop;
		if (el.offsetParent != null){
			positionY += getPositionY(el.offsetParent);
		}
		return positionY;
	}

	// *********************************************************
	//  共通関数
	// *********************************************************

	// dimNoをもとに軸情報をあらわすノードを求める
	//	<Input> dimNo:軸Index(XMLではHierarchyInfoタグおよびMembersタグの並び順(1start)に対応)
	//		          メジャーが「16」固定とならないことに注意 
	function getAxisByDimNo(dimNo) {
		var axis = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/HierarchyInfo[" + dimNo + "]");
		return axis;
	}

	// nodeから遡って、入力されたtagName,classNameと等しい最初の要素を返す
	function getNodeBox(node, tagName, className) {
		
		var retNode = node;
		while (retNode != null) {
			if (retNode.tagName != null && retNode.tagName == tagName && hasClassName(retNode, className)){
				return retNode;
			}
			retNode = retNode.parentNode;
		}
		return retNode;
	}


	// 指定された要素が指定されたクラス名を持つか
	function hasClassName(el, classNameString) {
		var i, list;
		list = el.className.split(" ");
		for (i = 0; i < list.length; i++){
			if (list[i] == classNameString){
				return true;
			}
		}
		return false;
	}

	// 指定された要素の「class」属性から指定されたクラス名を削除
	function removeClassName(el, classNameString) {
		var i, curList, newList;
		if (el.className == null){
			return;
		}

		newList = new Array();
		curList = el.className.split(" ");
		for (i = 0; i < curList.length; i++){
			if (curList[i] != classNameString){
				newList.push(curList[i]);
			}
		}
		el.className = newList.join(" ");
	}


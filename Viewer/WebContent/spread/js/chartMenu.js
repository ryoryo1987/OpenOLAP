//************************************************************************************
// *****************************************************************************
//  Chart
// *****************************************************************************


var chartMemberElementsNum = 1;

// 表示スタイルで使用する画像情報
var menuIMG = new Array(3);
	menuIMG[0] = "table.gif";
	menuIMG[1] = "chart.gif";
	menuIMG[2] = "table_chart.gif";

// *********************************************************
//  変数宣言部
// *********************************************************
//	var dimListMaxHeight = 200;	// スライサーボタン押下で表示される次元メンバ表示領域の
								// 縦の高さの規定値。これを超えると縦スクロールバーを表示

//	var activeSlicer = null;	// 現在押下状態にあるスライサーボタン

	// チャートボタン押下不能時（＝表全画面表示の場合）のスタイル
	var chartButtonDisableFilterStyle = "gray();"


// *********************************************************
//  関数部
// *********************************************************

	var chartXML = new ActiveXObject("MSXML2.DOMDocument");
	chartXML.async = false;
//alert(location.href);
	var boolflg = chartXML.load("./spread/chart_kind.xml");//位置は？
//alert(boolflg);

	// *********************************************************
	//  イベント（チャートの種類ボタン）
	// *********************************************************

	//ツールバーのチャートの種類ボタンクリック
	function clickChartButton(event,memNo) {

		// グラフ非表示中は、ボタンを受けつけない
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		if (node.text == "0") { // グラフ非表示（表のみ表示）
			return;
		}

		var button;
		button = window.event.srcElement;

		clickButtonNode=button;//クリックしたボタンをいれておく。
		button.blur();//選択囲みをなくす。

		// 軸の表示名称タイプを取得
//		var axis = getAxisByDimNo(dimNo); // 軸情報をあらわすノード
//		var dispMemberType = axis.selectSingleNode("DisplayMemberType").text;

//		if (button.dimList == null) {

			var memberNode;
			var memberHTML="";
			var tempAhrefElement;
			var tempElement;
			var tempParentNode;
			var firstChildNodes;

//alert(chartXML.xml);

			memberNode=chartXML.selectSingleNode("//*[@id=" + memNo + "]");
			button.dimList = document.createElement("<div id='toolsdimList' class='dimList' onmouseover='dimListMouseover(event)'>");


			tempParentNode=memberNode;

			tempParentNode=memberNode.parentNode;
//alert(memberNode.tagName);
//alert(tempParentNode.tagName!=undefined);
			//自分より親のレベルを表示
//			while(tempParentNode.tagName!=undefined){
//
//				tempAhrefElement=document.createElement("<a class='dimListItem' style='padding-top:0;padding-left:2;padding-right:2' onclick=\"clickDimMember("+tempParentNode.attributes.getNamedItem("id").text+",'"+tempParentNode.selectSingleNode(dispMemberType).text+"')\" onmouseover=\"dimListItemMouseover(event,"+tempParentNode.attributes.getNamedItem("id").text+","+memNo+");\">");
//				tempElement=document.createElement("<span class='dimListItemText'>longName</span>");
//				tempElement.innerHTML=tempParentNode.selectSingleNode(dispMemberType).text;
//				tempAhrefElement.appendChild(tempElement);
//				tempElement=document.createElement("<span class='dimListItemArrow'></span>");
//				tempElement.innerHTML="&#9654;";
//				tempAhrefElement.appendChild(tempElement);
//
//				if(button.dimList.hasChildNodes()){
//					firstChildNodes=button.dimList.childNodes[0];
//					tempElement=document.createElement("<div class='dimListItemSep'></div>");
//					firstChildNodes.insertAdjacentElement('BeforeBegin',tempElement);
//					tempElement.insertAdjacentElement('BeforeBegin',tempAhrefElement);
//				}else{
//					button.dimList.appendChild(tempAhrefElement);
//
//					tempElement=document.createElement("<div class='dimListItemSep'></div>");
//					button.dimList.appendChild(tempElement);
//				}
//				if(tempParentNode.parentNode.tagName!="Members"){
//					tempParentNode=tempParentNode.parentNode;
//				}else{
//					break;
//				}
//
//			}

			//自分と同じレベルを表示（一番親の場合は、Membersタグに他の情報がないため、０から）
			if(memberNode.parentNode.tagName==undefined){
				i=0;
			}else{
				i=chartMemberElementsNum;
			}
//alert(i);
//alert(chartMemberElementsNum);
//			tempParentNode=memberNode.parentNode;
			tempParentNode=memberNode;
			for(;i<tempParentNode.childNodes.length;i++){
//alert(tempParentNode.xml);
//alert(tempParentNode.childNodes[i].childNodes.length);
//alert(chartMemberElementsNum);

				if(tempParentNode.childNodes[i].childNodes.length>chartMemberElementsNum){
					tempAhrefElement=document.createElement("<a class='dimListItem'  style='padding-top:0;padding-left:2;padding-right:2' onclick=\"clickChartKind("+tempParentNode.childNodes[i].attributes.getNamedItem("id").text+",'0')\" onmouseover=\"chartListItemMouseover(event,"+tempParentNode.childNodes[i].attributes.getNamedItem("id").text+","+memNo+");\">");


					//image
					tempElement=document.createElement("<span class='dimListItemImage'></span>");
					tempElement.innerHTML="<image src='"+tempParentNode.childNodes[i].attributes.getNamedItem('image').text+"' style='margin-left:5;margin-right:5'></image>";
					tempAhrefElement.appendChild(tempElement);

					tempElement=document.createElement("<span class='dimListItemText'></span>");
					if ( tempParentNode.childNodes[i].attributes.getNamedItem("id").text == memNo ) {
						tempElement.innerHTML="<B>" + tempParentNode.childNodes[i].firstChild.text + "</B>";
					} else {
						tempElement.innerHTML=tempParentNode.childNodes[i].firstChild.text;
					}

					tempAhrefElement.appendChild(tempElement);
					tempElement=document.createElement("<span class='dimListItemArrow'></span>");
					tempElement.innerHTML="&#9654;";
					tempAhrefElement.appendChild(tempElement);

					button.dimList.appendChild(tempAhrefElement);
				}else{
//alert(i);

//alert(tempParentNode.childNodes[i].xml);

//alert(tempParentNode.childNodes[i].attributes.getNamedItem("id").text);

					tempAhrefElement=document.createElement("<a class='dimListItem'  style='padding-top:0;padding-left:2;padding-right:2' onclick=\"clickChartKind("+tempParentNode.childNodes[i].attributes.getNamedItem("id").text+",'1')\" onmouseover=\"chartListItemMouseover(event,null,"+memNo+");\">");

					//image
					tempElement=document.createElement("<span class='dimListItemImage'></span>");
					tempElement.innerHTML="<image src='"+tempParentNode.childNodes[i].attributes.getNamedItem('image').text+"' style='margin-left:5;margin-right:5'></image>";
					tempAhrefElement.appendChild(tempElement);

					tempElement=document.createElement("<span class='dimListItemText'></span>");
					if ( tempParentNode.childNodes[i].attributes.getNamedItem("id").text == memNo ) {
						tempElement.innerHTML="<B>" + tempParentNode.childNodes[i].firstChild.text + "</B>";
					} else {
						tempElement.innerHTML=tempParentNode.childNodes[i].firstChild.text;
					}

					tempAhrefElement.appendChild(tempElement);

					button.dimList.appendChild(tempAhrefElement);
				}
			}
			bodyNode.appendChild(button.dimList);
			if (button.dimList.isInitialized == null){
				initializeDimList(button.dimList);
			}
//		}

		// 初期化
		if (activeSlicer != null){
			resetSlicer(activeSlicer);
		}

		// クリックされたスライサーボタンをアクティブに設定
		if (button != activeSlicer) {
			changeSlicerStyle(button,30);
			activeSlicer = button;
		}else{
			activeSlicer = null;
		}

		// スタイルの初期化イベントを追加
		document.attachEvent( "onmouseup", sliceStatusClear );

		return false;
	}


	function chartListItemMouseover(event, memNo, selectedMemNo) {
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

//		if(dimNo==null){
//			window.event.cancelBubble = true;
//			return;
//		}

		// 軸の表示名称タイプを取得
//		var axis = getAxisByDimNo(dimNo); // 軸情報をあらわすノード
//		var dispMemberType = axis.selectSingleNode("DisplayMemberType").text;

//		// subdimListが初期化されていなければ、初期化する
		if (item.subdimList == null) {

			var memberNode;
			var memberHTML="";
			var tempAhrefElement;
			var tempElement;
			memberNode=chartXML.selectSingleNode("//*[@id=" + memNo + "]");

			item.subdimList = document.createElement("<div id='toolsdimList' class='dimList' onmouseover='dimListMouseover(event)'>");
			if(memberNode!=null){
				for(i=chartMemberElementsNum;i<memberNode.childNodes.length;i++){
					if(memberNode.childNodes[i].childNodes.length>chartMemberElementsNum){
						tempAhrefElement=document.createElement("<a class='dimListItem'  style='padding-top:0;padding-left:2;padding-right:2' onclick=\"clickChartKind("+memberNode.childNodes[i].attributes.getNamedItem("id").text+",'"+memberNode.childNodes[i].firstChild.text+"')\" onmouseover=\"chartListItemMouseover(event,"+memberNode.childNodes[i].attributes.getNamedItem("id").text+","+selectedMemNo+");\">");

						//image
						tempElement=document.createElement("<span class='dimListItemImage'></span>");
						tempElement.innerHTML="<image src='"+memberNode.childNodes[i].attributes.getNamedItem('image').text+"' style='margin-left:5;margin-right:5'></image>";
						tempAhrefElement.appendChild(tempElement);

						tempElement=document.createElement("<span class='dimListItemText'>longName</span>");
						if ( memberNode.childNodes[i].attributes.getNamedItem("id").text == selectedMemNo ) {
							tempElement.innerHTML="<B>" + memberNode.childNodes[i].firstChild.text + "</B>";
						} else {
							tempElement.innerHTML=memberNode.childNodes[i].firstChild.text;
						}
						tempAhrefElement.appendChild(tempElement);

						tempElement=document.createElement("<span class='dimListItemArrow'></span>");
						tempElement.innerHTML="&#9654;";
						tempAhrefElement.appendChild(tempElement);

						item.subdimList.appendChild(tempAhrefElement);
					}else{
						tempAhrefElement=document.createElement("<a class='dimListItem'  style='padding-top:0;padding-left:2;padding-right:2' onclick=\"clickChartKind("+memberNode.childNodes[i].attributes.getNamedItem("id").text+",'"+memberNode.childNodes[i].firstChild.text+"')\" onmouseover=\"chartListItemMouseover(event,null,null,"+selectedMemNo+");\">");

						//image
						tempElement=document.createElement("<span class='dimListItemImage'></span>");
						tempElement.innerHTML="<image src='"+memberNode.childNodes[i].attributes.getNamedItem('image').text+"' style='margin-left:5;margin-right:5'></image>";
						tempAhrefElement.appendChild(tempElement);

						tempElement=document.createElement("<span class='dimListItemText'></span>");
						if ( memberNode.childNodes[i].attributes.getNamedItem("id").text == selectedMemNo ) {

							tempElement.innerHTML="<B>" + memberNode.childNodes[i].firstChild.text + "</B>";
						} else {
							tempElement.innerHTML=memberNode.childNodes[i].firstChild.text;
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

		// 後処理
		window.event.cancelBubble = true;
	}


	//チャートの種類ボタンがクリックされた
	//	memNo:チャートのID（chart_kind.xmlの各チャートノードのid属性）
	//	memberName:チャートの名称
	function clickChartKind(memNo,memberName){
	
		// レポートXML内のカレントチャートIDを更新
		var currentChartIDNode = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/currentChartID");
		currentChartIDNode.text = memNo;

		// グラフ更新
		reloadChart();

		// スタイルを初期化
		if(activeSlicer != null) {
			resetSlicer(activeSlicer);
		}
		activeSlicer = null;

//alert(clickNode.xml);
	}


	// チャートの設定を行なう
	function changeChartKindButton(memNo) {
//alert(memNo);
		// スタイル設定	
		var clickNode = null;
		if (memNo == "NA") {
			clickNode = chartXML.selectSingleNode("//*[@default='true']");
		} else {
			clickNode = chartXML.selectSingleNode("//*[@id=" + memNo + "]");
		}

		var strHTML="";
			strHTML += "<img src='" + clickNode.attributes.getNamedItem('image').text + "' class='normal_toolicon'  onMouseOver='tbMouseOver(this);' onMouseDown='tbMouseDown(this);' onMouseUp='tbMouseUp(this);' onMouseOut='tbMouseOut(this);' />"
//			strHTML += "<div class='dimListButtonActive' style='padding-right:0px;display:inline;padding-left:0px";
//			strHTML += ";background-image:url("+clickNode.attributes.getNamedItem('image').text+")";
//			strHTML += ";padding-bottom:0px;margin:0px;width:20px;padding-top:0px;background-repeat:no-repeat;white-space:nowrap;height:20px'>";
		var tempNode=document.createElement(strHTML);

		var chartKindArea = document.all("chartKindArea");
		var currentChartKind = chartKindArea.firstChild;
		chartKindArea.insertBefore(tempNode,currentChartKind);
		chartKindArea.removeChild(currentChartKind);

	}



	// 表示スタイルのメニューが選択された
	function clickDisplayStyleMenu(menuID) {
		// 画面の分割状況を表すXMLノードの値を変更
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		node.text = menuID;

		// ツールバーのチャートタイプ選択ボタンを含むTABLE上にマウスポインタがある時のカーソルイメージを設定する
		setChartBtnCursorStyle();

		// ツールバー上の画面分割スタイルタイプメニューのイメージを変更する
		// 初期化
		if (activeSlicer != null){
			resetSlicer(activeSlicer);
		}

		// クリックされたスライサーボタンをアクティブに設定
//		if (button != activeSlicer) {
//			changeSlicerStyle(button,40);
//			activeSlicer = button;
//		}else{
//			activeSlicer = null;
//		}

		// スタイルの初期化イベントを追加
		document.attachEvent( "onmouseup", sliceStatusClear );

		// 選択されたスタイル別の設定・処理
		if (menuID == "0") { // 0:全画面表示（表）

			// 表部分を表示状態にする
			document.all("SpreadTable").style.display = "block";

			// グラフ表示用iFrame領域を非表示状態にする
			document.all("chartAreaDIV").style.display = "none";

			// チャート表示用フレームの高さを変更し、非表示状態にする(rowsのsize:0)
			dispChartSubArea(0);

			// チャートボタンのスタイルを設定
			document.all("chartKindArea").style.filter = chartButtonDisableFilterStyle;

			// 画面表示スタイルの変更をサーバに通知
			reloadChart();
			
		} else if (menuID == "1") { // 1:全画面表示（グラフ）

			// 表部分を非表示状態にする
			document.all("SpreadTable").style.display = "none";

			// チャート表示用フレームの高さを変更し、非表示状態にする(rowsのsize:0)
			dispChartSubArea(0);

			// チャートボタンのスタイルを設定
			document.all("chartKindArea").style.filter = "";

			// グラフ更新
			reloadChart();

			// グラフ表示用iFrame領域を表示状態にする
			document.all("chartAreaDIV").style.display = "block";

		} else if(menuID == "2") { // 2:縦分割（表、グラフ) ⇒ グラフ更新・表示

			// 表部分を表示状態にする
			document.all("SpreadTable").style.display = "block";

			// グラフ表示用iFrame領域を非表示状態にする
			document.all("chartAreaDIV").style.display = "none";

			// チャートボタンのスタイルを設定
			document.all("chartKindArea").style.filter = "";

			// グラフ更新
			reloadChart();

			// チャート表示用フレームの高さを変更し、表示状態にする
			dispChartSubArea(chartSubAreaInitialHeight);

		}

		//画像を変える。
		var img = document.getElementById("tabWindowDivisionBtn_Img");
		img.src='./images/chart/'+menuIMG[menuID];

//	alert(img.outerHTML);
//	alert(menu.fileName);

		if( activeSlicer != null ) {
			resetSlicer(activeSlicer);
		}
		activeSlicer = null;

	}

	// ツールバーの「画面表示」ボタン(全画面表示(表)、全画面表示(チャート)、分割画面の切り替え)が押下された
	function clickDisplayStyle(event){

		var button;
		button = window.event.srcElement;

		clickButtonNode=button;//クリックしたボタンをいれておく。
		button.blur();//選択囲みをなくす。

		button.dimList = document.createElement("<div id='toolsdimList' class='dimList' onmouseover='dimListMouseover(event)'>");

		// 軸の表示名称タイプを取得
		var memberNode;
		var memberHTML="";
		var tempAhrefElement;
		var tempElement;
		var tempParentNode;
		var firstChildNodes;

		//一つめ
		tempAhrefElement=document.createElement("<a class='dimListItem' style='padding-top:0;padding-left:2;padding-right:2' styleId='0' onclick=\"clickDisplayStyleMenu(this.styleId)\" onmouseover=\"chartListItemMouseover(event,null,null,0);\">");

		//image
		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="<image src='./images/chart/"+menuIMG[0]+"' style='margin-left:5;margin-right:5'></image>";
		tempAhrefElement.appendChild(tempElement);

		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="表";

		tempAhrefElement.appendChild(tempElement);

		button.dimList.appendChild(tempAhrefElement);

		//２つめ
		tempAhrefElement=document.createElement("<a class='dimListItem' style='padding-top:0;padding-left:2;padding-right:2' styleId='1' onclick=\"clickDisplayStyleMenu(this.styleId)\" onmouseover=\"chartListItemMouseover(event,null,null,0);\">");

		//image
		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="<image src='./images/chart/"+menuIMG[1]+"' style='margin-left:5;margin-right:5'></image>";
		tempAhrefElement.appendChild(tempElement);

		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="グラフ";

		tempAhrefElement.appendChild(tempElement);

		button.dimList.appendChild(tempAhrefElement);

		//３つめ
		tempAhrefElement=document.createElement("<a class='dimListItem' style='padding-top:0;padding-left:2;padding-right:2' styleId='2' onclick=\"clickDisplayStyleMenu(this.styleId)\" onmouseover=\"chartListItemMouseover(event,null,null,0);\">");

		//image
		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="<image src='./images/chart/"+menuIMG[2]+"' style='margin-left:5;margin-right:5'></image>";
		tempAhrefElement.appendChild(tempElement);

		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="表・グラフ";

		tempAhrefElement.appendChild(tempElement);

		button.dimList.appendChild(tempAhrefElement);



		bodyNode.appendChild(button.dimList);
		if (button.dimList.isInitialized == null){
			initializeDimList(button.dimList);
		}


		// 初期化
		if (activeSlicer != null){
			resetSlicer(activeSlicer);
		}

		// クリックされたスライサーボタンをアクティブに設定
		if (button != activeSlicer) {
			changeSlicerStyle(button,40);
			activeSlicer = button;
		}else{
			activeSlicer = null;
		}

		// スタイルの初期化イベントを追加
		document.attachEvent( "onmouseup", sliceStatusClear );

		return false;

	}

//************************************************************************************
// *****************************************************************************
//  Chart
// *****************************************************************************


var chartMemberElementsNum = 1;

// �\���X�^�C���Ŏg�p����摜���
var menuIMG = new Array(3);
	menuIMG[0] = "table.gif";
	menuIMG[1] = "chart.gif";
	menuIMG[2] = "table_chart.gif";

// *********************************************************
//  �ϐ��錾��
// *********************************************************
//	var dimListMaxHeight = 200;	// �X���C�T�[�{�^�������ŕ\������鎟�������o�\���̈��
								// �c�̍����̋K��l�B����𒴂���Əc�X�N���[���o�[��\��

//	var activeSlicer = null;	// ���݉�����Ԃɂ���X���C�T�[�{�^��

	// �`���[�g�{�^�������s�\���i���\�S��ʕ\���̏ꍇ�j�̃X�^�C��
	var chartButtonDisableFilterStyle = "gray();"


// *********************************************************
//  �֐���
// *********************************************************

	var chartXML = new ActiveXObject("MSXML2.DOMDocument");
	chartXML.async = false;
//alert(location.href);
	var boolflg = chartXML.load("./spread/chart_kind.xml");//�ʒu�́H
//alert(boolflg);

	// *********************************************************
	//  �C�x���g�i�`���[�g�̎�ރ{�^���j
	// *********************************************************

	//�c�[���o�[�̃`���[�g�̎�ރ{�^���N���b�N
	function clickChartButton(event,memNo) {

		// �O���t��\�����́A�{�^�����󂯂��Ȃ�
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		if (node.text == "0") { // �O���t��\���i�\�̂ݕ\���j
			return;
		}

		var button;
		button = window.event.srcElement;

		clickButtonNode=button;//�N���b�N�����{�^��������Ă����B
		button.blur();//�I���݂͂��Ȃ����B

		// ���̕\�����̃^�C�v���擾
//		var axis = getAxisByDimNo(dimNo); // ����������킷�m�[�h
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
			//�������e�̃��x����\��
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

			//�����Ɠ������x����\���i��Ԑe�̏ꍇ�́AMembers�^�O�ɑ��̏�񂪂Ȃ����߁A�O����j
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

		// ������
		if (activeSlicer != null){
			resetSlicer(activeSlicer);
		}

		// �N���b�N���ꂽ�X���C�T�[�{�^�����A�N�e�B�u�ɐݒ�
		if (button != activeSlicer) {
			changeSlicerStyle(button,30);
			activeSlicer = button;
		}else{
			activeSlicer = null;
		}

		// �X�^�C���̏������C�x���g��ǉ�
		document.attachEvent( "onmouseup", sliceStatusClear );

		return false;
	}


	function chartListItemMouseover(event, memNo, selectedMemNo) {
		var item, dimList, x, y;
		// �}�E�X�I�[�o�[���ꂽ�����o�̗v�f����т��̐e�v�f���擾
		item = getNodeBox(window.event.srcElement, "A", "dimListItem");
		dimList = getNodeBox(item, "DIV", "dimList");

		if (dimList.activeItem != null){
			closeSubDimList(dimList);
		}
		dimList.activeItem = item;

		// �}�E�X�I�[�o�[���ꂽ�����o��F�Â�����
		item.className += " dimListItemHighlight";

//		if(dimNo==null){
//			window.event.cancelBubble = true;
//			return;
//		}

		// ���̕\�����̃^�C�v���擾
//		var axis = getAxisByDimNo(dimNo); // ����������킷�m�[�h
//		var dispMemberType = axis.selectSingleNode("DisplayMemberType").text;

//		// subdimList������������Ă��Ȃ���΁A����������
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

		// subdimList�̈ʒu�����߂�
		x = getPositionX(item) + item.offsetWidth;
		y = getPositionY(item);

		// �q�����o�\���G���A�̕\���ʒu��document�G���A�̃T�C�Y�ɂ��␳
		var maxX;
		var maxY;
		maxX = (document.documentElement.scrollLeft   != 0 ? document.documentElement.scrollLeft    : document.body.scrollLeft)
			+ (document.documentElement.clientWidth   != 0 ? document.documentElement.clientWidth   : document.body.clientWidth);
		maxY = (document.documentElement.scrollTop    != 0 ? document.documentElement.scrollTop    : document.body.scrollTop)
			+ (document.documentElement.clientHeight  != 0 ? document.documentElement.clientHeight : document.body.clientHeight);
		maxX -= item.subdimList.offsetWidth;
		maxY -= item.subdimList.offsetHeight;
		if (x > maxX){
		// �q�����o�\���G���A��܂�Ԃ�
			x = Math.max(0, x - item.offsetWidth - item.subdimList.offsetWidth + (dimList.offsetWidth - item.offsetWidth));
		} else {
		// �q�����o�\���G���A�������o�\���G���A�̉E���ɕ\��
			// �q�����o�\���G���A��X���W��␳���A�����o���X�g�\���G���A��
			// �X�N���[���o�[��荶���ɕ\��
			x -= getScrollBarWidth(dimList);
		}
		y = Math.max(0, Math.min(y, maxY));

		// �I������Ă��郁���o��Y���W�Ǝq�����o�\���G���A��Y���W�����킹��
		y -= dimList.scrollTop;

		// �\��
		item.subdimList.style.left = x + "px";
		item.subdimList.style.top  = y + "px";
		item.subdimList.style.visibility = "visible";

		// �㏈��
		window.event.cancelBubble = true;
	}


	//�`���[�g�̎�ރ{�^�����N���b�N���ꂽ
	//	memNo:�`���[�g��ID�ichart_kind.xml�̊e�`���[�g�m�[�h��id�����j
	//	memberName:�`���[�g�̖���
	function clickChartKind(memNo,memberName){
	
		// ���|�[�gXML���̃J�����g�`���[�gID���X�V
		var currentChartIDNode = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/currentChartID");
		currentChartIDNode.text = memNo;

		// �O���t�X�V
		reloadChart();

		// �X�^�C����������
		if(activeSlicer != null) {
			resetSlicer(activeSlicer);
		}
		activeSlicer = null;

//alert(clickNode.xml);
	}


	// �`���[�g�̐ݒ���s�Ȃ�
	function changeChartKindButton(memNo) {
//alert(memNo);
		// �X�^�C���ݒ�	
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



	// �\���X�^�C���̃��j���[���I�����ꂽ
	function clickDisplayStyleMenu(menuID) {
		// ��ʂ̕����󋵂�\��XML�m�[�h�̒l��ύX
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		node.text = menuID;

		// �c�[���o�[�̃`���[�g�^�C�v�I���{�^�����܂�TABLE��Ƀ}�E�X�|�C���^�����鎞�̃J�[�\���C���[�W��ݒ肷��
		setChartBtnCursorStyle();

		// �c�[���o�[��̉�ʕ����X�^�C���^�C�v���j���[�̃C���[�W��ύX����
		// ������
		if (activeSlicer != null){
			resetSlicer(activeSlicer);
		}

		// �N���b�N���ꂽ�X���C�T�[�{�^�����A�N�e�B�u�ɐݒ�
//		if (button != activeSlicer) {
//			changeSlicerStyle(button,40);
//			activeSlicer = button;
//		}else{
//			activeSlicer = null;
//		}

		// �X�^�C���̏������C�x���g��ǉ�
		document.attachEvent( "onmouseup", sliceStatusClear );

		// �I�����ꂽ�X�^�C���ʂ̐ݒ�E����
		if (menuID == "0") { // 0:�S��ʕ\���i�\�j

			// �\������\����Ԃɂ���
			document.all("SpreadTable").style.display = "block";

			// �O���t�\���piFrame�̈���\����Ԃɂ���
			document.all("chartAreaDIV").style.display = "none";

			// �`���[�g�\���p�t���[���̍�����ύX���A��\����Ԃɂ���(rows��size:0)
			dispChartSubArea(0);

			// �`���[�g�{�^���̃X�^�C����ݒ�
			document.all("chartKindArea").style.filter = chartButtonDisableFilterStyle;

			// ��ʕ\���X�^�C���̕ύX���T�[�o�ɒʒm
			reloadChart();
			
		} else if (menuID == "1") { // 1:�S��ʕ\���i�O���t�j

			// �\�������\����Ԃɂ���
			document.all("SpreadTable").style.display = "none";

			// �`���[�g�\���p�t���[���̍�����ύX���A��\����Ԃɂ���(rows��size:0)
			dispChartSubArea(0);

			// �`���[�g�{�^���̃X�^�C����ݒ�
			document.all("chartKindArea").style.filter = "";

			// �O���t�X�V
			reloadChart();

			// �O���t�\���piFrame�̈��\����Ԃɂ���
			document.all("chartAreaDIV").style.display = "block";

		} else if(menuID == "2") { // 2:�c�����i�\�A�O���t) �� �O���t�X�V�E�\��

			// �\������\����Ԃɂ���
			document.all("SpreadTable").style.display = "block";

			// �O���t�\���piFrame�̈���\����Ԃɂ���
			document.all("chartAreaDIV").style.display = "none";

			// �`���[�g�{�^���̃X�^�C����ݒ�
			document.all("chartKindArea").style.filter = "";

			// �O���t�X�V
			reloadChart();

			// �`���[�g�\���p�t���[���̍�����ύX���A�\����Ԃɂ���
			dispChartSubArea(chartSubAreaInitialHeight);

		}

		//�摜��ς���B
		var img = document.getElementById("tabWindowDivisionBtn_Img");
		img.src='./images/chart/'+menuIMG[menuID];

//	alert(img.outerHTML);
//	alert(menu.fileName);

		if( activeSlicer != null ) {
			resetSlicer(activeSlicer);
		}
		activeSlicer = null;

	}

	// �c�[���o�[�́u��ʕ\���v�{�^��(�S��ʕ\��(�\)�A�S��ʕ\��(�`���[�g)�A������ʂ̐؂�ւ�)���������ꂽ
	function clickDisplayStyle(event){

		var button;
		button = window.event.srcElement;

		clickButtonNode=button;//�N���b�N�����{�^��������Ă����B
		button.blur();//�I���݂͂��Ȃ����B

		button.dimList = document.createElement("<div id='toolsdimList' class='dimList' onmouseover='dimListMouseover(event)'>");

		// ���̕\�����̃^�C�v���擾
		var memberNode;
		var memberHTML="";
		var tempAhrefElement;
		var tempElement;
		var tempParentNode;
		var firstChildNodes;

		//���
		tempAhrefElement=document.createElement("<a class='dimListItem' style='padding-top:0;padding-left:2;padding-right:2' styleId='0' onclick=\"clickDisplayStyleMenu(this.styleId)\" onmouseover=\"chartListItemMouseover(event,null,null,0);\">");

		//image
		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="<image src='./images/chart/"+menuIMG[0]+"' style='margin-left:5;margin-right:5'></image>";
		tempAhrefElement.appendChild(tempElement);

		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="�\";

		tempAhrefElement.appendChild(tempElement);

		button.dimList.appendChild(tempAhrefElement);

		//�Q��
		tempAhrefElement=document.createElement("<a class='dimListItem' style='padding-top:0;padding-left:2;padding-right:2' styleId='1' onclick=\"clickDisplayStyleMenu(this.styleId)\" onmouseover=\"chartListItemMouseover(event,null,null,0);\">");

		//image
		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="<image src='./images/chart/"+menuIMG[1]+"' style='margin-left:5;margin-right:5'></image>";
		tempAhrefElement.appendChild(tempElement);

		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="�O���t";

		tempAhrefElement.appendChild(tempElement);

		button.dimList.appendChild(tempAhrefElement);

		//�R��
		tempAhrefElement=document.createElement("<a class='dimListItem' style='padding-top:0;padding-left:2;padding-right:2' styleId='2' onclick=\"clickDisplayStyleMenu(this.styleId)\" onmouseover=\"chartListItemMouseover(event,null,null,0);\">");

		//image
		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="<image src='./images/chart/"+menuIMG[2]+"' style='margin-left:5;margin-right:5'></image>";
		tempAhrefElement.appendChild(tempElement);

		tempElement=document.createElement("<span class='dimListItemText'></span>");
		tempElement.innerHTML="�\�E�O���t";

		tempAhrefElement.appendChild(tempElement);

		button.dimList.appendChild(tempAhrefElement);



		bodyNode.appendChild(button.dimList);
		if (button.dimList.isInitialized == null){
			initializeDimList(button.dimList);
		}


		// ������
		if (activeSlicer != null){
			resetSlicer(activeSlicer);
		}

		// �N���b�N���ꂽ�X���C�T�[�{�^�����A�N�e�B�u�ɐݒ�
		if (button != activeSlicer) {
			changeSlicerStyle(button,40);
			activeSlicer = button;
		}else{
			activeSlicer = null;
		}

		// �X�^�C���̏������C�x���g��ǉ�
		document.attachEvent( "onmouseup", sliceStatusClear );

		return false;

	}

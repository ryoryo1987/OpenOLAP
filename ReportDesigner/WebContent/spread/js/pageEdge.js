// *****************************************************************************
//  ���j���[�\���A�X���C�X ����
// *****************************************************************************

// *********************************************************
//  �ϐ��錾��
// *********************************************************
	var dimListMaxHeight = 200;	// �X���C�T�[�{�^�������ŕ\������鎟�������o�\���̈��
								// �c�̍����̋K��l�B����𒴂���Əc�X�N���[���o�[��\��

	var activeSlicer = null;	// ���݉�����Ԃɂ���X���C�T�[�{�^��

// *********************************************************
//  �֐���
// *********************************************************

	// *********************************************************
	//  Spread�����\��
	// *********************************************************

	// �X���C�T�[�{�^���\��
	function showSlicerButton() {
		bodyNode=document.getElementById("SpreadBody");
		var pageTable=document.getElementById("pageEdgeTable");
		pageTable=pageTable.rows[0].cells;

		dimList=axesXMLData.getElementsByTagName("Members");

		// �����A�y�[�W�G�b�W�Ɏ����������ꍇ�́A�}���G���A��\�����Areturn
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

					// ����������킷�m�[�h
					axis = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/HierarchyInfo[@id=\"" + dimList[i].attributes.getNamedItem("id").text + "\"]");

					// �f�t�H���g�����o��Key(=UName)�����߂�
					selectedMemberID = axis.selectSingleNode("DefaultMemberKey").text;
					if ( selectedMemberID == "NA" ) {
						selectedMemberID = axesXMLData.selectSingleNode("/root/Axes/Members[@id=\"" + dimList[i].attributes.getNamedItem("id").text + "\"]//Member[1]/UName").text;
					}

					// �f�t�H���g�����o��ID�����߂�
					selectedMemberIndex = axesXMLData.selectSingleNode("/root/Axes/Members[@id=\"" + dimList[i].attributes.getNamedItem("id").text + "\"]//Member[UName=\"" + selectedMemberID + "\"]").getAttribute("id");

					// ���ɑ΂��Đݒ肳��Ă��郁���o���\���^�C�v
					var dispMemberType = axis.selectSingleNode("DisplayMemberType").text;

					buttonHTML=buttonHTML+"<div style='display:inline;'>";
					buttonHTML=buttonHTML+"<NOBR>";

					var styleStr = ""; // ���W���[�̏ꍇ�́A�C���[�W��ύX
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

					// �X�^�C���ύX�̂��߁A�R�����g���i20041125�j
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

		// �y�[�W�G�b�W�̓��I���������B�y�[�W�G�b�W�s��\������B
		document.getElementById("pageEdgeTable").rows[0].style.visibility='visible';

		return;
	}

	// *********************************************************
	//  �C�x���g�i�X���C�T�[�{�^���j
	// *********************************************************

	//�X���C�T�[�{�^���N���b�N
	//	dimNo:��Index(XML�ł�HierarchyInfo�^�O�����Members�^�O�̕��я�(1start)�ɑΉ�)
	//		 ���W���[���u16�v�Œ�ƂȂ�Ȃ����Ƃɒ��� 
	//	memNo:�������o��ID(XML�ł�Member�^�O�̑����uID�v�ɑΉ�)
	function clickSlicerButton(event, dimNo,memNo) {

		var button;
		button = window.event.srcElement;

		clickButtonNode=button;//�N���b�N�����{�^��������Ă����B
		button.blur();//�I���݂͂��Ȃ����B

		// ���̕\�����̃^�C�v���擾
		var axis = getAxisByDimNo(dimNo); // ����������킷�m�[�h
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
			//�������e�̃��x����\��
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

			//�����Ɠ������x����\���i��Ԑe�̏ꍇ�́AMembers�^�O�ɑ��̏�񂪂Ȃ����߁A�O����j
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
			//����΁A�����̎q����\��
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

		// ������
		if (activeSlicer != null){
			resetSlicer(activeSlicer);
		}

		// �N���b�N���ꂽ�X���C�T�[�{�^�����A�N�e�B�u�ɐݒ�
		if (button != activeSlicer) {
			changeSlicerStyle(button);
			activeSlicer = button;
		}else{
			activeSlicer = null;
		}

		// �X�^�C���̏������C�x���g��ǉ�
		document.attachEvent( "onmouseup", sliceStatusClear );

		return false;
	}


	//�X���C�T�[�{�^���̃}�E�XOver
	function slicerMouseover(event, dimNo,memNo) {
		var button;
		button = window.event.srcElement;

		// �X���C�T�[���A�N�e�B�u�ɐݒ�
		if (activeSlicer != null && activeSlicer != button){
			clickSlicerButton(event,dimNo,memNo);
		}
	}

	// *********************************************************
	//  �C�x���g�i�������o�[���X�g�\���{�b�N�X�j
	// *********************************************************

	// �X���C�T�[�ɂ��\�����ꂽ�����X�g�\���{�b�N�X�̃}�E�X�I�[�o�[
	function dimListMouseover(event) {
		var dimList;
		dimList = getNodeBox(window.event.srcElement, "DIV", "dimList");

		// �\�����ꂽ����/���W���[�̃����o���X�g���\���ɂ���
		if (dimList.activeItem != null){
		    closeSubDimList(dimList);
		}
	}

	// *********************************************************
	//  �C�x���g�i�������o�[���X�g�\���{�b�N�X�A�������o�[�j
	// *********************************************************

	// �������o�[���N���b�N���ꂽ
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

		// ***** �y�[�W�G�b�W�I���󋵂��X�V **************************************
		// 1.�����f�[�^XML�̃f�t�H���g�����o�����X�V
		//   (/root/OlapInfo/AxesInfo/HierarchyInfo/DefaultMemberKey)
		// 2.�y�[�W�G�b�W��ID�A�����oKey�̑g�ݍ��킹���X�g���(HTML��hidden)���X�V
		// 3.�f�t�H���g�����o�����X�V
		// ***********************************************************************

		// 1.�����f�[�^XML�̃f�t�H���g�����o�����X�V
		var selectedMemberID = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/HierarchyInfo[" + dimNo + "]" + "/DefaultMemberKey");

		// �I�����ꂽ�����o�̃C���f�b�N�X��Key(=UName)�ɕϊ�
		var memUName = axesXMLData.selectSingleNode("/root/Axes/Members[" + dimNo + "]//Member[@id=\"" + memNo + "\"]/UName").text;

		// �I�����ꂽ�����o��Key(=UName)�Ńf�t�H���g�����o�����X�V
		selectedMemberID.text = memUName;

		// 2.�y�[�W�G�b�W��ID�A�����oKey�̑g�ݍ��킹���X�g���(HTML��hidden)���X�V
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

		// 3.�f�t�H���g�����o�����X�V
		var defaultMemberString = "";
		var axesInfoNodes = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/HierarchyInfo");
		var defaultMembers = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/HierarchyInfo/DefaultMemberKey");
		for ( var i = 0; i < defaultMembers.length; i++ ) {
			var defaultID = axesInfoNodes[i].selectSingleNode("DefaultMemberKey").text;	// �f�t�H���g�����oID
			var axisID = axesInfoNodes[i].getAttributeNode("id").value;					// ��ID

			if ( i > 0 ) {
				defaultMemberString += ",";
			}
			defaultMemberString += axisID + "." + defaultID;
		}

		document.SpreadForm.defaultMembers.value = defaultMemberString;

		// ���������� SpreadTable�̃f�[�^���X�V ����������
		refreshTableData();
	}

	// �����X�g�\���{�b�N�X���̎������o�[�̃}�E�X�I�[�o�[
	// dimNo:��Index(XML�ł�HierarchyInfo�^�O�����Members�^�O�̕��я�(1start)�ɑΉ�)
	//		 ���W���[���u16�v�Œ�ƂȂ�Ȃ����Ƃɒ��� 
	// memNo:�������o��ID(XML�ł�Member�^�O�̑����uID�v�ɑΉ�)
	function dimListItemMouseover(event, dimNo, memNo, selectedMemNo) {
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

		if(dimNo==null){
			window.event.cancelBubble = true;
			return;
		}

		// ���̕\�����̃^�C�v���擾
		var axis = getAxisByDimNo(dimNo); // ����������킷�m�[�h
		var dispMemberType = axis.selectSingleNode("DisplayMemberType").text;

		// subdimList������������Ă��Ȃ���΁A����������
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


//alert(item.subdimList.outerHTML);
//alert(item.subdimList.offsetWidth + "," + item.subdimList.offsetHeight);
		item.subdimList.style.width = item.subdimList.offsetWidth;
		item.subdimList.style.height = item.subdimList.offsetHeight;
		item.subdimList.style.filter = "shadow(color=silver,direction=143)";
		// �㏈��
		window.event.cancelBubble = true;
	}

	// *********************************************************
	//  �C�x���g�i���̑��j
	// *********************************************************

	// �}�E�X�_�E���I�u�W�F�N�g�i�X�^�C���̃N���A�j
	function sliceStatusClear() {

		// �X�^�C���̏������C�x���g�i���̊֐����ĂԃC�x���g�j���폜
		document.detachEvent( "onmouseup", sliceStatusClear );

		var el;
		if (activeSlicer == null){// �A�N�e�B�u�ȃX���C�T�[�{�^��������
			return;
		}

		el = window.event.srcElement;// �A�N�e�B�u�ȃX���C�T�[�{�^�����N���b�N���ꂽ
		if (el == activeSlicer){
			return;
		}

		if (getNodeBox(el, "DIV", "dimList") == null) { // �X���C�T�[�{�^���A���j���[�ȊO���N���b�N���ꂽ
			if(activeSlicer != null) {
				resetSlicer(activeSlicer);
			}
			activeSlicer = null;

		}
	}

	// *********************************************************
	//  �X�^�C���i�X���C�T�[�{�^���j
	// *********************************************************

	// �X���C�T�[�{�^���̃X�^�C����ύX
	function changeSlicerStyle(button,position) {
		var x, y;

		if (position==null){
			position=0;
		}
		// �X���C�T�[�{�^���̃X�^�C�����u������Ă���v��ԂɕύX
		button.className += " dimListButtonActive";//CSS�Ɗ֌W

		// �I�����ꂽ���̃����o���X�g��\��
		x = getPositionX(button);
		y = getPositionY(button) + button.offsetHeight;
		x += button.offsetParent.clientLeft;
		y += button.offsetParent.clientTop;
		button.dimList.style.left = (x-position) + "px";
		button.dimList.style.top  = y + "px";
		button.dimList.style.visibility = "visible";
	}

	// �X���C�T�[�{�^���̃X�^�C�����N���A
	function resetSlicer(button) {
		removeClassName(button, "dimListButtonActive");

		// �\�����ꂽ����/���W���[�̃����o���X�g���\���ɂ���
		if (button.dimList != null) {
			closeSubDimList(button.dimList);
			button.dimList.style.visibility = "hidden";
		}
	}

	// *********************************************************
	//  �X�^�C���i�����o�[���X�g�\���{�b�N�X�j
	// *********************************************************
	// �����o�[���X�g�\���{�b�N�X�̃N���[�Y
	function closeSubDimList(dimList) {
		if (dimList == null || dimList.activeItem == null){
			return;
		}

		// �����o���X�g���N���[�Y�i�ċA�j
		if (dimList.activeItem.subdimList != null) {
			closeSubDimList(dimList.activeItem.subdimList);
			dimList.activeItem.subdimList.style.visibility = "hidden";
			dimList.activeItem.subdimList = null;
		}
		removeClassName(dimList.activeItem, "dimListItemHighlight");
		dimList.activeItem = null;
	}

	// �������o�[���X�g�\���{�b�N�X�̏�����
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
			// �������Œ�
			fixHeight(dimList);

			// �c�X�N���[���o�[�̕������߂�
			scrollBarWidth = getScrollBarWidth(dimList);
		}

		// dimList�̕����擾
		itemList = dimList.getElementsByTagName("A");
		if (itemList.length > 0) {
			itemWidth = itemList[0].offsetWidth + scrollBarWidth;
		}else{
			return;
		}

		// �����o���q�����o�����ꍇ�ɕ\�����������E�[�ɕ\�������悤�ɒ���
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
				if(imageEl!=null){//Image�t���̃��j���[�̏ꍇ
					textEl.style.paddingRight = (itemWidth - (textEl.offsetWidth + arrowEl.offsetWidth+imageEl.offsetWidth)) + "px";
				}else{
					textEl.style.paddingRight = (itemWidth - (textEl.offsetWidth + arrowEl.offsetWidth)) + "px";
				}
			}
		}

		// �\����␳(IE)
		w = itemList[0].offsetWidth;
		itemList[0].style.width = w + scrollBarWidth + "px";

		// dimList�����������ꂽ
		dimList.isInitialized = true;
	}


	// *********************************************************
	//  �X�^�C���i�傫���A���W�A�X�N���[���j
	// *********************************************************

	// �c�X�N���[���o�[�̕\�����K�v���H
	//   �������K��l(dimListMaxHeight)�𒴂����ꍇ�Atrue
	//   �����Ă��Ȃ��ꍇ�Afalse
	function needScrollBarY(dimList) {

		if ( dimList.offsetHeight > dimListMaxHeight ) {
			return true;
		} else {
			return false;
		}
	}

	// �c�X�N���[���o�[��\�������邽�߁A�������Œ肷��
	function fixHeight(dimList) {
		dimList.style.height = dimListMaxHeight;
	}

	// �c�X�N���[���o�[�\�����ɂ́A�X�N���[���o�[�������������L����
	function getScrollBarWidth(dimList) {
		var	scrollBarWidth = dimList.offsetWidth - dimList.clientWidth;
		return scrollBarWidth;
	}

	// X���W(�\���̈悩��̑��΍��W)��Ԃ�
	// ���X�^�C���i���W�j
	function getPositionX(el) {
		var positionX;
	//�y�[�W�G�b�W�\�����̉��X�N���[���ɑΉ�
	//	positionX = el.offsetLeft;
		positionX = el.offsetLeft - el.scrollLeft;
		if (el.offsetParent != null){
			positionX += getPositionX(el.offsetParent);
		}
		return positionX;
	}

	// Y���W(�\���̈悩��̑��΍��W)��Ԃ�
	// ���X�^�C���i���W�j
	function getPositionY(el) {
		var positionY;
		positionY = el.offsetTop;
		if (el.offsetParent != null){
			positionY += getPositionY(el.offsetParent);
		}
		return positionY;
	}

	// *********************************************************
	//  ���ʊ֐�
	// *********************************************************

	// dimNo�����ƂɎ���������킷�m�[�h�����߂�
	//	<Input> dimNo:��Index(XML�ł�HierarchyInfo�^�O�����Members�^�O�̕��я�(1start)�ɑΉ�)
	//		          ���W���[���u16�v�Œ�ƂȂ�Ȃ����Ƃɒ��� 
	function getAxisByDimNo(dimNo) {
		var axis = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/HierarchyInfo[" + dimNo + "]");
		return axis;
	}

	// node����k���āA���͂��ꂽtagName,className�Ɠ������ŏ��̗v�f��Ԃ�
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


	// �w�肳�ꂽ�v�f���w�肳�ꂽ�N���X��������
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

	// �w�肳�ꂽ�v�f�́uclass�v��������w�肳�ꂽ�N���X�����폜
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


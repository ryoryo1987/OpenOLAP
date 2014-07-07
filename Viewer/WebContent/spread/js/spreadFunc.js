	// =====================================================
	// ���ʕϐ���
	// =====================================================
	// Object �i�[�p
	var spreadTable   = null;	// Spread�z�u�p��TABLE�v�f
	var dataTableArea = null;	// �f�[�^�\�������͂�DIV�v�f
	var dataTable     = null;	// �f�[�^�\������TABLE�v�f
	var colHeader     = null;	// ��w�b�_�\�������͂�SPAN�v�f
	var rowHeader     = null;	// �s�w�b�_�\�������͂�SPAN�v�f
	var CRSHeaderObject = null;	// �N���X�w�b�_�[�����͂�SAPN�v�f

	// Spread �\���֘A
	var defaultCellWidth  = 100;	// �����\�����̗�w�b�_�̕�
	var defaultCellHeight = 22; 	// �����\�����̍s�w�b�_�̍���

	// �������i�[�p
	var axesXMLData;

	// �s�w�b�_�A��w�b�_�ɃZ�b�g���ꂽ����/���W���[��
	var rowObjNum = 0;
	var colObjNum = 0;

	// �s�w�b�_�A��w�b�_�̊e�i�̎���/���W���[�̃����o��
	var chMemNumList = new Array(3);
		chMemNumList[0] = 0;
		chMemNumList[1] = 0;
		chMemNumList[2] = 0;

	var rhMemNumList = new Array(3);
		rhMemNumList[0] = 0;
		rhMemNumList[1] = 0;
		rhMemNumList[2] = 0;

	// XML�̐ݒ�
	var memberElementsNum = 7;		// XML�̎��������o�����v�f��
	var isDrilledPosition = 5;		// XML�́uisDrilled�v��index(0 start)


	// ** ��ʓ��̊e�G���A�T�C�Y�̒����p **
	// ���ύX�p�̃h���b�O�G���A�Ƃ��āASpread�\�̉E�[�������͉��[�ƃu���E�U�g�ԂɎc���]��
	var emptyWidth  = 20;
	var emptyHeight = 20;


	// ===================================================================================
	// �֐�
	// ===================================================================================

	// ===== �������֐� ==================================================================

	// Spread�̏�����
	function loadSpread() {
		axesXMLData = parent.info_area.axesXMLData;

		//PageEdge�Ɏ���/���W���[�̃X���C�X�{�^���𐶐��A�\��(visibility��visible�ɕύX)
		showSlicerButton();

		// ======== �ϐ��̏�����(�S��) ========
		// �I�u�W�F�N�g
		spreadTable   = document.all("SpreadTable");
		dataTableArea = document.all("DataTableArea");
		dataTable     = dataTableArea.firstChild;
		colHeader     = document.all("ColumnHeaderArea");
		rowHeader     = document.all("RowHeaderArea");
		CRSHeaderObject = document.all("CrossHeaderArea");


		// �s�w�b�_�A��w�b�_�ɃZ�b�g���ꂽ����/���W���[��
		var metaDataArea = document.all("metaDataArea");
		colObjNum = parseInt(metaDataArea.all("colHiesCount").innerText);
		rowObjNum = parseInt(metaDataArea.all("rowHiesCount").innerText);

		// �s�w�b�_�A��w�b�_�ɃZ�b�g���ꂽ����/���W���[�̃����o��
		chMemNumList[0] = parseInt(metaDataArea.all("colHie0Count").innerText);
		chMemNumList[1] = parseInt(metaDataArea.all("colHie1Count").innerText);
		chMemNumList[2] = parseInt(metaDataArea.all("colHie2Count").innerText);

		rhMemNumList[0] = parseInt(metaDataArea.all("rowHie0Count").innerText);
		rhMemNumList[1] = parseInt(metaDataArea.all("rowHie1Count").innerText);
		rhMemNumList[2] = parseInt(metaDataArea.all("rowHie2Count").innerText);

		// ======== �ϐ��̏�����(�h���������p) ========
		viewedColSpreadKeyList[0] = document.SpreadForm.viewCol0KeyList_hidden.value;
		viewedColSpreadKeyList[1] = document.SpreadForm.viewCol1KeyList_hidden.value;
		viewedColSpreadKeyList[2] = document.SpreadForm.viewCol2KeyList_hidden.value;

		viewedRowSpreadKeyList[0] = document.SpreadForm.viewRow0KeyList_hidden.value;
		viewedRowSpreadKeyList[1] = document.SpreadForm.viewRow1KeyList_hidden.value;
		viewedRowSpreadKeyList[2] = document.SpreadForm.viewRow2KeyList_hidden.value;

		viewedColSpreadIndexKeyList = document.SpreadForm.viewColIndexKey_hidden.value;
		viewedRowSpreadIndexKeyList = document.SpreadForm.viewRowIndexKey_hidden.value;

		// ���݃E�C���h�E�ɕ\������Ă����/�s��SpreadIndex,KEY�̑g�ݍ��킹����������
		var colIndexKeysStringArray = viewedColSpreadIndexKeyList.split(",");
		for ( var i = 0; i < colIndexKeysStringArray.length; i++ ) {
			var indexKeysString = colIndexKeysStringArray[i];
			var indexKeysArray = indexKeysString.split(":");

			var spreadIndex = parseInt(indexKeysArray[0]);
			var keyArray = indexKeysArray[1].split(";");

			viewingColSpreadIndexKeysDict.add(spreadIndex, keyArray);
		}

		var rowIndexKeysStringArray = viewedRowSpreadIndexKeyList.split(",");
		for ( var i = 0; i < rowIndexKeysStringArray.length; i++ ) {
			var indexKeysString = rowIndexKeysStringArray[i];
			var indexKeysArray = indexKeysString.split(":");

			var spreadIndex = parseInt(indexKeysArray[0]);
			var keyArray = indexKeysArray[1].split(";");

			viewingRowSpreadIndexKeysDict.add(spreadIndex, keyArray);
		}

		// �A�z�z��̏�����(COL KEY)
		for ( var i = 0; i < viewedColSpreadKeyList.length; i++) {
			var tmpKeyArray = viewedColSpreadKeyList[i].split(",");

			for ( var j = 0; j < tmpKeyArray.length; j++ ) {
				var tmpKey = tmpKeyArray[j].toString();

				associationViewedColSpreadKey[i][tmpKey] = 1;
			}
		}

		// �A�z�z��̏�����(COL Index)
		var tmpIndexKeyArray = viewedColSpreadIndexKeyList.split(",");

		for ( var j = 0; j < tmpIndexKeyArray.length; j++ ) {
			var tmpIndexKey = tmpIndexKeyArray[j].toString();
			var tmpIndex = tmpIndexKey.split(":")[0].toString();

			associationViewedColSpreadIndex[tmpIndex] = 1;
		}

		// �A�z�z��̏�����(ROW KEY)
		for ( var i = 0; i < viewedRowSpreadKeyList.length; i++) {
			var tmpKeyArray = viewedRowSpreadKeyList[i].split(",");

			for ( var j = 0; j < tmpKeyArray.length; j++ ) {
				var tmpKey = tmpKeyArray[j].toString();

				associationViewedRowSpreadKey[i][tmpKey] = 1;
			}
		}

		// �A�z�z��̏�����(ROW Index)
		var tmpIndexKeyArray = viewedRowSpreadIndexKeyList.split(",");

		for ( var j = 0; j < tmpIndexKeyArray.length; j++ ) {
			var tmpIndexKey = tmpIndexKeyArray[j].toString();
			var tmpIndex = tmpIndexKey.split(":")[0].toString();

			associationViewedRowSpreadIndex[tmpIndex] = 1;
		}

		// ===== �s�w�b�_�����i�̏ꍇ�A���炩���߃w�b�_�Z���̕����L���ă����o����������悤�ɂ��Ă��� =====
//		if ( getHeaderObjNum("ROW") > 1 ) {
			for ( var j = 0; j < getHeaderObjNum("ROW"); j++ ) {
				changeCellWidth(document.all("CrossHeader_CG" + j), 40, "modifyCrossHeaderWidth", "UP");
			}
//		}

		// ===== �c�[���o�[�̃`���[�g�\���{�^���̃J�[�\���X�^�C����ݒ肷�� =====
		setChartBtnCursorStyle();

		// ===== �c�[���o�[�̐F�ݒ�^�C�v�؂�ւ��{�^����ݒ肷�� =====
		setColorTypeStyle();

		// ===== �s�w�b�_�A��w�b�_�A�f�[�^�\�����̕��A�����𒲐� =====
		resizeArea();

		// ===== �X�N���[���C�x���g��scrollView()�Ƃ̑Ή��t�� =====
		dataTableArea.onscroll = scrollView;

		// ===== Spread�e�[�u���̐F�A�f�[�^���ǂݍ��݁ASpread�̕\������(visibility��visible�ɕύX) =====
		refreshTableColor();


		// �Z����̉E�N���b�N�����̏��������s�Ȃ�
		initializeRightClickSettings();

		// ===== �`���[�g�\���G���A��\�� =====
		displayChartArea();

	}

	// �`���[�g�\���{�^�����܂�TABLE�v�f�̃X�^�C����ݒ肷��
	function setChartBtnCursorStyle() {
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		
		if(node.text == "0") { // �S��ʕ\���i�\�j

			// �J�[�\���X�^�C����ݒ�
			document.all("tblChartBtn").style.cursor = "default"; // �f�t�H���g�i���j

			// �X�^�C����gray()�ɐݒ�
			document.all("chartKindArea").style.filter = chartButtonDisableFilterStyle;

		} else if ( (node.text == "1") || (node.text == "2") ) { // �O���t�\����
			document.all("tblChartBtn").style.cursor = ""; // ���ݒ�i�����Ɏ���DIV�ɂ��Ahand�ɂȂ�j
		}
	}

	// �c�[���o�[�̐F�ݒ�^�C�v�؂�ւ��{�^����ݒ肷��
	function setColorTypeStyle() {
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/colorType");
		if(node.text == "1") {
			document.all("tblColorBtn").style.display = "block";
			document.all("tblHigtLightBtn").style.display = "none";
		} else if (node.text == "2") {
			document.all("tblColorBtn").style.display = "none";
			document.all("tblHigtLightBtn").style.display = "block";
		}
		
	}

	// �`���[�g�\���G���A��\��
	function displayChartArea() {
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");

		// �S��ʕ\���i�\�j�̂Ƃ��́A�O���t��ރA�C�R����ύX
		if (node.text == "0") {
			var selectedChartNo = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/currentChartID").text;
			changeChartKindButton(selectedChartNo);
		}

		if ((node.text == "1")||(node.text == "2")) { // �O���t�\����
			document.all("chartAreaDIV").style.visibility = "visible";
		}

		// �S��ʕ\���i�O���t�j�̂Ƃ��́ASpread��\�������A�O���t�݂̂�\������
		if (node.text == "1") { // �S��ʕ\���i�O���t�j
			clickDisplayStyleMenu(1); // 1:�S��ʕ\���i�O���t�j

		// �c�����\���i�\�E�O���t�j�̂Ƃ��́ASpread��\�������A�O���t�݂̂�\������
		} else if (node.text == "2") { // �����\���i�\�E�O���t�j
			clickDisplayStyleMenu(2);  // 2:�S��ʕ\���i�O���t�j
		}

	}
	

	// HTML�̃e�[�u���ɐF�ݒ��K�p���A������Ƀf�[�^�}���������Ăяo��
	function refreshTableColor() {
		document.SpreadForm.action = "Controller?action=loadColorAct";
		document.SpreadForm.target = "loadingStatus";
		document.SpreadForm.submit();
	}


	// ===== �T�[�o�ւ̃A�N�Z�X���ǂ�����ݒ� ========================================
	function setLoadingStatus(status) {
alert("setLoadingStatus start");

		if ( (status != true) && (status != false) ) {
			return;
		}

//		if (status == true) { // �T�[�o�[�փA�N�Z�X��
//			parent.spread_header.loadingStatus.loadingIMG.src = "./images/logo_anime.gif";
//		} else { // �T�[�o�[�ւ̃A�N�Z�X�I��
//			parent.spread_header.loadingStatus.loadingIMG.src = "./images/logo_anime_stop.gif";
//		}
	}

	// ============= �X�^�C�������֘A�֐� =====================================

	// �s���w�b�_�ƃf�[�^�e�[�u�����̃X�N���[���ʒu�����킹��
	function scrollView() {
		rowHeader.scrollTop = dataTableArea.scrollTop;
		colHeader.scrollLeft= dataTableArea.scrollLeft;
	}

	// �s�w�b�_�A��w�b�_�A�f�[�^�\�����̕���BODY�T�C�Y�ɍ��킹�ĕύX����B
	function resizeArea() {

		var modifyWidth = 8;

		if ( document.body.clientWidth != 0 ) {

			// �y�[�W�G�b�W�ɔz�u���ꂽ���������A�\����������Ȃ��ăX�N���[���o�[�ŕ\�������ꍇ�ɁA
			// �X�N���[���o�[�̍��������y�[�W�G�b�W�\�����̍����𑝂₷
			var pageEdgeTable = document.all("tblPageEdge");
			if (pageEdgeTable.parentElement.clientHeight == pageEdgeTable.parentElement.scrollHeight ) {
				pageEdgeTable.height = "";
			} else {
				if (pageEdgeTable.height == "") {
					pageEdgeTable.height = pageEdgeTable.parentElement.scrollHeight + 
											(pageEdgeTable.parentElement.scrollHeight - pageEdgeTable.parentElement.clientHeight); 
				}
			}

			// ���ύX�p�̃h���b�O�G���A�ł���SPAN�̃T�C�Y��ݒ�
			var spreadSpan = document.all("SpreadSpan");
			spreadSpan.style.width = document.body.clientWidth;
			spreadSpan.style.height = document.body.clientHeight;

			// �s�E��w�b�_�E�f�[�^�e�[�u�����̃T�C�Y��ݒ�
			var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
			var newWidth  = ( document.body.clientWidth 
								- rowHeader.offsetWidth 
								- modifyWidth ) - emptyWidth;
			var areaHeight;
				if ((node.text=="0") || (node.text=="2")) { // �\�����̓t���[���udisplay_area�v���Ŋ���
					areaHeight = ( getHeaderHeight() + getSpreadHeight() );
				} else if (node.text=="1") { // �udisplay_area�v�ɂ̓O���t���\������邽��
					areaHeight = getHeaderHeight();
				}
			var newHeight = ( document.body.clientHeight 
			                   - areaHeight - emptyHeight
			                 );
			// �s�w�b�_�A�f�[�^�\�����̕�����ї�w�b�_�A�f�[�^�\�����̍�����
			// ���ɂȂ����ꍇ�́A�␳�͍s�Ȃ�Ȃ�
			if ( newWidth <= 0 ) {
				return;
			} else if ( newHeight <= 0 ) {
				return;
			}
			colHeader.style.width      = newWidth;
			dataTableArea.style.width  = newWidth;
			rowHeader.style.height     = newHeight;
			dataTableArea.style.height = newHeight;

			// �s�E��w�b�_�A�f�[�^�e�[�u���̃X�N���[���ʒu(X���AY��)�����킹��
			scrollView();

		}
	}

// ===== �\���̈�̍����A���擾 =============================================

	// �X�v���b�h�\���t���[�����̏㕔�G���A(�X�v���b�h��������)�̍��������߂�B
	function getHeaderHeight() {

		// ���߂鍂�� �� ���|�[�g�^�C�g���A�c�[���o�[�\���� �{
		//				 �y�[�W�G�b�W�\����
		var headerHeight = document.all("spreadHeader").offsetHeight
							 + document.all("tblPageEdge").offsetHeight;

		return headerHeight;
	}


	// �X�v���b�h�\���t���[�����̃X�v���b�h�G���A�̍��������߂�B
	function getSpreadHeight() {

		// ���߂鍂�� �� ��w�b�_�[���̃^�C�g���� �{ ��w�b�_�[�� �{ 
		//				 �s�w�b�_����уf�[�^�e�[�u���\����
		var spreadHeight = colHeader.offsetHeight
							+ spreadTable.rows[0].offsetHeight
							+ spreadTable.rows[1].offsetHeight;

		return spreadHeight;
	}

// ===== ���b�Z�[�W�\�� =============================================

	// ���[�U�[�Ƀ��b�Z�[�W��\��
	function showMessage( id,arg1,arg2,arg3,arg4,arg5 ) {

		var message    = "";
		var arg1String = "";
		var arg2String = "";
		var arg3String = "";
		var arg4String = "";
		var arg5String = "";

		switch ( id ) {
		
			case "1" :
				if ( arg1 == "COL" ) {
					arg1String = "��w�b�_";
				} else if ( arg1 == "ROW" ) {
					arg1String = "�s�w�b�_";
				}
				message = arg1String + "�ɂ͂P�i�ȏ�̃f�B�����V�����܂��̓��W���[���K�v�ł��B";
				break;

			case "2" :
				if ( arg1 == "COL" ) {
					arg1String = "��w�b�_";
				} else if ( arg1 == "ROW" ) {
					arg1String = "�s�w�b�_";
				}
				message = arg1String + "�ɂ͂R�i�ȏ�̃f�B�����V�����܂��̓��W���[�͐ݒ�ł��܂���B";
				break;

			case "3" :
				if ( arg2 == "COL" ) {
					arg2String = "��w�b�_";
				} else if ( arg2 == "ROW" ) {
					arg2String = "�s�w�b�_";
				}
				message = arg2String + "�ɕ\���ł���Z���̍ő�l��" + arg1 + "�ł��B";
				break;

			case "4" :
				message = "���|�[�g�ɕ\���ł���Z���̍ő�l��" + arg1 + "�ł��B";
				break;

			case "5" :
				message = "�h�������������s���Ă��܂��B���X���������������B";
				break;

			// �Z���N�^
			case "6" :
				message = "�I���ς݂̃����o�[���Ƀ����o�[������܂���B";
				break;

			// ���|�[�g�ۑ�
			case "7" :
				message = "���|�[�g��ۑ����܂����B";
				break;

			// ���O�C�����̓`�F�b�N�i���[�U�[�����p�X���[�h�j
			case "8" :
				message = "���[�U�[������уp�X���[�h����͂��Ă��������B";
				break;

			// ���O�C�����̓`�F�b�N�i���[�U�[���j
			case "9" :
				message = "���[�U�[������͂��Ă��������B";
				break;

			// ���O�C�����̓`�F�b�N�i�p�X���[�h�j
			case "10" :
				message = "�p�X���[�h����͂��Ă��������B";
				break;

			// ���|�[�g���w�l�k���񐮌`�ł���
			case "11" :
				message = "���|�[�g���w�l�k�̎擾�Ɏ��s���܂����B\n" + arg1;
				break;

			// ���|�[�g���w�l�k�ϊ��p�̂w�r�k�s���񐮌`�ł���
			case "12" :
				message = "���|�[�g���ϊ��p�w�r�k�s�̎擾�Ɏ��s���܂����B\n" + arg1;
				break;

			// Color���w�l�k���񐮌`�ł���
			case "13" :
				message = "���|�[�g�J���[���w�l�k�̎擾�Ɏ��s���܂����B\n" + arg1;
				break;

			// �Z���f�[�^���w�l�k���񐮌`�ł���
			case "14" :
				message = "�Z���f�[�^���w�l�k�̎擾�Ɏ��s���܂����B\n" + arg1;
				break;

		}

		alert( message );
	}


	// ���[�U�[�Ɋm�F�����߂郁�b�Z�[�W��\��
	function showConfirm(msgId,arg1){
		var msg=new Array();
		msg["CFM4"] = "���O�A�E�g���܂��B��낵���ł����H";
		return confirm(msg[msgId]);
	}

// ====================================================================================

	// ��ʃt���[�Ń��O�A�E�g���Ɏg�p
	function logout_flow(element, contextPath) {
		if ( showConfirm("CFM4") ) {
			element.href = contextPath + "/Controller?action=logout";
			element.target="_top";
		} else {
			return;
		}
	}

// ===== �`���[�g�\���֘A ==============================================================

	// �`���[�g�\�����X�V	
	function reloadChart() {
	
		// �T�[�o�ւ̃A�N�Z�X�󋵂�ݒ�(�C���[�W�𓮂���)
//		setLoadingStatus(true);

		// ���ݕ\������Ă���s/��̏����擾���Ahidden�ɕۑ�����
		// �i�e�����o���h�������Ŕ�\���ƂȂ��Ă��郁���o�͊܂߂Ȃ��B�j
		setViewingColRowInfo();

		// �O���t�����擾
		var currentChartIDNode = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/currentChartID");

		// �O���t�\���ΏۂƂȂ�t���[���A�O���t�\���G���A�̃T�C�Y��ݒ�
		var targetFrame = null; // �O���t�\���ΏۂƂȂ�t���[��
		var chartWidth;			// �O���t�i�C���[�W�t�@�C���j�̕�
		var chartHeight;		// �O���t�i�C���[�W�t�@�C���j�̍���

		var displayScreenTypeNode = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		if (displayScreenTypeNode.text == "0") { // �S��ʕ\���i�\�j�̏ꍇ�A�C���i�[�t���[�����^�[�Q�b�g�ɐݒ�(�O���t��\��������킯�ł͂Ȃ��̂ŁA���ۂɂ͕\������Ȃ��_�~�[�̃t���[��)
			targetFrame = "chart_area";
		} else if (displayScreenTypeNode.text == "1") { // �S��ʕ\���i�O���t�j�̏ꍇ�A�C���i�[�t���[���ɃO���t��\��
			targetFrame = "chart_area";
			chartWidth = document.body.clientWidth-3;
			chartHeight = document.body.clientHeight - getHeaderHeight() -40;
//alert(chartWidth + "\n" + chartHeight);
			
			// iframe�̍�����ύX
			document.all("chart_area").height = chartHeight;

		} else if (displayScreenTypeNode.text == "2") { // �����\���i�\�A�O���t�j�̏ꍇ�A�����t���[���ɃO���t��\��
			targetFrame = "chart_sub_area";

			dispChartSubArea(chartSubAreaInitialHeight); // �\���G���A���쐬���A�\���G���A�̃T�C�Y�ɂ��A�C���[�W���쐬
			chartWidth = parent.chart_sub_area.document.body.clientWidth;
			chartHeight = parent.chart_sub_area.document.body.clientHeight;
		}

		// �`���[�g�̎�ރ{�^���\�����̃{�^����ύX
		var memNo = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/currentChartID").text;
		changeChartKindButton(memNo);

		// �T�[�o�[�֑��M���A��ʃ^�C�v�A�f�t�H���g�`���[�g�^�C�v���X�V����ƂƂ��ɁA�N���C�A���g�̃`���[�g���X�V����
		document.SpreadForm.action = "Controller?action=getChartInfo&chartID=" + currentChartIDNode.text + "&displayScreenType=" + displayScreenTypeNode.text + "&chartWidth=" + chartWidth + "&chartHeight=" + chartHeight;
		document.SpreadForm.target = targetFrame;
		document.SpreadForm.submit();
	}










// =============================================================================

// �h�����X���[�p�ϐ�

	// �E�N���b�N�ŕ\������郁�j���[�̖��̃��X�g
	var menuText = new Array();

	// �E�N���b�N�ŕ\������郁�j���[�N���b�N�Ŏ��s�����t�@���N�V�����̃��X�g
	var menuAction = new Array();

	// �E�N���b�N���ꂽ�Z�����i�[����I�u�W�F�N�g
	var rightClickedCell = null;

	// �|�b�v�A�b�v���j���[�̕�����
	var divMenu = "";

	// �|�b�v�A�b�v���j���[�̃I�u�W�F�N�g
	var oPopup = null;

// �h�����X���[�p���̏����ݒ�
function initializeRightClickSettings(){

	var targetRepIDs = axesXMLData.selectNodes("/root/OlapInfo/ReportInfo/Report/DrillThrowInfo/TargetReports/TargetReport//TargetRepID");
	var targetRepNames = axesXMLData.selectNodes("/root/OlapInfo/ReportInfo/Report/DrillThrowInfo/TargetReports/TargetReport//TargetRepName");

	for(var i=0; i<targetRepIDs.length; i++) {
		menuText[i]   = targetRepNames[i].text;
		menuAction[i] = "drillThrough(" + targetRepIDs[i].text + ")";
	}

	if(window.createPopup) {

		oPopup = window.createPopup();       //�|�b�v�A�b�v�I�u�W�F�N�g�쐬
		divMenu = '<DIV STYLE="border-top:1px solid #333333;border-left:1px solid #333333;background:' + popBGNormalColor + ';">';

			//���j���[���e�쐬
		for(count = 0; count < menuText.length; count++){
			divMenu +='<DIV onmouseover="this.style.background=\'' + popBGOverColor + '\';" onmouseout="this.style.background=\'' + popBGNormalColor + '\';" onclick="parent.' + menuAction[count] + '" style="font-size:11px; height:20px; padding-left:3px;padding-top:5px; cursor:hand; border-bottom:1px solid #333333; border-right:1px solid #333333;">' + menuText[count] + '</DIV>';
		}
		divMenu += '</DIV>';

		document.oncontextmenu = ContextMenu;                 //�E�N���b�N�C�x���g������

	}

}


// �}�E�X�C�x���g
// �E�N���b�N
function ContextMenu(){

	if(window.createPopup) {

		// �f�[�^���̓Z���ȊO�ł���΁A�I��
		if ( getCellPosition(event.srcElement) != "DATA" ) {
			return(false);
		}

		// �h�����X���[�\���|�[�g�������Ȃ�΁A�I��
		if (menuText.length==0) {
			return(false);
		}

		rightClickedCell = null;
		rightClickedCell = event.srcElement;

		//�|�b�v�A�b�v�ɕ\��������e��ݒ�
		oPopup.document.body.innerHTML = divMenu;


		// �|�b�v�A�b�v�̃X�^�C���ݒ�
		var popTopper = event.clientX + 0;              //�|�b�v�A�b�v��\������X���W���擾
		var popLefter = event.clientY + 0;              //�|�b�v�A�b�v��\������Y���W���擾

		//�|�b�v�A�b�v�̕�
		var popWidth  = 0;
			var maxString = 0;
			for (var i=0; i<menuText.length; i++) {
				if(maxString < menuText[i].length) {
					maxString = menuText[i].length;
				}
			}
			popWidth = maxString * 16;

		//�|�b�v�A�b�v�̍���
		var popHight  = null;
			var heightString = oPopup.document.body.firstChild.firstChild.style.height;
			popHight = (heightString.replace("px","") * menuText.length) + 1;

		//�|�b�v�A�b�v��\�����郁�\�b�h��call
		oPopup.show(popTopper, popLefter, popWidth, popHight, document.body);

		return(false);
	}

}

// �h�����X���[���I�����ꂽ
function drillThrough(targetRepID) {

//alert("�h�����X���[���I�����ꂽ");
//alert(rightClickedCell.outerHTML);

	// ���������� ���|�[�g��񐶐��� ����������
	var reportID = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/ReportID").text;
	var cubeSeq  = axesXMLData.selectSingleNode("/root/OlapInfo/CubeInfo/Cube/CubeSeq").text;

	var xmlString = "";
	xmlString += "<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>";
	xmlString += "<OpenOLAP>";
	xmlString += "<report_info report_type='M' report_id='" + reportID + "' cube_seq='" + cubeSeq + "'/>";

	// ���������� ����񐶐��� ���������� 
	xmlString += "<args>";

//<arg dim_seq='' key='' position='col1' dim_type='D'/>
//<arg dim_seq='' key='' position='edge1' dim_type='M'/> M�̓��W���[Seq�i16�łȂ���j

	// ��w�b�_�A�s�w�b�_
	var colIdKeyArray = getIdKeyList( rightClickedCell, "COL" ).split(":");
	xmlString += getAxisInfoString("col", colIdKeyArray);

	var rowIdKeyArray = getIdKeyList( rightClickedCell, "ROW" ).split(":");
	xmlString += getAxisInfoString("row", rowIdKeyArray);

	// �y�[�W�G�b�W�Őݒ肳��Ă���Key���X�g
	var pageAxes = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/PAGE/HierarchyID");
	var selectedMemberID = null;

	var tmpString = "";
	for ( var i=0; i<pageAxes.length; i++ ) {
		var axisID = pageAxes[i].text;
		var axis = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/HierarchyInfo[@id=\"" + axisID + "\"]");
		selectedMemberID = axis.selectSingleNode("DefaultMemberKey").text;
		if ( selectedMemberID == "NA" ) {
			selectedMemberID = axesXMLData.selectSingleNode("/root/Axes/Members[@id=\"" + axisID + "\"]//Member[1]/UName").text;
		}

		if ( i > 0 ) {
			tmpString += ":"
		}
		tmpString += axisID + "." + selectedMemberID;
	}
	var pageIdKeyArray = tmpString.split(":");
	xmlString += getAxisInfoString("page", pageIdKeyArray);

	xmlString += "</args>";

	// ���������� �h�����惌�|�[�g��񐶐��� ����������
	xmlString += "<TargetReportInfo>";
		xmlString += "<TargetReportID>";
			xmlString += targetRepID;
		xmlString += "</TargetReportID>";
	xmlString += "</TargetReportInfo>";

	xmlString += "</OpenOLAP>";

//alert("�h������ ���|�[�gID:" + targetRepID + "\n" + xmlString);
	document.SpreadForm.argXmlHidden.value = xmlString;	// �h�����X���[���XML��hidden�ɓo�^
	var newWin = window.open("flow/jsp/main/drill_arg.jsp?load=first","_blank","menubar=no,toolbar=no,width=700px,height=450px,resizable");


}


// �h�����X���[���XML�̎���񕔂̕�����𐶐�����
// 	targetEdge�F�ΏۂƂ���G�b�W�icol,row,page�j
// 	idKeyArray�F��ID����т��̃����o�[Key
//				��				�f�B�����V���� �������� ���W���[�j
//				��				ID1�`15�F�f�B�����V�����A 16:���W���[
//				�����o�[Key		�f�B�����V�����̏ꍇ�F�f�B�����V���������o�[��key
//								���W���[�̏ꍇ�F���W���[�����o�[�̃C���f�b�N�X�i1start�j
function getAxisInfoString(targetEdge, idKeyArray) {

	var infoString = "";

	for ( var i=0; i<idKeyArray.length; i++){
		var pairArray = idKeyArray[i].split(".");
		var id  = pairArray[0];
		var key = pairArray[1];
		
		var type = "";
		var seq = "";
		if ( id == "16") {
			type = "M";

			var node = axesXMLData.selectSingleNode("/root/Axes/Members[@id=\"" + id + "\"]//Member[./UName=\"" + key + "\"]");
			seq = node.getAttribute("measureSeq");

		} else {
			type = "D";
			var node = axesXMLData.selectSingleNode("/root/Axes/Members[@id=\"" + id + "\"]")
			seq = node.getAttribute("dimensionSeq");

		}

		infoString += "<arg dim_seq='" + seq + "' key='" + key + "' position='" + targetEdge + i + "' dim_type='" + type + "'/>"

	}
	return infoString;
}






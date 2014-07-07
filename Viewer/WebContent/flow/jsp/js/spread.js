	// =====================================================
	// ���ʕϐ���
	// =====================================================
	// Object �i�[�p
	var spreadTable   = null;	// Spread�z�u�p��TABLE�v�f
	var dataTableArea = null;	// �f�[�^�\�������͂�DIV�v�f
	var dataTable     = null;	// �f�[�^�\������TABLE�v�f
	var colHeader     = null;	// ��w�b�_�\�������͂�SPAN�v�f
	var rowHeader     = null;	// �s�w�b�_�\�������͂�SPAN�v�f

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

	// ============= �֐� =============================
	// �������֐�
	function loadSpread() {

		// ======== �ϐ��̏�����(�S��) ========
		// �I�u�W�F�N�g
		spreadTable   = document.all("SpreadTable");
		dataTableArea = document.all("DataTableArea");
		dataTable     = dataTableArea.firstChild;
		colHeader     = document.all("ColumnHeaderArea");


		// ===== �X�N���[���C�x���g��scrollView()�Ƃ̑Ή��t�� =====
		dataTableArea.onscroll = scrollView;

		// ===== �s�w�b�_�A��w�b�_�A�f�[�^�\�����̕��A�����𒲐� =====
		resizeArea();
	}

	function scrollView() {
	//	rowHeader.scrollTop = dataTableArea.scrollTop;
		colHeader.scrollLeft= dataTableArea.scrollLeft;
	}

	function resizeArea() {
	// �s�w�b�_�A��w�b�_�A�f�[�^�\�����̕���BODY�T�C�Y�ɍ��킹�ĕύX����B

		if ( document.body.clientWidth != 0 ) {

		//	var newWidth  = ( document.body.clientWidth - rowHeader.offsetWidth ) * 0.9;
			var newWidth  = ( document.body.clientWidth);
//			var newHeight = ( document.body.clientHeight - colHeader.offsetHeight - document.all("pageEdgeTable").offsetHeight - spreadTable.rows[0].offsetHeight - spreadTable.rows[1].offsetHeight ) * 0.9;
			var newHeight = ( document.body.clientHeight - colHeader.offsetHeight );

			// �s�w�b�_�A�f�[�^�\�����̕�����ї�w�b�_�A�f�[�^�\�����̍�����
			// ���ɂȂ����ꍇ�́A�␳�͍s�Ȃ�Ȃ�
			if ( newWidth <= 0 ) {
				return;
			} else if ( newHeight <= 0 ) {
				return;
			}

			colHeader.style.width      = newWidth;
			dataTableArea.style.width  = newWidth;

		//	rowHeader.style.height     = newHeight;
			dataTableArea.style.height = newHeight;

			// �s�E��w�b�_�A�f�[�^�e�[�u���̃X�N���[���ʒu(X���AY��)�����킹��
			scrollView();
		}
	}



// ============== ���ʊ֐� ==================================================
	function getCOLIndexByCOLObj( headerCOLObj ) {
	// Input	:�N���X�w�b�_,��w�b�_��COL�I�u�W�F�N�g
	//			�iID�����FCrossHeader_CGx,CH_CGx�j
	// Output	�F����ڂ���\��Index
		var strID     = headerCOLObj.id;
		var strGIndex = strID.lastIndexOf("G");
		var colIndex  = strID.substr(strGIndex + 1, strID.length - (strGIndex + 1));
		return colIndex;
	}

	function getColIndexByTDObj( headerTDObj ) {
	// Input	:�s�A��w�b�_��TD�I�u�W�F�N�g
	//			 (ID�����FRH_Rx_Cy�ACH_Rx_Cy)
	// Output	:����ڂ���\��Index
		var strID     = headerTDObj.id;
		var strCIndex = strID.lastIndexOf("C");
		var colIndex  = strID.substr(strCIndex + 1, strID.length - (strCIndex + 1));
		return colIndex;
	}



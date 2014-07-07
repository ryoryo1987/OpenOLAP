	var spreadTable   = null;
	var dataTableArea = null;
	var dataTable     = null;
	var colHeader     = null;
	var rowHeader     = null;

	var defaultCellWidth  = 100;
	var defaultCellHeight = 22; 

	var axesXMLData;

	var rowObjNum = 0;
	var colObjNum = 0;

	var chMemNumList = new Array(3);
		chMemNumList[0] = 0;
		chMemNumList[1] = 0;
		chMemNumList[2] = 0;

	var rhMemNumList = new Array(3);
		rhMemNumList[0] = 0;
		rhMemNumList[1] = 0;
		rhMemNumList[2] = 0;

	var memberElementsNum = 7;	
	var isDrilledPosition = 5;	

loadSpread();

	function loadSpread() {
		spreadTable   = document.all("SpreadTable");
		dataTableArea = document.all("DataTableArea");
		dataTable     = dataTableArea.firstChild;
		colHeader     = document.all("ColumnHeaderArea");


		dataTableArea.onscroll = scrollView;

		resizeArea();
	}

	function scrollView() {
		colHeader.scrollLeft= dataTableArea.scrollLeft;
	}

	function resizeArea() {

		if ( document.body.clientWidth != 0 ) {

		//	var newWidth  = ( document.body.clientWidth - rowHeader.offsetWidth ) * 0.9;
			var newWidth  = ( document.body.clientWidth) -10;
//			var newHeight = ( document.body.clientHeight - colHeader.offsetHeight - document.all("pageEdgeTable").offsetHeight - spreadTable.rows[0].offsetHeight - spreadTable.rows[1].offsetHeight ) * 0.9;
			var newHeight = ( document.body.clientHeight - colHeader.offsetHeight ) -15;

			if ( newWidth <= 0 ) {
				return;
			} else if ( newHeight <= 0 ) {
				return;
			}

			colHeader.style.width      = newWidth;
		//	dataTableArea.style.width  = newWidth;
			dataTableArea.style.width  = newWidth+10;

		//	rowHeader.style.height     = newHeight;
		//	dataTableArea.style.height = newHeight;
			dataTableArea.style.height  = newHeight+15;

			scrollView();
		}
	}

	function isInCrossHeaderAreaByTDObj(ele){
		var t = ele;
		var objID = "";
		var tSPANObj = null;
		if ( t.tagName == "TD" ) {
			tSPANObj = t.parentNode.parentNode.parentNode.parentNode;

			if ( tSPANObj != null ) {
				if ( tSPANObj.id == "CrossHeaderArea" ) {
					return true;
				}
			}
		} else {
			return false;
		}
		return false;
	}

	function isInCrossHeaderRowAxisNameAreaByTDObj(ele) {
		var isInCrossHeaderFLG = isInCrossHeaderAreaByTDObj(ele);
		if ( ele.tagName == "TD" ) {
			if ( isInCrossHeaderFLG ) {
				var currentRowIndex = ele.parentNode.rowIndex;
				var lastCrossHeaderRowIndex = ele.parentNode.parentNode.lastChild.rowIndex;
				if ( currentRowIndex == lastCrossHeaderRowIndex ) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	function sameRowToCrossHeaderAxisNameAreaByTDObj(ele) {
		var currentRowIndex = ele.parentNode.rowIndex;
		var crossHeaderAxisNameRowIndex = document.all("CrossHeaderArea").firstChild.rows.length -1;
		if ( currentRowIndex == crossHeaderAxisNameRowIndex ) {
			return true;
		} else {
			return false;
		}
	}

	function getIndex(obj){
		var parentObj = obj.parentNode;
		for(idx=0;idx<parentObj.childNodes.length;idx++){
			if(obj==parentObj.childNodes[idx]){
				return idx;
			}
		}
	}






	function getCOLIndexByCOLObj( headerCOLObj ) {
		return getIndex(headerCOLObj);
	}

	function getColIndexByTDObj( headerTDObj ) {
		return getIndex(headerTDObj);
	}

	function getRowIndexByTRObj( headerTRObj ) {
		return getIndex(headerTRObj);
	}


	function existNextRowAxis ( ele ) {
		var eleIndex = getColIndexByTDObj( ele );
		if ( eleIndex < colObjNum-1 ) {
			return true;
		} else {
			return false;
		}
	}

	function existNextRowAxisByID ( id ) {
		var eleIndex = getColIndexByTDObj( ele );
		if ( eleIndex < colObjNum-1 ) {
			return true;
		} else {
			return false;
		}
	}

	function getHieMemNum( targetString, hierarchyID ) {
		var target = targetString;	
		var hieID  = hierarchyID;	
									
		
		if ( targetString == "COL" ) {
			if ( hieID == 0 ) {
				return chMemNumList[0];
			} else if ( hieID == 1 ) {
				return chMemNumList[1];
			} else if ( hieID == 2 ) {
				return chMemNumList[2];
			}
		} else if ( targetString == "ROW" ) {
			if ( hieID == 0 ) {
				return rhMemNumList[0];
			} else if ( hieID == 1 ) {
				return rhMemNumList[1];
			} else if ( hieID == 2 ) {
				return rhMemNumList[2];
			}
		}
		return null;
	}

	function getHeaderObjNum( targetString ) {
		var target = targetString;	
		
		if ( targetString == "COL" ) {
			return colObjNum;
		} else if ( targetString == "ROW" ) {
			return rowObjNum;
		}
		return null;
	}
















// ============== 幅変更関連 ==================================================

	// 幅変更関連
	var target = null;
	var activation = null;
	var mouseX = -1;		
//	var mouseY = -1;		
	var selectedCellInitialValue = 0;	

	var crossHeaderMaxWidthRate  = 0.8;	
//	var crossHeaderMaxHeightRate = 0.8;	

	var CRSHeaderObject = document.all("CrossHeaderArea");

	function getNextAxisMemNum( hieIndex, target ) {
		if ( hieIndex > 1 || hieIndex < 0 ) {
			return null;
		}

		if ( target == "COL" ) {
			return chMemNumList[hieIndex + 1];
		} else if ( target == "ROW" ) {
			return rhMemNumList[hieIndex + 1];
		}
	}

	function getLowerHieComboNum( cell, target ) {
		var nextAxisMemNum = -1;
		var retComboNum    = 1;
		var hieIndex       = 0;
		var hieMaxIndex    = 0;

		if ( target == "COL" ) {
			hieIndex       = cell.parentNode.rowIndex;
			hieMaxIndex    = cell.parentNode.parentNode.rows.length-1;
		} else if ( target == "ROW" ) {
			hieIndex       = parseInt(getColIndexByTDObj(cell));
			hieMaxIndex    = cell.parentNode.parentNode.rows(0).cells.length-1;
		}

		for ( var i = hieIndex; i < hieMaxIndex; i++ ) {
			nextAxisMemNum = getNextAxisMemNum(i,target);
			retComboNum = retComboNum * nextAxisMemNum;
		}
		return retComboNum;
	}

	function changeCellIndexToCHCOL( cell,slideNum,position) {
		var toIDX = -1;
		var comboNum = 1;
		comboNum = getLowerHieComboNum(cell,"COL");
		if ( position == "LEFT" ) {
			toIDX = ( (cell.cellIndex + slideNum ) * comboNum );
		} else if ( position == "RIGHT" ) {
			toIDX = ( (cell.cellIndex + 1 + (slideNum) ) * comboNum ) -1;
		}
		return toIDX;
	}

	function changeCellWidth(target,delt,activation,method) {

		var width = target.offsetWidth + delt;
		if (width <= 0) {
			width = "1px";
			target.style.width = width;
			scrollView();	
			return;
		}

		if ( activation == "modifyColHeaderWidth" ) {
			target.style.width = width;
			if ( method == "UP" ) {
				var tmpColIndex = getCOLIndexByCOLObj(target);
				var dataColumn = document.all("columngroup2").childNodes[tmpColIndex];
				dataColumn.style.width = width;
			}
		} 

		scrollView();
		return;
	}

	function mouseDown2() {
		var srcEle = window.event.srcElement;
			if ( srcEle.tagName == "DIV" ) {
				srcEle = srcEle.parentElement;
			}
			if ( srcEle == null ) {
				return;
			}
		var selectedCell = null;
		var tmpObj = null;
		var comboNum = 1;
		var targetIndex = -1;

		var mousePosition = null;
			if ( onColumnHeaderCellVLine(window.event) ) {
				mousePosition = "columnHeaderCellVLine";
			} else {
				return;
			}

		target = null;
		activation = null;
		mouseX = -1;
		mouseY = -1;
		selectedCellInitialValue = 0;




		if ( ( mousePosition == "columnHeaderCellVLine" ) || ( mousePosition == "crossHeaderCellVLine" ) ) {
			if ( window.event.offsetX < 3 ) {
				tmpObj = srcEle.previousSibling;	// TR Object


				if ( mousePosition == "columnHeaderCellVLine" ) {
					targetIndex = changeCellIndexToCHCOL(srcEle,-1,"RIGHT");
					
					tmpObj = document.getElementById("columngroup1").childNodes[targetIndex];
				} else if ( mousePosition == "crossHeaderCellVLine1" ) {
					targetIndex = getColIndexByTDObj(srcEle) - 1;
					tmpObj = document.all( "CrossHeader_CG" + targetIndex );
				} else {
					return;
				}
			} else if ( window.event.offsetX > srcEle.offsetWidth - 4) {
				if ( mousePosition == "columnHeaderCellVLine" ) {
					targetIndex = changeCellIndexToCHCOL(srcEle,0,"RIGHT");
				//	tmpObj = colHeader.all("CH_CG" + targetIndex);
					tmpObj = document.getElementById("columngroup1").childNodes[targetIndex];

				} else {
					return null;
				}
			} else {
				return;
			}
			target = tmpObj;			
										
			if ( mousePosition == "columnHeaderCellVLine" ) {
				activation = "modifyColHeaderWidth";	
			} else if ( mousePosition == "crossHeaderCellVLine" ) {
				activation = "modifyCrossHeaderWidth";
				selectedCellInitialValue = target.offsetWidth;
			} else {
				return;
			}
			mouseX = event.clientX;		
			return;
		}

	}

	function mouseMove() {
	var retCode;


		if ( target != null && activation != null ) {
			if ( ( activation == "modifyColHeaderWidth" ) || ( activation == "modifyCrossHeaderWidth" ) ) {

				var delt = window.event.clientX - mouseX;

				if ( ( activation == "modifyCrossHeaderWidth" ) && 
                     ( document.body.clientWidth * crossHeaderMaxWidthRate ) < parseInt(CRSHeaderObject.offsetWidth + delt) ) {

					return;
				}

				var method = "MOVE";
				var retCode = changeCellWidth(target,delt,activation,method);

				mouseX = window.event.clientX;
				return;
			}

		} else {
			var pointedCell = window.event.srcElement;
			if ( onColumnHeaderCellVLine(window.event) == true ) {
				pointedCell.style.cursor = "col-resize";
			} else {
			//	pointedCell.style.cursor = "auto";
				pointedCell.style.cursor = "default";
			}
		}
	}

	function mouseUp() {
		var retCode;

		if ( target != null && activation != null ) {
			if ( ( activation == "modifyColHeaderWidth" ) || ( activation == "modifyCrossHeaderWidth" ) ) {

				var delt = window.event.clientX - mouseX;
				var method = "UP";

				if ( ( activation == "modifyCrossHeaderWidth" ) && 
                     ( document.body.clientWidth * crossHeaderMaxWidthRate ) < parseInt(CRSHeaderObject.offsetWidth + delt) ) {
					retCode = changeCellWidth(target,0,activation,method);

				} else {

					retCode = changeCellWidth(target,delt,activation,method);
				}

				target = null;
				activation = null;
				mouseX = -1;
				mouseY = -1;
				selectedCellInitialValue = 0;

				return;
			}
		}
	}


	function onColumnHeaderCellVLine( thisEvent ) {
		var ele = thisEvent.srcElement;
		if ( ( ele.tagName != "TD" ) || ( ele.parentElement.tagName != "TR" ) ) {
			return false;
		}
		if ( ( ele.parentElement.Spread != "ColumnHeaderRow" ) &&
			 ( ele.parentElement.Spread != "ColumnHeaderMeasureRow" ) ) {
			return false;
		}

		if ( thisEvent.offsetX < 3 && ele.cellIndex!=0) {
			return true;
		} else if ( thisEvent.offsetX > ele.offsetWidth - 4) {
			return true;
		}
		return false;
	}



	function changeAllCellWidth(){
		for(colNo=0;colNo<document.getElementById("columngroup2").childNodes.length;colNo++){
			document.getElementById("columngroup2").childNodes[colNo].style.width=document.getElementById("columngroup1").childNodes[colNo].style.width;
		}
	}




	function setChangeFlg(){
		//[navi_frm]フレームのHidden=1 -- 処理中フラグセット --
		top.frames[1].document.navi_form.change_flg.value = 1;
	}







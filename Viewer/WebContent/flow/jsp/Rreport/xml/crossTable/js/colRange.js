	var target = null;
	var activation = null;
	var mouseX = -1;
	var mouseY = -1;
	var selectedCellInitialValue = 0;
	var changedColRange = false;

	var crossHeaderMaxWidthRate  = 0.8;	// 幅
	var crossHeaderMaxHeightRate = 0.8;	// 高さ


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
				var dataColumn = dataTable.all("DT_CG" + tmpColIndex);
				dataColumn.style.width = width;
			}
		} else if ( activation == "modifyCrossHeaderWidth" ) { 

			CRSHeaderObject.style.width = CRSHeaderObject.offsetWidth + delt;

			target.style.width = width;

			if ( method == "UP" ) {
				var crossRHObj = document.all("CROSS_RH");
				crossRHObj.style.width = CRSHeaderObject.offsetWidth;

				rowHeader.style.width = CRSHeaderObject.offsetWidth;

				var cgColIndex = getCOLIndexByCOLObj(target);
				var rowCOLObj = document.all( "RH_CG" + cgColIndex );
				rowCOLObj.style.width = width;

				var totalChangedWidth = target.offsetWidth - selectedCellInitialValue;
				dataTableArea.style.width = dataTableArea.offsetWidth - totalChangedWidth;
				colHeader.style.width = colHeader.offsetWidth - totalChangedWidth;
			}
		}

		scrollView();
		return;
	}

	function changeRowHeight(target,delt,activation,method) {
		var height = target.offsetHeight + delt;
		if (height <= 0) {
			height = "1px";
			target.style.height = height;
			scrollView();

			return;
		}

		target.style.height = height;
		if ( method == "UP" ) {

			if ( activation == "modifyRowHeaderHeight" ) {
				var tmpRowIndex = parseInt(getRowIndexByTRObj(target));
				var dataRow = dataTable.rows(tmpRowIndex);
				
				dataRow.style.height = height;

			} else if ( activation == "modifyCrossHeaderHeight" ) {
				var tmpCHRowIndex = target.rowIndex;
				var colHeaderRow = colHeader.firstChild.rows(tmpCHRowIndex);

				colHeaderRow.style.height = height;

				var totalChangedHeight = target.offsetHeight - selectedCellInitialValue;

				rowHeader.style.height = rowHeader.offsetHeight - totalChangedHeight;
				dataTableArea.style.height = dataTableArea.offsetHeight - totalChangedHeight;
			}
		}
		scrollView();
		return;
	}


	function mouseDown() {

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
			} else if ( onCrossHeaderCellVLine(window.event) ) {
				mousePosition = "crossHeaderCellVLine";
			} else if ( onRowHeaderCellHLine(window.event) ) {
				mousePosition = "rowHeaderCellHLine";
			} else if ( onCrossHeaderCellHLine(window.event) ) {
				mousePosition = "crossHeaderCellHLine";
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
				if ( tmpObj == null ) {
					if ( mousePosition == "columnHeaderCellVLine" ) {
						var crossHeaderLastColIndex = 0;
						if ( !isLastHie(srcEle) ) {
							crossHeaderLastColIndex = rowObjNum-1;
						} else {
							selectedCell = document.all("CrossHeader_R" + srcEle.parentNode.rowIndex).lastChild;
							crossHeaderLastColIndex = getColIndexByTDObj( selectedCell );
						}
						activation = "modifyCrossHeaderWidth";	// 動作の設定

						target = document.all( "CrossHeader_CG" + parseInt(crossHeaderLastColIndex));

						mouseX = event.clientX;					// X座標を登録
						selectedCellInitialValue = target.offsetWidth;
						return;
					}
				}

				if ( mousePosition == "columnHeaderCellVLine" ) {
					targetIndex = changeCellIndexToCHCOL(srcEle,-1,"RIGHT");
					tmpObj = colHeader.all("CH_CG" + targetIndex);
					if ( tmpObj != null ) {
						if ( tmpObj.offsetWidth == 0 ) {
							while( targetIndex != 0) {
								targetIndex = targetIndex -1;
								tmpObj = tmpObj.previousSibling;
								if ( tmpObj.offsetWidth != 0 ) {
									break;
								}
							}
						}
					}
				} else if ( mousePosition == "crossHeaderCellVLine" ) {
					targetIndex = getColIndexByTDObj(srcEle) - 1;
					tmpObj = document.all( "CrossHeader_CG" + targetIndex );
				} else {
					return;
				}
			} else if ( window.event.offsetX > srcEle.offsetWidth - 4) {

				if ( mousePosition == "columnHeaderCellVLine" ) {
					targetIndex = changeCellIndexToCHCOL(srcEle,0,"RIGHT");
					tmpObj = colHeader.all("CH_CG" + targetIndex);

					if ( tmpObj.offsetWidth == 0 ) {
						while( targetIndex != getColIndexByTDObj(srcEle) ) {
							targetIndex = targetIndex -1;
							tmpObj = tmpObj.previousSibling;
							if ( tmpObj.offsetWidth != 0 ) {
								break;
							}
						}
					}

				} else if ( mousePosition == "crossHeaderCellVLine" ) {
					if ( !isInCrossHeaderLastRow(srcEle) ) {
						targetIndex = rowObjNum-1;
					} else {
						targetIndex = getColIndexByTDObj(srcEle);
					}
					tmpObj = document.all( "CrossHeader_CG" + targetIndex );

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

		if ( ( mousePosition == "rowHeaderCellHLine" ) || ( mousePosition == "crossHeaderCellHLine" ) ) {
			if ( window.event.offsetY < 3 ) {
				tmpObj = srcEle.parentNode.previousSibling;
				if ( tmpObj == null ) {
					if ( mousePosition == "rowHeaderCellHLine" ) {

						tmpObj = document.all("CrossHeaderArea").firstChild.lastChild.lastChild;
						activation = "modifyCrossHeaderHeight";
						target = tmpObj;

						selectedCellInitialValue = target.offsetHeight;
						mouseY = event.clientY;

						return;
					} else if ( mousePosition == "crossHeaderCellHLine" ) {
						return null;
					} else {
						return null;
					}
				}
				if ( mousePosition == "rowHeaderCellHLine" ) {
					var tmpRowIndex = tmpObj.rowIndex;
					if ( tmpObj.style.display == 'none' ) {
						while( tmpRowIndex != 0) {
							tmpRowIndex = tmpRowIndex -1;
							tmpObj = tmpObj.previousSibling;
							if ( tmpObj.style.display != 'none' ) {
								break;
							}
						}
					}
				}

			} else if ( window.event.offsetY > srcEle.offsetHeight - 4) {

				if ( mousePosition == "rowHeaderCellHLine" ) {
					comboNum = getLowerHieComboNum(srcEle,"ROW");
					targetIndex = srcEle.parentNode.rowIndex + comboNum -1;
					tmpObj = srcEle.parentNode.parentNode.rows[targetIndex];

					var tmpRowIndex = tmpObj.rowIndex;
					if ( tmpObj.style.display == 'none' ) {
						while( tmpRowIndex != srcEle.parentNode.rowIndex) {
							tmpRowIndex = tmpRowIndex -1;
							tmpObj = tmpObj.previousSibling;
							if ( tmpObj.style.display != 'none' ) {
								break;
							}
						}
					}

				} else if ( mousePosition == "crossHeaderCellHLine" )  {
					tmpObj = srcEle.parentNode;			// TR Object
				} else {
					return null;
				}
			} else {
				return null;
			}

			target = tmpObj;
			if ( mousePosition == "rowHeaderCellHLine" ) {
				activation = "modifyRowHeaderHeight";
			} else if ( mousePosition == "crossHeaderCellHLine" )  {
				activation = "modifyCrossHeaderHeight";
				selectedCellInitialValue = target.offsetHeight;
			} else {
				return null;
			}
			mouseY = event.clientY
			return;
		}

		event.cancelBubble = true;

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
			
			if ( ( activation == "modifyRowHeaderHeight" ) || ( activation == "modifyCrossHeaderHeight" ) ) {
				var delt = window.event.clientY - mouseY;

				if ( ( activation == "modifyCrossHeaderHeight" ) && 
                     ( document.body.clientHeight * crossHeaderMaxHeightRate ) < parseInt(CRSHeaderObject.offsetHeight + delt + spreadTable.rows[0].offsetHeight + spreadTable.rows[1].offsetHeight ) ) {
					return;
				}
				var method = "MOVE";
				retCode = changeRowHeight(target,delt,activation,method);

				mouseY = window.event.clientY;
				return;
			}

		} else {
			var pointedCell = window.event.srcElement;
			if ( onColumnHeaderCellVLine(window.event) == true ) {
				pointedCell.style.cursor = "col-resize";
			} else if ( onRowHeaderCellHLine(window.event) == true ) {
					pointedCell.style.cursor = "row-resize";
			} else if ( onCrossHeaderCellVLine(window.event) == true ) {
					pointedCell.style.cursor = "col-resize";
			} else if ( onCrossHeaderCellHLine(window.event) == true ) {
					pointedCell.style.cursor = "row-resize";
			} else if (window.event.srcElement.tagName=='IMG' || window.event.srcElement.tagName=='DIV') {
				if (window.event.srcElement.style.cursor == "") {
					pointedCell.style.cursor = "default";
				} else {
					pointedCell.style.cursor = window.event.srcElement.style.cursor;
				}
			} else {
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
				changedColRange = true;

				return;
			}

			if ( ( activation == "modifyRowHeaderHeight" ) || ( activation == "modifyCrossHeaderHeight" ) ) {
				var delt = window.event.clientY - mouseY;
				var method = "UP";

				if ( ( activation == "modifyCrossHeaderHeight" ) && 
                     ( document.body.clientHeight * crossHeaderMaxHeightRate ) < parseInt(CRSHeaderObject.offsetHeight + delt + spreadTable.rows[0].offsetHeight + spreadTable.rows[1].offsetHeight ) ) {
					retCode = changeRowHeight(target,0,activation,method);
				} else {
					retCode = changeRowHeight(target,delt,activation,method);
				}

				target = null;
				activation = null;
				mouseX = -1;
				mouseY = -1;
				selectedCellInitialValue = 0;
				changedColRange = true;

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
		if ( thisEvent.offsetX < 3 ) {
			return true;
		} else if ( thisEvent.offsetX > ele.offsetWidth - 4) {
			return true;
		}
		return false;
	}


	function onRowHeaderCellHLine( thisEvent ) {
		var ele = thisEvent.srcElement;
		if ( ( ele.tagName != "TD" ) || ( ele.parentElement.tagName != "TR" ) ) {
			return false;
		}
		if ( ele.parentElement.Spread != "RowHeaderRow" ) {
			return false;
		}

		if ( thisEvent.offsetY < 3 ) {
			return true;
		} else if ( thisEvent.offsetY > ele.offsetHeight - 4) {
			return true;
		}
		return false;
	}

	function onCrossHeaderCellHLine( thisEvent ) {
		var ele = thisEvent.srcElement;
		if ( ele.tagName == "DIV" ) {
			ele = ele.parentElement;
		}
		if ( !isInCrossHeaderAreaByTDObj( ele ) ) {
			return false;
		}

		if ( thisEvent.offsetY < 3 ) {
			//一行目のセル上部の場合は、「false」を返す
			if ( ele.parentNode.rowIndex == 0 ) {
				return false;
			}
			return true;
		} else if ( thisEvent.offsetY > ele.offsetHeight - 4) {
			return true;
		}
		return false;
	}

	function onCrossHeaderCellVLine( thisEvent ) {
		var ele = thisEvent.srcElement;
		if ( !isInCrossHeaderAreaByTDObj( ele ) ) {
			return false;
		}

		if ( thisEvent.offsetX < 3 ) {
			//一列目のセル左部の場合は、「false」を返す
			if ( ele.cellIndex == 0 ) {
				return false;
			}
			return true;
		} else if ( thisEvent.offsetX > ele.offsetWidth - 4) {
			return true;
		}
		return false;
	}

	var spreadTable   = null;
	var dataTableArea = null;
	var dataTable     = null;
	var colHeader     = null;
	var rowHeader     = null;
	var CRSHeaderObject = null;

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


//	function loadSpread() {

		spreadTable   = document.all("SpreadTable");
		dataTableArea = document.all("DataTableArea");
		dataTable     = dataTableArea.firstChild;
		colHeader     = document.all("ColumnHeaderArea");
		rowHeader     = document.all("RowHeaderArea");
		CRSHeaderObject = document.all("CrossHeaderArea");

		var metaDataArea = document.all("metaDataArea");
		colObjNum = parseInt(metaDataArea.all("colHiesCount").innerText);
		rowObjNum = parseInt(metaDataArea.all("rowHiesCount").innerText);

		for ( var j = 0; j < getHeaderObjNum("ROW"); j++ ) {
			changeCellWidth(document.all("CrossHeader_CG" + j), 40, "modifyCrossHeaderWidth", "UP");
		}

		resizeArea();

		dataTableArea.onscroll = scrollView;
//spreadTable.style.visibility='visible';

//************************************************************************
	var tbl = document.getElementById("RowHeaderTable");
	var tbl2 = document.getElementById("ColumnHeaderTable");

		if(tbl.line=='simple' || tbl.rows.length<=1){
		}else{
			var colCnt = tbl.rows[1].cells.length-1;
			var rowCnt = tbl.rows.length-1;
			var preData="";
			var startRow=0;
			var sameCnt=0;

			for(var i=(colCnt-1);i>=0;i=i-1){
				for(var j=0;j<rowCnt;j++){
					if((preData==tbl.rows[j].cells[i].outerText)==false){
//						if(startRow!=0){
							tbl.rows[startRow].cells[i].rowSpan=sameCnt+1;
//						}
						startRow=j;
						preData=tbl.rows[j].cells[i].outerText;
						sameCnt=0;
					}else{
						sameCnt++;
						tbl.rows[j].deleteCell(i);
					}
				}
				tbl.rows[startRow].cells[i].rowSpan=sameCnt+1;
				preData="";
			}
//**************************************************
			if(tbl2.rows.length<=1){
			}else{

				colCnt = tbl2.rows[1].cells.length-1;
	//alert(colCnt);
				rowCnt = tbl2.rows.length-1;
	//alert(rowCnt);
				preData="";
				startCol=colCnt;
				sameCnt=0;

	//			for(var j=0;j<rowCnt;j++){
				for(var j=(rowCnt-1);j>=0;j=j-1){
					for(var i=(colCnt-1);i>=0;i=i-1){
	//				for(var i=0;i<colCnt;i++){
	//alert(j+":"+i);
	//alert(tbl2.rows[j].cells[i].outerHTML);
						if((preData==tbl2.rows[j].cells[i].outerText)==false){
	//						if(startCol!=1){
	//alert(tbl2.rows[j].cells[i+1].outerHTML);
								tbl2.rows[j].cells[i+1].colSpan=sameCnt+1;
	//						}
							startCol=j;
							preData=tbl2.rows[j].cells[i].outerText;
							sameCnt=0;
						}else{
							sameCnt++;
							tbl2.rows[j].deleteCell(i);
						}
					}
					tbl2.rows[j].cells[i+1].colSpan=sameCnt+1;
					preData="";
				}
			}
		}

//************************************************************************

//alert(tabRow.outerHTML);

spreadTable.style.visibility='visible';
//	}

	function scrollView() {

		rowHeader.scrollTop = dataTableArea.scrollTop;
		colHeader.scrollLeft= dataTableArea.scrollLeft;
	}

	function resizeArea() {
		if ( document.body.clientWidth != 0 ) {

			var newWidth  = ( document.body.clientWidth - rowHeader.offsetWidth - 7 ) 
			var areaHeight;
					areaHeight = (colHeader.offsetHeight
									+ spreadTable.rows[0].offsetHeight
									+ spreadTable.rows[1].offsetHeight
								 );

			var newHeight = ( document.body.clientHeight 
			                   - areaHeight
			                 );

			if ( newWidth <= 0 ) {
				return;
			} else if ( newHeight <= 0 ) {
				return;
			}

			colHeader.style.width      = newWidth;
			dataTableArea.style.width  = newWidth;

			rowHeader.style.height     = newHeight;
			dataTableArea.style.height = newHeight;

			scrollView();
		}
	}


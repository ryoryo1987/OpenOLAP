	cellJoin();
	function cellJoin(){
		//Set Property
		var tbl = document.getElementById("tblTableBody");

		if(tbl.line=='simple'){
			return;
		}

		if(tbl.rows.length<=1){
			return;
		}

		var colCnt = tbl.rows[1].cells.length;
		var rowCnt = tbl.rows.length;
		var preData="";
		var startRow=0;
		var sameCnt=0;

		tbl.style.display='none';
		for(i=(colCnt-1);i>=0;i=i-1){
			for(j=1;j<rowCnt;j++){
				if((preData==tbl.rows[j].cells[i].outerText)==false){
					if(startRow!=0){
						tbl.rows[startRow].cells[i].rowSpan=sameCnt+1;
					}
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
		tbl.style.display='block';
	}

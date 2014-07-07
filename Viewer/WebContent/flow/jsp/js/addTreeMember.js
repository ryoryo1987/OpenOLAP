//Clickされたイメージのオブジェクトを入れておく。
var preClickObj = new Object;
var preRightClickObj = new Object;
var preAddObj = new Object;
preClickObj.src = "null";

//RightClick (true:'Copy' is selected; false:'Paste' was finished normally and 'Copy' is not selected)
var rc_copied_flg = false;

//新規作成Treeの中から、対象のNodeをSerchする。
function serchObject(argObjKind,objId,kind) {
var returnObj = new Object;

//  引数により、どのNodeを返すかを設定
	if (argObjKind == 'DimensionTop') {
		returnObj = document.getElementById("DimensionTop");
	} else if (argObjKind == 'SegmentDimensionTop') {
		returnObj = document.getElementById("SegmentDimensionTop");
	} else if (argObjKind == 'MeasureTop') {
		returnObj = document.getElementById("MeasureTop");
	} else if (argObjKind == 'SQLTuning') {
		returnObj = document.getElementById("SQLTuning");
	} else if (argObjKind == 'CustomMeasureTop') {
		returnObj = document.getElementById("CustomMeasureTop");
	} else if (argObjKind == 'CustomDimensionTop') {
		returnObj = document.getElementById("CustomDimensionTop");
	} else if (argObjKind == 'CustomSegmentDimensionTop') {
		returnObj = document.getElementById("CustomSegmentDimensionTop");
//	} else if (argObjKind == 'CustomDimSchema') {
//		returnObj = document.getElementById("CustomDimSchema");
//	} else if (argObjKind == 'CustomSegDimSchema') {
//		returnObj = document.getElementById("CustomSegDimSchema");
	}

	if (kind == 'CHILD') {
		//	返されたNodeがChildを持っていたら、その中から適した場所をSearchする
		if(returnObj.lastChild.hasChildNodes()){
			var obj_user;
			var char_cnt;
			len = returnObj.lastChild.childNodes.length;
			//IDが等しかったらNode取得
			for(i=0;i<len;i++){
				if (objId==returnObj.lastChild.childNodes[i].id){
					returnObj = returnObj.lastChild.childNodes[i];
					return returnObj;
				}
			}
		}
	}
	return returnObj;
}

function serchObject2(obj,objId){
	if(obj.lastChild.hasChildNodes()){
		var obj_user;
		var char_cnt;
		len = obj.lastChild.childNodes.length;
		//IDが等しかったらNode取得
		for(i=0;i<len;i++){
			if (objId==obj.lastChild.childNodes[i].id){
				obj = obj.lastChild.childNodes[i];
				return obj;
			}
		}
	}
}

function addObjects(objKind,updateKind,objId,objName) {
	top.frames[1].document.navi_form.change_flg.value = 0;


	var addObj= new Object;
	var tempObj = new Object;
	var tempParentNode;

	if(objKind=='Schema'||objKind=='SchemaTop'){
		if(updateKind==0){
			//User
			addObj = createTreeNode('Schema',objId,objName,'frm_user','Schema2');
			preClickObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
			//Dimension
			objId2 = objId + ",0";
			addObj = createTreeNode('DimensionSchema',objId2,objName,'frm_dimension','Schema2');
			tempObj=serchObject('DimensionTop',objId2,'');
			tempObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
			//Segment Dimension
			objId2 = objId + ",0";
			addObj = createTreeNode('SegmentDimensionSchema',objId2,objName,'frm_seg_dimension','Schema2');
			tempObj=serchObject('SegmentDimensionTop',objId2,'');
			tempObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
			//Measure
			objId2 = objId + ",0";
			addObj = createTreeNode('MeasureSchema',objId2,objName,'frm_measure','Schema2');
			tempObj=serchObject('MeasureTop',objId2,'');
			tempObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
			//Dimension
			addObj = createTreeNode('CustomDimSchema',objId,objName,'','Schema2');
			tempObj=serchObject('CustomDimensionTop',objId,'');
			tempObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
			//Segment Dimension
			objId2 = objId + ",0";
			addObj = createTreeNode('CustomSegDimSchema',objId,objName,'','Schema2');
			tempObj=serchObject('CustomSegmentDimensionTop',objId,'');
			tempObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
		}else if(updateKind==1){
			updateNodeName(preClickObj,objId,objName,'THIS');
			//Dimension
			objId2 = objId + ",0";
			tempObj=serchObject('DimensionTop',objId2,'');
			updateNodeName(tempObj,objId2,objName,'CHILD');
			//Segment Dimension
			objId2 = objId + ",0";
			tempObj=serchObject('SegmentDimensionTop',objId2,'');
			updateNodeName(tempObj,objId2,objName,'CHILD');
			//Measure
			objId2 = objId + ",0";
			tempObj=serchObject('MeasureTop',objId2 ,'');
			updateNodeName(tempObj,objId2,objName,'CHILD');

			tempObj=serchObject('CustomDimensionTop',objId ,'');
			updateNodeName(tempObj,objId,objName,'CHILD');

			tempObj=serchObject('CustomSegmentDimensionTop',objId ,'');
			updateNodeName(tempObj,objId,objName,'CHILD');
		}else if(updateKind==2){
			//User
			tempObj = preClickObj;
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');

			//Dimension
			objId2 = objId + ",0";
			tempObj=serchObject('DimensionTop',objId2,'CHILD');
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');

			//Segment Dimension
			objId2 = objId + ",0";
			tempObj=serchObject('SegmentDimensionTop',objId2,'CHILD');
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');

			//Measure
			objId2 = objId + ",0";
			tempObj=serchObject('MeasureTop',objId2,'CHILD');
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');


			tempObj=serchObject('CustomDimensionTop',objId,'CHILD');
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');

			tempObj=serchObject('CustomSegmentDimensionTop',objId,'CHILD');
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');


		}
	}else if(objKind=='Dimension'||objKind=='DimensionSchema'){
		if(updateKind==0){
			addObj = createTreeNode('Dimension',objId,objName,'frm_dimension','Dimension2');
			preClickObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');

			//CustomDimension
			addObj = createTreeNode('CustomDimension',objId.substring(objId.indexOf(",")+1)+',0',objName,'frm_cust_dim','Dimension2');
			tempObj=serchObject('CustomDimensionTop',objId.substring(0,objId.indexOf(",")),'CHILD');
			tempObj.lastChild.appendChild(addObj);
			tempObj=createTreeNode('DimParts',objId.substring(objId.indexOf(",")+1)+',1','標準','frm_cust_dim','DimParts2');
			addObj.lastChild.appendChild(tempObj);
			thisAndPreviousNode(addObj,'ALL');

		}else if(updateKind==1){
			updateNodeName(preClickObj,objId,objName,'THIS');
			
			tempObj=serchObject('CustomDimensionTop',objId.substring(0,objId.indexOf(",")),'CHILD');//スキーマ
//			tempObj=serchObject2(tempObj,objId.substring(objId.indexOf(",")+1)+',0');
			updateNodeName(tempObj,objId.substring(objId.indexOf(",")+1)+',0',objName,'CHILD');

		}else if(updateKind==2){
			tempObj = preClickObj;
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');

			tempObj=serchObject('CustomDimensionTop',objId.substring(0,objId.indexOf(",")),'CHILD');//スキーマ
			tempObj=serchObject2(tempObj,objId.substring(objId.indexOf(",")+1)+',0');
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');

		}else if(updateKind==9){//copy
			addObj = createTreeNode('Dimension',objId,objName,'frm_dimension','Dimension2');
			preRightClickObj.parentNode.parentNode.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');

			//CustomDimension
			addObj = createTreeNode('CustomDimension',objId.substring(objId.indexOf(",")+1)+',0',objName,'frm_cust_dim','Dimension2');
			tempObj=serchObject('CustomDimensionTop',objId.substring(0,objId.indexOf(",")),'CHILD');
			tempObj.lastChild.appendChild(addObj);
			tempObj=createTreeNode('DimParts',objId.substring(objId.indexOf(",")+1)+',1','標準','frm_cust_dim','DimParts2');
			addObj.lastChild.appendChild(tempObj);
			thisAndPreviousNode(addObj,'ALL');

		}
	}else if(objKind=='SegmentDimension'||objKind=='SegmentDimensionSchema'){
		if(updateKind==0){
			addObj = createTreeNode('SegmentDimension',objId,objName,'frm_seg_dimension','SegmentDimension2');
			preClickObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');

			//CustomSegmentDimensionTop
			addObj = createTreeNode('CustomSegmentDimension',objId.substring(objId.indexOf(",")+1)+',0',objName,'frm_segment_dim','SegmentDimension2');
			tempObj=serchObject('CustomSegmentDimensionTop',objId.substring(0,objId.indexOf(",")),'CHILD');
			tempObj.lastChild.appendChild(addObj);
			tempObj=createTreeNode('SegmentParts',objId.substring(objId.indexOf(",")+1)+',1','標準','frm_segment_dim','SegParts2');
			addObj.lastChild.appendChild(tempObj);
			thisAndPreviousNode(addObj,'ALL');

		}else if(updateKind==1){
			updateNodeName(preClickObj,objId,objName,'THIS');

			tempObj=serchObject('CustomSegmentDimensionTop',objId.substring(0,objId.indexOf(",")),'CHILD');//スキーマ
//			tempObj=serchObject2(tempObj,objId.substring(objId.indexOf(",")+1)+',0');
			updateNodeName(tempObj,objId.substring(objId.indexOf(",")+1)+',0',objName,'CHILD');

		}else if(updateKind==2){
			tempObj = preClickObj;
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');

			tempObj=serchObject('CustomSegmentDimensionTop',objId.substring(0,objId.indexOf(",")),'CHILD');//スキーマ
			tempObj=serchObject2(tempObj,objId.substring(objId.indexOf(",")+1)+',0');
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');

		}else if(updateKind==9){//copy
			addObj = createTreeNode('SegmentDimension',objId,objName,'frm_seg_dimension','SegmentDimension2');
			preRightClickObj.parentNode.parentNode.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');

			//CustomSegmentDimensionTop
			addObj = createTreeNode('CustomSegmentDimension',objId.substring(objId.indexOf(",")+1)+',0',objName,'frm_segment_dim','SegmentDimension2');
			tempObj=serchObject('CustomSegmentDimensionTop',objId.substring(0,objId.indexOf(",")),'CHILD');
			tempObj.lastChild.appendChild(addObj);
			tempObj=createTreeNode('SegmentParts',objId.substring(objId.indexOf(",")+1)+',1','標準','frm_segment_dim','SegParts2');
			addObj.lastChild.appendChild(tempObj);
			thisAndPreviousNode(addObj,'ALL');
		}
	}else if(objKind=='TimeDimension'||objKind=='TimeDimensionTop'){
		if(updateKind==0){
			addObj = createTreeNode('TimeDimension',objId,objName,'frm_time','TimeDimension2');
			preClickObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
		}else if(updateKind==1){
			updateNodeName(preClickObj,objId,objName,'THIS');
		}else if(updateKind==2){
			tempObj = preClickObj;
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');
		}else if(updateKind==9){//copy
			addObj = createTreeNode('TimeDimension',objId,objName,'frm_time','TimeDimension2');
			preRightClickObj.parentNode.parentNode.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
		}
	}else if(objKind=='Measure'||objKind=='MeasureSchema'){
		if(updateKind==0){
			addObj = createTreeNode('Measure',objId,objName,'frm_measure','Measure2');
			preClickObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
		}else if(updateKind==1){
			updateNodeName(preClickObj,objId,objName,'THIS');
		}else if(updateKind==2){
			tempObj = preClickObj;
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');
		}else if(updateKind==9){//copy
			addObj = createTreeNode('Measure',objId,objName,'frm_measure','Measure2');
			preRightClickObj.parentNode.parentNode.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
		}
	}else if(objKind=='Cube'||objKind=='CubeTop'){
		if(updateKind==0){
			tempObj = createTreeNode('CubeStructure',objId,'キューブ構成','frm_cubesct','CubeStructure2');
			addObj = createTreeNode('Cube',objId,objName,'frm_cube','Cube2');
			addObj.lastChild.appendChild(tempObj);
			preClickObj.lastChild.appendChild(addObj);
			preAddObj = addObj;
			thisAndPreviousNode(addObj,'ALL');

			//CustomMeasureTop
			addObj = createTreeNode('CustomMeasureCube',objId+",0",objName,'frm_formula','Cube2');
			tempObj=serchObject('CustomMeasureTop',objId,'');
			tempObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');

			//SQLTuning
			addObj = createTreeNode('SQLTuningCube',objId+",0",objName,'frm_sqltng','Cube2');
			tempObj=serchObject('SQLTuning',objId,'');
			tempObj.lastChild.appendChild(addObj);

			tempObj=createTreeNode('SQLTuningCategory',objId+",1",'キューブ定義','frm_sqltng','SQLTuningCategory2');
			addObj.lastChild.appendChild(tempObj);
			tempObj=createTreeNode('SQLTuningCategory',objId+",2",'データロード','frm_sqltng','SQLTuningCategory2');
			addObj.lastChild.appendChild(tempObj);
			tempObj=createTreeNode('SQLTuningCategory',objId+",3",'集計','frm_sqltng','SQLTuningCategory2');
			addObj.lastChild.appendChild(tempObj);
			tempObj=createTreeNode('SQLTuningCategory',objId+",4",'カスタムメジャー','frm_sqltng','SQLTuningCategory2');
			addObj.lastChild.appendChild(tempObj);

			thisAndPreviousNode(addObj,'ALL');
		}else if(updateKind==1){
			updateNodeName(preClickObj,objId,objName,'THIS');

			//CustomMeasureTop
			tempObj=serchObject('CustomMeasureTop',objId+",0",'CHILD');
			updateNodeName(tempObj,objId,objName,'THIS');

			//SQLTuning
			objId = objId + ",0";
			tempObj=serchObject('SQLTuning',objId,'');
			updateNodeName(tempObj,objId,objName,'CHILD');
		}else if(updateKind==2){
			tempObj = preClickObj;
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');

			//CustomMeasureTop
			tempObj=serchObject('CustomMeasureTop',objId+",0",'CHILD');
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');

			//SQLTuning
			objId = objId + ",0";
			tempObj=serchObject('SQLTuning',objId,'CHILD');
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');
		}else if(updateKind==9){
			tempObj = createTreeNode('CubeStructure',objId,'キューブ構成','frm_cubesct','CubeStructure2');
			addObj = createTreeNode('Cube',objId,objName,'frm_cube','Cube2');
			addObj.lastChild.appendChild(tempObj);
			preRightClickObj.parentNode.parentNode.lastChild.appendChild(addObj);
			preAddObj = addObj;
			thisAndPreviousNode(addObj,'ALL');

			//CustomMeasureTop
			addObj = createTreeNode('CustomMeasureCube',objId+",0",objName,'frm_formula','Cube2');
			tempObj=serchObject('CustomMeasureTop',objId,'');
			tempObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');

			//SQLTuning
			addObj = createTreeNode('SQLTuningCube',objId+",0",objName,'frm_sqltng','Cube2');
			tempObj=serchObject('SQLTuning',objId,'');
			tempObj.lastChild.appendChild(addObj);

			tempObj=createTreeNode('SQLTuningCategory',objId+",1",'キューブ定義','frm_sqltng','SQLTuningCategory2');
			addObj.lastChild.appendChild(tempObj);
			tempObj=createTreeNode('SQLTuningCategory',objId+",2",'データロード','frm_sqltng','SQLTuningCategory2');
			addObj.lastChild.appendChild(tempObj);
			tempObj=createTreeNode('SQLTuningCategory',objId+",3",'集計','frm_sqltng','SQLTuningCategory2');
			addObj.lastChild.appendChild(tempObj);
			tempObj=createTreeNode('SQLTuningCategory',objId+",4",'カスタムメジャー','frm_sqltng','SQLTuningCategory2');
			addObj.lastChild.appendChild(tempObj);

			thisAndPreviousNode(addObj,'ALL');
		}
	}else if(objKind=='CustomMeasureCube'||objKind=='CustomMeasure'){
		if(updateKind==0){
			addObj = createTreeNode('CustomMeasure',objId,objName,'frm_formula','CustomMeasure2');
			preClickObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
		}else if(updateKind==1){
			updateNodeName(preClickObj,objId,objName,'THIS');
		}else if(updateKind==2){
			tempObj = preClickObj;
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');
		}
	}else if(objKind=='CustomDimension'||objKind=='DimParts'){
		if(updateKind==0){
			addObj = createTreeNode('DimParts',objId,objName,'frm_cust_dim','DimParts2');
			preClickObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
		}else if(updateKind==1){
			updateNodeName(preClickObj,objId,objName,'THIS');
		}else if(updateKind==2){
			tempObj = preClickObj;
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');
		}else if(updateKind==9){//copy
			addObj = createTreeNode('DimParts',objId,objName,'frm_cust_dim','DimParts2');
			preRightClickObj.parentNode.parentNode.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
		}
	}else if(objKind=='CustomSegmentDimension'||objKind=='SegmentParts'){
		if(updateKind==0){
			addObj = createTreeNode('SegmentParts',objId,objName,'frm_segment_dim','SegParts2');
			preClickObj.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
		}else if(updateKind==1){
			updateNodeName(preClickObj,objId,objName,'THIS');
		}else if(updateKind==2){
			tempObj = preClickObj;
			tempParentNode=tempObj.parentNode.parentNode;
			tempObj.parentNode.removeChild(tempObj);
			thisAndLastChildNode(tempParentNode,'ALL');
		}else if(updateKind==9){//copy
			addObj = createTreeNode('SegmentParts',objId,objName,'frm_segment_dim','SegParts2');
			preRightClickObj.parentNode.parentNode.lastChild.appendChild(addObj);
			thisAndPreviousNode(addObj,'ALL');
		}
	}

	if(updateKind!=9){
		getReturnMsg(objName,updateKind);
		updateTreeObjToggle(updateKind);
	}

}
//**********************************************************************


//*****************************************************
//*******           Create Object         *************
//*****************************************************
function createTreeNode(objKind,objId,objName,fileName,imageFileName){
	fileName = ''+fileName+'.jsp';
	imageFileName = '../images/'+imageFileName+'.gif';

	addObj=createNodeDivObj(objKind,objId);
	tempObj=createPMImageObj();
		addObj.appendChild(tempObj);
	tempObj=createImageObj(objKind,objId,imageFileName,fileName);
		addObj.appendChild(tempObj);
	tempObj=createAhrefObj(objKind,objId,objName,fileName);
		addObj.appendChild(tempObj);
	tempObj=createDivC_Obj(objId);
		addObj.appendChild(tempObj);
	return addObj;
}

function createNodeDivObj(objKind,objId){
	var tempObj;
	tempObj = document.createElement("<div objkind='"+objKind+"' id='"+objId+"' class='treeItem'></div>");
	return tempObj;
}

function createPMImageObj(){
	var tempObj;
	tempObj = document.createElement("<img id='5' src='../images/tree/Lplus.gif' onclick=JavaScript:Toggle('TP',this,''); ondragstart='return false;'>");
	return tempObj;
}

function createImageObj(objKind,objId,imageFileName,fileName){
	var tempObj;
	tempObj = document.createElement("<img objkind='"+objKind+"' id='"+objId+"' src='"+imageFileName+"' onclick=\"javascript:Toggle('f',this,'"+fileName+"?id="+objId+"')\" ondragstart=\"javascript:startDrag(); return false\">");
	return tempObj;
}

function createAhrefObj(objKind,objId,objName,fileName){
	var tempObj;
	tempObj = document.createElement("<a href=\"return false;\" onclick=\"javascript:Toggle('f',this,'"+fileName+"?id="+ objId + "'); return false;\" id='"+objId+"' name='"+objId+"' ondrop=\"javascript:drop();  return false\" ondragover=\"javascript:overDrag(); return false\" ondragleave=\"javascript:leaveDrag(); return false\" ondragenter=\"javascript:enterDrag(); return false\" ondragend=\"javascript:endDrag(); return false\" ondragstart=\"javascript:startDrag(); return false\" ondblclick=\"javascript:ToggleDblClick('0',this,'frm_user.jsp?id="+objId+"')\"  objkind='"+objKind+"'>"+objName+"</a>");
	tempObj.innerHTML=objName;
	return tempObj;
}

function createDivC_Obj(objId){
	var tempObj;
	tempObj = document.createElement("<div id='"+objId+"-C' style='display:none;' class='container'></div>");
	return tempObj;
}

//テキストをノード化する
function textToDomObj(textObj){
	var tempXml = new ActiveXObject("MSXML2.DOMDocument");
	tempXml.async = false;
	tempXml.loadXML(textObj);
	var tempNode=tempXml.firstChild;
	return tempNode;
}


//XMLとXSLTを合わせページ更新（DOMを書き換えた後）
function domReload(frmXML,frmReload){//XMLページ再読み込み
	frmReload.document.open();//ドキュメントの初期化
	var strResult = frmXML.XMLData.transformNode(frmXML.objXSL);
	frmReload.document.write(strResult);
}

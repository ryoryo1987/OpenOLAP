//�e�L�X�g���m�[�h������
function textToDomObj(textObj){
	var tempXml = new ActiveXObject("MSXML2.DOMDocument");
	tempXml.async = false;
	tempXml.loadXML(textObj);
	var tempNode=tempXml.firstChild;
	return tempNode;
}


//XML��XSLT�����킹�y�[�W�X�V�iDOM��������������j
function domReload(frmXML,frmReload){//XML�y�[�W�ēǂݍ���
	frmReload.document.open();//�h�L�������g�̏�����
	var strResult = frmXML.XMLData.transformNode(frmXML.objXSL);
	frmReload.document.write(strResult);
}

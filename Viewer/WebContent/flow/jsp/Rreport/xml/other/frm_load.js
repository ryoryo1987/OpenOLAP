function changeMode(no,modeValue){
	for(i=1;i<=3;i++){
	//	document.all("mode" + i).src=document.all("mode" + i).src.replace("on.gif","off.gif");
	//	document.all("mode" + i).className=document.all("mode" + i).className.replace("selected","normal");
	//	document.all("mode" + i).className=document.all("mode" + i).className.replace("out","normal");
	//	document.all("mode" + i).className=document.all("mode" + i).className.replace("down","normal");
	//	document.all("mode" + i).className=document.all("mode" + i).className.replace("over","normal");
	//	document.all("mode" + i).className=document.all("mode" + i).className.replace("up","normal");
		document.all("mode" + i).className="normal_"+document.all("mode" + i).mode;
	}
//	document.all("mode" + no).src=document.all("mode" + no).src.replace("off.gif","on.gif");
//	document.all("mode" + no).className=document.all("mode" + no).className.replace("normal","selected");
	document.all("mode" + no).className="selected_"+document.all("mode" + no).mode;
	document.all.hid_mode.value=modeValue;
}

function getXMLData(){
	return XMLDoc;
}


	var XMLDoc = new ActiveXObject("MSXML2.DOMDocument");
	XMLDoc.async = false;

	var a = document.form_main.xmlText.innerHTML;
	a=a.replace(/&lt;/g,"<");
	a=a.replace(/&gt;/g,">");
	XMLDoc.loadXML("<?xml version='1.0' encoding='Shift_JIS'?>"+a);
	document.form_main.xmlText.innerHTML="";

	//å„Ç≈ÅAì«Ç›çûÇﬁ
	document.form_main.target = "frm_chart";
	document.form_main.action = "xml/other/chart_main.html";
	document.form_main.submit();


	changeMode(1,'Look');


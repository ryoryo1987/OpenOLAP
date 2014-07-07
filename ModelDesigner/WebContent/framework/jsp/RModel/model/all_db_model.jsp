<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS"/>
	<link rel="stylesheet" type="text/css" href="../../css/tree.css"/>
	<script language="JavaScript1.2" src="../../js/dbtree.js"></script>
</head>

<body style="margin-top:0px;margin-left:0px;padding-top:0px;">
<!--<body style="margin-top:0px;margin-left:0px;padding-top:0px;background : url('../../../images/title.gif') white repeat-x">-->
<!--<body onload="createPopUpMenu()" onContextmenu="return false">-->
<form name="navi_form" id="navi_form" target="navi_frm" method="post" action="">


	<!--**************************************************************-->
		<div id="root"  class="treeItem">

<script>
	var RmodelXML2 = new ActiveXObject("MSXML2.DOMDocument");
	RmodelXML2.async = false;
	RmodelXML2.loadXML(parent.RmodelXML.selectSingleNode("*").xml);
/*
	var tempXML = new ActiveXObject("MSXML2.DOMDocument");
	tempXML.setProperty("SelectionLanguage", "XPath");

	var tempStr='';
	tempStr+='<?xml version="1.0" encoding="Shift_JIS"?>';
	tempStr+='<Table name="AllTables">';
	tempStr+='<logical_model name="All Tables">';
	tempStr+='<select_clause id="select_clause">';
	tempXML = parent.RmodelXML.selectNodes("/RDBModel/db_tables/db_table/logical_model/select_clause");
	for(i=0;i<tempXML.length;i++){
		for(j=0;j<tempXML.item(i).childNodes.length;j++){
			tempStr+=tempXML.item(i).childNodes[j].xml;
		}
	}
	tempStr+='</select_clause>';
	tempStr+='<where_clause id="where_clause">';
	tempXML = parent.RmodelXML.selectNodes("/RDBModel/db_tables/db_table/logical_model/where_clause");
	for(i=0;i<tempXML.length;i++){
		for(j=0;j<tempXML.item(i).childNodes.length;j++){
			tempStr+=tempXML.item(i).childNodes[j].xml;
		}
	}
	tempStr+='</where_clause>';
	tempStr+='</logical_model>';
	tempStr+='</Table>';


	RmodelXML2.loadXML(tempStr);


//	document.write("<pre>"+tempStr.replace(/>/g,"&gt;").replace(/</g,"&lt;")+"</pre>");

*/
	var RmodelXSL = new ActiveXObject("MSXML2.DOMDocument");
	RmodelXSL.async = false;
//	RmodelXSL.load("all_db_model.xsl");
	RmodelXSL.load("mapping_db.xsl");

	var dbHTML = RmodelXML2.transformNode(RmodelXSL);
	document.write(dbHTML);

//document.all.div1.innerHTML=tempStr;
</script>


		</div>
<div id="nonDisp" style='display:none'>
</div>
	<!--**************************************************************-->
<div id="div1">
</div>

</form>
</body>
</html>


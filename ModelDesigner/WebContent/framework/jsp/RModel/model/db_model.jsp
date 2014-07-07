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
	RmodelXML2.setProperty("SelectionLanguage", "XPath");

//	RmodelXML.async = false;
//	RmodelXML.load("Rmodel.xml");
//	RmodelXML2.loadXML(parent.opener.XMLDom.xml);

	RmodelXML2 = parent.RmodelXML.selectSingleNode("/RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/logical_model");
	var RmodelXSL = new ActiveXObject("MSXML2.DOMDocument");
	RmodelXSL.async = false;
	RmodelXSL.load("db_model.xsl");
	var dbHTML = RmodelXML2.transformNode(RmodelXSL);

	document.write(dbHTML);

</script>


		</div>
<div id="nonDisp" style='display:none'>
</div>
	<!--**************************************************************-->

</form>
</body>
</html>


<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="openolap.viewer.chart.ChartCreator"
%>
	<HTML>
		<HEAD>
			<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
			<title><%=(String)session.getValue("aplName")%></title>
			<link rel="stylesheet" type="text/css" href="./css/common.css">
		</HEAD>
	
		<BODY style="margin:0;padding:0;" onmouseover='mouseover();' onmouseout='mouseout();' onmouseup='mouseup();'>

<%

//	Document doc = (Document)request.getAttribute("chartXML");
//	ChartCreator chartCreator = new ChartCreator();

	// チャート生成
//	chartCreator.createChart(doc);


	ChartCreator chartCreator = (ChartCreator)request.getAttribute("chartCreator");

	// チャート出力
	chartCreator.outPNGChart(request, out);



%>

		</BODY>
	
	</HTML>

<script>
	function mouseover(){
		if(parent.dragableObj!=null){
//alert(parent.dragableObj);
			parent.dragableObj.style.display = "none";
		}
	}
	function mouseout(){
		if(parent.dragableObj!=null){
			parent.dragableObj.style.display = "inline";
		}
	}
	function mouseup(){
		if(window.name=='chart_area'){
			parent.dragStatusClear();
		}
	}

</script>

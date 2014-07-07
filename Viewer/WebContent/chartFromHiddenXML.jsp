<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
%>
<html>
<head>
	<title>チャート表示</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link rel="stylesheet" href="css/common.css" type="text/css">

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	<FORM name='form_main' method="post" action="">

		<input type="hidden" name="chartXML" id="schemaName" value="">

		<input type="button" value="XML送信" onclick='createChart()'>

<textarea name="textfield1" cols="100" rows="30">
<?xml version="1.0" encoding="Shift_JIS" ?>
  <Chart>
  <ChartInfo>
  <Title>test</Title> 
  <TitleColor>Black</TitleColor> 
  <Type>Vertical3D_Bar</Type> 
  <Font>
  <FontName>Kochi Gothic</FontName> 
  <FontStyle>PLAIN</FontStyle> 
  <FontSize>10</FontSize> 
  </Font>
  <ChartSize>
  <ChartHeight>298</ChartHeight> 
  <ChartWidth>680</ChartWidth> 
  </ChartSize>
  <ChartBGColor>White</ChartBGColor> 
  <PlotBGColor>White</PlotBGColor> 
  <MultiPiePlotBGColor>White</MultiPiePlotBGColor> 
  <LegendPosition>South</LegendPosition> 
  <hasToolTip>1</hasToolTip> 
  <hasPieLabel>0</hasPieLabel> 
  <Category>
  <Label>time_メジャー</Label> 
  <LabelColor>Black</LabelColor> 
  </Category>
  <SeriesList>
  <Series>
  <Label>sales</Label> 
  <LabelColor>Black</LabelColor> 
  <isAutoRangeEnable>1</isAutoRangeEnable> 
  <MaxRange /> 
  <MinRange /> 
  </Series>
  </SeriesList>
  </ChartInfo>
  <DataSetList>
  <DataSet>
  <Data>
  <CategoryAxisName>2003年04月_sales</CategoryAxisName> 
  <ValueAxisName>Product 合計</ValueAxisName> 
  <Value>40479642</Value> 
  </Data>
  <Data>
  <CategoryAxisName>2003年04月_cost</CategoryAxisName> 
  <ValueAxisName>Product 合計</ValueAxisName> 
  <Value>36700989</Value> 
  </Data>
  </DataSet>
  </DataSetList>
  </Chart>

</textarea>

	</FORM>

</body>
</html>

<script>
function createChart(){

	document.form_main.chartXML.value=encodeURI(document.form_main.textfield1.value);

	// HTML中のIMG要素として、イメージを出力
//	document.form_main.action = "Controller?action=dispChartFromXML&chartDispMode=xml";

	// 直接イメージを出力
	document.form_main.action = "Controller?action=dispChartFromXML&chartDispMode=image";

	// チャート表示処理を要求
	document.form_main.target = "_self";
	document.form_main.submit();
}
</script>

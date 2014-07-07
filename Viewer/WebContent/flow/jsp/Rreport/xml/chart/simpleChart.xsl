<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">
<xsl:output indent="yes" omit-xml-declaration="no" encoding="Shift_JIS"/>

<xsl:comment>Table(Row,col) Header Column</xsl:comment>
<xsl:variable name="rowHeaderCol1" select="//OpenOLAP/property/member/@value"></xsl:variable>
<xsl:variable name="colHeaderCol1" select="//OpenOLAP/property/colHeader/@colName1"></xsl:variable>

<xsl:variable name="measure1" select="//measure1/@value"></xsl:variable>
<xsl:variable name="measure2" select="//measure2/@value"></xsl:variable>
<xsl:variable name="measure3" select="//measure3/@value"></xsl:variable>
<xsl:variable name="measure4" select="//measure4/@value"></xsl:variable>
<xsl:variable name="measure5" select="//measure5/@value"></xsl:variable>
<xsl:variable name="measure6" select="//measure6/@value"></xsl:variable>
<xsl:variable name="measure7" select="//measure7/@value"></xsl:variable>
<xsl:variable name="measure8" select="//measure8/@value"></xsl:variable>
<xsl:variable name="measure9" select="//measure9/@value"></xsl:variable>
<xsl:variable name="measure10" select="//measure10/@value"></xsl:variable>


<xsl:template match="/">
  <Chart>
  <ChartInfo>

	  <Title>　</Title> 
	  <TitleColor>Black</TitleColor> 
	  <Type><xsl:value-of select="//OpenOLAP/property/chartKind/@chartKind" /></Type> 

	  <Font>
		  <FontName>Kochi Gothic</FontName> 
		  <FontStyle>PLAIN</FontStyle> 
		  <FontSize>10</FontSize> 
	  </Font>

	  <ChartSize>
		  <ChartHeight><xsl:value-of select="//OpenOLAP/property/sizeHeight/@value" /></ChartHeight> 
		  <ChartWidth><xsl:value-of select="//OpenOLAP/property/sizeWidth/@value" /></ChartWidth> 
	  </ChartSize>

	  <ChartBGColor>White</ChartBGColor> 
	  <PlotBGColor>White</PlotBGColor> 
	  <MultiPiePlotBGColor>White</MultiPiePlotBGColor> 
	  <LegendPosition>South</LegendPosition> 
	  <hasToolTip>1</hasToolTip> 
	  <hasPieLabel>0</hasPieLabel> 

	  <Category>
			<Label>
				<xsl:value-of select="$rowHeaderCol1" />
			</Label> 
		  <LabelColor>Black</LabelColor> 
	  </Category>

	  <SeriesList>
		  <Series>
			<Label>　</Label> 
			  <LabelColor>Black</LabelColor> 
			  <isAutoRangeEnable>1</isAutoRangeEnable> 
			  <MaxRange /> 
			  <MinRange /> 
		  </Series>
	  </SeriesList>
  </ChartInfo>

  <DataSetList>
	  <DataSet>
		<xsl:apply-templates select="//OpenOLAP/data" mode="rowMeasure"/>
	  </DataSet>
  </DataSetList>
  </Chart>


</xsl:template>

<!--*******************************************************************************-->
<xsl:template match="data" mode="colMeasure">
	<xsl:for-each select="//data/row">
		<xsl:if test="$measure1!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[position()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[position()=$measure1])" /></ValueAxisName> 
				<Value><xsl:value-of select="./@*[position()=$measure1]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure2!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[position()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[position()=$measure2])" /></ValueAxisName> 
				<Value><xsl:value-of select="./@*[position()=$measure2]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure3!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[position()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[position()=$measure3])" /></ValueAxisName> 
				<Value><xsl:value-of select="./@*[position()=$measure3]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure4!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[position()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[position()=$measure4])" /></ValueAxisName> 
				<Value><xsl:value-of select="./@*[position()=$measure4]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure5!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[position()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[position()=$measure5])" /></ValueAxisName> 
				<Value><xsl:value-of select="./@*[position()=$measure5]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure6!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[position()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[position()=$measure6])" /></ValueAxisName> 
				<Value><xsl:value-of select="./@*[position()=$measure6]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure7!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[position()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[position()=$measure7])" /></ValueAxisName> 
				<Value><xsl:value-of select="./@*[position()=$measure7]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure8!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[position()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[position()=$measure8])" /></ValueAxisName> 
				<Value><xsl:value-of select="./@*[position()=$measure8]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure9!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[position()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[position()=$measure9])" /></ValueAxisName> 
				<Value><xsl:value-of select="./@*[position()=$measure9]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure10!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[position()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[position()=$measure10])" /></ValueAxisName> 
				<Value><xsl:value-of select="./@*[position()=$measure10]" /></Value> 
			</Data>
		</xsl:if>
	</xsl:for-each>
</xsl:template>
<!--*******************************************************************************-->


<!--*******************************************************************************-->
<xsl:template match="data" mode="rowMeasure">
	<xsl:for-each select="//data/row">
		<xsl:if test="$measure1!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[name()=$rowHeaderCol1]" /></CategoryAxisName>
				<ValueAxisName><xsl:value-of select="local-name(./@*[name()=$measure1])" /></ValueAxisName>
				<Value><xsl:value-of select="translate(translate(./@*[name()=$measure1],'￥',''),',','')" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure2!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[name()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[name()=$measure2])" /></ValueAxisName>
				<Value><xsl:value-of select="./@*[name()=$measure2]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure3!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[name()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[name()=$measure3])" /></ValueAxisName>
				<Value><xsl:value-of select="./@*[name()=$measure3]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure4!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[name()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[name()=$measure4])" /></ValueAxisName>
				<Value><xsl:value-of select="./@*[name()=$measure4]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure5!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[name()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[name()=$measure5])" /></ValueAxisName>
				<Value><xsl:value-of select="./@*[name()=$measure5]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure6!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[name()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[name()=$measure6])" /></ValueAxisName>
				<Value><xsl:value-of select="./@*[name()=$measure6]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure7!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[name()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[name()=$measure7])" /></ValueAxisName>
				<Value><xsl:value-of select="./@*[name()=$measure7]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure8!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[name()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[name()=$measure8])" /></ValueAxisName>
				<Value><xsl:value-of select="./@*[name()=$measure8]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure9!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[name()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[name()=$measure9])" /></ValueAxisName>
				<Value><xsl:value-of select="./@*[name()=$measure9]" /></Value> 
			</Data>
		</xsl:if>
		<xsl:if test="$measure10!=0">
			<Data>
				<CategoryAxisName><xsl:value-of select="./@*[name()=$rowHeaderCol1]" /></CategoryAxisName> 
				<ValueAxisName><xsl:value-of select="local-name(./@*[name()=$measure10])" /></ValueAxisName>
				<Value><xsl:value-of select="./@*[name()=$measure10]" /></Value> 
			</Data>
		</xsl:if>

	</xsl:for-each>
</xsl:template>
<!--*******************************************************************************-->

<!--*******************************************************************************-->
<xsl:template match="data" mode="noMeasure">
	<xsl:for-each select="//data/row">
		<Data>
			<CategoryAxisName><xsl:value-of select="./@*[position()=$rowHeaderCol1]" /></CategoryAxisName> 
			<ValueAxisName><xsl:value-of select="./@*[position()=$colHeaderCol1]" /></ValueAxisName> 
			<Value><xsl:value-of select="./@*[position()=$measure1]" /></Value> 
		</Data>
	</xsl:for-each>
</xsl:template>
<!--*******************************************************************************-->

</xsl:stylesheet>


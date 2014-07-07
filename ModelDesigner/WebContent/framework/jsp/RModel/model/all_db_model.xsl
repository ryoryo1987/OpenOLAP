<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" encoding="Shift_JIS" omit-xml-declaration="yes"/>

<xsl:param name="show_ns"/>
<xsl:variable name="apos">'</xsl:variable>



<xsl:template match="/">


	<html lang="ja">
	<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS"/>


	<!--************* style sheet **************-->
	<link rel="stylesheet" type="text/css" href="test.css"/>

	</head>
	<body>

    <xsl:apply-templates select="." mode="tree-art" />


	</body>
	</html>


</xsl:template>

<xsl:template match="/" mode="tree-art">
	<div id="root" class="treeItem" style="border-style:hidden">
		<div id="root" class="treeItem" style="font-size : 12px; font-weight: normal;">
		    <xsl:apply-templates mode="tree-art-select" select="/*" />
		    <xsl:apply-templates mode="tree-art-where" select="/*" />
		</div>
	</div>
</xsl:template>

<xsl:template match="*">
    <xsl:apply-templates select="." mode="tree-art" />
</xsl:template>


<xsl:template match="*" mode="tree-art-select">



	<xsl:if test="local-name()!='logical_model' or count(*//logical_column)!=0">


	<xsl:variable name="imgFileName">
		<xsl:choose>
			<xsl:when test="./att1='Text'">../../../images/text.gif</xsl:when>
			<xsl:when test="./att1='Number'">../../../images/number.gif</xsl:when>
			<xsl:when test="./att1='Date'">../../../images/date.gif</xsl:when>
			<xsl:otherwise>../../../images/DimensionTop2.gif</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="dispStyle">
		<xsl:choose>
			<xsl:when test="local-name()='logical_model'">display:block;</xsl:when>
			<xsl:when test="local-name()='select_clause'">display:block;</xsl:when>
			<xsl:when test="local-name()='where_clause'">display:block;</xsl:when>
			<xsl:otherwise>display:none;</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>



	<xsl:element name="div">



		<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@id" /><xsl:text /></xsl:attribute>
		<xsl:attribute name="class">treeItem</xsl:attribute>
		<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>

	    <xsl:call-template name="tree-art-hierarchy" />

		<xsl:element name="img">
			<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@id" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="src"><xsl:value-of select="$imgFileName" /></xsl:attribute>
			<xsl:attribute name="onclick">javascript:Toggle('f',this,'')</xsl:attribute>
			<xsl:attribute name="ondragstart">javascript:startDrag(); return false</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
		</xsl:element>

		<xsl:element name="a">
			<xsl:attribute name="href">return false;</xsl:attribute>
			<xsl:attribute name="onclick">javascript:Toggle('f',this,'');return false;</xsl:attribute>
			<xsl:attribute name="id"><xsl:text />a_<xsl:value-of select="@id" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="name"><xsl:text /><xsl:value-of select="@id" /><xsl:text /></xsl:attribute>

			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
			<xsl:attribute name="ondblclick">javascript:ToggleDblClick('f',this,'')</xsl:attribute>




			<xsl:attribute name="ondragstart">return false</xsl:attribute>

			<xsl:choose>
				<xsl:when test="local-name()='RDBModel'">
					抽出項目
				    <xsl:apply-templates mode="tree-art-select" select="*//logical_model" />
				</xsl:when>

				<xsl:when test="local-name()='logical_model'">
						<xsl:text /><xsl:value-of select="@name" /><xsl:text />
					    <xsl:apply-templates mode="tree-art-select" select="*//logical_column" />
				</xsl:when>

				<xsl:when test="local-name()='logical_column'">
					<!--
						<xsl:text /><xsl:value-of select="./name/text()" /><xsl:text />　
						<xsl:text /><xsl:value-of select="./type/text()" /><xsl:text />
					-->
					<xsl:text /><xsl:value-of select="./name/text()" /><xsl:text />　
				</xsl:when>




				<xsl:otherwise>
					<xsl:text /><xsl:value-of select="local-name()" /><xsl:text />
				</xsl:otherwise>
			</xsl:choose>


		</xsl:element>


	</xsl:element>


	</xsl:if>

</xsl:template>


<xsl:template match="*" mode="tree-art-where">
		<xsl:variable name="imgFileName">
			<xsl:choose>
				<xsl:when test="./att1='Text'">../../../images/text.gif</xsl:when>
				<xsl:when test="./att1='Number'">../../../images/number.gif</xsl:when>
				<xsl:when test="./att1='Date'">../../../images/date.gif</xsl:when>
				<xsl:otherwise>../../../images/DimensionTop2.gif</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="dispStyle">
			<xsl:choose>
				<xsl:when test="local-name()='logical_model'">display:block;</xsl:when>
				<xsl:when test="local-name()='select_clause'">display:block;</xsl:when>
				<xsl:when test="local-name()='where_clause'">display:block;</xsl:when>
				<xsl:otherwise>display:none;</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>



	<xsl:element name="div">



		<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@id" /><xsl:text /></xsl:attribute>
		<xsl:attribute name="class">treeItem</xsl:attribute>
		<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>

	    <xsl:call-template name="tree-art-hierarchy" />

		<xsl:element name="img">
			<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@id" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="src"><xsl:value-of select="$imgFileName" /></xsl:attribute>
			<xsl:attribute name="onclick">javascript:Toggle('f',this,'')</xsl:attribute>
			<xsl:attribute name="ondragstart">javascript:startDrag(); return false</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
		</xsl:element>

		<xsl:element name="a">
			<xsl:attribute name="href">return false;</xsl:attribute>
			<xsl:attribute name="onclick">javascript:Toggle('f',this,'');return false;</xsl:attribute>
			<xsl:attribute name="id"><xsl:text />a_<xsl:value-of select="@id" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="name"><xsl:text /><xsl:value-of select="@id" /><xsl:text /></xsl:attribute>

			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
			<xsl:attribute name="ondblclick">javascript:ToggleDblClick('f',this,'')</xsl:attribute>


			<xsl:attribute name="ondragstart">return false</xsl:attribute>

			<xsl:choose>
				<xsl:when test="local-name()='RDBModel'">
					条件項目
				    <xsl:apply-templates mode="tree-art-where" select="*//logical_condition" />
				</xsl:when>



				<xsl:when test="local-name()='logical_condition'">
					<!--
						<xsl:text /><xsl:value-of select="./name/text()" /><xsl:text />　
						<xsl:text /><xsl:value-of select="./type/text()" /><xsl:text />
					-->
					<xsl:text /><xsl:value-of select="./name/text()" /><xsl:text />　
				</xsl:when>



				<xsl:otherwise>
					<xsl:text /><xsl:value-of select="local-name()" />vvv<xsl:text />
				</xsl:otherwise>
			</xsl:choose>


		</xsl:element>


	</xsl:element>


</xsl:template>
























<xsl:template match="*" mode="non-disp">
	<xsl:element name="div">
	</xsl:element>
</xsl:template>

<!-- Plobably Delete function-->
<xsl:template match="text()" mode="tree-art">
</xsl:template>

<xsl:template match="comment()" mode="tree-art">
    <xsl:call-template name="tree-art-hierarchy" />
    <xsl:text />___comment '<xsl:value-of select="." />'&#xA;<xsl:text />
</xsl:template>

<xsl:template name="tree-art-hierarchy">
    <xsl:for-each select="ancestor::*">
        <xsl:choose>
			<xsl:when test="local-name()='RDBModel'"> </xsl:when>
			<xsl:when test="local-name()='db_tables'"> </xsl:when>
			<xsl:when test="local-name()='logical_model'"></xsl:when>
			<xsl:when test="local-name()='where_clause'"></xsl:when>
			<xsl:when test="following-sibling::*"><img id="H" src="../../../images/I.gif" ondragstart="return false;"/></xsl:when>
			<xsl:otherwise><img id="H" src="../../../images/blank.gif" ondragstart="return false;"/></xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>

   <xsl:choose>                                                                                                      


		<xsl:when test="local-name()='logical_column' or local-name()='logical_condition'">
		   <xsl:choose>                                                                                                      
			<xsl:when test = "child::* and not(following-sibling::*)">
				<img id="5" src="../../../images/L.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/>
			</xsl:when>

			<xsl:when test = "child::* and following-sibling::*">
				<img id="5" src="../../../images/T.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
			</xsl:when>
		   </xsl:choose>                                                                                                      
		</xsl:when>


		<xsl:when test = "not(node())">
			<img id="5" src="../../../images/T.gif"/>
		</xsl:when>

		<xsl:when test = "child::* and not(following-sibling::*)">
			<img id="5" src="../../../images/Lminus.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "child::* and following-sibling::*">
			<img id="5" src="../../../images/Tminus.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and not(following-sibling::*)">
			<img id="5" src="../../../images/L.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and following-sibling::*">
			<img id="5" src="../../../images/T.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
		</xsl:when>

       <xsl:otherwise><img id="1" src="../../../images/blank.gif"/></xsl:otherwise>                                           
   </xsl:choose>                                                                                                     

</xsl:template>

<!-- recursive template to escape backslashes, apostrophes, newlines and tabs -->
<xsl:template name="escape-ws">
    <xsl:param name="text" />
    <xsl:choose>
        <xsl:when test="contains($text, '\')">
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-before($text, '\')" />
            </xsl:call-template>
            <xsl:text>\\</xsl:text>
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, '\')" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($text, $apos)">
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-before($text, $apos)" />
            </xsl:call-template>
            <xsl:text>\'</xsl:text>
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, $apos)" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="contains($text, '&#xA;')">
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-before($text, '&#xA;')" />
            </xsl:call-template>
            <xsl:text></xsl:text>
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, '&#xA;')" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="contains($text, '&#x9;')">
            <xsl:value-of select="substring-before($text, '&#x9;')" />
            <xsl:text></xsl:text>
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, '&#x9;')" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$text" /></xsl:otherwise>
    </xsl:choose>

</xsl:template>

</xsl:stylesheet>

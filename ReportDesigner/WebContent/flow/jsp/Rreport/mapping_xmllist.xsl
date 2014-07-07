<?xml version="1.0" encoding="Shift-JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:param name="show_ns"/>
<xsl:variable name="apos">'</xsl:variable>

<xsl:template match="/">

<div id="root"  class="treeItem">
	    <xsl:apply-templates select="." mode="tree-art" />
</div>

<div id="hiddenTree" style='display:block'>
</div>

</xsl:template>

<!--
<xsl:template match="/" mode="tree-art">
	<div id="root" class="treeItem" style="border-style:hidden">
		<div id="root" class="treeItem" style="font-size : 12px; font-weight: normal;">
		    <xsl:apply-templates mode="tree-art" select="//sql" />
		</div>
	</div>
	<div id="root" class="treeItem" style="border-style:hidden">
		<div id="root" class="treeItem" style="font-size : 12px; font-weight: normal;">
		    <xsl:apply-templates mode="tree-art" select="//OpenOLAP/screenSql" />
		</div>
	</div>
</xsl:template>
-->

<xsl:template match="sql">
    <xsl:apply-templates select="." mode="tree-art" />
</xsl:template>

<xsl:template match="screenSql">
    <xsl:apply-templates select="." mode="tree-art" />
</xsl:template>

<xsl:template match="sqlcol">
    <xsl:apply-templates select="." mode="tree-art" />
</xsl:template>

<xsl:template match="where_clause">
    <xsl:apply-templates select="." mode="tree-art" />
</xsl:template>

<xsl:template match="*" mode="tree-art">
<xsl:value-of select="." />
		<xsl:variable name="imgFileName">
			<xsl:choose>
				<xsl:when test="local-name()='sql'">../../../images/Rreport/select.gif</xsl:when>
				<xsl:when test="local-name()='sqlcol'">
			        <xsl:choose>
						<xsl:when test="@datatype='Text'">../../../images/Rreport/text.gif</xsl:when>
						<xsl:when test="@datatype='Number'">../../../images/Rreport/number.gif</xsl:when>
						<xsl:when test="@datatype='Date'">../../../images/Rreport/date.gif</xsl:when>
						<xsl:otherwise>../../../images/Rreport/list.gif</xsl:otherwise>
			        </xsl:choose>
				</xsl:when>
				<xsl:when test="local-name()='where_clause'">../../../images/Rreport/where.gif</xsl:when>
				<xsl:otherwise>../../../images/Rreport/where_top.gif</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="execFileName">
		</xsl:variable>

		<xsl:variable name="dispStyle">
			<xsl:choose>
				<xsl:when test="local-name()='sql'">display:block;</xsl:when>
				<xsl:when test="local-name()='sqlcol'">display:none;</xsl:when>
				<xsl:otherwise>display:block;</xsl:otherwise>
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
			<xsl:attribute name="onclick">javascript:Toggle('f',this,'<xsl:value-of select="$execFileName" />')</xsl:attribute>
			<xsl:attribute name="ondragstart">javascript:startDrag(); return false</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
		</xsl:element>


		<xsl:element name="a">
				<xsl:choose>
				<xsl:when test='@id = ""'>
				</xsl:when>
				<xsl:otherwise>
						<xsl:attribute name="href">return false;</xsl:attribute>
						<xsl:attribute name="onclick">javascript:Toggle('f',this,'<xsl:value-of select="$execFileName" />'); return false;</xsl:attribute>

						<xsl:attribute name="ondrop">javascript:drop(); return false</xsl:attribute>
						<xsl:attribute name="ondragover">javascript:overDrag(); return false</xsl:attribute>
						<xsl:attribute name="ondragleave">javascript:leaveDrag(); return false</xsl:attribute>
						<xsl:attribute name="ondragenter">javascript:enterDrag(); return false</xsl:attribute>

						<xsl:attribute name="ondragstart">javascript:startDragListToList();</xsl:attribute>

				</xsl:otherwise>
				</xsl:choose>

		        <xsl:choose>
					<xsl:when test="local-name()='sqlcol'"><xsl:text /><xsl:value-of select="@name" /><xsl:text /></xsl:when>
					<xsl:when test="local-name()='sql'"><xsl:text />表示項目の追加<xsl:text /></xsl:when>
					<xsl:when test="local-name()='where_clause'"><xsl:text /><xsl:value-of select="@name" /><xsl:text /></xsl:when>
					<xsl:otherwise><xsl:text />条件項目の追加<xsl:text /></xsl:otherwise>
		        </xsl:choose>

			
		</xsl:element>


			<xsl:element name="div">
				<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@id" />-C<xsl:text /></xsl:attribute>
				<xsl:attribute name="style"><xsl:value-of select="$dispStyle" /></xsl:attribute>
				<xsl:attribute name="class">container</xsl:attribute>
				    <xsl:apply-templates select="@datatype" mode="tree-art" />
<!--
				    <xsl:apply-templates select="@cellformat" mode="tree-art" />
-->
				    <xsl:apply-templates mode="tree-art" />
			</xsl:element>

	</xsl:element>


</xsl:template>

<!-- Plobably Delete function-->

<xsl:template match="@*" mode="tree-art">
	<xsl:element name="div">
	    <xsl:call-template name="tree-art-hierarchy" />
		<xsl:element name="img">
	        <xsl:choose>
				<xsl:when test=".=' Text'"><xsl:attribute name="src">../../../images/Rreport/text.gif</xsl:attribute></xsl:when>
				<xsl:when test=".=' string'"><xsl:attribute name="src">../../../images/Rreport/list.gif</xsl:attribute></xsl:when>
				<xsl:when test=".=' Number'"><xsl:attribute name="src">../../../images/Rreport/number.gif</xsl:attribute></xsl:when>
				<xsl:when test=".=' Date'"><xsl:attribute name="src">../../../images/Rreport/date.gif</xsl:attribute></xsl:when>
				<xsl:otherwise><xsl:attribute name="src">../../../images/Rreport/list.gif</xsl:attribute></xsl:otherwise>
	        </xsl:choose>
		</xsl:element>


		<xsl:element name="a">
			<xsl:attribute name="href">return false;</xsl:attribute>
			<xsl:attribute name="onclick">javascript:Toggle('f',this,'alert()'); return false;</xsl:attribute>
			<xsl:attribute name="ondragstart">return false;</xsl:attribute>
			<xsl:text /><xsl:value-of select="local-name()" /><xsl:text />
			<xsl:text />=<xsl:text />

		    <xsl:call-template name="escape-ws">
		        <xsl:with-param name="text" select="." />
		    </xsl:call-template>
		</xsl:element>

	</xsl:element>

</xsl:template>

<xsl:template match="text()" mode="tree-art">

	<xsl:element name="div">
	    <xsl:call-template name="tree-art-hierarchy" />
		<xsl:element name="img">
			<xsl:attribute name="src">../../../images/Rreport/file.gif</xsl:attribute>
		</xsl:element>

		<xsl:element name="a">
			<xsl:attribute name="href">return false;</xsl:attribute>
			<xsl:attribute name="onclick">javascript:Toggle('f',this,'alert()'); return false;</xsl:attribute>

				<xsl:attribute name="ondrop">javascript:drop(); return false</xsl:attribute>
				<xsl:attribute name="ondragover">javascript:overDrag(); return false</xsl:attribute>
				<xsl:attribute name="ondragleave">javascript:leaveDrag(); return false</xsl:attribute>
				<xsl:attribute name="ondragenter">javascript:enterDrag(); return false</xsl:attribute>
				<xsl:attribute name="ondragend">javascript:endDrag(); return false</xsl:attribute>

				<xsl:attribute name="ondragstart">return false</xsl:attribute>

<!--
	<xsl:value-of select="position()" />
	<xsl:value-of select="generate-id(.)" />
	<xsl:value-of select="local-name()" />
-->
			<xsl:call-template name="escape-ws">
				<xsl:with-param name="text" select="." />
			</xsl:call-template>
		</xsl:element>

	</xsl:element>
</xsl:template>

<xsl:template match="comment()" mode="tree-art">
    <xsl:call-template name="tree-art-hierarchy" />
    <xsl:text />___comment '<xsl:value-of select="." />'&#xA;<xsl:text />
</xsl:template>


<xsl:template name="tree-art-hierarchy">
    <xsl:for-each select="ancestor::*">

        <xsl:choose>
			<xsl:when test="local-name()='OpenOLAP'"> </xsl:when>
			<xsl:when test="local-name()='screenSql'"><img id="H" src="../../../images/Rreport/blank.gif" ondragstart="return false;"/></xsl:when>

			<xsl:when test="following-sibling::*"><img id="H" src="../../../images/Rreport/I.gif" ondragstart="return false;"/></xsl:when>
			<xsl:otherwise><img id="H" src="../../../images/Rreport/blank.gif" ondragstart="return false;"/></xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
<!--
	<xsl:value-of select="not(node()) and (local-name())" />-
	<xsl:value-of select="not(local-name())" />-

	<xsl:value-of select="not(not(node()))" />-
	<xsl:value-of select="not(not(local-name()))" />-
	<xsl:value-of select="not(not(child::*))" />-
	<xsl:value-of select="not(not(following-sibling::*))" />


	<xsl:value-of select="attribute::*[1]" />
-->


   <xsl:choose>
		<!-- *****************attribute**********************-->
		<xsl:when test = "not(attribute::*[1]) and not(node())">
		   <xsl:choose>
				<xsl:when test = "local-name()='datatype-----Comment------'">
					<img id="L" src="../../../images/Rreport/T.gif"/>
				</xsl:when>
				<xsl:otherwise>
					<img id="1" src="../../../images/Rreport/L.gif"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<!-- *****************Node**********************-->
		<xsl:when test = "not(not(attribute::*[1]) and not(node()))">
		   <xsl:choose>
				<xsl:when test = "attribute::*[1] and not(following-sibling::*)">
				   <xsl:choose>
					<xsl:when test="local-name()='sql'"><img id="L" src="../../../images/Rreport/Lminus.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/></xsl:when>
					<xsl:when test="local-name()='sqlcol'"><img id="L" src="../../../images/Rreport/Lplus.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/></xsl:when>
					<xsl:when test="local-name()='where_clause'"><img id="L" src="../../../images/Rreport/L.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/></xsl:when>
					<xsl:otherwise><img id="L" src="../../../images/Rreport/Lminus.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/></xsl:otherwise>
				   </xsl:choose>
				</xsl:when>
				<xsl:when test = "attribute::*[1]">
				   <xsl:choose>
					<xsl:when test="local-name()='sql'"><img id="L" src="../../../images/Rreport/Tminus.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/></xsl:when>
					<xsl:when test="local-name()='sqlcol'"><img id="L" src="../../../images/Rreport/Tplus.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/></xsl:when>
					<xsl:when test="local-name()='where_clause'"><img id="L" src="../../../images/Rreport/T.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/></xsl:when>
					<xsl:otherwise><img id="L" src="../../../images/Rreport/Lminus.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/></xsl:otherwise><!--where句-->
				   </xsl:choose>
				</xsl:when>

				<xsl:when test = "child::* and not(following-sibling::*)">
					<img id="L" src="../../../images/Rreport/Lminus.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
				</xsl:when>

				<xsl:when test = "child::* and following-sibling::*">
					<img id="L" src="../../../images/Rreport/Tminus.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
				</xsl:when>

				<xsl:when test = "not(child::*) and not(following-sibling::*)">
					<img id="L" src="../../../images/Rreport/L.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/>
				</xsl:when>

				<xsl:when test = "not(child::*) and following-sibling::*">
					<img id="L" src="../../../images/Rreport/T.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
				</xsl:when>

		       <xsl:otherwise><img id="1" src="../../../images/Rreport/blank.gif"/></xsl:otherwise>                                           
		   </xsl:choose>
		</xsl:when>

<!-- 
		<xsl:when test = "not(local-name())">
		   <xsl:choose>
				<xsl:when test = "not(following-sibling::*)">
					<img id="L" src="../../../images/Rreport/L.gif"/>
				</xsl:when>
				<xsl:otherwise>
					<img id="1" src="../../../images/Rreport/T.gif"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
-->


       <xsl:otherwise><img id="1" src="../../../images/Rreport/blank.gif"/></xsl:otherwise>                                           
   </xsl:choose>                                                                                                     

</xsl:template>

<!-- Attribute Hierarchy-->
<xsl:template name="hierarchy-attribute">
    <xsl:for-each select="ancestor::*">
        <xsl:choose>
			<xsl:when test="local-name()='OpenOLAP'"> </xsl:when>
			<xsl:when test="following-sibling::*"><img id="H" src="../../../images/Rreport/I.gif" ondragstart="return false;"/></xsl:when>
			<xsl:otherwise><img id="H" src="../../../images/Rreport/blank.gif" ondragstart="return false;"/></xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
<xsl:value-of select="not(preceding-sibling::*)" />
	<xsl:choose>
		<xsl:when test = "attribute::*">
		</xsl:when>

		<xsl:when test = "child::*">
			<img id="L" src="../../../images/Rreport/T.gif"/>
		</xsl:when>
       <xsl:otherwise><img id="L" src="../../../images/Rreport/L.gif"/></xsl:otherwise>                                           
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

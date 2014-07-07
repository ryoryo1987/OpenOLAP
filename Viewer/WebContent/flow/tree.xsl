<?xml version="1.0" encoding="Shift-JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" encoding="Shift-JIS" omit-xml-declaration="yes"/>

<xsl:param name="show_ns"/>
<xsl:variable name="apos">'</xsl:variable>

<xsl:template match="/">

<html lang="ja">
<head>
<title>OpenOLAP</title>
<link type="text/css" rel="stylesheet" href="../css/tree.css"/>

<!--************* right Click **************-->
<link rel="stylesheet" type="text/css" href="../../css/rightclick.css"/>
<script language="JavaScript1.2" src="jsp/js/leftTreeRightclick.js"></script>
<!--************* End right Click **************-->

<script language="JavaScript1.2" src="jsp/js/addTreeMember.js"></script>
<script language="JavaScript1.2" src="jsp/js/tree.js"></script>

<!-- Message -->
<script language="JavaScript1.2" src="jsp/js/registration.js"></script>
</head>

<script type="text/JavaScript1.2">
<xsl:comment>
<![CDATA[
]]>
</xsl:comment>
</script>

<body onload="javascript:ToggleDblClick('f',document.getElementById('root').firstChild.firstChild.firstChild.firstChild,'レポート');" style="margin-top:0px;margin-left:0px;padding-top:0px">
<form name="navi_form" id="navi_form" target="navi_frm" method="post" action="">

<input type="hidden" name = "a"/>
<input type="hidden" name = "preClick"/>

<input type="hidden" name = "child_record" value=""/>
<input type="hidden" name = "parent_record" value=""/>

<input type="hidden" name = "objKind" value=""/>
<input type="hidden" name = "seqId" value=""/>


<input type="hidden" name = "change_flg" value="0"/>


<input type="hidden" name = "copyObj_objKind" value=""/>
<input type="hidden" name = "copyObj_id" value=""/>
<input type="hidden" name = "copyParentObj_objKind" value=""/>
<input type="hidden" name = "copyParentObj_id" value=""/>

<img src="../images/tree/menu.gif" style="margin:0;padding:0;" ondragstart="return false;" onClick="javascript:Toggle('r',this.nextSibling,'home.jsp');" ondblClick="javascript:reverseDisplay(this.parentNode);"/>

<!--ツリータイトル部分-->
<table style="border-collapse:collapse;width:100%;table-layout:fixed;margin:0">
	<tr>
		<td style="width:49;height:34;background:url('../images/tree/tree_title_left.gif') no-repeat"></td>
		<td style="height:34;background:url('../images/tree/tree_title_center.gif') repeat-x;text-align:center;padding-top:10"><img src="../images/tree/tree_title.gif" /></td>
		<td style="width:39;height:34;background:url('../images/tree/tree_title_right.gif') no-repeat"></td>
	</tr>
</table>
<table style="border-collapse:collapse;width:100%;height:80%;table-layout:fixed">
	<tr>
		<td style="width:20;background-color:white"></td>
		<td style="background:url('../images/tree/bg.gif') no-repeat ;vertical-align:top">
			<div id="root" class="treeItem" style="padding-top:18;width:100%;height:100%;overflow:auto">
				<xsl:apply-templates select="." mode="tree-art" />
			</div>
		</td>
		<td style="width:7;background-color:white"></td>
	</tr>
</table>

</form>
</body>
</html>

</xsl:template>

<xsl:template match="/" mode="tree-art">
	<div id="root" class="treeItem" style="border-style:hidden">
		<div id="root" class="treeItem" style="font-size : 12px; font-weight: normal;">
		    <xsl:apply-templates mode="tree-art" select="/*/*" />
		</div>
	</div>
</xsl:template>

<xsl:template match="*" mode="tree-art">

		<xsl:variable name="imgFileName">
			<xsl:choose>
				<xsl:when test="local-name()='OpenOLAP'">../images/tree/folder2.gif</xsl:when>
				<xsl:when test="local-name()='category'">
					<xsl:choose>
						<xsl:when test="@KI='R' and @RTYPE='M'">../images/tree/m_report.gif</xsl:when>
						<xsl:when test="@KI='R' and @RTYPE='R'">../images/tree/r_report.gif</xsl:when>
						<xsl:when test="@KI='R' and @RTYPE='P'">../images/tree/p_report.gif</xsl:when>
						<xsl:otherwise>../images/tree/folder2.gif</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="local-name()='category2'">
					<xsl:choose>
						<xsl:when test="@KI='R' and @RTYPE='M'">../images/tree/m_report.gif</xsl:when>
						<xsl:when test="@KI='R' and @RTYPE='R'">../images/tree/r_report.gif</xsl:when>
						<xsl:when test="@KI='R' and @RTYPE='P'">../images/tree/p_report.gif</xsl:when>
						<xsl:otherwise>../images/tree/folder_p2.gif</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="local-name()='ReportTop'">../images/tree/report_top2.gif</xsl:when>
				<xsl:when test="local-name()='KojinReportTop'">../images/tree/kojin_report_top.gif</xsl:when>
				<xsl:when test="local-name()='KojinReportTop2'">../images/tree/kojin_report_top.gif</xsl:when>
				<xsl:when test="local-name()='Folder'">../images/tree/folder2.gif</xsl:when>
				<xsl:when test="local-name()='report'">../images/tree/r_report.gif</xsl:when>
				<xsl:when test="local-name()='Admin'">../images/tree/admin2.gif</xsl:when>
				<xsl:when test="local-name()='CreateMReport'">../images/tree/create_m_report.gif</xsl:when>
				<xsl:when test="local-name()='CreateRReport'">../images/tree/create_r_report.gif</xsl:when>
				<xsl:when test="local-name()='CreatePortalReport'">../images/tree/create_p_report.gif</xsl:when>
				<xsl:when test="local-name()='AdminFolderReport'">../images/tree/admin_folder_report2.gif</xsl:when>
				<xsl:when test="local-name()='Authority'">../images/tree/authority.gif</xsl:when>
				<xsl:when test="local-name()='CreateEdit'">../images/tree/user_group.gif</xsl:when>
				<xsl:when test="local-name()='UserConfig'">../images/tree/user.gif</xsl:when>
				<xsl:when test="local-name()='User'">../images/tree/user.gif</xsl:when>
				<xsl:when test="local-name()='Group'">../images/tree/group.gif</xsl:when>
				<xsl:when test="local-name()='SEC'">../images/tree/group.gif</xsl:when>
				<xsl:when test="local-name()='ChangePassword'">../images/tree/password.gif</xsl:when>
				<xsl:when test="local-name()='Export'">../images/tree/export.gif</xsl:when>
				<xsl:otherwise>../images/tree/folder2.gif</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="execFileName">
			<xsl:choose>
				<xsl:when test="local-name()='OpenOLAP'">OpenOLAP_Admin.html</xsl:when>
				<xsl:when test="local-name()='category'">
					<xsl:choose>
						<xsl:when test="@KI='R' and @RTYPE='M'"><xsl:text>../Controller?action=displayNewReport</xsl:text></xsl:when>
						<xsl:when test="@KI='R' and @RTYPE='R'">jsp/Rreport/frm_r_report.jsp</xsl:when>
						<xsl:when test="@KI='R' and @RTYPE='P'"><xsl:text>jsp/portal/portal_frm.jsp</xsl:text></xsl:when>
						<xsl:otherwise>noSubmit</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="local-name()='category2'">
					<xsl:choose>
						<xsl:when test="@KI='R' and @RTYPE='M'"><xsl:text>../Controller?action=displayNewReport</xsl:text></xsl:when>
						<xsl:when test="@KI='R' and @RTYPE='R'"><xsl:text>jsp/Rreport/dispFrm.jsp?kind=db&amp;rId=</xsl:text><xsl:value-of select="@ID" /></xsl:when>
						<xsl:when test="@KI='R' and @RTYPE='P'"><xsl:text>jsp/portal/portal_frm.jsp</xsl:text></xsl:when>
						<xsl:otherwise>noSubmit</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="local-name()='ReportTop'">home.jsp</xsl:when>
				<xsl:when test="local-name()='KojinReportTop'">jsp/frm_report_mng.jsp</xsl:when>
				<xsl:when test="local-name()='KojinReportTop2'">jsp/frm_report_mng.jsp</xsl:when>
				<xsl:when test="local-name()='Report'">noSubmit</xsl:when>
				<xsl:when test="local-name()='Admin'">report_admin.jsp</xsl:when>
				<xsl:when test="local-name()='CreateMReport'">jsp/frm_Mreport.jsp</xsl:when>
				<xsl:when test="local-name()='CreateRReport'">jsp/Rreport/frm_Rreport.jsp</xsl:when>
				<xsl:when test="local-name()='CreatePortalReport'">jsp/portal/frm_Portalreport.jsp</xsl:when>
				<xsl:when test="local-name()='AdminFolderReport'">jsp/frm_report_mng.jsp</xsl:when>
				<xsl:when test="local-name()='hozon'">jsp/frm_report_rgs.jsp</xsl:when>
				<xsl:when test="local-name()='CreateEdit'">user_group.jsp</xsl:when>
				<xsl:when test="local-name()='User'">jsp/frm_user.jsp</xsl:when>
				<xsl:when test="local-name()='Group'">jsp/frm_group.jsp</xsl:when>
				<xsl:when test="local-name()='Authority'">authority.jsp</xsl:when>
				<xsl:when test="local-name()='REPORT'">jsp/frm_rep.jsp</xsl:when>
				<xsl:when test="local-name()='SEC'">jsp/frm_sec.jsp</xsl:when>
				<xsl:when test="local-name()='UserConfig'">user_config.jsp</xsl:when>
				<xsl:when test="local-name()='ChangePassword'">jsp/frm_pwd.jsp</xsl:when>
				<xsl:when test="local-name()='Export'">jsp/frm_exp.jsp</xsl:when>

				<xsl:otherwise>blank.html</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="dispStyle">
			<xsl:choose>
				<xsl:when test="local-name()='OpenOLAP'">display:none;</xsl:when>
				<xsl:when test="local-name()='ReportTop'">display:none;</xsl:when>
				<xsl:when test="local-name()='kojinReportTop'">display:none;</xsl:when>
				<xsl:when test="local-name()='Folder'">display:none;</xsl:when>
				<xsl:when test="local-name()='report'">display:none;</xsl:when>
				<xsl:when test="local-name()='Admin'">display:none;</xsl:when>
				<xsl:when test="local-name()='CreateEdit'">display:none;</xsl:when>
				<xsl:when test="local-name()='CreateReport'">display:none;</xsl:when>
				<xsl:when test="local-name()='AdminFolderReport'">display:none;</xsl:when>
				<xsl:otherwise>display:none;</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>



	<xsl:element name="div">
		<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
		<xsl:attribute name="class">treeItem</xsl:attribute>
		<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>

	    <xsl:call-template name="tree-art-hierarchy" />

		<xsl:element name="img">
			<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
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
			<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="name"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="ondrop">javascript:drop(); return false</xsl:attribute>
			<xsl:attribute name="ondragover">javascript:overDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragleave">javascript:leaveDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragenter">javascript:enterDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragend">javascript:endDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragstart">javascript:startDrag(); return false</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
			<xsl:attribute name="ondblclick">javascript:ToggleDblClick('f',this,'<xsl:value-of select="$execFileName" />')</xsl:attribute>
	</xsl:otherwise>
	</xsl:choose>

			<xsl:text /><xsl:value-of select="text()" /><xsl:text />
		</xsl:element>

			<xsl:element name="div">
				<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@ID" />-C<xsl:text /></xsl:attribute>
				<xsl:attribute name="style"><xsl:value-of select="$dispStyle" /></xsl:attribute>
				<xsl:attribute name="class">container</xsl:attribute>
				    <xsl:apply-templates mode="tree-art" />
			</xsl:element>

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
			<xsl:when test="local-name()='OpenOLAP'"> </xsl:when>
			<xsl:when test="following-sibling::*"><img id="H" src="../images/tree/I.gif" ondragstart="return false;"/></xsl:when>
			<xsl:otherwise><img id="H" src="../images/tree/blank.gif" ondragstart="return false;"/></xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>

   <xsl:choose>                                                                                                      

		<xsl:when test = "not(node())">
			<img id="5" src="../images/tree/T.gif"/>
		</xsl:when>

		<xsl:when test = "child::* and not(following-sibling::*)">
			<img id="5" src="../images/tree/Lplus.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "child::* and following-sibling::*">
			<img id="5" src="../images/tree/Tplus.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and not(following-sibling::*)">
			<img id="5" src="../images/tree/L.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and following-sibling::*">
			<img id="5" src="../images/tree/T.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
		</xsl:when>

       <xsl:otherwise><img id="1" src="../images/tree/Tplus.gif"/></xsl:otherwise>                                           
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

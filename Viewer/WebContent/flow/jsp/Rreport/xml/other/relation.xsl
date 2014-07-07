<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">

<xsl:template match="/">

<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS"/>
	<title>OpenOLAP</title>
	<link id="stylefile" rel="stylesheet" type="text/css" href="xml/condition/spreadStyle_blue_1.css"/>
	<script language="JavaScript" src="relation_load.js"></script>

	<script type="text/JavaScript">
	<xsl:comment>
	<![CDATA[

		function changeClass(obj){
			var modeName=obj.mode;
			if(obj.className.indexOf("selected")==-1){

				if(event.type=="mouseover"){
					obj.className="over_"+modeName;
				}else if(event.type=="mousedown"){
					obj.className="down_"+modeName;
				}else if(event.type=="mouseup"){
					obj.className="up_"+modeName;
				}else if(event.type=="mouseout"){
					obj.className="out_"+modeName;
				}

			}
		}


	]]>
	</xsl:comment>
	</script>
	<style>
	/* 参照モードボタン */
	input.normal_look, input.up_look, input.out_look {
		width : 60;
		height : 30;
		background : url("xml/other/look_off.gif") no-repeat;
		border-style : none;
	}

	input.over_look, input.down_look {
		width : 60;
		height : 30;
		background : url("xml/other/look_r.gif") no-repeat;
		border-style : none;
	}

	input.selected_look {
		width : 60;
		height : 30;
		background : url("xml/other/look_on.gif") no-repeat;
		border-style : none;
	}

	/* 移動モードボタン */
	input.normal_move, input.up_move, input.out_move {
		width : 60;
		height : 30;
		background : url("xml/other/move_off.gif") no-repeat;
		border-style : none;
	}

	input.over_move, input.down_move {
		width : 60;
		height : 30;
		background : url("xml/other/move_r.gif") no-repeat;
		border-style : none;
	}

	input.selected_move {
		width : 60;
		height : 30;
		background : url("xml/other/move_on.gif") no-repeat;
		border-style : none;
	}

	/* ラインモードボタン */
	input.normal_line, input.up_line, input.out_line {
		width : 60;
		height : 30;
		background : url("xml/other/line_off.gif") no-repeat;
		border-style : none;
	}

	input.over_line, input.down_line {
		width : 60;
		height : 30;
		background : url("xml/other/line_r.gif") no-repeat;
		border-style : none;
	}

	input.selected_line {
		width : 60;
		height : 30;
		background : url("xml/other/line_on.gif") no-repeat;
		border-style : none;
	}

	/* ラインを削除ボタン */
	input.normal_line_del, input.up_line_del, input.out_line_del {
		width : 100;
		height : 30;
		background : url("xml/other/line_del.gif") no-repeat;
		border-style : none;
	}

	input.over_line_del, input.down_line_del {
		width : 100;
		height : 30;
		background : url("xml/other/line_del_r.gif") no-repeat;
		border-style : none;
	}

	/* 保存ボタン */
	input.normal_hozon, input.up_hozon, input.out_hozon {
		width : 60;
		height : 30;
		background : url("xml/other/hozon.gif") no-repeat;
		border-style : none;
	}

	input.over_hozon, input.down_hozon {
		width : 60;
		height : 30;
		background : url("xml/other/hozon_r.gif") no-repeat;
		border-style : none;
	}



	</style>

</head>
<body>
<form name="form_main" id="form_main" method="post" action="">

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<div>
				<table style="width:100%;border-collapse:collapse;margin-left:8">
					<tr>
						<td style="background-color:#EDECE8">
							<img src="xml/other/txt.gif" />
							<input type="button" id="mode1" style="cursor:hand;" onclick="changeMode(1,'Look')" mode="look" class="selected_look" onMouseOver="changeClass(this)" onMouseDown="changeClass(this)" onMouseUp="changeClass(this)" onMouseOut="changeClass(this)" />
							<input type="button" id="mode2" style="cursor:hand;" onclick="changeMode(2,'Move')" mode="move" class="normal_move" onMouseOver="changeClass(this)" onMouseDown="changeClass(this)" onMouseUp="changeClass(this)" onMouseOut="changeClass(this)" />
							<input type="button" id="mode3" style="cursor:hand;" onclick="changeMode(3,'Line')" mode="line" class="normal_line" onMouseOver="changeClass(this)" onMouseDown="changeClass(this)" onMouseUp="changeClass(this)" onMouseOut="changeClass(this)" />
							<img src="xml/other/Line.gif" />
							<input type="button" id="del_btn" style="cursor:hand;" onclick="frm_chart.del()" class="normal_line_del" onMouseOver="className='over_line_del'" onMouseDown="className='down_line_del'" onMouseUp="className='up_line_del'" onMouseOut="className='out_line_del'" />
							<input type="button" id="save_btn" style="cursor:hand;" onclick="frm_chart.save()" class="normal_hozon" onMouseOver="className='over_hozon'" onMouseDown="className='down_hozon'" onMouseUp="className='up_hozon'" onMouseOut="className='out_hozon'" />


						</td>
					</tr>
				</table>
<textarea name="xmlText" id='xmlText' cols="0" rows="0" style='display:none'>
    <xsl:apply-templates select="/" mode="direct"/>
</textarea>
			</div>
		</td>
	</tr>
	<tr>
	<td width="100%" height="100%">
		<iframe name="frm_chart" src="" width="100%" height="100%" style="margin-left:8"></iframe>
		<input type="hidden" id="hid_mode" value=""/>
	</td>
	</tr>
</table>
</form>
</body>
<script language="JavaScript1.2" src="xml/other/frm_load.js"></script>

</html>

</xsl:template>

<!--*******************************************************************************-->
<xsl:template match="@*|*|text()" mode="direct">
	<xsl:copy>
		<xsl:apply-templates select="@*|*|text()"  mode="direct"/>
	</xsl:copy>
</xsl:template>
<!--*******************************************************************************-->
</xsl:stylesheet>

<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="java.util.ArrayList,java.util.Iterator,openolap.viewer.Report,openolap.viewer.Dimension,openolap.viewer.common.Constants"
%><html>
	<head>
		<title>�Z���N�^</title>
		<link rel="stylesheet" type="text/css" href="./css/common.css">
	</head>
	<body onload='changeDim("onload")' onselectstart="return false">
		<form name="frm_main" method="post" id="frm_main">
	<table class="Header" style="border-collapse:collapse;border:none">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">�Z���N�^
			</td>
		</tr>
	</table>
<div style="margin:15">
<span class="title">�ި�ݼ��/Ҽެ����F</span>
<select id='dimList' name='dimList' onchange='javaScript:changeDim("dimChange");'>

<%
	int i = 0;
	String measureID = Constants.MeasureID;

	Report report = (Report)session.getAttribute("report");
	String targetAxisID = (String)request.getParameter("targetAxisID");

	// �v�����ꂽ��ID���f�t�H���g�I���Ƃ��āA�f�B�����V����/���W���[�I�����X�g���쐬
	String selectedString = "";
	if ( measureID.equals(targetAxisID) ) {
		selectedString = "selected=true";
	}
	out.println("<option value=''  id='" + measureID + "' " +selectedString+ ">���W���[</option>");
	for ( i=0; i < report.getTotalDimensionNumber(); i++ ) {
		Dimension dim = (Dimension) report.getAxisByID(Integer.toString(i+1));
		selectedString = "";
		if ( String.valueOf(i+1).equals(targetAxisID) ) {
			selectedString = "selected=true";
		}
		out.println("<option value='' id='" + (i+1) + "'" +selectedString+ ">" + dim.getName() + "</option>");
	}
%>
</select>

<span id="dimMemberNameTypeArea" style="display:none">
	<span class="title">�����o�[���\���F</span>
	<select id="dimMemberNameType" onchange='javaScript:changeDimMemNameType(this)'>
<%

		// �f�B�����V�����̃����o�󋵕\�����𐶐�
		ArrayList dimMemberDispTypeList = new ArrayList();
		for ( i=0; i < report.getTotalDimensionNumber(); i++ ) {
			Dimension dim = (Dimension) report.getAxisByID(Integer.toString(i+1));
			dimMemberDispTypeList.add(dim.getId() + ":" + dim.getDispMemberNameType());
		}
		String dimMemberDispTypesString = "";
		Iterator it = dimMemberDispTypeList.iterator();
		i = 0;
		while (it.hasNext()) {
			if ( i > 0 ) {
				dimMemberDispTypesString += ",";
			}
			dimMemberDispTypesString += (String) it.next();
			i++;
		}

		out.println("<option name='" + Dimension.DISP_SHORT_NAME + "'>�V���[�g�l�[��</option>");
		out.println("<option name='" + Dimension.DISP_LONG_NAME + "'>�����O�l�[��</option>");

%>
	</select>
</span>

</div>

<!-- Selecter Body���ɕ\����v�����鎲��ID -->
<input type='hidden' name='dimNumber' value=''>

		</form>

		<!-- �f�B�����V����/���W���[���̃����o��KEY�E�h�������i�[�p�G���A -->
		<div id="statusArea" style="display:none">
			<div id="1"></div>
			<div id="2"></div>
			<div id="3"></div>
			<div id="4"></div>
			<div id="5"></div>
			<div id="6"></div>
			<div id="7"></div>
			<div id="8"></div>
			<div id="9"></div>
			<div id="10"></div>
			<div id="11"></div>
			<div id="12"></div>
			<div id="13"></div>
			<div id="14"></div>
			<div id="15"></div>
			<div id="16"></div>
		</div>

		<!-- �u�f�B�����V����/���W���[���v���X�g�{�b�N�X�̐؂�ւ��O�̒l�i��ID�j -->
		<div id="beforeDimArea" style="display:none">
			<div id="beforeDimID"><%= measureID %></div>
		</div>

		<!-- ���W���[�^�C�v -->
		<div id="measureTypeArea" style="display:none">
			<div id="measureType"></div>
		</div>

		<!-- �f�B�����V�����̃����o�[���̕\���^�C�v -->
		<div id="dimMemDispTypeArea" style="display:none">
			<div id="dimMemDispTypes"><%= dimMemberDispTypesString %></div>
		</div>

	</body>
</html>
<script>

var measureID = <%= measureID %>

function changeDim( source ) {

	// ��ID
	var dimID = document.frm_main.dimList.options[document.frm_main.dimList.selectedIndex].id;

	// �f�B�����V���������o�\�����̃^�C�v�I�𗓂�������
	if ( dimID != measureID ) {	// ���W���[
		initDimMemDispTypeSelection();
	}

	// �f�B�����V���������o�̕\�����I�𗓂̕\��/��\���ؑ�
	if ( dimID == measureID ) {	// ���W���[
		document.all("dimMemberNameTypeArea").style.display = "none";
	} else {	// �f�B�����V����
		document.all("dimMemberNameTypeArea").style.display = "";
	}

	if ( source == "dimChange" ) {

		// ���݁A�ݒ蒆�̃f�B�����V����/���W���[�̃����o��Ԃ�ۑ�
		var ret = parent.frm_body.setSelectedList( document.all("beforeDimID").innerText, "dimChange" );
		if ( ret == -1 ) {
			// �f�B�����V����/���W���[�I�𗓂̑I�������ɖ߂�
			var dimListOptionArray = document.frm_main.dimList.options;
			for ( var i = 0; i < dimListOptionArray.length; i++ ) {
				if ( dimListOptionArray[i].id == document.all("beforeDimID").innerText ) {
					dimListOptionArray[i].selected = true;
				} else {
					dimListOptionArray[i].selected = false;
				}
			}
			return false;
		}

	} else if ( source == "onload" ) {

		// �f�B�����V���������o�̕\�����I�𗓂̕\��/��\���ؑ�
		if ( dimID == measureID ) {	// ���W���[
			document.all("dimMemberNameTypeArea").style.display = "none";
		} else {	// �f�B�����V����
			document.all("dimMemberNameTypeArea").style.display = "";
		}

		// �G�b�W�z�u�����擾
		// �i�s���y�[�W�ɔz�u���ꂽ�f�B�����V����/���W���[ID���X�g�j

// Modal Dialog
//		var axesXMLData = parent.window.opener.parent.info_area.axesXMLData;
		var axesXMLData = window.dialogArguments[1];

		var colIDString = "";
		var rowIDString = "";
		var pageIDString = "";

		var colIDs = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/COL/HierarchyID");
		for ( i = 0; i < colIDs.length ; i++ ) {
			if ( colIDString == "" ) {
				colIDString =  colIDs[i].text;
			} else {
				colIDString += "," + colIDs[i].text;
			}
		}
		var rowIDs = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/ROW/HierarchyID");
		for ( i = 0; i < rowIDs.length ; i++ ) {
			if ( rowIDString == "" ) {
				rowIDString =  rowIDs[i].text;
			} else {
				rowIDString += "," + rowIDs[i].text;
			}
		}
		var pageIDs = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/PAGE/HierarchyID");
		for ( i = 0; i < pageIDs.length ; i++ ) {
			if ( pageIDString == "" ) {
				pageIDString =  pageIDs[i].text;
			} else {
				pageIDString += "," + pageIDs[i].text;
			}
		}

		// ���ݕ\�����̎������o��ID�ƃh������Ԃ�ݒ�
		var axes = axesXMLData.selectNodes("/root/Axes/Members");
		var statusArea = document.all("statusArea");
		for ( i = 0; i < axes.length; i++ ) {
			var axisInfo = "";
			var axisMembers = axes[i].selectNodes(".//Member");
			for ( var j = 0; j < axisMembers.length; j++ ) {
				var key = axisMembers[j].selectSingleNode("UName").text;
				var isDrilledString = axisMembers[j].selectSingleNode("isDrilled").text;
				var isDrilled = null;
				if ( isDrilledString == "true" ) {
					isDrilled = "1";
				} else {
					isDrilled = "0";
				}

				if ( j > 0 ) {
					axisInfo += ",";
				}
				axisInfo += key + ":" + isDrilled;
//alert("axis" + i + "," + key + "," + isDrilledString + "," + isDrilled);
			}

			var axisIndex = null;
			if ( i != axes.length-1 ) {
				axisIndex = i;
			} else {
				axisIndex = 15;
			}
			statusArea.childNodes[axisIndex].innerText = axisInfo;
		}
	}

    // ���݂�dimID��ۑ�
	document.frm_main.dimNumber.value = dimID;

	// ���݂�dimID������̃f�B�����V����/���W���[���؂�ւ����Ɏg�p���邽�߂Ɉꎞ�ۑ�
	document.all("beforeDimID").innerText = dimID;

	document.frm_main.action = "Controller?action=displaySelecterBody&dispMemNameType=" + getDimMemNameTypeByDimID( dimID );
	document.frm_main.target = "frm_body";
	document.frm_main.submit();

}

// �f�B�����V�����̃����o���̕\���^�C�v�I�𗓂̃f�t�H���g�\���l��ݒ�
function initDimMemDispTypeSelection() {

	var dimMemDispType = getDimMemNameTypeByDimID( document.frm_main.dimList.options[document.frm_main.dimList.selectedIndex].id );

	var dimMemOptionArray = document.frm_main.dimMemberNameType.options;
	for ( var i = 0; i < dimMemOptionArray.length; i++ ) {
		if ( dimMemOptionArray[i].name == dimMemDispType ) {
			dimMemOptionArray[i].selected = true;
		} else {
			dimMemOptionArray[i].selected = false;
		}
	}
}

function changeDimMemNameType( obj ) {
// �f�B�����V�����̃����o�̕\�����^�C�v���ύX���ꂽ���ɌĂяo����A
// �Z���N�^�ŕ\������Ă��郁���o�̕\�����^�C�v��ύX���A�I�����ꂽ�l��DIV�ɉ��ۑ�

	var dimMemDispTypeArray = document.getElementById("dimMemDispTypeArea").firstChild.innerText.split(",");
	var selectedDimID = document.frm_main.dimList.options[document.frm_main.dimList.selectedIndex].id;
	var selectedDimMemDispType = document.frm_main.dimMemberNameType.options[document.frm_main.dimMemberNameType.selectedIndex].name;

	// �I�����ꂽ�����o�̕\�����^�C�v�ɏ]���A�����o�\������؂�ւ�
	parent.frm_body.changeDisplayName(selectedDimMemDispType);

	// �I�����ꂽ�����o�̕\�����^�C�v��DIV�ɉ��ۑ�
	for ( var i = 0; i < dimMemDispTypeArray.length; i++ ) {
		// dimMemDispTypeArray[i].split(":")[0]: �f�B�����V����ID
		// dimMemDispTypeArray[i].split(":")[1]: �f�B�����V�����̃����o�\�����^�C�v

		var dimMemDispTypeIDValue = dimMemDispTypeArray[i].split(":")
		if ( selectedDimID == dimMemDispTypeIDValue[0] ) {
			dimMemDispTypeIDValue[1] = selectedDimMemDispType;
			dimMemDispTypeArray[i] = dimMemDispTypeIDValue.join(":");
		}
	}

	document.getElementById("dimMemDispTypeArea").firstChild.innerText = dimMemDispTypeArray.join(",");
}

function getDimMemNameTypeByDimID( dimId ) {
// �^����ꂽ�f�B�����V����ID�ɑ΂���\�����^�C�v��Ԃ�
// (�N���C�A���g���ŉ��ݒ�(DIV)����Ă���l)

	var dimMemDispTypeArray = document.getElementById("dimMemDispTypeArea").firstChild.innerText.split(",");
	for ( var i = 0; i < dimMemDispTypeArray.length; i++ ) {
		// dimMemDispTypeArray[i].split(":")[0]: �f�B�����V����ID
		// dimMemDispTypeArray[i].split(":")[1]: �f�B�����V�����̃����o�\�����^�C�v

		var dimMemDispTypeIDValue = dimMemDispTypeArray[i].split(":")
		if ( dimId == dimMemDispTypeIDValue[0] ) {
			return dimMemDispTypeIDValue[1];
		}
	}
}

</script>

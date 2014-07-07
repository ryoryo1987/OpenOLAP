<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*, java.net.*" %>
<%@ include file="../../connect.jsp"%>

<%
	String Sql;
	String objKind = request.getParameter("objKind");
	int userSeq = Integer.parseInt(request.getParameter("userSeq"));
	int objSeq = Integer.parseInt(request.getParameter("objSeq"));

	//最大レベル数
	String maxLevel=(String)session.getValue("strMaxLevel");

	String strUserName="";
	Sql = "SELECT name FROM oo_user WHERE user_seq = " + userSeq;
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		strUserName = rs.getString("name");
		session.putValue("strUserName",strUserName);
	}
	rs.close();

	String strName="";
	String strComment="";
	String strDimType=(String)session.getValue("dimType");
	String strTotalFlg="1";
	String strSortType = "1";
	String strSortOrder = "1";

	Sql = "SELECT d.name,d.comment,coalesce(d.dim_type,'1') AS dim_type,d.total_flg,d.sort_type,d.sort_order";
	Sql = Sql + " FROM oo_dimension d";
	Sql = Sql + " WHERE d.dimension_seq = " + objSeq;
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		strName = rs.getString("name");
		strComment = rs.getString("comment");
		strDimType = rs.getString("dim_type");
		strTotalFlg = rs.getString("total_flg");
		strSortType = rs.getString("sort_type");
		strSortOrder = rs.getString("sort_order");
	}
	rs.close();


	String strTableFlg="0";
	String strViewFlg="0";

	Sql = "SELECT table_flg,view_flg";
	Sql = Sql + " FROM oo_user";
	Sql = Sql + " WHERE user_seq = " + userSeq;
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		strTableFlg = rs.getString("table_flg");
		strViewFlg = rs.getString("view_flg");
	}
	rs.close();



%>

<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript" src="../js/common.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/common.css">

	<script language="JavaScript">

		var max_num=<%=maxLevel%>;//レベルMAX数

			function load(){

<%

			String parentLevelSeq="";
		//	Sql = "SELECT l.level_seq,l.dimension_seq,l.level_no,l.name,l.comment,l.table_name,l.long_name_col,l.short_name_col,l.sort_col,l.sort_type,l.sort_order";
			Sql = "SELECT l.level_seq,l.dimension_seq,l.level_no,l.name,l.comment,l.table_name,l.long_name_col,l.short_name_col,l.sort_col";
			Sql = Sql + " ,l.key_col1,l.key_col2,l.key_col3,l.key_col4,l.key_col5";
			Sql = Sql + " ,l.link_col1,l.link_col2,l.link_col3,l.link_col4,l.link_col5";
			Sql = Sql + " ,l.where_clause,c.x_point,c.y_point";
			Sql = Sql + " ,oo_fun_columnList(l.table_name,'" + strUserName + "') AS columnlist";
			Sql = Sql + " FROM oo_level l";
			Sql = Sql + " ,oo_level_chart c";
			Sql = Sql + " WHERE l.dimension_seq = " + objSeq;
			Sql = Sql + " AND l.level_seq = c.level_seq";
			Sql = Sql + " ORDER BY l.level_no";
			rs = stmt.executeQuery(Sql);
			while(rs.next()){

				out.println("if(document.all." + rs.getString("table_name") + "==undefined){");
				out.println("document.all.div_hid.innerHTML += '<select name=\"" + rs.getString("table_name") + "\"><option value=\"\">---------------</option></select>';");

				StringTokenizer st = new StringTokenizer(rs.getString("columnlist"),",");
				while(st.hasMoreTokens()) {

					String columnText = st.nextToken();
					StringTokenizer st2 = new StringTokenizer(columnText," ");
					String columnName = st2.nextToken();
%>
						var tempOpValue = "<%=columnName%>";
						var tempOpText = "<%=columnText%>";

						//カラムリストのクローンを作成
						addOption = document.createElement("OPTION");
						addOption.value = tempOpValue;
						addOption.text = tempOpText;
						document.form_main.elements["<%=rs.getString("table_name")%>"].options.add(addOption);
<%
				}
				out.println("}");
%>
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_name" mON="レベル名" value="<%=rs.getString("name")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_comment" mON="コメント" value="<%=rs.getString("comment")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_table" mON="テーブル" value="<%=rs.getString("table_name")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_longname" mON="ロングネーム" value="<%=rs.getString("long_name_col")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_shortname" mON="ショートネーム" value="<%=rs.getString("short_name_col")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_sortcol" mON="ソートカラム" value="<%=rs.getString("sort_col")%>">';
			//	document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_sorttype" mON="ソートタイプ" value="<%//=rs.getString("sort_type")%>">';
			//	document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_sortorder" mON="ソート順" value="<%//=rs.getString("sort_order")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_keycol1" mON="キーカラム" value="<%=rs.getString("key_col1")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_keycol2" value="<%=rs.getString("key_col2")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_keycol3" value="<%=rs.getString("key_col3")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_keycol4" value="<%=rs.getString("key_col4")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_keycol5" value="<%=rs.getString("key_col5")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_m_linkcol1" value="<%=rs.getString("link_col1")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_m_linkcol2" value="<%=rs.getString("link_col2")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_m_linkcol3" value="<%=rs.getString("link_col3")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_m_linkcol4" value="<%=rs.getString("link_col4")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_m_linkcol5" value="<%=rs.getString("link_col5")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_level_no" value="<%=rs.getString("level_no")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_where_clause" mON="WHERE句" value="<%=ood.replace(ood.replace(ood.replace(rs.getString("where_clause"),"\\","\\\\"),"'","\\'"),"\r\n","\\n")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_x_point" value="<%=rs.getString("x_point")%>">';
				document.all.div_hid.innerHTML += '<input type="hidden" name="hid_lv<%=rs.getString("level_seq")%>_y_point" value="<%=rs.getString("y_point")%>">';

				showDiv(<%=rs.getString("level_seq")%>,"level","<%=rs.getString("name")%>",<%=rs.getString("x_point")%>,<%=rs.getString("y_point")%>);


				<%if(!"".equals(parentLevelSeq)){%>
					chart.makeLine(chart.document.getElementById("body_<%=parentLevelSeq%>"),chart.document.getElementById("body_<%=rs.getString("level_seq")%>"));
					levelCheck();
				//	chart.document.getElementById("body_<%=parentLevelSeq%>,body_<%=rs.getString("level_seq")%>").lastChild.dashstyle='';
					mappingCheck();
				<%}%>
<%

				parentLevelSeq = rs.getString("level_seq");
			}
			rs.close();
%>
			}






		//レベルアイコンの表示
		function showDiv(levelSeq,type,objName,x_point,y_point){

			for(i=1;i<=max_num;i++){
				div_id = "div_" + type + i;
				if(chart.document.getElementById(div_id).objId=="0"){
					lay_id = div_id;
					break;
				}
				if(i==max_num){
					showMsg("DIM4",max_num);
					return;
				}
			}

			if(x_point==undefined){
				var pixelTopValue=50;
				var pixelLeftValue=50;
				for(i=1;i<=max_num;i++){
					div_id = "div_" + type + i;
					if(chart.document.getElementById(div_id).objId!="0"){
						if((pixelTopValue==chart.document.getElementById(div_id).style.pixelTop)&&(pixelLeftValue==chart.document.getElementById(div_id).style.pixelLeft)){
							var pixelTopValue=pixelTopValue+20;
							var pixelLeftValue=pixelLeftValue+20;
							i=0;
						}
					}
				}
			}else{
				var pixelTopValue=y_point;
				var pixelLeftValue=x_point;
			}
			chart.document.getElementById(lay_id).style.pixelTop=pixelTopValue;
			chart.document.getElementById(lay_id).style.pixelLeft=pixelLeftValue;

			chart.document.getElementById(lay_id).objId=levelSeq;
			chart.document.getElementById(lay_id).style.display="block";

			if(objName==null){
				objName="";
			}
			strHTML = "";
			strHTML += '<div id="head_' + levelSeq + '" head_value="' + levelSeq + '" type="' + type + '" move="1" style="cursor:move;text-align:center;border:1 solid #C2AC74;border-bottom:3 double #C2AC74;color:#333333;padding:2 2 2 2;font-weight:bold;background-color:#ffeedd;width:100;" basecolor="white" onclick="objectSelected(this);parent.showPpty(1,this);">レベル</div>';
			strHTML += '<div id="body_' + levelSeq + '" head_value="' + levelSeq + '" type="' + type + '" move="2" style="cursor:crosshair;text-align:center;border:1 solid #C2AC74;padding:2 2 2 2;background:#ffeedd;width:100;height:30;OVERFLOW: hidden;TEXT-OVERFLOW: ellipsis;" onclick="objectSelected(parentNode.firstChild);parent.showPpty(1,this);">' + objName + '</div>';
			chart.document.getElementById(lay_id).innerHTML = strHTML + '<div id="map"></div>';

		}



		//レベルをチェックしてレベルNOを表示
		function levelCheck(){

			var j=0;
			var k=0;
			var mappingObjectNum=0;
			var strHTML="";
			var firstObjId="";

			for(i=1;i<=max_num;i++){
				var div_id = "div_level" + i;
				if(chart.document.getElementById(div_id).objId!="0"){
					j++;
					var passiveObj = "";
					var activeObj = "";
					var exeOrderNum = 1;
					for(lineNum=0;lineNum<chart.document.getElementById(div_id).lastChild.childNodes.length;lineNum++){
						if(lineNum==0){mappingObjectNum++;}
						var arr1 = chart.document.getElementById(div_id).lastChild.childNodes[lineNum].id.split(',');
						if(arr1[0] == "t"){
							passiveObj = arr1[1].replace("body_","");

							//自分が何番目のLEVELかを探査
							var div_id2 = chart.document.getElementById("head_" + passiveObj).parentNode.id;
							exeOrderNum++;
							var passiveFlg = false;
							for(lineNum2=0;lineNum2<chart.document.getElementById(div_id2).lastChild.childNodes.length;lineNum2++){

								//無限ループ回避
								if(exeOrderNum>max_num){
									showMsg("DIM5");
									chart.deleteLine(chart.document.getElementById("lineSource").lastChild.id);//最後にappendされたLINEを削除
									return;
								}

								var arr2 = chart.document.getElementById(div_id2).lastChild.childNodes[lineNum2].id.split(',');
								if(arr2[0] == "t"){
									passiveFlg = true;//フラグを立てる
									div_id2 = chart.document.getElementById("head_" + arr2[1].replace("body_","")).parentNode.id;//LEVELを次のパッシブLEVELにセット
									lineNum2=-1;//FOR文のカウントを初期化
									exeOrderNum++;
								}
								if((lineNum2==chart.document.getElementById(div_id2).lastChild.childNodes.length-1)&&(passiveFlg==false)){break;};
							}
						}else if(arr1[0] == "f"){
							activeObj = arr1[2].replace("body_","");
						}
						 chart.document.getElementById(div_id).firstChild.innerHTML="レベル " + exeOrderNum;
						 chart.document.getElementById(div_id).level=exeOrderNum;
					}
				}
			}

		}



		function mappingCheck(){
			setData();
			for(var ob=0;ob<chart.document.all.length;ob++){
				if((chart.document.all(ob).tagName=="line")&&(chart.document.all(ob).id!="dashline")){
					var mappingFlg = true;
					var arr = chart.document.all(ob).id.split(',');
					var parLvlSeq=arr[0].replace('body_','');
					var cldLvlSeq=arr[1].replace('body_','');
					if((document.form_main.elements["hid_lv" + parLvlSeq + "_keycol1"].value=="")||(document.form_main.elements["hid_lv" + cldLvlSeq + "_m_linkcol1"].value=="")){
						mappingFlg = false;
					}
					if(!(((document.form_main.elements["hid_lv" + parLvlSeq + "_keycol1"].value=="")&&(document.form_main.elements["hid_lv" + cldLvlSeq + "_m_linkcol1"].value==""))||((document.form_main.elements["hid_lv" + parLvlSeq + "_keycol1"].value!="")&&(document.form_main.elements["hid_lv" + cldLvlSeq + "_m_linkcol1"].value!="")))){
						mappingFlg = false;
					}
					if(!(((document.form_main.elements["hid_lv" + parLvlSeq + "_keycol2"].value=="")&&(document.form_main.elements["hid_lv" + cldLvlSeq + "_m_linkcol2"].value==""))||((document.form_main.elements["hid_lv" + parLvlSeq + "_keycol2"].value!="")&&(document.form_main.elements["hid_lv" + cldLvlSeq + "_m_linkcol2"].value!="")))){
						mappingFlg = false;
					}
					if(!(((document.form_main.elements["hid_lv" + parLvlSeq + "_keycol3"].value=="")&&(document.form_main.elements["hid_lv" + cldLvlSeq + "_m_linkcol3"].value==""))||((document.form_main.elements["hid_lv" + parLvlSeq + "_keycol3"].value!="")&&(document.form_main.elements["hid_lv" + cldLvlSeq + "_m_linkcol3"].value!="")))){
						mappingFlg = false;
					}
					if(!(((document.form_main.elements["hid_lv" + parLvlSeq + "_keycol4"].value=="")&&(document.form_main.elements["hid_lv" + cldLvlSeq + "_m_linkcol4"].value==""))||((document.form_main.elements["hid_lv" + parLvlSeq + "_keycol4"].value!="")&&(document.form_main.elements["hid_lv" + cldLvlSeq + "_m_linkcol4"].value!="")))){
						mappingFlg = false;
					}
					if(!(((document.form_main.elements["hid_lv" + parLvlSeq + "_keycol5"].value=="")&&(document.form_main.elements["hid_lv" + cldLvlSeq + "_m_linkcol5"].value==""))||((document.form_main.elements["hid_lv" + parLvlSeq + "_keycol5"].value!="")&&(document.form_main.elements["hid_lv" + cldLvlSeq + "_m_linkcol5"].value!="")))){
						mappingFlg = false;
					}
					if(mappingFlg){
						chart.document.all(ob).lastChild.dashstyle='';
					}else{
						chart.document.all(ob).lastChild.dashstyle='dash';
					}
				}
			}
		}




		//プロパティー画面の表示切替
		function showPpty(type,obj){
			setData();
			levelCheck();
			if(type==1){
				document.getElementById("tbl_level").style.display="block";
				document.getElementById("tbl_mapping").style.display="none";
				document.getElementById("tbl_none").style.display="none";
			}
			if(type==11){
				document.getElementById("tbl_level").style.display="none";
				document.getElementById("tbl_mapping").style.display="block";
				document.getElementById("tbl_none").style.display="none";
			}
			if(type==0){
				document.getElementById("tbl_level").style.display="none";
				document.getElementById("tbl_mapping").style.display="none";
				document.getElementById("tbl_none").style.display="block";
			}
			dispData(obj);
		}



		//プロパティー画面の値を隠しオブジェクトにセット
		function setData(){
			if(document.getElementById("tbl_level").style.display=="block"){
				var lvlseq = document.form_main.hid_current_lvlseq.value;
				chart.document.getElementById("body_" + document.form_main.hid_current_lvlseq.value).innerHTML=document.form_main.txt_level_name.value;
				document.form_main.elements["hid_lv" + lvlseq + "_name"].value=document.form_main.txt_level_name.value;
				document.form_main.elements["hid_lv" + lvlseq + "_comment"].value=document.form_main.txt_level_comment.value;
				document.form_main.elements["hid_lv" + lvlseq + "_table"].value=document.form_main.lst_table.value;
				document.form_main.elements["hid_lv" + lvlseq + "_longname"].value=document.form_main.lst_longname.value;
				document.form_main.elements["hid_lv" + lvlseq + "_shortname"].value=document.form_main.lst_shortname.value;
				document.form_main.elements["hid_lv" + lvlseq + "_sortcol"].value=document.form_main.lst_sortcol.value;
			//	document.form_main.elements["hid_lv" + lvlseq + "_sorttype"].value=document.form_main.lst_sorttype.value;
			//	document.form_main.elements["hid_lv" + lvlseq + "_sortorder"].value=document.form_main.lst_sortorder.value;
				document.form_main.elements["hid_lv" + lvlseq + "_keycol1"].value=document.form_main.lst_keycol1.value;
				document.form_main.elements["hid_lv" + lvlseq + "_keycol2"].value=document.form_main.lst_keycol2.value;
				document.form_main.elements["hid_lv" + lvlseq + "_keycol3"].value=document.form_main.lst_keycol3.value;
				document.form_main.elements["hid_lv" + lvlseq + "_keycol4"].value=document.form_main.lst_keycol4.value;
				document.form_main.elements["hid_lv" + lvlseq + "_keycol5"].value=document.form_main.lst_keycol5.value;
				document.form_main.elements["hid_lv" + lvlseq + "_where_clause"].value=document.form_main.txt_where_clause.value;
				document.form_main.elements["hid_lv" + lvlseq + "_x_point"].value=chart.document.getElementById("body_" + document.form_main.hid_current_lvlseq.value).parentNode.style.pixelLeft;
				document.form_main.elements["hid_lv" + lvlseq + "_y_point"].value=chart.document.getElementById("body_" + document.form_main.hid_current_lvlseq.value).parentNode.style.pixelTop;
			}else if(document.getElementById("tbl_mapping").style.display=="block"){
				var lvlseq = document.form_main.hid_current_lvlseq.value;
				document.form_main.elements["hid_lv" + lvlseq + "_m_linkcol1"].value=document.form_main.lst_m_linkcol1.value;
				document.form_main.elements["hid_lv" + lvlseq + "_m_linkcol2"].value=document.form_main.lst_m_linkcol2.value;
				document.form_main.elements["hid_lv" + lvlseq + "_m_linkcol3"].value=document.form_main.lst_m_linkcol3.value;
				document.form_main.elements["hid_lv" + lvlseq + "_m_linkcol4"].value=document.form_main.lst_m_linkcol4.value;
				document.form_main.elements["hid_lv" + lvlseq + "_m_linkcol5"].value=document.form_main.lst_m_linkcol5.value;
			}
		}


		//隠しオブジェクトから値を取得しプロパティー画面にセット
		function dispData(obj){
			if(document.getElementById("tbl_level").style.display=="block"){
				var lvlseq = obj.head_value;
				if(document.form_main.elements["hid_lv" + lvlseq + "_name"]!=undefined){
					document.form_main.txt_level_name.value=document.form_main.elements["hid_lv" + lvlseq + "_name"].value;
					document.form_main.txt_level_comment.value=document.form_main.elements["hid_lv" + lvlseq + "_comment"].value;
					document.form_main.lst_table.options[selectedValue(document.form_main.lst_table,document.form_main.elements["hid_lv" + lvlseq + "_table"].value)].selected=true;
					createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_longname',document.form_main.elements["hid_lv" + lvlseq + "_longname"].value)
					createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_shortname',document.form_main.elements["hid_lv" + lvlseq + "_shortname"].value)
					createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_sortcol',document.form_main.elements["hid_lv" + lvlseq + "_sortcol"].value)
				//	document.form_main.lst_sorttype.options[selectedValue(document.form_main.lst_sorttype,document.form_main.elements["hid_lv" + lvlseq + "_sorttype"].value)].selected=true;
				//	document.form_main.lst_sortorder.options[selectedValue(document.form_main.lst_sortorder,document.form_main.elements["hid_lv" + lvlseq + "_sortorder"].value)].selected=true;
					createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_keycol1',document.form_main.elements["hid_lv" + lvlseq + "_keycol1"].value)
					createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_keycol2',document.form_main.elements["hid_lv" + lvlseq + "_keycol2"].value)
					createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_keycol3',document.form_main.elements["hid_lv" + lvlseq + "_keycol3"].value)
					createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_keycol4',document.form_main.elements["hid_lv" + lvlseq + "_keycol4"].value)
					createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_keycol5',document.form_main.elements["hid_lv" + lvlseq + "_keycol5"].value)
					document.form_main.txt_where_clause.value=document.form_main.elements["hid_lv" + lvlseq + "_where_clause"].value;
				}
				document.form_main.hid_current_lvlseq.value=lvlseq;
			}else if(document.getElementById("tbl_mapping").style.display=="block"){
				document.form_main.hid_current_mapping.value=obj.id;
				var arr = obj.id.split(',');
				var parLvlseq = arr[0].replace("body_","");
				var lvlseq = arr[1].replace("body_","");

				document.all.span_lvl_name1.innerHTML=chart.document.getElementById("head_" + parLvlseq).innerHTML;
				document.all.span_lvl_name2.innerHTML=chart.document.getElementById("head_" + lvlseq).innerHTML;

				createColumnList(document.form_main.elements["hid_lv" + parLvlseq + "_table"].value,'lst_m_keycol1',document.form_main.elements["hid_lv" + parLvlseq + "_keycol1"].value)
				createColumnList(document.form_main.elements["hid_lv" + parLvlseq + "_table"].value,'lst_m_keycol2',document.form_main.elements["hid_lv" + parLvlseq + "_keycol2"].value)
				createColumnList(document.form_main.elements["hid_lv" + parLvlseq + "_table"].value,'lst_m_keycol3',document.form_main.elements["hid_lv" + parLvlseq + "_keycol3"].value)
				createColumnList(document.form_main.elements["hid_lv" + parLvlseq + "_table"].value,'lst_m_keycol4',document.form_main.elements["hid_lv" + parLvlseq + "_keycol4"].value)
				createColumnList(document.form_main.elements["hid_lv" + parLvlseq + "_table"].value,'lst_m_keycol5',document.form_main.elements["hid_lv" + parLvlseq + "_keycol5"].value)
				createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_m_linkcol1',document.form_main.elements["hid_lv" + lvlseq + "_m_linkcol1"].value)
				createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_m_linkcol2',document.form_main.elements["hid_lv" + lvlseq + "_m_linkcol2"].value)
				createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_m_linkcol3',document.form_main.elements["hid_lv" + lvlseq + "_m_linkcol3"].value)
				createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_m_linkcol4',document.form_main.elements["hid_lv" + lvlseq + "_m_linkcol4"].value)
				createColumnList(document.form_main.elements["hid_lv" + lvlseq + "_table"].value,'lst_m_linkcol5',document.form_main.elements["hid_lv" + lvlseq + "_m_linkcol5"].value)
				document.form_main.hid_current_lvlseq.value=lvlseq;
			}
		}





		//テーブル切り替え時、カラムリストを変更
		function changeTabelList(obj){
			
			//Submitのリスト変更ではマッピングチェックに間に合わない為、とりあえずリストを未選択にする。
			document.form_main.lst_keycol1.options[0].selected=true;
			document.form_main.lst_keycol2.options[0].selected=true;
			document.form_main.lst_keycol3.options[0].selected=true;
			document.form_main.lst_keycol4.options[0].selected=true;
			document.form_main.lst_keycol5.options[0].selected=true;
			//リンクカラムの初期化
			document.form_main.elements["hid_lv" + document.form_main.hid_current_lvlseq.value + "_m_linkcol1"].value="";
			document.form_main.elements["hid_lv" + document.form_main.hid_current_lvlseq.value + "_m_linkcol2"].value="";
			document.form_main.elements["hid_lv" + document.form_main.hid_current_lvlseq.value + "_m_linkcol3"].value="";
			document.form_main.elements["hid_lv" + document.form_main.hid_current_lvlseq.value + "_m_linkcol4"].value="";
			document.form_main.elements["hid_lv" + document.form_main.hid_current_lvlseq.value + "_m_linkcol5"].value="";


			mappingCheck();//マッピングチェック

			document.form_main.action = "../hidden/change_table.jsp?type=dim&table_name=" + obj.value;
			document.form_main.target = "frm_hidden";
			document.form_main.submit();


/*
			var div_id = chart.document.getElementById("head_" + document.form_main.hid_current_lvlseq.value).parentNode.id;
			for(lineNum=0;lineNum<chart.document.getElementById(div_id).lastChild.childNodes.length;lineNum++){
				chart.document.getElementById(chart.document.getElementById(div_id).lastChild.childNodes[lineNum].id.replace("f,","").replace("t,","")).lastChild.dashstyle='dash';
			}
*/
		}


		//レベル情報を隠しオブジェクトにセットし、保存・削除処理を実行
		function regist(tp) {

			if (tp!=2) {

				var levelNum=setBeforeRegist();

				//共通エラーチェックを先に行う
				if(!checkData()){return;}

				if(document.form_main.hid_levelseq_string.value==""){
					showMsg("DIM1");
					return;
				}

				//マッピングチェック
				var mappingNum=0;
				for(i=0;i<chart.document.getElementById("lineSource").childNodes.length;i++){
					if(chart.document.getElementById("lineSource").childNodes[i].firstChild!=undefined){
						if(chart.document.getElementById("lineSource").childNodes[i].firstChild.dashstyle=="dash"){
							var arr = chart.document.getElementById("lineSource").childNodes[i].id.split(',');
							var obj1=chart.document.getElementById("head_" + arr[0].replace("body_","")).innerHTML;
							var obj2=chart.document.getElementById("head_" + arr[1].replace("body_","")).innerHTML;
							showMsg("DIM2",obj1,obj2);
							return;
						}
						mappingNum++;
					}
				}

				//全てのレベル間でマッピングが行われているかをチェック
				if((levelNum-1)!=mappingNum){
					showMsg("DIM3");
					return;
				}
			}


			submitData("dim_regist.jsp",tp,"<%=objKind%>","<%=objSeq%>",document.form_main.txt_name.value);

		}



		function editWhereClause(){
		//	var newWin = window.open("../frm_filter.jsp?tableName=" + document.form_main.lst_table.value,"_blank","menubar=no,toolbar=no,width=720px,height=500px,resizable");
			window.showModalDialog("../frm_filter.jsp?tableName=" + document.form_main.lst_table.value,self,"dialogHeight:500px; dialogWidth:720px;");
		}

	</script>
</head>

<body onload="load()">

<form name="form_main" id="form_main" method="post" action="">
	<!-- レイアウト用 -->
	<div class="main" id="dv_main">
	<table class="frame">
		<tr>
			<td class="left_top"></td>
			<td class="top"></td>
			<td class="right_top"></td>
		</tr>
		<tr>
			<td class="left"></td>
			<td class="main" style="padding-left:10px;padding-right:10px">
			
 				<!-- コンテンツ -->
				<!-- **************************  MAIN TABLE <1>***************************** -->
				<table width="100%">
				<%if(!(objSeq==0)){%>
					<tr>
						<th width="150" class="standard">ディメンションID</th>
						<td class="standard" colspan="3">
							<%=objSeq%>
						</td>
					</tr>
				<%}%>

					<tr>
						<th width="150" class="standard">ディメンション名</th>
						<td class="standard" colspan="3">
							<input type="text" name="txt_name" value="<%=strName%>" mON="ディメンション名" maxlength="30" size="60" onChange="setChangeFlg();">
						</td>
					</tr>

					<tr>
						<th class="standard">コメント</th>
						<td class="standard" colspan="3">
							<input type="text" name="txt_comment" mON="コメント" value="<%=strComment%>" size="80" maxlength="250" onChange="setChangeFlg();">
						</td>
					</tr>
					<input type="hidden" name="lst_dim_type" value="0">

					<tr>
						<th class="standard">合計値</th>
						<td class="standard">
							<input type="checkbox" name="chk_total" mON="合計値" onChange="setChangeFlg();" <%if(strTotalFlg.equals("1")){%>checked<%}%>>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						<th class="standard">ソート</th>
						<td class="standard">
						&nbsp;&nbsp;&nbsp;&nbsp;ソートタイプ
						<select name="lst_sorttype" onChange="setChangeFlg();">
							<option value="1" <%if(strSortType.equals("1")){%>selected<%}%>>文字列</option>
							<option value="2" <%if(strSortType.equals("2")){%>selected<%}%>>数値</option>
						</select>
						&nbsp;&nbsp;&nbsp;&nbsp;ソート順
						<select name="lst_sortorder" onChange="setChangeFlg();">
							<option value="1" <%if(strSortOrder.equals("1")){%>selected<%}%>>昇順</option>
							<option value="2" <%if(strSortOrder.equals("2")){%>selected<%}%>>降順</option>
						</select>
						</td>
					</tr>
				</table>

				<div width="100%" align="right" style="margin-top:5px">
					<input type="button" value="" onclick="getNewSeq('level');setChangeFlg();" class="normal_level" onMouseOver="className='over_level'" onMouseDown="className='down_level'" onMouseUp="className='up_level'" onMouseOut="className='out_level'"><input type="button" value="" onclick="chart.del();setChangeFlg();" class="normal_delete_mini" onMouseOver="className='over_delete_mini'" onMouseDown="className='down_delete_mini'" onMouseUp="className='up_delete_mini'" onMouseOut="className='out_delete_mini'"><input type="button" value="" onclick="dispSqlViewer()" class="normal_sql" onMouseOver="className='over_sql'" onMouseDown="className='down_sql'" onMouseUp="className='up_sql'" onMouseOut="className='out_sql'">
				</div>


				<iframe name="chart" src="dim_chart.jsp?maxLevel=<%=maxLevel%>" width="100%" height="150" style="margin-bottom:10px"></iframe>

				<table id="tbl_none" class="standard" style="display:none;width:100%">
					<tr><td></td></tr>
				</table>
				<table id="tbl_level" style="display:none;width:100%">
				<tr>
					<th width="150" class="standard">
					レベル名
					</th>
					<td class="standard">
						<input type="text" name="txt_level_name" value="" maxlength="30" size="60" onChange="setChangeFlg();">
					</td>
				</tr>
				<tr>
					<th width="150" class="standard">
					コメント
					</th>
					<td class="standard">
						<input type="text" name="txt_level_comment" value="" size="80" maxlength="250" onChange="setChangeFlg();">
					</td>
				</tr>
				<tr>
					<th width="150" class="standard">
					テーブル
					</th>
					<td class="standard">
						<select name="lst_table" onchange="changeTabelList(this);setChangeFlg();">
							<option value="">---------------</option>
						<%
						Sql="";
						if("1".equals(strTableFlg)){
							Sql = Sql + "SELECT tablename as name";
							Sql = Sql + " FROM pg_tables";
							Sql = Sql + " WHERE schemaname like (select name from oo_user where user_seq = '" + userSeq + "')";
						}
						if(("1".equals(strTableFlg))&&("1".equals(strViewFlg))){
							Sql = Sql + " UNION ";
						}
						if("1".equals(strViewFlg)){
							Sql = Sql + "SELECT viewname as name";
							Sql = Sql + " FROM pg_views";
							Sql = Sql + " WHERE schemaname like (select name from oo_user where user_seq = '" + userSeq + "')";
						}
						Sql = Sql + " ORDER BY name";
						rs = stmt.executeQuery(Sql);
						while(rs.next()) {
							%>
							<option value="<%=rs.getString("name")%>"><%=rs.getString("name")%></option>
							<%
						}
						rs.close();
						%>
						</select>
					</td>
				</tr>
				<tr>
				<th width="150" class="standard">
				ロングネーム
				</th>
					<td class="standard">
						<select name="lst_longname" onChange="setChangeFlg();">
							<option value="">---------------</option>
						</select>
					</td>
				</tr>
				<tr>
					<th width="150" class="standard">
					ショートネーム
					</th>
					<td class="standard">
						<select name="lst_shortname" onChange="setChangeFlg();">
							<option value="">---------------</option>
						</select>
					</td>
				</tr>
				<tr>
					<th width="150" class="standard">
					ソートカラム
					</th>
					<td class="standard">
						<select name="lst_sortcol" onChange="setChangeFlg();">
							<option value="">---------------</option>
						</select>
						<!--
						&nbsp;&nbsp;&nbsp;&nbsp;ソートタイプ
						<select name="lst_sorttype" onChange="setChangeFlg();">
							<option value="1">文字列</option>
							<option value="2">数値</option>
						</select>
						&nbsp;&nbsp;&nbsp;&nbsp;ソート順
						<select name="lst_sortorder" onChange="setChangeFlg();">
							<option value="1">昇順</option>
							<option value="2">降順</option>
						</select>
						-->
					</td>
				</tr>
				<tr>
					<th width="150" class="standard">
					キーカラム
					</th>
					<td class="standard">
						<select name="lst_keycol1" onchange="mappingCheck();setChangeFlg();">
							<option value="">---------------</option>
						</select>
						<br>
						<select name="lst_keycol2" onchange="mappingCheck();setChangeFlg();">
							<option value="">---------------</option>
						</select>
						<br>
						<select name="lst_keycol3" onchange="mappingCheck();setChangeFlg();">
							<option value="">---------------</option>
						</select>
						<br>
						<select name="lst_keycol4" onchange="mappingCheck();setChangeFlg();">
							<option value="">---------------</option>
						</select>
						<br>
						<select name="lst_keycol5" onchange="mappingCheck();setChangeFlg();">
							<option value="">---------------</option>
						</select>
					</td>
				</tr>
				<tr>
					<th width="150" class="standard">
					WHERE句
					</th>
					<td class="standard">
					<!--	<input type="text" name="txt_where_clause" value="" size="80" maxlength="250" onChange="setChangeFlg();">-->
						<textarea name="txt_where_clause" value="" rows="2" cols="100" onChange="setChangeFlg();"></textarea>
					<!--	<input type="button" value="編集" onclick="editWhereClause()">-->
						<input type="button" value="" onclick="editWhereClause();setChangeFlg();" class="normal_edit" onMouseOver="className='over_edit'" onMouseDown="className='down_edit'" onMouseUp="className='up_edit'" onMouseOut="className='out_edit'" style="margin-bottom:5">
					</td>
				</tr>
				</table>


				<table id="tbl_mapping" style="display:none;">
					<tr>
						<td align="center"><span id="span_lvl_name1"></span>&nbsp;&nbsp;キーカラム</td>
						<td>&nbsp;</td>
						<td align="center"><span id="span_lvl_name2"></span>&nbsp;&nbsp;リンクカラム</td>
					</tr>
					<tr> 
						<td>
							<select name="lst_m_keycol1" disabled>
								<option value="">---------------------</option>
							</select>
						</td>
						<td>&nbsp;------&nbsp;</td>
						<td>
							<select name="lst_m_linkcol1" onchange="mappingCheck();setChangeFlg();">
								<option value="">---------------------</option>
							</select>
						</td>
					</tr>
					<tr> 
						<td>
							<select name="lst_m_keycol2" disabled>
								<option value="">---------------------</option>
							</select>
						</td>
						<td>&nbsp;------&nbsp;</td>
						<td>
							<select name="lst_m_linkcol2" onchange="mappingCheck();setChangeFlg();">
								<option value="">---------------------</option>
							</select>
						</td>
					</tr>
					<tr> 
						<td>
							<select name="lst_m_keycol3" disabled>
								<option value="">---------------------</option>
							</select>
						</td>
						<td>&nbsp;------&nbsp;</td>
						<td>
							<select name="lst_m_linkcol3" onchange="mappingCheck();setChangeFlg();">
								<option value="">---------------------</option>
							</select>
						</td>
					</tr>
					<tr> 
						<td>
							<select name="lst_m_keycol4" disabled>
								<option value="">---------------------</option>
							</select>
						</td>
						<td>&nbsp;------&nbsp;</td>
						<td>
							<select name="lst_m_linkcol4" onchange="mappingCheck();setChangeFlg();">
								<option value="">---------------------</option>
							</select>
						</td>
					</tr>
					<tr> 
						<td>
							<select name="lst_m_keycol5" disabled>
								<option value="">---------------------</option>
							</select>
						</td>
						<td>&nbsp;------&nbsp;</td>
						<td>
							<select name="lst_m_linkcol5" onchange="mappingCheck();setChangeFlg();">
								<option value="">---------------------</option>
							</select>
						</td>
					</tr>

				</table>

				<div class="command">
				<%if(objSeq==0){%>
				<!-- **************************  新規 ボタン ***************************** -->
					<input type="button" name="allcrt_btn" value="" onClick="JavaScript:regist(0);" class="normal_create" onMouseOver="className='over_create'" onMouseDown="className='down_create'" onMouseUp="className='up_create'" onMouseOut="className='out_create'">
				<%}else{%>
				<!-- **************************  更新 ボタン ***************************** -->
					<input type="button" name="edt_btn" value="" onClick="JavaScript:regist(1);" class="normal_update" onMouseOver="className='over_update'" onMouseDown="className='down_update'" onMouseUp="className='up_update'" onMouseOut="className='out_update'">
					<input type="button" name="del_btn" value="" onClick="JavaScript:regist(2);" class="normal_delete" onMouseOver="className='over_delete'" onMouseDown="className='down_delete'" onMouseUp="className='up_delete'" onMouseOut="className='out_delete'">
				<%}%>
				</div>

			</td>
			<td class="right"></td>
		</tr>
		<tr>
			<td class="left_bottom"></td>
			<td class="bottom"></td>
			<td class="right_bottom"></td>
		</tr>
	</table>
	</div>


<!--隠しオブジェクト-->
<div name="div_hid" id="div_hid" style="display:none;"></div>
<input type="hidden" name="hid_current_lvlseq" value="">
<input type="hidden" name="hid_current_mapping" value="">
<input type="hidden" name="hid_levelseq_string" id="hid_levelseq_string" value="">
<input type="hidden" name="hid_user_seq" id="hid_user_seq" value="<%=userSeq%>">
<input type="hidden" name="hid_obj_seq" id="hid_obj_seq" value="<%=objSeq%>">
<input type="hidden" name="hid_obj_kind" id="hid_obj_kind" value="<%=objKind%>">

</form>

</body>
</html>



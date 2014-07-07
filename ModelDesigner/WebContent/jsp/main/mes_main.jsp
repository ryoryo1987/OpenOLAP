<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ include file="../../connect.jsp"%>

<%
	String Sql;
	String objKind = request.getParameter("objKind");
	int userSeq = Integer.parseInt(request.getParameter("userSeq"));
	int objSeq = Integer.parseInt(request.getParameter("objSeq"));


	//最大ディメンション数
//	String maxDim="15";
	String maxDim=(String)session.getValue("strMaxDimension");

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
	String strFactTable="";
	String strFactCol="";
	String strFactCalcMethod="";
	String strFactWhereClause="";
	String strTimeDimFlg="0";
	String strTimeCol="";
	String strTimeFormat="";

	Sql = "SELECT m.name,m.comment,m.fact_table,m.fact_col,m.fact_calc_method,m.fact_where_clause,m.time_dim_flg,m.time_col,m.time_format";
	Sql = Sql + " FROM oo_measure m";
	Sql = Sql + " WHERE m.measure_seq = " + objSeq;
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		strName = rs.getString("name");
		strComment = rs.getString("comment");
		strFactTable = rs.getString("fact_table");
		strFactCol = rs.getString("fact_col");
		strFactCalcMethod = rs.getString("fact_calc_method");
		strFactWhereClause = rs.getString("fact_where_clause");
		strTimeDimFlg = rs.getString("time_dim_flg");
		strTimeCol = rs.getString("time_col");
		strTimeFormat = rs.getString("time_format");
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

		var max_num=<%=maxDim%>;//MAX数

			function load(){
					<%if(!"".equals(strFactTable)){%>
						if(document.all.<%=strFactTable%>==undefined){
							document.all.div_hid.innerHTML += '<select name="<%=strFactTable%>"><option value="">---------------</option></select>';

							<%
							Sql = "";
							Sql += " SELECT";
							Sql += " oo_fun_columnList('" + strFactTable + "','" + strUserName + "') AS columnlist";
							rs = stmt.executeQuery(Sql);
							while(rs.next()){

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
										document.form_main.elements["<%=strFactTable%>"].options.add(addOption);
				<%
								}

							}
							rs.close();

						%>
						}
					<%
					}
					%>


				var factXpoint=300;
				var factYpoint=50;
				var factColName="";
<%

			Sql = "SELECT m.fact_table,m.fact_col";
			Sql = Sql + " ,c.x_point,c.y_point";
			Sql = Sql + " FROM oo_measure m";
			Sql = Sql + " ,oo_measure_chart c";
			Sql = Sql + " WHERE m.measure_seq = " + objSeq;
			Sql = Sql + " AND m.measure_seq = c.measure_seq";
			Sql = Sql + " AND c.object_type = 'F'";
			rs = stmt.executeQuery(Sql);
			while(rs.next()){
				out.println("factXpoint=" + rs.getString("x_point") + ";");
				out.println("factYpoint=" + rs.getString("y_point") + ";");
				out.println("factColName='" + rs.getString("fact_table") + ". " + rs.getString("fact_col") + "';");
			}
			rs.close();
%>

			showDiv("fact","fact","ファクト",factColName,factXpoint,factYpoint);


			<%
			Sql = "SELECT ";
			Sql = Sql + " c.x_point,c.y_point";
			Sql = Sql + " FROM oo_measure m";
			Sql = Sql + " ,oo_measure_chart c";
			Sql = Sql + " WHERE m.measure_seq = " + objSeq;
			Sql = Sql + " AND m.measure_seq = c.measure_seq";
			Sql = Sql + " AND c.object_type = 'T'";
			rs = stmt.executeQuery(Sql);
			while(rs.next()){
				%>showDiv('time','time','時間ディメンション','TIME_DATE',<%=rs.getString("x_point")%>,<%=rs.getString("y_point")%>);<%
			}
			rs.close();
			%>

<%

			Sql = "SELECT l.measure_seq,l.dimension_seq,d.name as dim_name";
			Sql = Sql + " ,l.fact_link_col1,l.fact_link_col2,l.fact_link_col3,l.fact_link_col4,l.fact_link_col5";
			Sql = Sql + " ,c.x_point,c.y_point";
			Sql = Sql + " FROM oo_measure_link l";
			Sql = Sql + " ,oo_measure_chart c";
			Sql = Sql + " ,oo_dimension d";
			Sql = Sql + " WHERE l.measure_seq = " + objSeq;
			Sql = Sql + " AND l.measure_seq = c.measure_seq";
			Sql = Sql + " AND l.dimension_seq = c.dimension_seq";
			Sql = Sql + " AND l.dimension_seq = d.dimension_seq";
			Sql = Sql + " AND c.object_type = 'D'";
			Sql = Sql + " ORDER BY l.dimension_seq";
			rs = stmt.executeQuery(Sql);
			while(rs.next()){

%>

				document.form_main.lst_dimension.options[selectedValue(document.form_main.lst_dimension,"<%=rs.getString("dimension_seq")%>")].selected=true;
				showDiv(document.form_main.lst_dimension.value,'dimension',document.form_main.lst_dimension.options[document.form_main.lst_dimension.selectedIndex].text,document.form_main.lst_dimension.options[document.form_main.lst_dimension.selectedIndex].maxLevelName,<%=rs.getString("x_point")%>,<%=rs.getString("y_point")%>);

				document.form_main.hid_dim<%=rs.getString("dimension_seq")%>_m_factcol1.value="<%=rs.getString("fact_link_col1")%>";
				document.form_main.hid_dim<%=rs.getString("dimension_seq")%>_m_factcol2.value="<%=rs.getString("fact_link_col2")%>";
				document.form_main.hid_dim<%=rs.getString("dimension_seq")%>_m_factcol3.value="<%=rs.getString("fact_link_col3")%>";
				document.form_main.hid_dim<%=rs.getString("dimension_seq")%>_m_factcol4.value="<%=rs.getString("fact_link_col4")%>";
				document.form_main.hid_dim<%=rs.getString("dimension_seq")%>_m_factcol5.value="<%=rs.getString("fact_link_col5")%>";

<%
			}
			rs.close();
%>


				mappingCheck();
			}






		//アイコンの表示
		function showDiv(objSeq,type,objTopName,objName,x_point,y_point){

			if(type=="fact"){
				lay_id = "div_fact";
			}else if(type=="time"){
				lay_id = "div_time";
				if(chart.document.getElementById(lay_id).objId==objSeq){
					showMsg("MES4","時間ディメンション");
					return;
				}
			}else{
				for(i=1;i<=max_num;i++){
					div_id = "div_" + type + i;
					if(chart.document.getElementById(div_id).objId==objSeq){
						showMsg("MES4",objTopName);
						return;
					}
					if(chart.document.getElementById(div_id).objId=="0"){
						lay_id = div_id;
						break;
					}
					if(i==max_num){
						showMsg("MES3",max_num);
						return;
					}
				}
			}


			var pixelTopValue=y_point;
			var pixelLeftValue=x_point;
			if(type=="dimension"){
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
			}

			chart.document.getElementById(lay_id).style.pixelTop=pixelTopValue;
			chart.document.getElementById(lay_id).style.pixelLeft=pixelLeftValue;

			chart.document.getElementById(lay_id).objId=objSeq;
			chart.document.getElementById(lay_id).style.display="block";

			if(objName==null){
				objName="";
			}

			if(type=="dimension"){
				var gif_name="Dimension1";
				var showParameter=1;
				var bgclr="#e1eafb";
			}else if(type=="time"){
				var gif_name="TimeDimension1";
				var showParameter=2;
				var bgclr="#ddffee";
			}else if(type=="fact"){
				var gif_name="Measure1";
				var showParameter=3;
				var bgclr="ffffdd";
			}

			strHTML = "";
			strHTML += '<div id="head_' + objSeq + '" head_value="' + objSeq + '" type="' + type + '" move="1" style="cursor:move;text-align:center;border:1 solid #608ca8;border-bottom:3 double #0e559c;color:#0e559c;padding:2 2 2 15;font-weight:bold;background:url(../../images/'+gif_name+'.gif) no-repeat '+bgclr+';width:120;OVERFLOW: hidden;TEXT-OVERFLOW: ellipsis;" basecolor="white" onclick="objectSelected(this);parent.showPpty('+showParameter+',this);">'+objTopName+'</div>';
			strHTML += '<div id="body_' + objSeq + '" head_value="' + objSeq + '" type="' + type + '" move="2" style="text-align:center;border:1 solid #608ca8;padding:2 2 2 2;background:'+bgclr+';width:120;height:30;OVERFLOW: hidden;TEXT-OVERFLOW: ellipsis;" onclick="objectSelected(parentNode.firstChild);parent.showPpty('+showParameter+',this);">' + objName + '</div>';
			chart.document.getElementById(lay_id).innerHTML = strHTML + '<div id="map"></div>';

			if(type=="dimension"){
				chart.makeLine(chart.document.getElementById("body_"+objSeq),chart.document.getElementById("body_fact"),11);
				chart.document.getElementById("body_"+objSeq+",body_fact").lastChild.dashstyle='dash';
				if(document.all("hid_dim"+objSeq+"_m_keycol1")==undefined){
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_m_keycol1" value="' + document.form_main.lst_dimension.options[document.form_main.lst_dimension.selectedIndex].keycol1 + '">';
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_m_keycol2" value="' + document.form_main.lst_dimension.options[document.form_main.lst_dimension.selectedIndex].keycol2 + '">';
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_m_keycol3" value="' + document.form_main.lst_dimension.options[document.form_main.lst_dimension.selectedIndex].keycol3 + '">';
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_m_keycol4" value="' + document.form_main.lst_dimension.options[document.form_main.lst_dimension.selectedIndex].keycol4 + '">';
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_m_keycol5" value="' + document.form_main.lst_dimension.options[document.form_main.lst_dimension.selectedIndex].keycol5 + '">';
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_m_factcol1" value="">';
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_m_factcol2" value="">';
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_m_factcol3" value="">';
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_m_factcol4" value="">';
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_m_factcol5" value="">';
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_x_point" value="">';
					document.all.div_hid.innerHTML += '<input type="hidden" name="hid_dim'+objSeq+'_y_point" value="">';
				}
			}
			if(type=="time"){
				chart.makeLine(chart.document.getElementById("body_time"),chart.document.getElementById("body_fact"),12);
				chart.document.getElementById("body_time,body_fact").lastChild.dashstyle='dash';
			}

		}



		function mappingCheck(){
			setData();
			for(var ob=0;ob<chart.document.all.length;ob++){
				if((chart.document.all(ob).tagName=="line")&&(chart.document.all(ob).id!="dashline")){
					var mappingFlg = true;
					var arr = chart.document.all(ob).id.split(',');
					if(chart.document.getElementById(arr[0]).type=="time"){
						if(document.form_main.hid_time_col.value==""){
							mappingFlg = false;
						}
					}else if(chart.document.getElementById(arr[0]).type=="dimension"){
						var dimseq=arr[0].replace('body_','');
						if((document.form_main.elements["hid_dim" + dimseq + "_m_keycol1"].value=="")||(document.form_main.elements["hid_dim" + dimseq + "_m_factcol1"].value=="")){
							mappingFlg = false;
						}
						if(!(((document.form_main.elements["hid_dim" + dimseq + "_m_keycol1"].value=="")&&(document.form_main.elements["hid_dim" + dimseq + "_m_factcol1"].value==""))||((document.form_main.elements["hid_dim" + dimseq + "_m_keycol1"].value!="")&&(document.form_main.elements["hid_dim" + dimseq + "_m_factcol1"].value!="")))){
							mappingFlg = false;
						}
						if(!(((document.form_main.elements["hid_dim" + dimseq + "_m_keycol2"].value=="")&&(document.form_main.elements["hid_dim" + dimseq + "_m_factcol2"].value==""))||((document.form_main.elements["hid_dim" + dimseq + "_m_keycol2"].value!="")&&(document.form_main.elements["hid_dim" + dimseq + "_m_factcol2"].value!="")))){
							mappingFlg = false;
						}
						if(!(((document.form_main.elements["hid_dim" + dimseq + "_m_keycol3"].value=="")&&(document.form_main.elements["hid_dim" + dimseq + "_m_factcol3"].value==""))||((document.form_main.elements["hid_dim" + dimseq + "_m_keycol3"].value!="")&&(document.form_main.elements["hid_dim" + dimseq + "_m_factcol3"].value!="")))){
							mappingFlg = false;
						}
						if(!(((document.form_main.elements["hid_dim" + dimseq + "_m_keycol4"].value=="")&&(document.form_main.elements["hid_dim" + dimseq + "_m_factcol4"].value==""))||((document.form_main.elements["hid_dim" + dimseq + "_m_keycol4"].value!="")&&(document.form_main.elements["hid_dim" + dimseq + "_m_factcol4"].value!="")))){
							mappingFlg = false;
						}
						if(!(((document.form_main.elements["hid_dim" + dimseq + "_m_keycol5"].value=="")&&(document.form_main.elements["hid_dim" + dimseq + "_m_factcol5"].value==""))||((document.form_main.elements["hid_dim" + dimseq + "_m_keycol5"].value!="")&&(document.form_main.elements["hid_dim" + dimseq + "_m_factcol5"].value!="")))){
							mappingFlg = false;
						}
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
			if(type==1){//dimension
				document.getElementById("tbl_fact").style.display="none";
				document.getElementById("tbl_mapping1").style.display="none";
				document.getElementById("tbl_mapping2").style.display="none";
				document.getElementById("tbl_none").style.display="block";
			}
			if(type==2){//time dimension
				document.getElementById("tbl_fact").style.display="none";
				document.getElementById("tbl_mapping1").style.display="none";
				document.getElementById("tbl_mapping2").style.display="none";
				document.getElementById("tbl_none").style.display="block";
			}
			if(type==3){//fact
				document.getElementById("tbl_fact").style.display="block";
				document.getElementById("tbl_mapping1").style.display="none";
				document.getElementById("tbl_mapping2").style.display="none";
				document.getElementById("tbl_none").style.display="none";
			}
			if(type==11){//mapping to dimension
				document.getElementById("tbl_fact").style.display="none";
				document.getElementById("tbl_mapping1").style.display="block";
				document.getElementById("tbl_mapping2").style.display="none";
				document.getElementById("tbl_none").style.display="none";
			}
			if(type==12){//mapping to time dimension
				document.getElementById("tbl_fact").style.display="none";
				document.getElementById("tbl_mapping1").style.display="none";
				document.getElementById("tbl_mapping2").style.display="block";
				document.getElementById("tbl_none").style.display="none";
			}
			if(type==0){
				document.getElementById("tbl_fact").style.display="none";
				document.getElementById("tbl_mapping1").style.display="none";
				document.getElementById("tbl_mapping2").style.display="none";
				document.getElementById("tbl_none").style.display="block";
			}
			dispData(obj);
		}



		//プロパティー画面の値を隠しオブジェクトにセット
		function setData(){
			if(document.getElementById("tbl_fact").style.display=="block"){
				chart.document.getElementById("div_fact").childNodes[1].innerHTML=document.form_main.lst_fact_table.value + ". " + document.form_main.lst_fact_col.value;
				document.form_main.elements["hid_fact_table"].value=document.form_main.lst_fact_table.value;
				document.form_main.elements["hid_fact_col"].value=document.form_main.lst_fact_col.value;
				document.form_main.elements["hid_fact_calc_method"].value=document.form_main.lst_fact_calc_method.value;
				document.form_main.elements["hid_fact_where_clause"].value=document.form_main.txt_fact_where_clause.value;
			}else if(document.getElementById("tbl_mapping1").style.display=="block"){
				var dimSeq=document.form_main.hid_current_dimseq.value;
				document.form_main.elements["hid_dim" + dimSeq + "_m_factcol1"].value=document.form_main.lst_fact_linkcol1.value;
				document.form_main.elements["hid_dim" + dimSeq + "_m_factcol2"].value=document.form_main.lst_fact_linkcol2.value;
				document.form_main.elements["hid_dim" + dimSeq + "_m_factcol3"].value=document.form_main.lst_fact_linkcol3.value;
				document.form_main.elements["hid_dim" + dimSeq + "_m_factcol4"].value=document.form_main.lst_fact_linkcol4.value;
				document.form_main.elements["hid_dim" + dimSeq + "_m_factcol5"].value=document.form_main.lst_fact_linkcol5.value;
			}else if(document.getElementById("tbl_mapping2").style.display=="block"){
				document.form_main.elements["hid_time_col"].value=document.form_main.lst_time_col.value;
				document.form_main.elements["hid_time_format"].value=document.form_main.lst_time_format.value;
			}
		}


		//隠しオブジェクトから値を取得しプロパティー画面にセット
		function dispData(obj){
			if(document.getElementById("tbl_fact").style.display=="block"){

				createColumnList(document.form_main.elements["hid_fact_table"].value,"lst_fact_col");

				document.form_main.lst_fact_table.options[selectedValue(document.form_main.lst_fact_table,document.form_main.elements["hid_fact_table"].value)].selected=true;
				document.form_main.lst_fact_col.options[selectedValue(document.form_main.lst_fact_col,document.form_main.elements["hid_fact_col"].value)].selected=true;
				document.form_main.lst_fact_calc_method.options[selectedValue(document.form_main.lst_fact_calc_method,document.form_main.elements["hid_fact_calc_method"].value)].selected=true;
				document.form_main.txt_fact_where_clause.value=document.form_main.elements["hid_fact_where_clause"].value;

			}else if(document.getElementById("tbl_mapping1").style.display=="block"){
				document.form_main.hid_current_mapping.value=obj.id;
				var arr = obj.id.split(',');
				var dimseq = arr[0].replace("body_","");

				addColumnList("lst_m_keycol1",document.form_main.elements["hid_dim" + dimseq + "_m_keycol1"].value);
				addColumnList("lst_m_keycol2",document.form_main.elements["hid_dim" + dimseq + "_m_keycol2"].value);
				addColumnList("lst_m_keycol3",document.form_main.elements["hid_dim" + dimseq + "_m_keycol3"].value);
				addColumnList("lst_m_keycol4",document.form_main.elements["hid_dim" + dimseq + "_m_keycol4"].value);
				addColumnList("lst_m_keycol5",document.form_main.elements["hid_dim" + dimseq + "_m_keycol5"].value);

				createColumnList(document.form_main.elements["hid_fact_table"].value,"lst_fact_linkcol1",document.form_main.elements["hid_dim" + dimseq + "_m_factcol1"].value);
				createColumnList(document.form_main.elements["hid_fact_table"].value,"lst_fact_linkcol2",document.form_main.elements["hid_dim" + dimseq + "_m_factcol2"].value);
				createColumnList(document.form_main.elements["hid_fact_table"].value,"lst_fact_linkcol3",document.form_main.elements["hid_dim" + dimseq + "_m_factcol3"].value);
				createColumnList(document.form_main.elements["hid_fact_table"].value,"lst_fact_linkcol4",document.form_main.elements["hid_dim" + dimseq + "_m_factcol4"].value);
				createColumnList(document.form_main.elements["hid_fact_table"].value,"lst_fact_linkcol5",document.form_main.elements["hid_dim" + dimseq + "_m_factcol5"].value);

				document.form_main.hid_current_dimseq.value=dimseq;

			}else if(document.getElementById("tbl_mapping2").style.display=="block"){
				createColumnList(document.form_main.elements["hid_fact_table"].value,"lst_time_col",document.form_main.hid_time_col.value);
				document.form_main.lst_time_format.options[selectedValue(document.form_main.lst_time_format,document.form_main.elements["hid_time_format"].value)].selected=true;
			}
		}




		//リストにメニューをひとつ追加して、選択状態にする
		function addColumnList(listBoxName,addValue,addText){
			resetList(document.form_main.elements[listBoxName]);
			if(addText==undefined){addText=addValue;}
			addOption = document.createElement("OPTION");
			addOption.value = addValue;
			addOption.text = addText;
			document.form_main.elements[listBoxName].add(addOption);
			document.form_main.elements[listBoxName].options[selectedValue(document.form_main.elements[listBoxName],addValue)].selected=true;
		}



		//テーブル切り替え、カラムリストを初期化
		function changeTabelList(obj){
			
			document.form_main.action = "../hidden/change_table.jsp?type=mes&table_name=" + obj.value;
			document.form_main.target = "frm_hidden";
			document.form_main.submit();

			for(i=0;i<document.all.div_hid.childNodes.length;i++){
				if(document.all.div_hid.childNodes[i].name.indexOf("_m_factcol")!=-1){
					document.all.div_hid.childNodes[i].value="";
				}
			}
			document.form_main.elements["hid_time_col"].value="";

		}






		//レベル情報を隠しオブジェクトにセットし、保存・削除処理を実行
		function regist(tp) {

			//ディメンションを隠しオブジェクトに格納
			document.form_main.hid_dimseq_string.value="";
			for(var ob=0;ob<chart.document.all.length;ob++){
				if(chart.document.all(ob).id.indexOf("dimension")!=-1){
					if((chart.document.all(ob).objId!=undefined)&&(chart.document.all(ob).objId!="0")){
						if(ob!=0){
							document.form_main.hid_dimseq_string.value+=",";
						}
						document.form_main.hid_dimseq_string.value+= chart.document.all(ob).objId;
						document.form_main.elements["hid_dim" + chart.document.all(ob).objId + "_x_point"].value=chart.document.all(ob).style.pixelLeft;
						document.form_main.elements["hid_dim" + chart.document.all(ob).objId + "_y_point"].value=chart.document.all(ob).style.pixelTop;

					}
				}
			}


			//新規/更新時エラーチェック&登録
			if (tp < 2) {
				setData();


				//共通エラーチェックを先に行う
				if(!checkData()){return;}


				//時間ディメンションフラグをセット
				if(chart.document.getElementById("div_time").objId=="0"){
					document.form_main.hid_time_flg.value="0";
				}else{
					document.form_main.hid_time_flg.value="1";
					document.form_main.hid_time_x_point.value=chart.document.getElementById("div_time").style.pixelLeft;
					document.form_main.hid_time_y_point.value=chart.document.getElementById("div_time").style.pixelTop;
				}

				document.form_main.hid_fact_x_point.value=chart.document.getElementById("div_fact").style.pixelLeft;
				document.form_main.hid_fact_y_point.value=chart.document.getElementById("div_fact").style.pixelTop;


				//マッピングチェック
				var mappingNum=0;
				for(i=0;i<chart.document.getElementById("lineSource").childNodes.length;i++){
					if(chart.document.getElementById("lineSource").childNodes[i].firstChild!=undefined){
						if(chart.document.getElementById("lineSource").childNodes[i].firstChild.dashstyle=="dash"){
							var arr = chart.document.getElementById("lineSource").childNodes[i].id.split(',');
							var obj1=chart.document.getElementById("head_" + arr[0].replace("body_","")).innerHTML;
							var obj2=chart.document.getElementById("head_" + arr[1].replace("body_","")).innerHTML;
							showMsg("MES2",obj1,obj2);
							return;
						}
						mappingNum++;
					}
				}

				if((document.form_main.hid_dimseq_string.value=="")&&(document.form_main.hid_time_flg.value=="0")){
					showMsg("MES9");
					return;
				}

			}


			submitData("mes_regist.jsp",tp,"<%=objKind%>","<%=objSeq%>",document.form_main.txt_name.value);

		}


		function editWhereClause(){
		//	var newWin = window.open("../frm_filter.jsp?tableName=" + document.form_main.lst_fact_table.value,"_blank","menubar=no,toolbar=no,width=720px,height=500px,resizable");
			window.showModalDialog("../frm_filter.jsp?tableName=" + document.form_main.lst_fact_table.value,self,"dialogHeight:500px; dialogWidth:720px;");
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
						<th width="150" class="standard">メジャーID</th>
						<td class="standard">
							<%=objSeq%>
						</td>
					</tr>
					<%}%>


					<tr>
						<th width="150" class="standard">メジャー名</th>
						<td class="standard">
							<input type="text" name="txt_name" value="<%=strName%>" maxlength="30" size="60" mON="メジャー名" onchange="setChangeFlg();">
						</td>
					</tr>

					<tr>
						<th class="standard">コメント</th>
						<td class="standard">
							<input type="text" name="txt_comment" value="<%=strComment%>" mON="コメント" maxlength="250" size="80" onchange="setChangeFlg();">
						</td>
					</tr>
				</table>

				<div width="100%" align="left" style="margin-top:15px;margin-bottom:3px">
					<table style="border-collapse:collapse">
					<tr>
					<td>
					<img src="../../images/Dimension1.gif">ディメンション：
					<select name="lst_dimension" style="margin:0">
					<%
/*					Sql = "SELECT dimension_seq,name";
					Sql = Sql + " FROM oo_dimension";
					Sql = Sql + " WHERE user_seq = '" + userSeq + "'";
					Sql = Sql + " ORDER BY name";
					rs = stmt.executeQuery(Sql);
					while(rs.next()) {
						Sql = " SELECT name,key_col1,key_col2,key_col3,key_col4,key_col5 FROM oo_level WHERE dimension_seq = " + rs.getString("dimension_seq") + " AND level_no = ";
						Sql = Sql + " (SELECT MAX(level_no) FROM oo_level WHERE dimension_seq = " + rs.getString("dimension_seq") + ")";
						rs2 = stmt2.executeQuery(Sql);
						while(rs2.next()) {
							out.println("<option value='" + rs.getString("dimension_seq") + "' maxLevelName='" + rs2.getString("name") + "' keycol1='" + rs2.getString("key_col1") + "' keycol2='" + rs2.getString("key_col2") + "' keycol3='" + rs2.getString("key_col3") + "' keycol4='" + rs2.getString("key_col4") + "' keycol5='" + rs2.getString("key_col5") + "'>" + rs.getString("name") + "</option>");
						}
						rs2.close();
					}
					rs.close();
*/


					Sql = "SELECT * FROM oo_fun_measure(" + userSeq + ") WHERE dimension_seq<>-1";
					rs = stmt.executeQuery(Sql);
					while(rs.next()) {
						out.println("<option value='" + rs.getString("dimension_seq") + "' maxLevelName='" + rs.getString("name") + "' keycol1='" + rs.getString("key_col1") + "' keycol2='" + rs.getString("key_col2") + "' keycol3='" + rs.getString("key_col3") + "' keycol4='" + rs.getString("key_col4") + "' keycol5='" + rs.getString("key_col5") + "'>" + rs.getString("comment") + "</option>");
					}
					rs.close();

					%>
					</select>
					</td>
					<td valign="middle">
					<input type="button" value="" onclick="showDiv(document.form_main.lst_dimension.value,'dimension',document.form_main.lst_dimension.options[document.form_main.lst_dimension.selectedIndex].text,document.form_main.lst_dimension.options[document.form_main.lst_dimension.selectedIndex].maxLevelName,50,50);setChangeFlg();" class="normal_add_mini" onMouseOver="className='over_add_mini'" onMouseDown="className='down_add_mini'" onMouseUp="className='up_add_mini'" onMouseOut="className='out_add_mini'">
					&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
					<img src="../../images/TimeDimension1.gif">時間ディメンション：
					</td>
					<td valign="middle">
					<input type="button" value="" onclick="showDiv('time','time','時間ディメンション','TIME_DATE',500,50);setChangeFlg();" class="normal_add_mini" onMouseOver="className='over_add_mini'" onMouseDown="className='down_add_mini'" onMouseUp="className='up_add_mini'" onMouseOut="className='out_add_mini'">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" id="delete_btn" value="" onclick="chart.del();setChangeFlg();" class="normal_del_dim" onMouseOver="className='over_del_dim'" onMouseDown="className='down_del_dim'" onMouseUp="className='up_del_dim'" onMouseOut="className='out_del_dim'">
					</td>
					</tr>
					</table>
				</div>

				<iframe name="chart" src="mes_chart.jsp?maxDim=<%=maxDim%>" width="100%" height="150" style="margin-bottom:10px"></iframe>

				<table id="tbl_none" class="standard" style="display:none;">
					<tr><td></td></tr>
				</table>
				
				<table id="tbl_fact" style="display:none;width:100%;">
				<tr>
					<th width="150" class="standard">
					ファクトテーブル
					</th>
					<td class="standard">
						<select name="lst_fact_table" onchange="changeTabelList(this);mappingCheck();setChangeFlg();">
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
					ファクトカラム
					</th>
					<td class="standard">
						<select name="lst_fact_col" onchange="setChangeFlg();">
							<option value="">---------------</option>
						</select>
					</td>
				</tr>
				<tr>
					<th width="150" class="standard">
					集計方法
					</th>
					<td class="standard">
						<select name="lst_fact_calc_method" onchange="setChangeFlg();">
						<%
						Sql = "SELECT method_no,method_name";
						Sql = Sql + " FROM oo_calc_method";
						Sql = Sql + " order by method_no";
						rs = stmt.executeQuery(Sql);
						while(rs.next()) {
							%>
							<option value="<%=rs.getString("method_no")%>"><%=rs.getString("method_name")%></option>
							<%
						}
						rs.close();
						%>
						</select>
					</td>
				</tr>
				<tr>
					<th width="150" class="standard">
					WHERE句
					</th>
					<td class="standard" style="vertical-align:middle">
					<!--	<input type="text" name="txt_fact_where_clause" value="" maxlength="250" size="80" onchange="setChangeFlg();">-->
						<textarea name="txt_fact_where_clause" value="" rows="2" cols="100" onChange="setChangeFlg();"></textarea>
					<!--	<input type="button" value="編集" onclick="editWhereClause()">-->
						<input type="button" value="" onclick="editWhereClause();setChangeFlg();" class="normal_edit" onMouseOver="className='over_edit'" onMouseDown="className='down_edit'" onMouseUp="className='up_edit'" onMouseOut="className='out_edit'"style="margin-bottom:5">
					</td>
				</tr>
				</table>


				<table id="tbl_mapping1" style="display:none;">
					<tr>
						<td>ディメンションボトムレベル<br>キーカラム</td>
						<td>&nbsp;</td>
						<td>ファクト<br>リンクカラム</td>
					</tr>
					<tr> 
						<td>
							<select name="lst_m_keycol1" disabled>
								<option value="">---------------------</option>
							</select>
						</td>
						<td>&nbsp;------&nbsp;</td>
						<td>
							<select name="lst_fact_linkcol1" onchange="mappingCheck();setChangeFlg();">
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
							<select name="lst_fact_linkcol2" onchange="mappingCheck();setChangeFlg();">
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
							<select name="lst_fact_linkcol3" onchange="mappingCheck();setChangeFlg();">
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
							<select name="lst_fact_linkcol4" onchange="mappingCheck();setChangeFlg();">
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
							<select name="lst_fact_linkcol5" onchange="mappingCheck();setChangeFlg();">
								<option value="">---------------------</option>
							</select>
						</td>
					</tr>
				</table>


				<table id="tbl_mapping2" style="display:none;">
				<tr>
					<th width="150" class="standard">
					ファクト リンクカラム
					</th>
					<td class="standard">
						<select name="lst_time_col" onchange="mappingCheck();setChangeFlg();">
							<option value="">---------------</option>
						</select>
					</td>
				</tr>
				<tr>
					<th width="150" class="standard">
					フォーマット
					</th>
					<td class="standard">
						<select name="lst_time_format" onchange="mappingCheck();setChangeFlg();">
							<option value="">date型</option>
						<%
						Sql = "SELECT time_name_format_cd,time_name";
						Sql = Sql + " FROM oo_time_format";
						Sql = Sql + " WHERE time_kind_cd='MEASURE'";
						Sql = Sql + " ORDER BY time_name_format_cd";
						rs = stmt.executeQuery(Sql);
						while(rs.next()) {
							%>
							<option value="<%=rs.getString("time_name_format_cd")%>"><%=rs.getString("time_name")%></option>
							<%
						}
						rs.close();
						%>
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
<div name="div_hid2" id="div_hid2" style="display:none;"></div>
<input type="hidden" name="hid_fact_table" value="<%=strFactTable%>" mON="ファクトテーブル">
<input type="hidden" name="hid_fact_col" value="<%=strFactCol%>" mON="ファクトカラム">
<input type="hidden" name="hid_fact_calc_method" value="<%=strFactCalcMethod%>" mON="集計方法">
<input type="hidden" name="hid_fact_where_clause" value="<%=strFactWhereClause%>" mON="WHERE句">
<input type="hidden" name="hid_fact_x_point" value="">
<input type="hidden" name="hid_fact_y_point" value="">
<input type="hidden" name="hid_time_flg" value="<%=strTimeDimFlg%>">
<input type="hidden" name="hid_time_col" value="<%=strTimeCol%>">
<input type="hidden" name="hid_time_format" value="<%=strTimeFormat%>">
<input type="hidden" name="hid_time_x_point" value="">
<input type="hidden" name="hid_time_y_point" value="">

<input type="hidden" name="hid_current_dimseq" value="">
<input type="hidden" name="hid_current_mapping" value="">
<input type="hidden" name="hid_dimseq_string" id="hid_dimseq_string" value="">
<input type="hidden" name="hid_user_seq" id="hid_user_seq" value="<%=userSeq%>">
<input type="hidden" name="hid_obj_seq" id="hid_obj_seq" value="<%=objSeq%>">
<input type="hidden" name="hid_obj_kind" id="hid_obj_kind" value="<%=objKind%>">

</form>

</body>
</html>



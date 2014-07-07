<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%> 
<%@ page import = "java.util.*"%>
<%@ page errorPage="ErrorPage.jsp"%>

<%@ include file="../../connect.jsp" %>


<%
	String Sql = "";
	String errorMsgId = "";
	String errorArg1 = "";
	String filename = request.getParameter("filename");
	int tp = Integer.parseInt(request.getParameter("tp"));
	String objKind = request.getParameter("objKind");
	String objSeq = request.getParameter("objSeq");
	String objName = request.getParameter("objName");
	boolean submitFlg = true;
	int i=0;
	String dimSeqString="";
	int intCustLevel=0;



	//スキーマ
	if(objKind.equals("SchemaTop")||objKind.equals("Schema")){
		if (tp!=2) {
			//スキーマの存在を確認
			Sql = "SELECT * FROM pg_namespace";
			Sql = Sql + " WHERE nspname = '" + objName + "'";
			rs = stmt.executeQuery(Sql);
			if(!rs.next()){
				errorMsgId = "USR2";
				errorArg1 = objName;
				submitFlg = false;
			}
			rs.close();
		}
		if(tp==2){//削除
			//ディメンションが登録済みの場合は削除できない
			Sql = "";
			Sql = "SELECT * FROM oo_dimension";
			Sql = Sql + " WHERE user_seq = " + objSeq;
			Sql = Sql + " AND dimension_seq != -1";
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				errorMsgId = "USR3";
				errorArg1 = objName;
				submitFlg = false;
			}
			rs.close();
		}
	}


	//ディメンション
	if((objKind.equals("Dimension"))||(objKind.equals("SegmentDimension"))){
		if(tp==2){//削除
			//メジャーに登録済みの場合は削除できない
			Sql = "SELECT * FROM oo_measure_link";
			Sql = Sql + " WHERE dimension_seq = " + objSeq;
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				errorMsgId = "DIM6";
				errorArg1 = objName;
				submitFlg = false;
			}
			rs.close();
		}
	}

	//時間ディメンション
	if(objKind.equals("TimeDimension")){
		if(tp==2){//削除
			//キューブに登録済みの場合は削除できない
			Sql = "SELECT * FROM oo_cube_structure";
			Sql = Sql + " WHERE dimension_seq = " + objSeq;
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				errorMsgId = "TIM2";
				errorArg1 = objName;
				submitFlg = false;
			}
			rs.close();
		}
	}


	//メジャー
	if((objKind.equals("MeasureSchema"))||(objKind.equals("Measure"))){


		//メジャー名チェック
		if((tp==0)||(tp==1)){//新規・更新
			int exeCount=0;

			Sql = " CREATE TABLE OO_MEASURE_REGIST_TEST";
			Sql = Sql + " (" + objName + " varchar)";

			try{
				exeCount = stmt.executeUpdate(Sql);
			}catch(SQLException e){
				errorMsgId = "MES6";
				errorArg1 = "";
				submitFlg = false;
			}

			Sql = " DROP TABLE OO_MEASURE_REGIST_TEST";
			try{
				exeCount = stmt.executeUpdate(Sql);
			}catch(SQLException e){
			}

			//時間ディメンションが登録されていない場合はアラート
			if("".equals(errorMsgId)){
				if("1".equals(request.getParameter("hid_time_flg"))){
					Sql = "SELECT * FROM oo_time";
					rs = stmt.executeQuery(Sql);
					if(!rs.next()){
						errorMsgId = "MES7";
						errorArg1 = "";
						submitFlg = false;
					}
					rs.close();
				}
			}


		}

		if((tp==1)&&("".equals(errorMsgId))){//更新

			boolean tempErrFlg = false;



			//キューブに使用されているメジャーの場合、ディメンションは削除できない
			Sql = "SELECT cube_seq";
			Sql = Sql + " FROM oo_cube_structure";
			Sql = Sql + " WHERE";
			Sql = Sql + " measure_seq = " + objSeq;
			rs = stmt.executeQuery(Sql);
			if (rs.next()) {

				//①通常次元が削除されている場合
				dimSeqString = "," + request.getParameter("hid_dimseq_string") + ",";
				Sql = "SELECT dimension_seq";
				Sql = Sql + " FROM oo_measure_link";
				Sql = Sql + " WHERE";
				Sql = Sql + " measure_seq = " + objSeq;
				rs = stmt.executeQuery(Sql);
				i=0;
				while (rs.next()) {
					i++;
					if(dimSeqString.indexOf(","+rs.getString("dimension_seq")+",")==-1){
						tempErrFlg=true;
					}
				}
				rs.close();

				//②時間次元が削除されている場合
				Sql = "SELECT time_dim_flg";
				Sql = Sql + " FROM oo_measure";
				Sql = Sql + " WHERE";
				Sql = Sql + " measure_seq = " + objSeq;
				rs = stmt.executeQuery(Sql);
				if (rs.next()) {
					if(("1".equals(rs.getString("time_dim_flg")))&&("0".equals(request.getParameter("hid_time_flg")))){
						tempErrFlg=true;
					}
				}
				rs.close();

				if(tempErrFlg){//次元を削除した時メッセージを表示
					errorMsgId = "MES10";
					errorArg1 = objName;
					submitFlg = false;
				}

			}
			rs.close();




			if("".equals(errorMsgId)){


				//キューブに同じディメンションパターンとして登録されたメジャーが全て同じディメンションパターンの時のみ警告（要するにディメンションパターンを変更しようとした最初のメジャー登録時のみ警告を出す）
				Sql = "";
				Sql = Sql + " SELECT COUNT(DISTINCT oo_fun_mlink(m.measure_seq)||','||m.time_dim_flg) AS dim_pattern_count";
				Sql = Sql + " FROM oo_measure m";
				Sql = Sql + " WHERE m.measure_seq IN (";
				Sql = Sql + " SELECT measure_seq FROM oo_cube_structure WHERE cube_seq IN ";
				Sql = Sql + " (SELECT DISTINCT cube_seq FROM oo_cube_structure WHERE measure_seq = " + objSeq + ")";
				Sql = Sql + " )";
				int dimPatternCount=0;
				rs = stmt.executeQuery(Sql);
				if (rs.next()) {
					dimPatternCount = rs.getInt("dim_pattern_count");
				}
				rs.close();

				if(dimPatternCount==1){
					Sql = "SELECT COUNT(DISTINCT measure_seq) AS measure_count FROM oo_cube_structure";
					Sql = Sql + " WHERE cube_seq in (SELECT DISTINCT cube_seq FROM oo_cube_structure WHERE measure_seq = " + objSeq + ")";
					rs = stmt.executeQuery(Sql);
					if(rs.next()){
						if(rs.getInt("measure_count")>1){
					
							//次元構成が変更されているかをチェック
							//①メジャーの次元が削除されている場合
							dimSeqString = "," + request.getParameter("hid_dimseq_string") + ",";
							Sql = "SELECT dimension_seq";
							Sql = Sql + " FROM oo_measure_link";
							Sql = Sql + " WHERE";
							Sql = Sql + " measure_seq = " + objSeq;
							rs2 = stmt2.executeQuery(Sql);
							i=0;
							while (rs2.next()) {
								i++;
								if(dimSeqString.indexOf(","+rs2.getString("dimension_seq")+",")==-1){
									tempErrFlg=true;
								}
							}
							rs2.close();

							//②次元の数が異なる場合
							StringTokenizer str = new StringTokenizer(request.getParameter("hid_dimseq_string"),",");
							int dimCount = str.countTokens();
							if(i!=dimCount){
								tempErrFlg=true;
							}

							//③時間次元の有無が異なる場合
							Sql = "SELECT time_dim_flg";
							Sql = Sql + " FROM oo_measure";
							Sql = Sql + " WHERE";
							Sql = Sql + " measure_seq = " + objSeq;
							rs2 = stmt2.executeQuery(Sql);
							while (rs2.next()) {
								if(!rs2.getString("time_dim_flg").equals(request.getParameter("hid_time_flg"))){
									tempErrFlg=true;
								}
							}
							rs2.close();

							if(tempErrFlg){//次元構成を変更（追加）した時のみメッセージを表示
								errorMsgId = "MES5";
								errorArg1 = objName;
								submitFlg = true;
							}
						}
					}
					rs.close();

				}


			}


		}else if(tp==2){//削除
			Sql = "SELECT * FROM oo_cube_structure";
			Sql = Sql + " WHERE measure_seq = " + objSeq;
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				errorMsgId = "MES8";
				errorArg1 = objName;
				submitFlg = false;
			}
			rs.close();

		}

	}


	//キューブ
	if((objKind.equals("CubeTop"))||(objKind.equals("Cube"))){


		if((tp==0)||(tp==1)){//新規作成・更新
			String LinkString = "";
			String preLinkString = "";
			StringTokenizer str = new StringTokenizer(request.getParameter("hid_right"),",");
			i=0;
			while(str.hasMoreTokens()) {
				i++;

				//メジャーごとのファクトリンクカラム設定を取得する
				Sql = "SELECT fact_link_col1||','||fact_link_col2||','||fact_link_col3||','||fact_link_col4||','||fact_link_col5 AS linkstring ";
				Sql = Sql + " FROM oo_measure_link";
				Sql = Sql + " WHERE measure_seq = " + str.nextToken();
				Sql = Sql + " ORDER BY dimension_seq";
				rs = stmt.executeQuery(Sql);
				LinkString="";
				while(rs.next()){
					LinkString += rs.getString("linkstring");
				}
				rs.close();

				//メジャー同士で比べて、一つでも異なるファクトリンクカラム設定であればアラートメッセージを出力
				if(i!=1){
					if(!preLinkString.equals(LinkString)){
						errorMsgId = "CUB4";
					//	errorArg1 = objName;
						submitFlg = true;
					}
				}
				preLinkString = LinkString;

			}


		}


		if(tp==2){//削除
			//実キューブがある場合は削除できない
			Sql = "SELECT * FROM pg_tables";
			Sql = Sql + " WHERE schemaname = '" + session.getValue("loginSchema") + "'";
			Sql = Sql + " AND tablename = 'cube_" + objSeq + "'";
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				errorMsgId = "CUB5";
				errorArg1 = objName;
				submitFlg = false;
			}
			rs.close();
		}

	}



	//ディメンションのカスタマイズ（パーツ画面）
	if((objKind.equals("DimParts"))||(objKind.equals("SegmentParts"))){
		if((tp==0)||(tp==1)){//新規作成・更新

			connMeta = (Connection)session.getValue(session.getId()+"Conn");
			stmt     = (Statement) session.getValue(session.getId()+"Stmt");


			intCustLevel=0;

			Sql=" select MAX(level) AS maxLevel FROM oo_dim_tree('oo_dim_" + request.getParameter("hid_dim_seq") + "_" + request.getParameter("hid_obj_seq") + "',null,null)";
		//	Sql=" SELECT MAX(cust_level) AS maxLevel FROM oo_dim_" + request.getParameter("hid_dim_seq") + "_" + request.getParameter("hid_obj_seq");
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				intCustLevel = rs.getInt("maxLevel");
			}
			rs.close();

			if(intCustLevel==16){//newTreeではMAXが15を超える場合は16が返ってくる
				errorMsgId = "CSD1";
			//	errorArg1 = intCustLevel+"";
				submitFlg = false;
			}


		}

		if(tp==2){//削除
			//キューブがある場合は削除できない
			Sql = "SELECT * FROM oo_cube_structure";
			Sql = Sql + " WHERE dimension_seq = '" + session.getValue("dimSeq") + "'";
			Sql = Sql + " AND part_seq = '" + objSeq + "'";
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				errorMsgId = "CSD2";
				errorArg1 = objName;
				submitFlg = false;
			}
			rs.close();
		}

	}



%>



<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript">
		function load(){
			if("<%=errorMsgId%>"!=""){
				if("<%=errorArg1%>"!=""){
					showMsg("<%=errorMsgId%>","<%=errorArg1%>");
				}else{
					showMsg("<%=errorMsgId%>");
				}
			}
			<%if(submitFlg){%>
				formSubmit("<%=filename%>",<%=tp%>,parent.frm_main.document.form_main,"<%=objKind%>");
			<%}%>
		}
	</script>
	</head>
	<body onload="load();">
<%out.println(""+Sql);%>
	</body>
</html>











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



	//�X�L�[�}
	if(objKind.equals("SchemaTop")||objKind.equals("Schema")){
		if (tp!=2) {
			//�X�L�[�}�̑��݂��m�F
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
		if(tp==2){//�폜
			//�f�B�����V�������o�^�ς݂̏ꍇ�͍폜�ł��Ȃ�
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


	//�f�B�����V����
	if((objKind.equals("Dimension"))||(objKind.equals("SegmentDimension"))){
		if(tp==2){//�폜
			//���W���[�ɓo�^�ς݂̏ꍇ�͍폜�ł��Ȃ�
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

	//���ԃf�B�����V����
	if(objKind.equals("TimeDimension")){
		if(tp==2){//�폜
			//�L���[�u�ɓo�^�ς݂̏ꍇ�͍폜�ł��Ȃ�
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


	//���W���[
	if((objKind.equals("MeasureSchema"))||(objKind.equals("Measure"))){


		//���W���[���`�F�b�N
		if((tp==0)||(tp==1)){//�V�K�E�X�V
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

			//���ԃf�B�����V�������o�^����Ă��Ȃ��ꍇ�̓A���[�g
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

		if((tp==1)&&("".equals(errorMsgId))){//�X�V

			boolean tempErrFlg = false;



			//�L���[�u�Ɏg�p����Ă��郁�W���[�̏ꍇ�A�f�B�����V�����͍폜�ł��Ȃ�
			Sql = "SELECT cube_seq";
			Sql = Sql + " FROM oo_cube_structure";
			Sql = Sql + " WHERE";
			Sql = Sql + " measure_seq = " + objSeq;
			rs = stmt.executeQuery(Sql);
			if (rs.next()) {

				//�@�ʏ펟�����폜����Ă���ꍇ
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

				//�A���Ԏ������폜����Ă���ꍇ
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

				if(tempErrFlg){//�������폜���������b�Z�[�W��\��
					errorMsgId = "MES10";
					errorArg1 = objName;
					submitFlg = false;
				}

			}
			rs.close();




			if("".equals(errorMsgId)){


				//�L���[�u�ɓ����f�B�����V�����p�^�[���Ƃ��ēo�^���ꂽ���W���[���S�ē����f�B�����V�����p�^�[���̎��̂݌x���i�v����Ƀf�B�����V�����p�^�[����ύX���悤�Ƃ����ŏ��̃��W���[�o�^���̂݌x�����o���j
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
					
							//�����\�����ύX����Ă��邩���`�F�b�N
							//�@���W���[�̎������폜����Ă���ꍇ
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

							//�A�����̐����قȂ�ꍇ
							StringTokenizer str = new StringTokenizer(request.getParameter("hid_dimseq_string"),",");
							int dimCount = str.countTokens();
							if(i!=dimCount){
								tempErrFlg=true;
							}

							//�B���Ԏ����̗L�����قȂ�ꍇ
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

							if(tempErrFlg){//�����\����ύX�i�ǉ��j�������̂݃��b�Z�[�W��\��
								errorMsgId = "MES5";
								errorArg1 = objName;
								submitFlg = true;
							}
						}
					}
					rs.close();

				}


			}


		}else if(tp==2){//�폜
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


	//�L���[�u
	if((objKind.equals("CubeTop"))||(objKind.equals("Cube"))){


		if((tp==0)||(tp==1)){//�V�K�쐬�E�X�V
			String LinkString = "";
			String preLinkString = "";
			StringTokenizer str = new StringTokenizer(request.getParameter("hid_right"),",");
			i=0;
			while(str.hasMoreTokens()) {
				i++;

				//���W���[���Ƃ̃t�@�N�g�����N�J�����ݒ���擾����
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

				//���W���[���m�Ŕ�ׂāA��ł��قȂ�t�@�N�g�����N�J�����ݒ�ł���΃A���[�g���b�Z�[�W���o��
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


		if(tp==2){//�폜
			//���L���[�u������ꍇ�͍폜�ł��Ȃ�
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



	//�f�B�����V�����̃J�X�^�}�C�Y�i�p�[�c��ʁj
	if((objKind.equals("DimParts"))||(objKind.equals("SegmentParts"))){
		if((tp==0)||(tp==1)){//�V�K�쐬�E�X�V

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

			if(intCustLevel==16){//newTree�ł�MAX��15�𒴂���ꍇ��16���Ԃ��Ă���
				errorMsgId = "CSD1";
			//	errorArg1 = intCustLevel+"";
				submitFlg = false;
			}


		}

		if(tp==2){//�폜
			//�L���[�u������ꍇ�͍폜�ł��Ȃ�
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











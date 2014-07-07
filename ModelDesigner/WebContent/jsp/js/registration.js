




//***************************************************************
//	�֐���		:submitData
//�@�@�\�T�v	:
//�@����		:
//	�쐬		:
//	�C��		:
//	���l		:
//***************************************************************
function submitData(filename,tp,objKind,objSeq,objName){
	if(tp!=2){
		if(checkData()){
			//�������`�F�b�N
			document.form_main.action = "../hidden/regist_check.jsp?filename=" + filename + "&tp=" + tp + "&objKind=" + objKind + "&objSeq=" + objSeq + "&objName=" + objName;
			document.form_main.target = "frm_hidden";
			document.form_main.submit();
		}
	}else if(tp==2){
		//�������`�F�b�N
		document.form_main.action = "../hidden/regist_check.jsp?filename=" + filename + "&tp=" + tp + "&objKind=" + objKind + "&objSeq=" + objSeq + "&objName=" + objName;
		document.form_main.target = "frm_hidden";
		document.form_main.submit();
	}
}


function formSubmit(filename,tp,formObj,objKind){
	var submitFlg=true;
	if(objKind.indexOf("SQLTuning")!=-1){
		submitFlg=showConfirm("CFM4",formObj.txt_name.value);
	}else{
		submitFlg=getConfirm(tp,formObj);
	}

	if(submitFlg){
		formObj.action = "../hidden/" + filename + "?tp=" + tp;
		formObj.target = "frm_hidden";
		formObj.submit();
	}
}



//***************************************************************
//	�֐���		:checkData
//�@�@�\�T�v	:�G���[�`�F�b�N
//�@����		:
//	�쐬		:
//	�C��		:
//	���l		:
//***************************************************************
function checkData(){

	var objCount = document.all.length;
	var errNum = 0;





	for (i = 0; i < objCount; i++) {
		var obj = document.all[i];
		if (obj.tagName=='INPUT') {
			//�e�L�X�g�{�b�N�X
			if((obj.type=='text')&&(obj.mON!=undefined)){
				if(obj.name.indexOf('_comment')!=-1){
					if(errNum==0){errNum = IsIllegalChar(obj,1);}//�s������(& ' < >)�`�F�b�N
				}else if(obj.name.indexOf('_integer')!=-1){
					obj.value = TrimAllStr(obj.value);//�S�g����
					errNum = IsNullChar(obj);//�����̓`�F�b�N
					if(errNum==0){errNum = IntNumCheck(obj);}//���l�`�F�b�N
					if(errNum==0){errNum = DecimalCheck(obj);}//�����`�F�b�N
				}else if(obj.name.indexOf('_numeric')!=-1){
					obj.value = TrimAllStr(obj.value);//�S�g����
					errNum = IsNullChar(obj);//�����̓`�F�b�N
					if(errNum==0){errNum = IntNumCheck(obj);}//���l�`�F�b�N
					if(errNum==0){errNum = NumericCheck(obj);}//���l�`�F�b�N

				}else{
					obj.value = TrimAllStr(obj.value);//�S�g����
					errNum = IsNullChar(obj);//�����̓`�F�b�N
					if(errNum==0){errNum = IsIllegalChar(obj,1);}//�s������(& ' < >)�`�F�b�N
				}
			} else if (obj.type=='password') {
				errNum = IsNullChar(obj);//�����̓`�F�b�N
				if(errNum==0){errNum = IsIllegalChar(obj,1);}//�s������(& ' < >)�`�F�b�N
			}else if((obj.type=='hidden')&&(obj.mON!=undefined)){
				if(obj.name.indexOf('_comment')!=-1){
					if(errNum==0){errNum = IsIllegalChar(obj,1);}//�s������(& ' < >)�`�F�b�N
				}else if(obj.name.indexOf('where_clause')!=-1){
					if(errNum==0){errNum = IsIllegalChar(obj,2);}//�s������(& ")�`�F�b�N
					if(errNum==0){errNum = MaxLengthCheck(obj);}//�s������(& ")�`�F�b�N
				}else{
					obj.value = TrimAllStr(obj.value);//�S�g����
					errNum = IsNullChar(obj);//�����̓`�F�b�N
					if(errNum==0){errNum = IsIllegalChar(obj,1);}//�s������(& ' < >)�`�F�b�N
				}
			}
		}else if((obj.tagName=='SELECT')&&(obj.mON!=undefined)&&(obj.disabled!=true)){
			if (obj.value=="") {
				errNum = 101;
			}
		}else if((obj.type=='textarea')&&(obj.mON!=undefined)&&(obj.disabled!=true)&&(obj.readonly==undefined)){
			errNum = IsNullChar(obj);//�����̓`�F�b�N
			if(errNum==0){errNum = IsIllegalChar(obj,2);}//�s������(& ")�`�F�b�N
		}


		//�G���[����
		if(errNum!=0){
			showMsg("ERR"+errNum,obj.mON,obj.title);
			if(obj.type!='hidden'){
				obj.focus();
				if (obj.tagName != 'SELECT') {//���X�g�{�b�N�X�ł̓Z���N�g�ł��Ȃ�
					obj.select();
				}
			}
			return false;
		}




	}


	return true;


}











//***************************************************************
//	�֐���		:IsIllegalChar
//�@�@�\�T�v	:�o�^��� �s�������`�F�b�N
//�@����		:Obj=�I�u�W�F�N�g intVal=�`�F�b�N�p�^�[��
//	�쐬		:
//	�C��		:
//	���l		:
//***************************************************************
function IsIllegalChar(Obj,intVal) {
	var err_flg = 0;
	var strObj = Obj.value;
	if (intVal == 1) {
			//�s������ [& ' < > \]
			if(strObj.indexOf("&")!=-1 || strObj.indexOf("'")!=-1 || strObj.indexOf("<")!=-1 || strObj.indexOf(">")!=-1 || strObj.indexOf("\\")!=-1) {
				if(Obj.type!='hidden'){
					err_flg = 11;
				}else if(Obj.type=='hidden'){
					err_flg = 12;
				}
			}
	} else if (intVal == 2) {
			//[Where Clause]�̏ꍇ �s������ [& " \]
			if(strObj.indexOf("&")!=-1 || strObj.indexOf("\"")!=-1 || strObj.indexOf("\\")!=-1) {
				if(Obj.type!='hidden'){
					err_flg = 13;
				}else if(Obj.type=='hidden'){
					err_flg = 14;
				}
			}
	}
	return err_flg;
}






//***************************************************************
//	�֐���		:IsNullChar
//�@�@�\�T�v	:�o�^��� �����̓`�F�b�N
//�@����		:Obj=�I�u�W�F�N�g
//	�쐬		:
//	�C��		:
//	���l		:
//***************************************************************
function IsNullChar(Obj) {
	var err_flg = 0;
	var strObj = Obj.value;

	//�����̓`�F�b�N
	if (strObj == "") {
		if(Obj.type!='hidden'){
			err_flg = 21;
		}else if(Obj.type=='hidden'){
			err_flg = 22;
		}
	}

	return err_flg;

}




//***************************************************************
//	�֐���		:IntNumCheck
//�@�@�\�T�v	:�o�^��� ���l�`�F�b�N
//�@����		:Obj=�I�u�W�F�N�g
//	�쐬		:
//	�C��		:
//	���l		:
//***************************************************************
function IntNumCheck(Obj) {
	var err_flg = 0;
	var strObj = Obj.value;

	//���l�`�F�b�N
	if ((isNaN(strObj) == true)&&(strObj != "")) {
		err_flg = 31;
	}

	return err_flg;

}


//***************************************************************
//	�֐���		:DecimalCheck
//�@�@�\�T�v	:�o�^��� ���l�`�F�b�N
//�@����		:Obj=�I�u�W�F�N�g
//	�쐬		:
//	�C��		:
//	���l		:
//***************************************************************
function DecimalCheck(Obj) {
	var err_flg = 0;
	var strObj = Obj.value;

	//�����_�`�F�b�N
	if (strObj.indexOf(".") != -1) {
		err_flg = 32;
	}

	return err_flg;

}
 

//***************************************************************
//	�֐���		:MinMaxCheck
//�@�@�\�T�v	:�o�^��� ���l�`�F�b�N
//�@����		:Obj=�I�u�W�F�N�g, MinValue=�ŏ��l, MaxValue=�ő�l
//	�쐬		:
//	�C��		:
//	���l		:
//***************************************************************
function MinMaxCheck(Obj,MinValue,MaxValue) {
	var err_flg = 0;
	var strObj = Obj.value;
	var intMin = MinValue;
	var intMax = MaxValue;

	if ((strObj.valueOf(Number) > intMax || strObj.valueOf(Number) < intMin)&&(strObj != "")) {
		err_flg = 33;
	}

	return err_flg;

}


//***************************************************************
//	�֐���		:NumericCheck
//�@�@�\�T�v	:�o�^��� �����_�L�����i��2�ʂ܂Łj�`�F�b�N
//�@����		:Obj=�I�u�W�F�N�g
//	�쐬		:
//	�C��		:
//	���l		:
//***************************************************************
function NumericCheck(Obj) {
	var err_flg = 0;
	var strObj = Obj.value;

	//�����_�L�����i��2�ʂ܂Łj�`�F�b�N
	if(strObj.substring(0,strObj.length-3).indexOf(".")!=-1){
		err_flg = 34;
	}

	return err_flg;

}



//***************************************************************
//	�֐���		:NumericCheck
//�@�@�\�T�v	:�o�^��� �����_�L�����i��2�ʂ܂Łj�`�F�b�N
//�@����		:Obj=�I�u�W�F�N�g
//	�쐬		:
//	�C��		:
//	���l		:
//***************************************************************
function MaxLengthCheck(Obj) {
	var err_flg = 0;
	var strObj = Obj.value;

	//MAXLENGTH�i250�����ȓ��܂Łj�`�F�b�N
	if(strObj.length>250){
		err_flg = 41;
	}

	return err_flg;

}





//***************************************************************
//	�֐���		:
//�@�@�\�T�v	:�o�^��� ���p�X�y�[�X�폜
//�@����		:strVal=������
//	�쐬		:
//	�C��		:
//	���l		:
//***************************************************************
/*
	//Trim���̃X�y�[�X
	function TrimLeftStr( strVal )
	{
		var tmpStr;
		tmpStr = strVal;
		if ( strVal.charAt(0) == ' ' ) 
		{
			tmpStr = TrimLeftStr( strVal.substr(1, strVal.length ) );
		}
		return tmpStr;
	}
	
	//Trim�E�̃X�y�[�X
	function TrimRightStr( strVal )
	{
		var tmpStr;
		tmpStr = strVal;
		if ( strVal.charAt(strVal.length-1) == ' ' ) 
		{
			tmpStr = TrimRightStr( strVal.substr(0, strVal.length - 1 ) );
		}
		return tmpStr
	}
	
	//Trim�O�ƌ�̃X�y�[�X
	function TrimStr( strVal )
	{
		var tmpStr;
		tmpStr = TrimLeftStr( strVal );
		return TrimRightStr( tmpStr );
	}
*/

	//Trim�S�X�y�[�X�i���p�̂݁j
	function TrimAllStr( strVal )   
	{
		var tmpStr;
		tmpStr = strVal.replace(/ /g,"");
		return tmpStr;
	}




function showMsg(msgId,arg1,arg2){
	var msg=new Array();
	msg["LOG01"] = "���^���[�U�[����͂��Ă��������B";
	msg["LOG02"] = "���^�X�L�[�}����͂��Ă��������B";
	msg["LOG03"] = "�R�l�N�g�\�[�X����͂��Ă��������B";
	msg["ERR11"] = arg1+ ":�s������(& ' < > \\)���܂܂�Ă��܂��B���͂������Ă��������B";
	if(arg2!=undefined){tempString = arg2 + "��";}
	msg["ERR12"] = tempString + arg1+ ":�s������(& ' < > \\)���܂܂�Ă��܂��B���͂������Ă��������B";
	msg["ERR13"] = arg1 + ":�s������(& \" \\)���܂܂�Ă��܂��B���͂������Ă��������B";
	if(arg2!=undefined){tempString = arg2 + "��";}
	msg["ERR14"] = tempString + arg1 + ":�s������(& \" \\)���܂܂�Ă��܂��B���͂������Ă��������B";
	msg["ERR21"] = arg1 + "�������͂ł��B" + arg1 + "����͂��Ă��������B";
	var tempString = "";
	if(arg2!=undefined&&arg2!=""){tempString = arg2 + "��";}
	msg["ERR22"] = tempString + arg1 + "�����ݒ�ł��B";
	msg["ERR31"] = arg1 + "�𐔒l�œ��͂��Ă��������B";
	msg["ERR32"] = arg1 + "�𐮐��œ��͂��Ă��������B";
	msg["ERR33"] = arg1 + "��L���Ȕ͈͂œ��͂��Ă��������B";
	msg["ERR34"] = arg1 + "�͏����_�ȉ���2�ʂ܂ł̐��l�œ��͂��Ă��������B";
	msg["ERR41"] = arg1 + "��250�����ȓ��œ��͂��Ă��������B";
	msg["ERR101"] = arg1 + "�����I���ł��B";
	msg["COM1"] = "�I�u�W�F�N�g���R�s�[���܂����B";
	msg["USR1"] = "�g�p�\�ȃ\�[�X����ȏ�w�肵�Ă��������B";
	msg["USR2"] = arg1 + "�X�L�[�}�͑��݂��܂���B";
	msg["USR3"] = arg1 + "�X�L�[�}�͊��Ƀf�B�����V������o�^�ς݂ł��邽�߁A�폜�ł��܂���B";
	msg["DIM1"] = "���x�����쐬���Ă��������B";
	msg["DIM2"] = arg1 + "��" + arg2 + "�̃}�b�s���O���������ݒ肳��Ă��܂���B�}�b�s���O���m�F���Ă��������B";
	msg["DIM3"] = "�}�b�s���O����Ă��Ȃ����x��������܂��B";
	msg["DIM4"] = "���x���͍ő�" + arg1 + "�܂łł��B";
	msg["DIM5"] = "���x���̃}�b�s���O���z�����邱�Ƃ͂ł��܂���B";
	msg["DIM6"] = arg1 + "�͊��Ƀ��W���[�Ŏg�p����Ă��邽�߁A�폜�ł��܂���B";
	msg["CHT1"] = "�}�b�s���O�ς݂ł��B";
	msg["CHT2"] = "�s���ȃ}�b�s���O�ł��B";
	msg["TIM1"] = "���ԃf�B�����V�����\����ݒ肵�Ă��������B";
	msg["TIM2"] = arg1 + "�͊��ɃL���[�u�Ŏg�p����Ă��邽�߁A�폜�ł��܂���B";
	msg["TIM3"] = "�f�[�^�ێ����Ԃ͈̔͂𐳂����ݒ肵�Ă��������B";
	msg["MES1"] = "�f�B�����V�������쐬���ă}�b�s���O���Ă��������B";
	msg["MES2"] = arg1 + "��" + arg2 + "�̃}�b�s���O���������ݒ肳��Ă��܂���B�}�b�s���O���m�F���Ă��������B";
	msg["MES3"] = "���ԃf�B�����V�����ȊO�̃f�B�����V�����͍ő�" + arg1 + "�܂łł��B";
	msg["MES4"] = arg1 + "�͊��ɒǉ�����Ă��܂��B";
	msg["MES5"] = "�x���F" + arg1 + "�Ɠ����f�B�����V�����p�^�[���̃��W���[�����ɃL���[�u�ɓo�^����Ă��܂��B\n�f�B�����V������ǉ�����ꍇ�͑��̃��W���[�����l�Ƀf�B�����V������ǉ�����K�v������܂��B";
	msg["MES6"] = "���W���[����PostgreSQL�̃J�������Ɏw��ł��镶�����ݒ肵�Ă��������B";
	msg["MES7"] = "���ԃf�B�����V���������݂��܂���B���ԃf�B�����V�����̃}�b�s���O���폜���邩�A���ԃf�B�����V�������쐬��A�ēx�o�^���Ă��������B";
	msg["MES8"] = arg1 + "�͊��ɃL���[�u�Ŏg�p����Ă��邽�߁A�폜�ł��܂���B";
	msg["MES9"] = "�t�@�N�g�e�[�u���͈�ȏ�̃f�B�����V�����������͎��ԃf�B�����V�����ƃ}�b�s���O���Ȃ���΂Ȃ�܂���B";
	msg["MES10"] = arg1 + "�͊��ɃL���[�u�Ŏg�p����Ă��邽�߁A�f�B�����V�������폜���邱�Ƃ͂ł��܂���B";
	msg["CUB1"] = "�I�����W���[���w�肵�Ă��������B";
	msg["CUB2"] = "�I�����W���[�Ƀf�B�����V�����p�^�[�����قȂ郁�W���[���w�肷�邱�Ƃ͂ł��܂���B";
	msg["CUB3"] = "�ǉ����郁�W���[��I�����Ă��������B";
	msg["CUB4"] = "�x���F�e���W���[�Őݒ肳��Ă���t�@�N�g�e�[�u���̃����N�J����������ł͂���܂���B�t�@�N�g�����N�J�������m�F���Ă��������B";
	msg["CUB5"] = arg1 + "�͎��L���[�u�����݂��邽�߁A�폜�ł��܂���B";
	msg["CUB6"] = "�x���F�L���[�u�\�����ύX����Ă���ꍇ�A�L���[�u�\���͏���������܂��B";
	msg["CUB7"] = "�L���[�u�ɓo�^�ł��郁�W���[�͍ő�" + arg1 + "�܂łł��B";
	msg["CUB8"] = "�폜���郁�W���[��I�����Ă��������B";
	msg["FML1"] = "�������g���v�Z���Ɋ܂߂邱�Ƃ͂ł��܂���B";
	msg["CST1"] = "�S�ẴI�u�W�F�N�g���폜���邱�Ƃ͂ł��܂���B";
	msg["TNG1"] = "SQL��o�^���܂����B";
	msg["JRG1"] = "�L���[�u�����I���ł��B";
	msg["JRG2"] = "�u�X�N���b�v���r���h�v�Ƃ���ȊO�̃v���Z�X�𓯎��Ɏw�肷�邱�Ƃ͂ł��܂���B";
	msg["JRG3"] = "���s���X�g�ɒǉ����܂����B";
	msg["JRG4"] = arg1 + "���폜���܂����B";
	msg["JRG5"] = arg1 + "�𒆎~���܂��B";
	msg["JRG6"] = arg1 + "�͊��ɏI�����Ă��܂��B";
	msg["JRG7"] = "�ŋߎg�p�����W���u�����I���ł��B";
	msg["CSD1"] = "���x���̃J�X�^�}�C�Y�͍ő�15���x���܂łł��B";
	msg["CSD2"] = arg1 + "�͊��ɃL���[�u�Ŏg�p����Ă��邽�߁A�폜�ł��܂���B";


	alert(msg[msgId]);
}

function getConfirm(tp,formObj){
	var strTemp="";
	if(tp==0){
		strTemp="�쐬";
	}else if(tp==1){
		strTemp="�X�V";
	}else if(tp==2){
		strTemp="�폜";
	}else if(tp==3){
		strTemp="�쐬��A���s���X�g�ɒǉ�";
	}else if(tp==4){
		strTemp="�X�V��A���s���X�g�ɒǉ�";
	}
	return confirm(formObj.txt_name.value + "��" + strTemp + "���܂��B��낵���ł����H");
}


function showConfirm(msgId,arg1){
	var msg=new Array();
	msg["CFM1"] = "�ύX���͔j������܂��B��낵���ł����H";
	msg["CFM2"] = "�J�X�^�}�C�Y���ꂽSQL�͏���������܂��B��낵���ł����H";
	msg["CFM3"] = "���̃I�u�W�F�N�g���R�s�[���܂��B��낵���ł����H";
	msg["CFM4"] = arg1 + "��o�^���܂��B��낵���ł����H";
	msg["CFM5"] = "���O�A�E�g���܂��B��낵���ł����H";
	return confirm(msg[msgId]);
}


function getReturnMsg(objName,tp){
	var strTemp="";
	if(tp==0){
		strTemp="�쐬";
	}else if(tp==1){
		strTemp="�X�V";
	}else if(tp==2){
		strTemp="�폜";
	}
	alert(objName + "��" + strTemp + "���܂����B");
}





function setChangeFlg(){
	//[navi_frm]�t���[����Hidden=1 -- �������t���O�Z�b�g --
	top.frames[1].document.navi_form.change_flg.value = 1;
}
import java.io.*;
import java.util.*;
import java.lang.*;
import java.text.*;
import java.text.DateFormat;


/**
*���O��G���[���O�̍쐬�A��ʂւ̃��b�Z�[�W�\���Ȃǂ��s���N���X�ł��B
*@author IAF Consulting, Inc.
*/
public class writeLog  {


	FileWriter fw_l = null;
	FileWriter fw_e = null;
	BufferedWriter bw_l = null;
	BufferedWriter bw_e = null;
	boolean errWriteFlg = false;

	java.util.Date dtStartCubeTime;
	java.util.Date dtStartTotalTime;


	String sumLogStr = "";
	String beforeStepStr = "";
	String beforeStepText = "";
	String sumLogAlert = "";

	int errorCount = 0;
	int totalErrorCount = 0;
	int alertCount = 0;

	DateFormat df1=new SimpleDateFormat("yyyy/MM/dd(E) HH:mm:ss");
	DateFormat df2=new SimpleDateFormat("HH:mm:ss");


	/**
	* Constructor
	*/
	public writeLog() {
	}

		/**
		*���O�t�@�C�����폜���܂��B
		*@param filepath �t�@�C���p�X
		*/
		public String logDelete(String filepath) {
		 //   System.out.println(filepath);
			try {
				File file = new File(filepath);
				file.delete();
				return "success";
			} catch (Exception e) {
				return e.toString();
			}
		}

		/**
		*���O�t�@�C�����I�[�v�����܂��B
		*@param filepath �t�@�C���p�X
		*/
		public String logOpen(String filepath) {
		 //   System.out.println(filepath);
			try {
				fw_l = new FileWriter(filepath,true);
				bw_l = new BufferedWriter(fw_l,10);
				return "success";
			} catch (IOException e) {
				return e.toString();
			}
		}


		/**
		*�G���[���O�t�@�C�����I�[�v�����܂��B
		*@param filepath �t�@�C���p�X
		*/
		public String errLogOpen(String filepath) {
		    //System.out.println(filepath);
			try {
				fw_e = new FileWriter(filepath,true);
				bw_e = new BufferedWriter(fw_e,10);
				return "success";
			} catch (IOException e) {
				return e.toString();
			}
		}


		/**
		*���O�̊J�n���L�q���܂��B
		*/
		public void logStart() {
			try {
				bw_l.write("*********************" + df1.format(getNowTime()) + "*********************");
				bw_l.newLine();
				bw_l.flush();
			} catch (IOException e) {
				System.out.println("Caught exception: " + e +".");
			}
		}


		/**
		*���O�A�G���[���O�A�R���\�[���Ɋe���[�h�ɉ����ă��b�Z�[�W���o�͂��܂��B
		*@param MSG ���b�Z�[�W
		*/
		public void output(String MSG) {

			//���O�ւ̏o��
//			try {
//				if(fw_l!=null){
//					bw_l.write(MSG);
//					bw_l.newLine();
//					bw_l.flush();
//				}
//			} catch (IOException e) {
//				System.out.println("Caught exception: " + e +".");
//			}


			//�G���[���O�ւ̏o��
			try {
				if(fw_e!=null){//���O�ւ̏o��
					errWriteFlg=true;
					bw_e.write(MSG);
					bw_e.newLine();
					bw_e.flush();
				}
			} catch (IOException e) {
				System.out.println("Caught exception: " + e +".");
			}

		}


		/**
		*���O�t�@�C���A�G���[���O�t�@�C�����N���[�Y���܂��B
		*/
		public void fileClose() {
			try {
//				if(bw_l!=null){//���O�t�@�C���̃N���[�Y
//					bw_l.newLine();
//					bw_l.newLine();
//					bw_l.newLine();
//					bw_l.close();
//				}
				if(bw_e!=null){//�G���[���O�t�@�C���̃N���[�Y
					bw_e.newLine();
					bw_e.newLine();
					bw_e.newLine();
					bw_e.close();
				}
			} catch (IOException e) {
				System.out.println("Caught exception: " + e +".");
			}
		}


		/**
		*�����I�Ɏg�p���錻������Ԃ��܂��B
		*@return dt ���t�H�[�}�b�g����
		*/
		public static java.util.Date getNowTime() {
			Calendar cal = Calendar.getInstance();
			java.util.Date dt = cal.getTime();
			return dt;
		}



		/**
		*�Q�̎����̊Ԋu���v�Z���܂��B
		*@param olddt �����P
		*@param crrdt �����Q
		*@return strActionTime �Z�o���ꂽ�Q�̎����̊Ԋu
		*/
		private String calcActionTime(java.util.Date olddt,java.util.Date crrdt) {
			Long second=new Long((crrdt.getTime() - olddt.getTime()) / 1000);
			int intTotalSecond=(int)second.intValue(); 
			int intHour=(intTotalSecond/3600);
			int intMinute=((intTotalSecond%3600)/60);
			int intSecond=((intTotalSecond%3600)%60);
			String strHour="";
			String strMinute="";
			String strSecond="";
			if(intHour!=0){
				strHour = intHour+"����";
			}
			if(intMinute!=0){
				strMinute = intMinute+"��";
			}
			if((intSecond!=0)||(intHour==0&&intMinute==0)){
				strSecond = intSecond+"�b";
			}
		//	String strActionTime = strHour + strMinute + strSecond + " (" + intTotalSecond + "�b)";
			String strActionTime = strHour + strMinute + strSecond;
			return strActionTime;
		}


		/**
		*�L���[�u�����J�n������ݒ肵�܂��B
		*/
		private void setCubeTime() {
			dtStartCubeTime = getNowTime();
		}

		/**
		*�S�o�b�`�����J�n������ݒ肵�܂��B
		*/
		private void setTotalTime() {
			dtStartTotalTime = getNowTime();
		}

		/**
		*�L���[�u�����J�n�������擾���܂��B
		*/
		private Date getCubeTime() {
			return dtStartCubeTime;
		}

		/**
		*�S�o�b�`�����J�n�������擾���܂��B
		*/
		private Date getTotalTime() {
			return dtStartTotalTime;
		}


}


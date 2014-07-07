import java.io.*;
import java.util.*;
import java.lang.*;
import java.text.*;
import java.text.DateFormat;


/**
*ログやエラーログの作成、画面へのメッセージ表示などを行うクラスです。
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
		*ログファイルを削除します。
		*@param filepath ファイルパス
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
		*ログファイルをオープンします。
		*@param filepath ファイルパス
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
		*エラーログファイルをオープンします。
		*@param filepath ファイルパス
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
		*ログの開始を記述します。
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
		*ログ、エラーログ、コンソールに各モードに応じてメッセージを出力します。
		*@param MSG メッセージ
		*/
		public void output(String MSG) {

			//ログへの出力
//			try {
//				if(fw_l!=null){
//					bw_l.write(MSG);
//					bw_l.newLine();
//					bw_l.flush();
//				}
//			} catch (IOException e) {
//				System.out.println("Caught exception: " + e +".");
//			}


			//エラーログへの出力
			try {
				if(fw_e!=null){//ログへの出力
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
		*ログファイル、エラーログファイルをクローズします。
		*/
		public void fileClose() {
			try {
//				if(bw_l!=null){//ログファイルのクローズ
//					bw_l.newLine();
//					bw_l.newLine();
//					bw_l.newLine();
//					bw_l.close();
//				}
				if(bw_e!=null){//エラーログファイルのクローズ
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
		*内部的に使用する現時刻を返します。
		*@return dt 未フォーマット時刻
		*/
		public static java.util.Date getNowTime() {
			Calendar cal = Calendar.getInstance();
			java.util.Date dt = cal.getTime();
			return dt;
		}



		/**
		*２つの時刻の間隔を計算します。
		*@param olddt 時刻１
		*@param crrdt 時刻２
		*@return strActionTime 算出された２つの時刻の間隔
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
				strHour = intHour+"時間";
			}
			if(intMinute!=0){
				strMinute = intMinute+"分";
			}
			if((intSecond!=0)||(intHour==0&&intMinute==0)){
				strSecond = intSecond+"秒";
			}
		//	String strActionTime = strHour + strMinute + strSecond + " (" + intTotalSecond + "秒)";
			String strActionTime = strHour + strMinute + strSecond;
			return strActionTime;
		}


		/**
		*キューブ処理開始時刻を設定します。
		*/
		private void setCubeTime() {
			dtStartCubeTime = getNowTime();
		}

		/**
		*全バッチ処理開始時刻を設定します。
		*/
		private void setTotalTime() {
			dtStartTotalTime = getNowTime();
		}

		/**
		*キューブ処理開始時刻を取得します。
		*/
		private Date getCubeTime() {
			return dtStartCubeTime;
		}

		/**
		*全バッチ処理開始時刻を取得します。
		*/
		private Date getTotalTime() {
			return dtStartTotalTime;
		}


}


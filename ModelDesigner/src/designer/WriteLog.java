package designer;
import java.io.*;
import java.util.*;
import java.lang.*;
import java.text.*;
import java.text.DateFormat;


/**
*ログやエラーログの作成、画面へのメッセージ表示などを行うクラスです。
*@author IAF Consulting, Inc.
*/
public class WriteLog  {


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

	boolean innerFlg = false;

	//表示モード　0:なし　1:進行状況・エラーメッセージ　2:サマリーログ　3:進行状況・エラーメッセージ・サマリーログ
	int dos_disp = 1;

	//ログ表示モード　0:なし　1:進行状況・エラーメッセージ　2:サマリーログ　3:進行状況・エラーメッセージ・サマリーログ
	int log_disp = 1;//GUIでのデフォルト値となる



	DateFormat df1=new SimpleDateFormat("yyyy/MM/dd(E) HH:mm:ss");
	DateFormat df2=new SimpleDateFormat("HH:mm:ss");


	/**
	* Constructor
	*/
	public WriteLog() {
	}


		/**
		*ログモードをセットします。
		*@param logMode ログモード<BR>0:なし　1:進行状況・エラーメッセージ　2:サマリーログ　3:進行状況・エラーメッセージ・サマリーログ
		*/
		public void setLogMode(int logMode) {
			log_disp = logMode; 
		}

		/**
		*コンソールの出力モードをセットします。
		*@param consoleMode 出力モード<BR>0:なし　1:進行状況・エラーメッセージ　2:サマリーログ　3:進行状況・エラーメッセージ・サマリーログ
		*/
		public void setConsoleMode(int consoleMode) {
			dos_disp = consoleMode; 
		}


		public void setInnerFlg() {
			innerFlg = true; 
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
				if(!innerFlg){
					System.out.println("Caught exception: " + e +".");
				}
			}
		}


		/**
		*ログ、エラーログ、コンソールに各モードに応じてメッセージを出力します。
		*@param MSG メッセージ
		*@param msgType メッセージタイプ<BR>0:引数エラー　1:進行表示　2:エラーメッセージ　3エラースクリプト　4サマリーログ
		*/
		public void output(String MSG,int msgType) {


			//引数エラー時
			if(msgType==0){
				MSG="引数エラー: " + MSG;
			}

			//エラーカウント
			if(msgType==2){
				totalErrorCount++;//全エラー
				errorCount++;//キューブごとのエラー
			}


			//コンソールへの出力
			if(dos_disp==0){
			}else if(dos_disp==1){//進行状況・エラーメッセージ
				if(msgType==0||msgType==1||msgType==2){
					if(!innerFlg){
						System.out.println(MSG);
					}
				}
			}else if(dos_disp==2){//サマリーログ
				if(msgType==0||msgType==4){
					if(!innerFlg){
						System.out.println(MSG);
					}
				}
			}else if(dos_disp==3){//進行状況・エラーメッセージ・サマリーログ
				if(msgType==0||msgType==1||msgType==2||msgType==4){
					if(!innerFlg){
						System.out.println(MSG);
					}
				}
			}


			//ログへの出力
			try {
				if(fw_l!=null){
					if(log_disp==0){
					}else if(log_disp==1){//進行状況・エラーメッセージ
						if(msgType==0||msgType==1||msgType==2){
							bw_l.write(MSG);
							bw_l.newLine();
							bw_l.flush();
						}
					}else if(log_disp==2){//サマリーログ
						if(msgType==0||msgType==4){
							bw_l.write(MSG);
							bw_l.newLine();
							bw_l.flush();
						}
					}else if(log_disp==3){//進行状況・エラーメッセージ・サマリーログ
						if(msgType==0||msgType==1||msgType==2||msgType==4){
							bw_l.write(MSG);
							bw_l.newLine();
							bw_l.flush();
						}
					}
				}
			} catch (IOException e) {
				if(!innerFlg){
					System.out.println("Caught exception: " + e +".");
				}
			}


			//エラーログへの出力
			try {
				if(fw_e!=null){//ログへの出力
					if(msgType==0||msgType==2||msgType==3){
						errWriteFlg=true;
						bw_e.write(MSG);
						bw_e.newLine();
						bw_e.flush();
					}
				}
			} catch (IOException e) {
				if(!innerFlg){
					System.out.println("Caught exception: " + e +".");
				}
			}

		}


		/**
		*ログファイル、エラーログファイルをクローズします。
		*/
		public void fileClose() {
			try {
				if(bw_l!=null){//ログファイルのクローズ
					bw_l.newLine();
					bw_l.newLine();
					bw_l.newLine();
					bw_l.close();
				}
				if(bw_e!=null){//エラーログファイルのクローズ
					if(errWriteFlg){
						bw_e.newLine();
						bw_e.newLine();
						bw_e.newLine();
					}
					bw_e.close();
				}
			} catch (IOException e) {
				if(!innerFlg){
					System.out.println("Caught exception: " + e +".");
				}
			}
		}






		//SUMMARY LOG

		/**
		*メモリ上のサマリーログにメッセージを追加します。
		*/
		public void addSumLog(String str) {
			sumLogStr+="" + str + System.getProperty("line.separator");
		}


		/**
		*サマリーログの開始を記述します。
		*/
		public void writeStartTime() {
			setTotalTime();
			addSumLog("------------------ " + "サマリーログ" + " ------------------");
			addSumLog("開始時刻  : " + df1.format(getTotalTime()));
		}

		/**
		*サマリーログに引数（キューブ）を記述します。
		*/
		public void writeArgCube(String cubelistStr) {
			addSumLog("cube      : " + cubelistStr);
		}

		/**
		*サマリーログに引数（プロセス）を記述します。
		*/
		public void writeArgProcess(String procStr) {
			addSumLog("process   : " + procStr);
		}

		/**
		*サマリーログに引数（データロード対象期間）を記述します。
		*/
		public void writeArgTime(String timeStr) {
			addSumLog("time: " + timeStr);
		}

		/**
		*サマリーログに警告メッセージを記述します。
		*/
		public void writeAlert(String alertStr) {
			output(alertStr,1);
			sumLogAlert+="" + alertStr + System.getProperty("line.separator");
			alertCount++;
		}

		/**
		*サマリーログにキューブ処理の開始を記述します。
		*@param cubeStr キューブ名
		*/
		public void writeCube(String cubeStr) {
			errorCount=0;//エラーカウントの初期化
			addSumLog("");
			if(dtStartCubeTime==null){
				addSumLog("--------- " + "キューブ処理" + " ---------");
			}
			setCubeTime();
			addSumLog("■" + cubeStr);
		}

		/**
		*サマリーログにキューブ処理の終了を記述します。
		*/
		public void writeCubeEnd() {
			java.util.Date olddt = getCubeTime();
			java.util.Date crrdt = getNowTime();
		//	addSumLog(df2.format(olddt) + " - " + df2.format(crrdt));
			addSumLog("From      :" + df1.format(olddt));
			addSumLog("To        :" + df1.format(crrdt));
			addSumLog("実行時間  :" + calcActionTime(olddt,crrdt));
			addSumLog("エラー数  :" + errorCount);
		}


		/**
		*サマリーログの終了を記述します。
		*/
		public void writeEnd() {
			java.util.Date olddt = getTotalTime();
			java.util.Date crrdt = getNowTime();
			addSumLog("");
			addSumLog("--------- " + "サマリーレポート" + " ---------");
		//	addSumLog(df2.format(olddt) + " - " + df2.format(crrdt));
			addSumLog("From      :" + df1.format(olddt));
			addSumLog("To        :" + df1.format(crrdt));
			addSumLog("総実行時間:" + calcActionTime(olddt,crrdt));
			addSumLog("総エラー数:" + totalErrorCount);
			if(!"".equals(sumLogAlert)){
				addSumLog("警告数    :" + alertCount);
				addSumLog(sumLogAlert);
			}
			addSumLog("--------------------------------------------------");
		}


		/**
		*メモリ上のサマリーログを出力します。
		*/
		public void writeSumLog() {
			output("",4);
			output("",4);
			output(sumLogStr,4);
		//	System.out.println(sumLogStr);
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

		public int getTotalErrorCount(){
			return totalErrorCount;
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


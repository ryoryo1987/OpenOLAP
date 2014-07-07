package designer;
import java.io.*;
import java.util.*;
import java.text.*;
import java.sql.*;
import designer.ood;



/**
*このクラスは、キューブに対してのSQLを取得し、実行します。
*@author IAF Consulting, Inc.
*@see designer.ood
*/
public class ExecuteJob {


	/**
	*<BR>未実行のJOBがある限り、キューブに対してのSQLを取得し、実行します。
	*@param args キューブ作成JOB引数
	*/
	public static void main(String[] args){
		try{

			int i=0;
			int j=0;
			String metaName;
			String metaPwd;
			String metaSchema;
			String strDSN;
			String strSessionId;
			String strFilePath;
			Connection connMeta;
			Statement stmt=null;
			ResultSet rs=null;
			String Sql="";
			String jobSeq="";
			String jobName="";
			String jobCubeSeq="";
			String jobProcess="";
			int exeCount;
			boolean errorFlg = false;
			String strProcess="";

			String strArgMetaname="";
			String strArgMetapwd="null";
			String strArgMetaschema="";
			String strArgDsn="";
			String strArgCube="";
			String strArgProcess="";
			String strArgLog="";
			String strArgErrlog="";
			String strArgTime="";
			String strArgSessionId="";
			String strArgOutputMode="3";
			String strArgLogMode="3";
			String strArgErrStop="0";
			String cubeName="";



			//各引数とHELP文///////////////////////////////////////////////
			String[] arrCommand1 = new String[100];
			String[] arrCommand2 = new String[100];
			String[] arrUsage = new String[100];
			String[] arrDesc = new String[100];
			i=0;
			arrCommand1[i]="metaname";
			arrCommand2[i]="mn";
			arrUsage[i]="メタユーザー名";
			arrDesc[i]="OpenOLAPメタ情報を持つPostgreSQLユーザー名を指定します。";
			i++;
			arrCommand1[i]="metapwd";
			arrCommand2[i]="mp";
			arrUsage[i]="パスワード";
			arrDesc[i]="OpenOLAPメタ情報を持つPostgreSQLユーザーのパスワードを指定します。";
			i++;
			arrCommand1[i]="metaschema";
			arrCommand2[i]="ms";
			arrUsage[i]="メタスキーマ";
			arrDesc[i]="OpenOLAPメタ情報が属するPostgreSQLスキーマ名を指定します。";
			i++;
			arrCommand1[i]="dsn";
			arrCommand2[i]="d";
			arrUsage[i]="データソース";
			arrDesc[i]="接続するデータソース（jdbc:postgresql://ホスト:ポート番号/DB名）を指定します。";
			i++;
			arrCommand1[i]="cube";
			arrCommand2[i]="c";
			arrUsage[i]="キューブ名（キューブID）,...";
			arrDesc[i]="処理対象のキューブ（キューブIDもしくはキューブ名）を指定します。";
			i++;
			arrCommand1[i]="process";
			arrCommand2[i]="p";
			arrUsage[i]="プロセス番号,...";
			arrDesc[i]="キューブの処理プロセス（プロセス番号）を指定します。";
			arrDesc[i]+="\nプロセス番号：";
			arrDesc[i]+="\n     0: 削除＆新規作成（デフォルト）";
			arrDesc[i]+="\n     9: キューブ削除";
			arrDesc[i]+="\n     1: キューブ定義";
			arrDesc[i]+="\n     2: データロード";
			arrDesc[i]+="\n     3: 集計";
			arrDesc[i]+="\n     4: カスタムメジャー";
			arrDesc[i]+="\n※カンマ区切り・範囲選択（-）により、複数のプロセス番号を指定することも可能です。";
			arrDesc[i]+="\n";
			arrDesc[i]+="\n入力例： -p 0";
			arrDesc[i]+="\n　　　　 -p 1,2,3";
			arrDesc[i]+="\n　　　　 -p 2-4";
			i++;
			arrCommand1[i]="log";
			arrCommand2[i]="l";
			arrUsage[i]="ログファイルパス,ログ出力モード";
			arrDesc[i]="ログファイルの出力先を指定します。またログ出力モードの指定も可能です。";
			arrDesc[i]+="\nログ出力モード：";
			arrDesc[i]+="\n     0: 詳細なし";
			arrDesc[i]+="\n     1: 進行状況";
			arrDesc[i]+="\n     2: サマリーログ";
			arrDesc[i]+="\n     3: 進行状況・サマリーログ（デフォルト）";
			arrDesc[i]+="\n";
			arrDesc[i]+="\n入力例： -l /var/openolap/log20040301.log,3";
			i++;
			arrCommand1[i]="errlog";
			arrCommand2[i]="e";
			arrUsage[i]="エラーログファイルパス";
			arrDesc[i]="エラーログファイルの出力先を指定します。出力モードは指定できません。";
			i++;
			arrCommand1[i]="time";
			arrCommand2[i]="t";
			arrUsage[i]="期間種別,過去期間数,未来期間数";
			arrDesc[i]="データロードの対象期間を指定します。";
			arrDesc[i]+="\n期間種別：";
			arrDesc[i]+="\n     year(y): 年";
			arrDesc[i]+="\n     half(h): 半期";
			arrDesc[i]+="\n     quarter(q): 四半期";
			arrDesc[i]+="\n     month(m): 月";
			arrDesc[i]+="\n     week(w): 週";
			arrDesc[i]+="\n     day(d): 日";
			arrDesc[i]+="\n過去期間数：現期間を0として、データロード対象期間の開始となる過去期間";
			arrDesc[i]+="\n未来期間数：現期間を0として、データロード対象期間の終了となる未来期間";
			arrDesc[i]+="\n※期間種別のみを指定した場合、データロード対象期間は当期間（過去期間数:0、未来期間数:0）となります。";
			arrDesc[i]+="\n※オプション未設定時（デフォルト）および明示的に「all」を指定した場合は、時間ディメンション全期間がデータロード対象となります。";
			arrDesc[i]+="\n";
			arrDesc[i]+="\n入力例：今年　　　　　-t year,0,0 (または -t year)";
			arrDesc[i]+="\n　　　　前月～翌々月　-t month,1,2";
			arrDesc[i]+="\n　　　　翌週　　　　　-t week,-1,1";
			arrDesc[i]+="\n　　　　前日　　　　　-t day,1,-1";
			arrDesc[i]+="\n　　　　全期間　　　　-t all";
			i++;
			arrCommand1[i]="output";
			arrCommand2[i]="o";
			arrUsage[i]="出力モード";
			arrDesc[i]="コンソールの出力モードを指定します。";
			arrDesc[i]+="\n出力モード：";
			arrDesc[i]+="\n     0: 詳細なし";
			arrDesc[i]+="\n     1: 進行状況";
			arrDesc[i]+="\n     2: サマリーログ";
			arrDesc[i]+="\n     3: 進行状況・サマリーログ（デフォルト）";
			i++;
			arrCommand1[i]="stop";
			arrCommand2[i]="s";
			arrUsage[i]="エラー処理";
			arrDesc[i]="エラー発生時における処理の中断を指定します。";
			arrDesc[i]+="\n処理モード：";
			arrDesc[i]+="\n     0: 次のキューブの処理に移る（デフォルト）";
			arrDesc[i]+="\n     1: 全処理を中断する";
			i++;
			arrCommand1[i]="innerargument";
			arrCommand2[i]="i";
			arrUsage[i]="OpenOLAP Designer内部引数";
			arrDesc[i]="バッチでは指定する必要はありません。";
			i++;



			//Help表示///////////////////////////////////////////////
			if((args.length==0)||("help".equals(args[0])&&args.length==1)){//引数なしor引数「help」
				System.out.println("\n引数一覧");
				for(i=0;i<arrCommand1.length;i++){
					if(arrCommand1[i]==null){break;}
					String tempString="-" + arrCommand1[i] + "(" + "-" + arrCommand2[i] + ")";
					while(tempString.length()<=25){
						tempString += " ";
					}
					System.out.println(tempString + "     " + arrUsage[i]);
				}
				System.out.println("\n各引数の詳細は以下のようにして確認できます。");
				System.out.println("java designer.ExecuteJob help %引数名%");
				System.exit(9);return;
			}else if("help".equals(args[0])){
				for(i=0;i<arrCommand1.length;i++){
					if(arrCommand1[i]==null){break;}
					if((arrCommand1[i].startsWith(ood.replace(args[1],"-","")))||(arrCommand2[i].equals(ood.replace(args[1],"-","")))){
						System.out.println("\n[" + arrCommand1[i] + "]\n入力形式：　-" + arrCommand1[i] + "(" + "-" + arrCommand2[i] + ")" + " " + arrUsage[i]);
						System.out.println("" + arrDesc[i] + "\n");
					}
				}
				System.exit(9);return;
			}




			//引数チェック(log作成)///////////////////////////////////////////////
			WriteLog msg = new WriteLog();


			String strLogOpenReturn="";
			for(int iCount=0;iCount<args.length;iCount++){
				if((args[iCount].equals("-l"))||(args[iCount].equals("-log"))){

					//ログファイル
					StringTokenizer st = new StringTokenizer(args[iCount+1],",");
					int tempCount = st.countTokens();
					String tempLogFilePath="";
					if(tempCount==1){
						tempLogFilePath=args[iCount+1];
					}else{
						tempLogFilePath=st.nextToken();
						strArgLogMode=st.nextToken();
					}
					strLogOpenReturn=msg.logOpen(tempLogFilePath);
					msg.writeStartTime();
					if(!"success".equals(strLogOpenReturn)){
						msg.output("ログファイルをオープンできません。ログファイルパスを確認してください。" + System.getProperty("line.separator") + strLogOpenReturn,0);
						System.exit(9);return;
					}
				}
			}
			if("".equals(strLogOpenReturn)){
				msg.output("logが指定されていません。logを指定してください。",0);
				System.exit(9);return;
			}

			//ログがオープンできればバッチ起動をログに書き込む
			for(int iCount=0;iCount<args.length;iCount++){
				if((args[iCount].equals("-i"))||(args[iCount].equals("-innerargument"))){
					msg.setInnerFlg();
					break;
				}
				if(iCount==args.length-1){
					msg.logStart();
				}
			}




			//引数と属性値の形式チェック
			if(!args[0].startsWith("-")){
				msg.output(args[0] + "はオプションではありません。オプションを正しく指定してください。",0);
				bye(msg,rs,stmt);
				System.exit(9);return;
			}
			for(int iCount=0;iCount<args.length;iCount++){
				if(args[iCount].startsWith("-")){
					for(i=0;i<arrCommand1.length;i++){
						if(arrCommand1[i]==null){
							msg.output(args[iCount] + "は無効なオプションです。",0);
							bye(msg,rs,stmt);
							System.exit(9);return;
						}
						if((args[iCount].substring(1).equals(arrCommand1[i]))||(args[iCount].substring(1).equals(arrCommand2[i]))){
							if((iCount+1>=args.length)||(args[iCount+1].startsWith("-"))){
								msg.output(args[iCount] + "の属性値を入力してください。",0);
								bye(msg,rs,stmt);
								System.exit(9);return;
							}
							if("metaname".equals(arrCommand1[i])){
								strArgMetaname=args[iCount+1];
							}
							if("metapwd".equals(arrCommand1[i])){
								strArgMetapwd=args[iCount+1];
							}
							if("metaschema".equals(arrCommand1[i])){
								strArgMetaschema=args[iCount+1];
							}
							if("dsn".equals(arrCommand1[i])){
								strArgDsn=args[iCount+1];
							}
							if("cube".equals(arrCommand1[i])){
								strArgCube=args[iCount+1];
								msg.writeArgCube(strArgCube);
							}
							if("process".equals(arrCommand1[i])){
								strArgProcess=args[iCount+1];
								msg.writeArgProcess(strArgProcess);
							}
							if("log".equals(arrCommand1[i])){
								strArgLog=args[iCount+1];
							}
							if("errlog".equals(arrCommand1[i])){
								strArgErrlog=args[iCount+1];
							}
							if("time".equals(arrCommand1[i])){
								strArgTime=args[iCount+1];
								msg.writeArgTime(strArgTime);
							}
							if("output".equals(arrCommand1[i])){
								strArgOutputMode=args[iCount+1];
							}
							if("stop".equals(arrCommand1[i])){
								strArgErrStop=args[iCount+1];
							}
							if("innerargument".equals(arrCommand1[i])){
								strArgSessionId=args[iCount+1];
							}
							break;
						}
					}
				}
			}



			//必須項目入力チェック
		//	if("".equals(strArgLog)){
		//		System.out.println("logが指定されていません。logを指定してください。");
		//		System.exit(9);return;
		//	}
			if("".equals(strArgMetaname)){
				msg.output("metanameが指定されていません。metanameを指定してください。",0);
				bye(msg,rs,stmt);
				System.exit(9);return;
			}
		//	if("".equals(strArgMetapwd)){
		//		msg.output("metapwdが指定されていません。metapwdを指定してください。",0);
		//		bye(msg,rs,stmt);
		//		System.exit(9);return;
		//	}
			if("".equals(strArgMetaschema)){
				msg.output("metaschemaが指定されていません。metaschemaを指定してください。",0);
				bye(msg,rs,stmt);
				System.exit(9);return;
			}
			if("".equals(strArgDsn)){
				msg.output("dsnが指定されていません。dsnを指定してください。",0);
				bye(msg,rs,stmt);
				System.exit(9);return;
			}





			//属性値の詳細チェック
			//JDBCコネクション
			try{
				Class.forName("org.postgresql.Driver");
				connMeta = DriverManager.getConnection(strArgDsn, strArgMetaname, strArgMetapwd);
				stmt = connMeta.createStatement();
			}catch(Exception e){
				msg.output("JDBCコネクションが確立できません。" + System.getProperty("line.separator") + e,0);
				bye(msg,rs,stmt);
				System.exit(9);return;
			}

			//処理プロセス
			StringTokenizer st = new StringTokenizer(strArgProcess,",");//カンマ区切りの文字列を分割
			while (st.hasMoreTokens()) {
				String tempString = st.nextToken();
				if(tempString.length()==1){
				    try{
						int num = Integer.parseInt(tempString);
						if(!(((0<=num)&&(num<=4))||(num==9))){
							errorFlg = true;
						}else{
							if(!"".equals(strProcess)){strProcess+=",";}
							strProcess+=tempString;
						}
					}catch(Exception e) {
						errorFlg = true;
					}
				}else if(tempString.length()==3&&tempString.substring(1,2).equals("-")){
					int fromNum=0;
					int toNum=0;
				    try{
						fromNum = Integer.parseInt(tempString.substring(0,1));
						toNum = Integer.parseInt(tempString.substring(2,3));
					}catch(Exception e) {
						errorFlg = true;
					}
					//fromが１～４でなければエラー
					boolean errNumFlg1 = true;
					for(i=1;i<=4;i++){
						if(i==fromNum){
							errNumFlg1 = false;
							break;
						}
					}
					//toが１～４でなければエラー
					boolean errNumFlg2 = true;
					for(i=1;i<=4;i++){
						if(i==toNum){
							errNumFlg2 = false;
							break;
						}
					}
					//fromよりtoがちいさければエラー
					boolean errNumFlg3 = false;
					if(fromNum>=toNum){
						errNumFlg3 = true;
					}
					if(errNumFlg1||errNumFlg2||errNumFlg3){
						errorFlg = true;
					}

					if(!errorFlg){
						for(i=fromNum;i<=toNum;i++){
							if(!"".equals(strProcess)){strProcess+=",";}
							strProcess+=i;
						}
					}
				}else{
					errorFlg = true;
				}
				if(errorFlg){
					msg.output("processの属性値が不正です。processの属性値を正しく入力してください。",0);
					bye(msg,rs,stmt);
					System.exit(9);return;
				}
			}
			if("".equals(strProcess)){
				strProcess="0";//省略時用
			}




			//データロード対象期間
			String strArgTimeKind="ALL";
			int intArgTimePast=0;
			int intArgTimeFuture=0;

			if(!"".equals(strArgTime)){
				errorFlg = false;
				st = new StringTokenizer(strArgTime,",");//カンマ区切りの文字列を分割
				int tempCount = st.countTokens();
				if((tempCount==1)||(tempCount==3)){
					strArgTimeKind=st.nextToken().toUpperCase();
					if("ALL".equals(strArgTimeKind)){
						intArgTimePast=0;
						intArgTimeFuture=0;
					}else if(!(("YEAR".equals(strArgTimeKind))||("HALF".equals(strArgTimeKind))||("QUARTER".equals(strArgTimeKind))||("MONTH".equals(strArgTimeKind))||("WEEK".equals(strArgTimeKind))||("DAY".equals(strArgTimeKind))||("Y".equals(strArgTimeKind))||("H".equals(strArgTimeKind))||("Q".equals(strArgTimeKind))||("M".equals(strArgTimeKind))||("W".equals(strArgTimeKind))||("D".equals(strArgTimeKind)))){
						errorFlg = true;
					}else{
						if(tempCount==3){
						    try{
								intArgTimePast = Integer.parseInt(st.nextToken());
								intArgTimeFuture = Integer.parseInt(st.nextToken());
							}catch(Exception e){
								errorFlg = true;
							}
							if(intArgTimePast*-1>intArgTimeFuture){
								errorFlg = true;
							}
						}
					}
					strArgTimeKind=strArgTimeKind.substring(0,1);
				}else{
					errorFlg = true;
				}
				if(errorFlg){
					msg.output("timeの属性値が不正です。timeの属性値を正しく入力してください。",0);
					bye(msg,rs,stmt);
					System.exit(9);return;
				}
			}
			if("A".equals(strArgTimeKind)){
				strArgTimeKind="ALL";
			}
			if("Y".equals(strArgTimeKind)){
				strArgTimeKind="YEAR";
			}
			if("H".equals(strArgTimeKind)){
				strArgTimeKind="HALF";
			}
			if("Q".equals(strArgTimeKind)){
				strArgTimeKind="QUARTER";
			}
			if("M".equals(strArgTimeKind)){
				strArgTimeKind="MONTH";
			}
			if("W".equals(strArgTimeKind)){
				strArgTimeKind="WEEK";
			}
			if("D".equals(strArgTimeKind)){
				strArgTimeKind="DAY";
			}






			//出力モードチェック
			errorFlg = false;
			int tempInt=0;
		    try{
				tempInt = Integer.parseInt(strArgOutputMode);
			}catch(Exception e) {
				errorFlg = true;
			}
			//tempIntが１～３でなければエラー
			if(!(0<=tempInt&&tempInt<=3)){
				errorFlg = true;
			}
			if(errorFlg){
				msg.output("outputの属性値が不正です。outputの属性値を正しく入力してください。",0);
				bye(msg,rs,stmt);
				System.exit(9);return;
			}


			//ログモードチェック
			errorFlg = false;
			tempInt=0;
		    try{
				tempInt = Integer.parseInt(strArgLogMode);
			}catch(Exception e) {
				errorFlg = true;
			}
			//tempIntが１～３でなければエラー
			if(!(0<=tempInt&&tempInt<=3)){
				errorFlg = true;
			}
			if(errorFlg){
				msg.output("log出力モードが不正です。log出力モードを正しく入力してください。",0);
				bye(msg,rs,stmt);
				System.exit(9);return;
			}





			//出力モードのセット
			msg.setConsoleMode(Integer.parseInt(strArgOutputMode));
			//ログモードのセット
			msg.setLogMode(Integer.parseInt(strArgLogMode));


			//エラーログファイルOPEN
			if(!"".equals(strArgErrlog)){
				strLogOpenReturn=msg.errLogOpen(strArgErrlog);
				if(!"success".equals(strLogOpenReturn)){
				//	msg.output("警告：エラーログファイルがオープンできません。" + System.getProperty("line.separator") + strLogOpenReturn,1);
					msg.writeAlert("警告:エラーログファイルがオープンできません。" + System.getProperty("line.separator") + strLogOpenReturn);
				}
			}



			//バッチ時の処理
			if("".equals(strArgSessionId)){
				DateFormat df=new SimpleDateFormat("HHmmss");
				strArgSessionId=Math.random()+""+df.format(msg.getNowTime());//バッチの時は自動的に乱数を割り振る

				//キューブ「ALL」指定時は、全キューブID（カンマ区切り）に置き換える
				if("ALL".equals(strArgCube.toUpperCase())){
					strArgCube="";
					Sql = "SELECT cube_seq FROM " + strArgMetaschema + ".oo_cube ORDER BY cube_seq";
					rs = stmt.executeQuery(Sql);
					while(rs.next()){
						if(!"".equals(strArgCube)){
							strArgCube+=",";
						}
						strArgCube += rs.getString("cube_seq");
					}
					rs.close();
				}


				st = new StringTokenizer(strArgCube,",");//カンマ区切りの文字列を分割
				while (st.hasMoreTokens()) {

					String tempString = st.nextToken();
					String strCubeSeq = "";
					int cubeExistFlg=0;

					//キューブの存在を確認、名前からIDに変換も

					//name
					Sql = "SELECT cube_seq FROM " + strArgMetaschema + ".oo_cube WHERE name = '" + tempString + "'";
					rs = stmt.executeQuery(Sql);
					if(rs.next()){
						cubeExistFlg=1;
						strCubeSeq = rs.getString("cube_seq");
					}
					rs.close();

					//seq
					if(cubeExistFlg==0){
						Sql = "SELECT cube_seq FROM " + strArgMetaschema + ".oo_cube WHERE cube_seq = '" + tempString + "'";
						rs = stmt.executeQuery(Sql);
						if(rs.next()){
							cubeExistFlg=1;
							strCubeSeq = rs.getString("cube_seq");
						}
						rs.close();
					}

					//キューブをひとづずつ待機JOBとしてDBに登録
					if(cubeExistFlg==1){

						//SEQUENCE 取得
						int newJobSeq=0;
						Sql = "SELECT nextval('" + strArgMetaschema + ".oo_job_seq') as seq_no";
						rs = stmt.executeQuery(Sql);
						if(rs.next()){
							newJobSeq = rs.getInt("seq_no");
						}
						rs.close();


						Sql = "INSERT INTO " + strArgMetaschema + ".oo_job (";
						Sql = Sql + "job_seq";
						Sql = Sql + ",cube_seq";
						Sql = Sql + ",process";
						Sql = Sql + ",session_id";
						Sql = Sql + ",time";
						Sql = Sql + ",status";
						Sql = Sql + ",stop_flg";
						Sql = Sql + ")VALUES(";
						Sql = Sql + "" + newJobSeq;
						Sql = Sql + ",'" + strCubeSeq + "'";
						Sql = Sql + ",'" + strProcess + "'";
						Sql = Sql + ",'" + strArgSessionId + "'";
						Sql = Sql + ",'NOW'";
						Sql = Sql + ",'9'";
						Sql = Sql + ",'0'";
						Sql = Sql + ")";
					//	out.println(Sql);
						exeCount = stmt.executeUpdate(Sql);

					}else{
					//	msg.output("警告：キューブ：" + tempString + "は存在しません。",1);
						msg.writeAlert("警告:キューブ " + tempString + " は存在しません。");
					}

				}
			}
			




			//DBから待機JOBがなくなるまでJOBを取得して各JOBの処理を行う
			while(true){
				Sql = "";
				Sql = Sql + " SELECT j.job_seq, c.cube_seq||':'||c.name||' (プロセス '||j.process||')' AS name,j.cube_seq,j.process,c.name AS cubename FROM " + strArgMetaschema + ".oo_job j," + strArgMetaschema + ".oo_cube c";
				Sql = Sql + " WHERE j.cube_seq=c.cube_seq";
				Sql = Sql + " AND j.status = '9'";
				Sql = Sql + " AND j.session_id = '" + strArgSessionId + "'";
				Sql = Sql + " ORDER BY j.job_seq";
				Sql = Sql + " LIMIT 1";
				rs = stmt.executeQuery(Sql);
				if (rs.next()) {
					jobSeq = rs.getString("job_seq");
					jobName = rs.getString("name");
					jobCubeSeq = rs.getString("cube_seq");
					jobProcess = rs.getString("process");
					cubeName = rs.getString("cubename");
					msg.writeCube(jobName);
				}else{
					//実行するジョブがなければ、処理終了
					break;
				}
				rs.close();

				msg.output("",1);
				msg.output("",1);
				msg.output(jobName,1);
				msg.output("",1);


				int errFlg=0;

				//処理中フラグをセット
				Sql = "UPDATE " + strArgMetaschema + ".oo_job ";
				Sql = Sql + " SET status = '1'";
				Sql = Sql + " WHERE job_seq = '" + jobSeq + "'";
				exeCount = stmt.executeUpdate(Sql);





				if(!"ALL".equals(strArgTimeKind)){//データロード対象期間の期間種別を時間ディメンションのレベルとして持っているかをチェック（時間ディメンションが存在する時のみ）
					Sql = " SELECT " +  strArgTimeKind + "_flg AS levelFlg FROM " + strArgMetaschema + ".oo_time";
					Sql = Sql + " WHERE time_seq in (";
					Sql = Sql + " SELECT dimension_seq";
					Sql = Sql + " FROM " + strArgMetaschema + ".oo_cube_structure";
					Sql = Sql + " WHERE cube_seq = " + jobCubeSeq;
					Sql = Sql + " AND time_dim_flg = '1'";
					Sql = Sql + " )";
					rs = stmt.executeQuery(Sql);
					if (rs.next()) {
						if("0".equals(rs.getString("levelFlg"))){
							msg.output(cubeName + "の時間ディメンションには" + strArgTimeKind + "レベルが存在しない為、データロード対象期間に" + strArgTimeKind + "を指定することはできません。",2);
							errFlg=1;
						}
					}
					rs.close();
				}


				//SQL生成
				Hashtable sHash = new Hashtable();
				if(errFlg==0){
					try{
						sHash = new designer.GenerateSql().main(connMeta,strArgMetaschema,jobCubeSeq,jobProcess,strArgTimeKind,intArgTimePast,intArgTimeFuture,0);
					}catch(Exception e){
						msg.output("SQLの作成に失敗しました。" + System.getProperty("line.separator") + e,2);
						errFlg=1;
					}
				}


				if(errFlg==0){

					Calendar cal = Calendar.getInstance(TimeZone.getDefault());
				//	DateFormat df=new SimpleDateFormat("yyyy/MM/dd (EE) HH:mm:ss");
					DateFormat df=new SimpleDateFormat("HH:mm:ss");

					String generatedSql="";
					String[] arrSql;
					String[] arrMsg;
				//	String[] arrIgnore;
					arrSql=(String[])sHash.get("arrSql");
					arrMsg=(String[])sHash.get("arrMsg");
				//	arrIgnore=(String[])sHash.get("arrIgnore");


					int sqlNum=0;
					//キューブ処理SQLを一つずつ順に実行
					for(i=0;i<arrSql.length;i++){
						if(arrSql[i]!=null){
							sqlNum++;
						}
					}


					for(i=0;i<arrSql.length;i++){
						if(arrSql[i]!=null){

						//	String strPoint = "[" + (i+1) + "/" + (((Integer)sHash.get("sqlNum")).intValue()+1) + "]";
							String strPoint = "[" + (i+1) + "/" + sqlNum + "]";

							//処理中止フラグの確認（GUIの中止ボタン）
							Sql = "";
							Sql = Sql + " SELECT job_seq,cube_seq,process FROM " + strArgMetaschema + ".oo_job";
							Sql = Sql + " WHERE job_seq = '" + jobSeq + "'";
							Sql = Sql + " AND stop_flg = '1'";
							rs = stmt.executeQuery(Sql);
							if (rs.next()) {
								msg.output("処理中止",1);
								break;//キューブ作成処理終了
							}
							rs.close();

							Sql = arrSql[i];
							msg.output(df.format(msg.getNowTime()) + "  " + strPoint + " " + arrMsg[i] + "   処理開始...",1);
						//	msg.output(Sql,1);
							try{
							//	if(Sql.startsWith("SELECT")){
								//SQLの実行
								if(Sql.indexOf("--OpenOLAP Executing Procedure--")!=-1){
									rs = stmt.executeQuery(Sql);//プロシージャー実行
								}else{
									exeCount = stmt.executeUpdate(Sql);//通常SQL実行
								}
							}catch(Exception e){
							//	if("0".equals(arrIgnore[i])){
								if(Sql.indexOf("--OpenOLAP Ignore Error--")==-1){
									msg.output(df.format(msg.getNowTime()) + "  " + strPoint + " " + arrMsg[i] + "   処理にてエラー発生" + System.getProperty("line.separator") + e,2);
									break;
								}
							}
							msg.output(df.format(msg.getNowTime()) + "  処理終了",1);
						}
					}


					//キューブ情報をメタに登録する
					String[] arrInfoSql;
					arrInfoSql=(String[])sHash.get("arrInfoSql");
					msg.output(df.format(msg.getNowTime()) + "  キューブ情報登録   処理開始...",1);
					for(i=0;i<arrInfoSql.length;i++){
						if(arrInfoSql[i]!=null){
							Sql = arrInfoSql[i];
							try{
							//	if(Sql.startsWith("SELECT")){
							//		rs = stmt.executeQuery(Sql);
							//	}else{
									exeCount = stmt.executeUpdate(Sql);
							//	}
							}catch(SQLException e){
							//	if("0".equals(arrIgnore[i])){
									msg.output(df.format(msg.getNowTime()) + "  キューブ情報登録   処理にてエラー発生" + System.getProperty("line.separator") + e,2);
									break;
							//	}
							}

						}
					}
					msg.output(df.format(msg.getNowTime()) + "  処理終了",1);


					msg.output("全処理終了",1);//該当キューブ処理終了（全キューブ処理ではない）
					msg.output("",1);


				}

				msg.writeCubeEnd();

				//処理終了フラグをセット
				Sql = "UPDATE " + strArgMetaschema + ".oo_job ";
				Sql = Sql + " SET status = '0'";
				Sql = Sql + " ,stop_flg = '0'";
				Sql = Sql + " WHERE job_seq = '" + jobSeq + "'";
				exeCount = stmt.executeUpdate(Sql);


			//	Sql = "UPDATE " + strArgMetaschema + ".oo_cube ";
			//	Sql = Sql + " SET ";
			//	Sql = Sql + " record_count = (SELECT COUNT(*) FROM " + strArgMetaschema + ".cube_" + jobCubeSeq + ")";
			//	Sql = Sql + " WHERE cube_seq = '" + jobCubeSeq + "'";
			//	exeCount = stmt.executeUpdate(Sql);


				//エラー発生時に次キューブに行くかはオプションによる
				if("1".equals(strArgErrStop)){
					if(msg.errorCount>0){
						//全キューブ処理中断
						break;
					}
				}

			}


			bye(msg,rs,stmt);


			int totalErrorCount=msg.getTotalErrorCount();
			if(totalErrorCount!=0){
				System.exit(9);return;
			}

			//終了コード
			System.exit(0);

		}catch(Exception e){
			System.out.println("Error:" + e);
			System.exit(9);return;
		}

	}


	/**
	*メモリ上のサマリーログを必要に応じてログなどに出力します。
	*<BR>また、ResultSet,Statementをクローズします。
	*@param msg WriteLogインスタンス
	*@param rs ResultSet
	*@param stmt Statement
	*/
	private static void bye(WriteLog msg,ResultSet rs,Statement stmt) {
		msg.writeEnd();
		msg.writeSumLog();
		msg.fileClose();
		try{
			if(rs!=null){
				rs.close();
			}
			if(stmt!=null){
				stmt.close();
			}
		}catch(Exception e){
			System.out.println("Error:" + e);
		}
	}


}




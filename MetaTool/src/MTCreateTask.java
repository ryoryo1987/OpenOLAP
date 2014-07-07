import java.util.*;
import java.io.*;

import java.sql.*;
import java.sql.SQLException;

public class MTCreateTask {
	private int lengthOfTask;
	private int current = 0;
	private String statMessage;

	private String url;
	private String user;
	private String password;
	private String schema;

	MTActualTask mtat = null;

	Statement stmt = null;
//	CallableStatement cstmt = null;

	// SQL�X�N���v�g�̊Ǘ�
	static final int iMaxScript = 200;
	String[] script = null;
	static final int iMaxProc  = 100;
	String[] proc = null;
	static final int iMaxTime  = 100;
	String[] time = null;

	//DB Status
	int iRetValue;
	String strRetValue;

	// ���ݏ������̃^�X�NNo.(Work)
	int iCurrentCount = 0;
	// ���ׂẴ^�X�N��(Work)
	int iTotalCount = 0;

	public MTCreateTask(Hashtable C3Hash) {
		//�X�e�[�^�X������
		iRetValue = 0;
		strRetValue = "";

		//Compute length of task...
		//In a real program, this would figure out
		//the number of bytes to read or whatever.

		//�^�X�N�Ǘ�
		//�ϐ��E�z��̏�����
		script = new String[iMaxScript];
		proc   = new String[iMaxProc];
		time   = new String[iMaxTime];
		for (int iCount = 0; iCount < iMaxScript; iCount++) { script[iCount] = ""; }
		for (int iCount = 0; iCount < iMaxProc;  iCount++) { proc[iCount]  = ""; }
		for (int iCount = 0; iCount < iMaxTime;  iCount++) { time[iCount]  = ""; }

		iTotalCount  = 0;
		iTotalCount += this.init_script();
		iTotalCount += this.init_proc();
		iTotalCount += this.init_time();
		lengthOfTask = iTotalCount;

		//JDBC�ڑ��p�p�����[�^�ݒ�
		url = "jdbc:postgresql://";
		url = url + (String)C3Hash.get("HOST") + ":";
		url = url + (String)C3Hash.get("PORT") + "/";
		url = url + (String)C3Hash.get("SID");

		user = (String)C3Hash.get("USER");
		password = (String)C3Hash.get("PASS");
		schema = (String)C3Hash.get("SCHM");

		// �����\�����b�Z�[�W
		statMessage = "�ڑ���...";
	}

    /**
     * Called from ProgressBarDemo to start the task.
     */
    void go() {
        current = 0;
Dbg.out("url:"+url);
Dbg.out("user:"+user);
Dbg.out("password:"+password);
        final SwingWorker worker = new SwingWorker() {
            public Object construct() {
				mtat = new MTActualTask(url, user, password,schema);
				return mtat;
            }
        };
        worker.start();
    }

    /**
     * Called from ProgressBarDemo to find out how much work needs
     * to be done.
     */
    int getLengthOfTask() {
		return lengthOfTask;
    }

    /**
     * Called from ProgressBarDemo to find out how much has been done.
     */
    int getCurrent() {
		return current;
    }

    void stop() {
        current = lengthOfTask;
    }

    /**
     * Called from ProgressBarDemo to find out if the task has completed. �i�^�X�N�����̔���j
     */
    boolean done() {
        if (current >= lengthOfTask)
            return true;
        else
            return false;
    }

    String getMessage() {
        return statMessage;
    }

	// �^�X�N�E�X�e�[�^�X�Ǘ����\�b�h
	int getIntStatus() {
		return iRetValue;
	}
	String getStringStatus() {
		return strRetValue;
	}
	void initStatus() {
		iRetValue = 0;
		strRetValue = "";
	}

	//JDBC�ڑ��p�����[�^�̍Đݒ�i�E�B�U�[�h�Ŗ߂����Ƃ��ɍĐݒ肪�K�v�Ȃ̂ŊO������Ăяo���郁�\�b�h�Ƃ��ėp�Ӂj
	void setValue(Hashtable C3Hash) {
		url = "jdbc:postgresql://";
		url = url + (String)C3Hash.get("HOST") + ":";
		url = url + (String)C3Hash.get("PORT") + "/";
		url = url + (String)C3Hash.get("SID");

		user = (String)C3Hash.get("USER");
		password = (String)C3Hash.get("PASS");
		schema = (String)C3Hash.get("SCHM");
	}

	// �����N���X�͂�������
	class MTActualTask {
		MTActualTask (String strUrl, String strUser, String strPassword,String strSchema) {
			// �����ݒ�

			url      = strUrl;
			user     = strUser;
			password = strPassword;
			schema   = strSchema;
			// �^�X�N�̎��s�J�n
			//iRetValue = this.execute();
			this.execute();
		}

		void execute() {
			//���b�Z�[�W�\���p�ɑҋ@
			try {
				Thread.sleep(1000); //sleep for a second
			} catch (InterruptedException e) {}

			// �h���C�o�N���X�����[�h
			try {
				Class.forName("org.postgresql.Driver");
			} catch (Exception e) {
				System.out.println("Caught exception " + e +".");
				iRetValue = 100;
				strRetValue = (String)e.getMessage();
			}

			// �f�[�^�x�[�X�֐ڑ�
			Connection conn = null;
			try {
				conn = (Connection)java.sql.DriverManager.getConnection(url, user, password);
			} catch (SQLException e) {
				System.out.println("Connection attempt failed.");
				e.printStackTrace();
				iRetValue = 110;
				strRetValue = (String)e.getMessage();
			}

			// �X�e�[�g�����g�I�u�W�F�N�g�𐶐�
			try {
				stmt = conn.createStatement();
			} catch (SQLException e) {
				System.out.println("Caught exception " + e +".");
				iRetValue = 120;
				strRetValue = (String)e.getMessage();
			}

			// *********************
			// Processing.....start
			// *********************

			int iRecCount=0;
			String sql = "SELECT count(*) as rec_cnt FROM pg_namespace where nspname ='"+schema+"'";
			try {
				ResultSet rs = stmt.executeQuery(sql);
				while(rs.next()) {
					iRecCount = rs.getInt("rec_cnt");
				}
				if (iRecCount == 0) {
					iRetValue = 1000;
					strRetValue = schema+"�X�L�[�}�����݂��܂���B";
					//�������f
					return;
				}
			} catch (SQLException e) {
				System.out.println("Caught exception " + e +".");
			}

			//���^�e�[�u���Ǘ��pSQL
			sql = "select count(*) as rec_cnt from "+schema+".oo_meta_info";
			iRecCount = -1; // 0 �ȉ��ɂ��Ă����āA���R�[�h���擾�ł��Ȃ������ꍇ�Ƌ�ʁi�O�̂��߁j
			//���R�[�h�̗L������
			try {
				ResultSet rs = stmt.executeQuery(sql);
				while(rs.next()) {
					iRecCount = rs.getInt("rec_cnt");
				}
			} catch (SQLException e) {
				//�e�[�u�������݂��Ȃ������ꍇ�͉������Ȃ��i���߂Ă̐ݒ�j
			}

			// iRecCount = -1 -> �e�[�u�������݂��Ȃ�(Create���s)
			// iRecCount =  0 -> �e�[�u����������(Create���s)
			if (iRecCount > 0) {
				iRetValue = 1000;
				strRetValue = "���łɃ��^�f�[�^�����݂��܂��B";
				//�������f
				return;
			}


			//Error Log
			String logFileName = "metaTool.log";
			String strLogReturnMsg="";
			writeLog errlog = new writeLog();

			//Delete
			strLogReturnMsg=errlog.logDelete(logFileName);


			//�X�N���v�g���s
			for (int iCount = 0; iCount < script.length; iCount++) {
				try {
					if (!script[iCount].equals("")) {
try {
	Thread.sleep(50); //sleep for a second
} catch (InterruptedException e) {}
						iCurrentCount++; // �J�E���g�A�b�v
						current = iCurrentCount;
						statMessage = current + "�^" + lengthOfTask + " �I�����܂����B";
						script[iCount]=replace(script[iCount],"%schema%",schema);
						stmt.executeUpdate(script[iCount]);
					}
				} catch (SQLException e) {
Dbg.out("Error"+script[iCount]+e.toString());
					//Error Log
					strLogReturnMsg=errlog.errLogOpen(logFileName);
					errlog.output("************************************************");
					errlog.output("*** Message ***");
					errlog.output(e.toString());
					errlog.output("***** SQL *****");
					errlog.output(script[iCount]);
					errlog.fileClose();
				}
			}

			for (int iCount = 0; iCount < proc.length; iCount++) {
				try {
					if (!proc[iCount].equals("")) {
try {
	Thread.sleep(50); //sleep for a second
} catch (InterruptedException e) {}
						iCurrentCount++; // �J�E���g�A�b�v
						current = iCurrentCount;
						statMessage = current + "�^" + lengthOfTask + " �I�����܂����B";
						proc[iCount]=replace(proc[iCount],"%schema%",schema);
						stmt.executeUpdate(proc[iCount]);
					}
				} catch (SQLException e) {
Dbg.out("Error"+proc[iCount]+e.toString());
					//Error Log
					strLogReturnMsg=errlog.errLogOpen(logFileName);
					errlog.output("************************************************");
					errlog.output("*** Message ***");
					errlog.output(e.toString());
					errlog.output("***** SQL *****");
					errlog.output(proc[iCount]);
					errlog.fileClose();
				}
			}

			for (int iCount = 0; iCount < time.length; iCount++) {
				try {
					if (!time[iCount].equals("")) {
try {
	Thread.sleep(50); //sleep for a second
} catch (InterruptedException e) {}
						iCurrentCount++; // �J�E���g�A�b�v
						current = iCurrentCount;
						statMessage = current + "�^" + lengthOfTask + " �I�����܂����B";
						time[iCount]=replace(time[iCount],"%schema%",schema);
						ResultSet rs = stmt.executeQuery(time[iCount]);
						rs.close();
					}
				} catch (SQLException e) {
Dbg.out("Error"+time[iCount]+e.toString());
					//Error Log
					strLogReturnMsg=errlog.errLogOpen(logFileName);
					errlog.output("************************************************");
					errlog.output("*** Message ***");
					errlog.output(e.toString());
					errlog.output("***** SQL *****");
					errlog.output(time[iCount]);
					errlog.fileClose();
				}
			}

			//
			// Processing.....end
			// 

			// �f�[�^�x�[�X����ؒf
			try {
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				System.out.println("Caught exception " + e +".");
				iRetValue = 199;
				strRetValue = (String)e.getMessage();
			}

			//���b�Z�[�W�\���p�ɑҋ@
			try {
				Thread.sleep(1000); //sleep for a second
			} catch (InterruptedException e) {}
			iRetValue = 0;
			strRetValue = "";
		}

	}
	// �����N���X�͂����܂�

	String readFile (String pathName){
		try{
			//FileReader fr = new FileReader(pathName);
			//BufferedReader br = new BufferedReader(fr);

			FileInputStream fis = new FileInputStream(pathName);
			InputStreamReader isr = null;
				isr = new InputStreamReader(fis,"Shift_JIS");
				//isr = new InputStreamReader(fis);

			BufferedReader br = new BufferedReader(isr);

			String line="";
			StringBuffer allText= new StringBuffer(50000);

			line = "";
//			allText = line + "\n";
			while(line != null){
				line = br.readLine();
				if (line !=null){
					allText.append(line + "\n");
				}
			}
//System.out.println(pathName+":::::"+allText.length());
			return allText.toString();
		}catch(FileNotFoundException e){
		}catch(IOException e){
		}
		return null;
	}

	int init_script() {
	    script = split(this.readFile("createMetaTable.oo"), "/"+"\n");
		return script.length -1 ;
	}

	int init_proc() {
	    proc = split(this.readFile("createProcedure.oo"), "/"+"\n");
		return proc.length -1 ;
	}

	int init_time() {
	    time = split(this.readFile("createTimeData.oo"), "/"+"\n");
		return time.length -1 ;
	}

	private static String replace(String strTarget, String strOldStr, String strOldNew){
	    String strSplit[];
	    String strResult;

	    strSplit = split(strTarget, strOldStr);
	    strResult = strSplit[0];
	    for (int i = 1; i < strSplit.length; i ++)
	    {
	        strResult += strOldNew + strSplit[i];
	    }

	    return strResult;
	}

	private static String[] split(String strTarget, String strDelimiter){
	    String strResult[];
	    Vector objResult;
	    int intDelimiterLen;
	    int intStart;
	    int intEnd;

	    objResult = new java.util.Vector();
	    strTarget = strTarget + strDelimiter;
	    intDelimiterLen = strDelimiter.length();
	    intStart = 0;
	    while ((intEnd = strTarget.indexOf(strDelimiter, intStart)) >= 0)
	    {
	        objResult.addElement(strTarget.substring(intStart, intEnd));
	        intStart = intEnd + intDelimiterLen;
	    }

	    strResult = new String[objResult.size()];
	    objResult.copyInto(strResult);
	    return strResult;
	}


}

import java.util.*;
import java.awt.*;

import javax.swing.*;
import javax.swing.border.*;	// ボーダ

public class C4Panel extends JPanel  implements GetPanelValue {

	int val;	//引数

	JLabel comment;	//説明用

	//User & Password
	JLabel				lblUser;	//User
	JTextField			txfUser;
	JLabel				lblPass;	//Password
	JPasswordField		pwfPass;

	//"jdbc:oracle:thin:@" + 192.168.1.70 + ":" + 1521 + ":" + ORCL
	JLabel				lblHost;	//Hostname
	JTextField			txfHost;
	JLabel				lblPort;	//Port
	JTextField			txfPort;
	JLabel				lblSid;		//SID
	JTextField			txfSid;

	String strUSER;		//User
	String strPASS;		//Password
	String strHOST;		//Hostname
	String strPORT;		//Port
	String strSID;		//SID
	String strShm;		//Schema

	JTextArea			taSetting;

	JLabel footer;	//メッセージ用

	//改行コード
	String newline = "\n";

	//コンストラクタ
	public C4Panel() {

		// スペースを占めるが描画はしない、空の透過ボーダ
		setBorder(new EmptyBorder(5,5,5,5));
		// 全体のレイアウトマネージャをボックスレイアウト(Y_AXIS)に設定
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		//未使用
		comment = new JLabel("These are the setting value which you inputted.");
		footer = new JLabel("上記情報でメタを作成します。よろしければ、次へを押してください。");

		// ----------------------------------------------------------------------------------------
		// テキスト入力欄作成
		// →入力確認欄はテキストエリアに表示する。

		taSetting = new JTextArea(5, 20);
		taSetting.setMargin(new Insets(5,5,5,5));
		taSetting.setEditable(false);
		taSetting.setBackground(Color.lightGray);

		// ----------------------------------------------------------------------------------------
		// JPanelパネルの設定

		JPanel pnlFooter = new JPanel();
		pnlFooter.setLayout(new GridLayout(0, 1));
		pnlFooter.add(footer);


		JPanel connPanel = new JPanel();
		connPanel.setLayout(new BoxLayout(connPanel, BoxLayout.Y_AXIS));

		Border textBorder = new TitledBorder(null,"確認",
						      TitledBorder.LEFT, TitledBorder.TOP,
							  new Font("Dialog", Font.BOLD, 12));

		Border emptyBorder = new EmptyBorder(5,5,5,5);
		Border compoundBorder = new CompoundBorder(textBorder, emptyBorder);
		connPanel.setBorder(compoundBorder);
		connPanel.add(new JScrollPane(taSetting), BorderLayout.CENTER);

		this.add(connPanel);
		this.add(pnlFooter);

	} // コンストラクタ（終）

	// 選択項目
	public Hashtable getValue() {
		Hashtable val = new Hashtable();
		return val;	
	}

	// 選択項目
	public void setValue(Hashtable C3Hash) {
		Hashtable val = (Hashtable)C3Hash;
		String strPassDummy = "";
		strUSER = (String)val.get("USER");		//User
		strPASS = (String)val.get("PASS");		//Password
		strHOST = (String)val.get("HOST");		//Hostname
		strPORT = (String)val.get("PORT");		//Port
		strSID  = (String)val.get("SID");		//SID
		strShm  = (String)val.get("SCHM");		//Schema

		//内容の初期化
		taSetting.setText("");
		taSetting.append("ユーザー名     : " + strUSER + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());
		for (int iCount = 0; iCount < strPASS.length(); iCount++) {
			strPassDummy = strPassDummy + "*";
		}
		taSetting.append("パスワード     : " + strPassDummy + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());
		taSetting.append("ホスト名       : " + strHOST + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());
		taSetting.append("ポート番号     : " + strPORT + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());
		taSetting.append("データベース名 : " + strSID  + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());
		taSetting.append("スキーマ名     : " + strShm  + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());

	}
}

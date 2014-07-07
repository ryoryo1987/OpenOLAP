import java.util.*;
import java.awt.*;

import javax.swing.*;
import javax.swing.border.*;	// ボーダ

public class C3Panel extends JPanel implements GetPanelValue {

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

	//Schema
	JLabel				lblShm;		//Schema
	JTextField			txfShm;

	// コンストラクタ
	public C3Panel(){
		// スペースを占めるが描画はしない、空の透過ボーダ
		setBorder(new EmptyBorder(5,5,5,5));
		// 全体のレイアウトマネージャをボックスレイアウト(Y_AXIS)に設定
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		comment = new JLabel("メタを作成するPostgreSQLデータベースの情報を入力してください。");

		// ----------------------------------------------------------------------------------------
		// テキスト入力欄作成

		lblUser = new JLabel("ユーザー名: ", JLabel.RIGHT);
		txfUser = new JTextField("");

		lblPass = new JLabel("パスワード: ", JLabel.RIGHT);
		pwfPass = new JPasswordField("");

		lblHost = new JLabel("ホスト名: ", JLabel.RIGHT);
		txfHost = new JTextField("");

		lblPort = new JLabel("ポート: ", JLabel.RIGHT);
		txfPort = new JTextField("5432");

		lblSid = new JLabel("データベース名: ", JLabel.RIGHT);
		txfSid = new JTextField("");

		lblShm = new JLabel("スキーマ名: ", JLabel.RIGHT);
		txfShm = new JTextField("public");

		// ----------------------------------------------------------------------------------------
		// JPanelパネルの設定

		JPanel pnlComment = new JPanel();
		pnlComment.setLayout(new GridLayout(0, 1));
		pnlComment.add(comment);

		JPanel pnlLabel = new JPanel();
		pnlLabel.setLayout(new GridLayout(0, 1));
		pnlLabel.add(lblUser);
		pnlLabel.add(lblPass);
		pnlLabel.add(lblHost);
		pnlLabel.add(lblPort);
		pnlLabel.add(lblSid);
		pnlLabel.add(lblShm);

		JPanel pnlField = new JPanel();
		pnlField.setLayout(new GridLayout(0, 1));
		pnlField.add(txfUser);
		pnlField.add(pwfPass);
		pnlField.add(txfHost);
		pnlField.add(txfPort);
		pnlField.add(txfSid);
		pnlField.add(txfShm);

		JPanel connPanel = new JPanel();
		connPanel.setLayout(new BoxLayout(connPanel, BoxLayout.X_AXIS));

		Border textBorder = new TitledBorder(null,"PostgreSQL Database",
						      TitledBorder.LEFT, TitledBorder.TOP,
							  new Font("Dialog", Font.BOLD, 12));

		Border emptyBorder = new EmptyBorder(5,5,5,5);
		Border compoundBorder = new CompoundBorder(textBorder, emptyBorder);
		connPanel.setBorder(compoundBorder);
		connPanel.add(pnlLabel);
		connPanel.add(pnlField);

		this.add(pnlComment);
		this.add(connPanel);

	} // コンストラクタ（終）

	// 選択項目
	public Hashtable getValue() {
		Hashtable val = new Hashtable();
		String str;
		str = txfUser.getText();
		val.put("USER", str);
		str = (new String( pwfPass.getPassword() )).trim();
		val.put("PASS", str);
		str = txfHost.getText();
		val.put("HOST", str);
		str = txfPort.getText();
		val.put("PORT", str);
		str = txfSid.getText();
		val.put("SID", str);
		str = txfShm.getText();
		val.put("SCHM", str);
		return val;	
	}

	public int checkValue() {
		int iRetValue = 0;
		String val = "";
		// USER
		val = txfUser.getText();
		if (val.equals("")) { iRetValue += 1; }
		// PASSWORD
		val = (new String( pwfPass.getPassword() )).trim();
		if (val.equals("")) { iRetValue += 2; }
		// HOST
		val = txfHost.getText();
		if (val.equals("")) { iRetValue += 4; }
		// PORT
		val = txfPort.getText();
		if (val.equals("")) { iRetValue += 8; }
		// SID
		val = txfSid.getText();
		if (val.equals("")) { iRetValue += 16; }
		// Schema
		val = txfShm.getText();
		if (val.equals("")) { iRetValue += 32; }
		return iRetValue;
	}

}
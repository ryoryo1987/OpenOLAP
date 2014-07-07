import java.util.*;
import java.awt.*;

import javax.swing.*;
import javax.swing.border.*;	// �{�[�_

public class C4Panel extends JPanel  implements GetPanelValue {

	int val;	//����

	JLabel comment;	//�����p

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

	JLabel footer;	//���b�Z�[�W�p

	//���s�R�[�h
	String newline = "\n";

	//�R���X�g���N�^
	public C4Panel() {

		// �X�y�[�X���߂邪�`��͂��Ȃ��A��̓��߃{�[�_
		setBorder(new EmptyBorder(5,5,5,5));
		// �S�̂̃��C�A�E�g�}�l�[�W�����{�b�N�X���C�A�E�g(Y_AXIS)�ɐݒ�
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		//���g�p
		comment = new JLabel("These are the setting value which you inputted.");
		footer = new JLabel("��L���Ń��^���쐬���܂��B��낵����΁A���ւ������Ă��������B");

		// ----------------------------------------------------------------------------------------
		// �e�L�X�g���͗��쐬
		// �����͊m�F���̓e�L�X�g�G���A�ɕ\������B

		taSetting = new JTextArea(5, 20);
		taSetting.setMargin(new Insets(5,5,5,5));
		taSetting.setEditable(false);
		taSetting.setBackground(Color.lightGray);

		// ----------------------------------------------------------------------------------------
		// JPanel�p�l���̐ݒ�

		JPanel pnlFooter = new JPanel();
		pnlFooter.setLayout(new GridLayout(0, 1));
		pnlFooter.add(footer);


		JPanel connPanel = new JPanel();
		connPanel.setLayout(new BoxLayout(connPanel, BoxLayout.Y_AXIS));

		Border textBorder = new TitledBorder(null,"�m�F",
						      TitledBorder.LEFT, TitledBorder.TOP,
							  new Font("Dialog", Font.BOLD, 12));

		Border emptyBorder = new EmptyBorder(5,5,5,5);
		Border compoundBorder = new CompoundBorder(textBorder, emptyBorder);
		connPanel.setBorder(compoundBorder);
		connPanel.add(new JScrollPane(taSetting), BorderLayout.CENTER);

		this.add(connPanel);
		this.add(pnlFooter);

	} // �R���X�g���N�^�i�I�j

	// �I������
	public Hashtable getValue() {
		Hashtable val = new Hashtable();
		return val;	
	}

	// �I������
	public void setValue(Hashtable C3Hash) {
		Hashtable val = (Hashtable)C3Hash;
		String strPassDummy = "";
		strUSER = (String)val.get("USER");		//User
		strPASS = (String)val.get("PASS");		//Password
		strHOST = (String)val.get("HOST");		//Hostname
		strPORT = (String)val.get("PORT");		//Port
		strSID  = (String)val.get("SID");		//SID
		strShm  = (String)val.get("SCHM");		//Schema

		//���e�̏�����
		taSetting.setText("");
		taSetting.append("���[�U�[��     : " + strUSER + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());
		for (int iCount = 0; iCount < strPASS.length(); iCount++) {
			strPassDummy = strPassDummy + "*";
		}
		taSetting.append("�p�X���[�h     : " + strPassDummy + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());
		taSetting.append("�z�X�g��       : " + strHOST + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());
		taSetting.append("�|�[�g�ԍ�     : " + strPORT + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());
		taSetting.append("�f�[�^�x�[�X�� : " + strSID  + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());
		taSetting.append("�X�L�[�}��     : " + strShm  + newline);
		taSetting.setCaretPosition(taSetting.getDocument().getLength());

	}
}

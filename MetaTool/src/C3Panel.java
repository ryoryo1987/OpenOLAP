import java.util.*;
import java.awt.*;

import javax.swing.*;
import javax.swing.border.*;	// �{�[�_

public class C3Panel extends JPanel implements GetPanelValue {

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

	//Schema
	JLabel				lblShm;		//Schema
	JTextField			txfShm;

	// �R���X�g���N�^
	public C3Panel(){
		// �X�y�[�X���߂邪�`��͂��Ȃ��A��̓��߃{�[�_
		setBorder(new EmptyBorder(5,5,5,5));
		// �S�̂̃��C�A�E�g�}�l�[�W�����{�b�N�X���C�A�E�g(Y_AXIS)�ɐݒ�
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		comment = new JLabel("���^���쐬����PostgreSQL�f�[�^�x�[�X�̏�����͂��Ă��������B");

		// ----------------------------------------------------------------------------------------
		// �e�L�X�g���͗��쐬

		lblUser = new JLabel("���[�U�[��: ", JLabel.RIGHT);
		txfUser = new JTextField("");

		lblPass = new JLabel("�p�X���[�h: ", JLabel.RIGHT);
		pwfPass = new JPasswordField("");

		lblHost = new JLabel("�z�X�g��: ", JLabel.RIGHT);
		txfHost = new JTextField("");

		lblPort = new JLabel("�|�[�g: ", JLabel.RIGHT);
		txfPort = new JTextField("5432");

		lblSid = new JLabel("�f�[�^�x�[�X��: ", JLabel.RIGHT);
		txfSid = new JTextField("");

		lblShm = new JLabel("�X�L�[�}��: ", JLabel.RIGHT);
		txfShm = new JTextField("public");

		// ----------------------------------------------------------------------------------------
		// JPanel�p�l���̐ݒ�

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

	} // �R���X�g���N�^�i�I�j

	// �I������
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
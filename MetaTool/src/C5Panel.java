import java.util.*;
import java.awt.event.*;
import java.awt.*;
import java.io.*;

import javax.swing.*;
import javax.swing.border.*;	// �{�[�_

public class C5Panel extends JPanel  implements GetPanelValue {
	public final static int ONE_SECOND = 1000;

	private JLabel comment; // �����p
	private JProgressBar progressBar;
	private javax.swing.Timer timer;
	private JTextArea taskOutput;
	private String newline = "\n";
	private String strWorkMessage = "";

	MTCreateTask mtCreateTask = null;

	JButton btnExit = null;
	JButton btnBack = null;
	JButton btnNext = null;

	// �R���X�g���N�^
	public C5Panel(MTCreateTask mtct) {
		mtCreateTask = mtct;
		// �X�y�[�X���߂邪�`��͂��Ȃ��A��̓��߃{�[�_
		setBorder(new EmptyBorder(5,5,5,5));
		// �w�i�F�̕ύX�i���ɕύX���Ȃ��j
//		setBackground(Color.blue);
		// �S�̂̃��C�A�E�g�}�l�[�W�����{�b�N�X���C�A�E�g(Y_AXIS)�ɐݒ�
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		// ----------------------------------------------------------------------------------------
		// �R�����g�쐬
		comment = new JLabel("�o��");

		// ----------------------------------------------------------------------------------------
		// �v���O���X�o�[�쐬
		progressBar = new JProgressBar(0, mtCreateTask.getLengthOfTask());
		progressBar.setValue(0);
		progressBar.setStringPainted(true);

		// ----------------------------------------------------------------------------------------
		// �o�͕\���p�e�L�X�g�G���A�쐬
		taskOutput = new JTextArea(5, 20);
		taskOutput.setMargin(new Insets(5,5,5,5));
		taskOutput.setEditable(false);

		this.add(comment);
		this.add(progressBar);
		this.add(new JScrollPane(taskOutput), BorderLayout.CENTER);

		//Create a timer.
		timer = new javax.swing.Timer(ONE_SECOND, new ActionListener() {
			public void actionPerformed(ActionEvent evt) {
				progressBar.setValue(mtCreateTask.getCurrent());
				//�����y�C���g
				progressBar.paintImmediately(progressBar.getVisibleRect());
				//�\�����b�Z�[�W�̐���i���b�Z�[�W���ω�������e�L�X�g�G���A�ɒǉ��\������j
				if (!strWorkMessage.equals(mtCreateTask.getMessage())) {
					strWorkMessage = mtCreateTask.getMessage();
					taskOutput.append(strWorkMessage + newline);
				}
				taskOutput.setCaretPosition(
						taskOutput.getDocument().getLength());
				if (mtCreateTask.done()) {
					Toolkit.getDefaultToolkit().beep();
					timer.stop();
					//�����\��

					File file = new File("metaTool.log");

					if(file.exists()){
						taskOutput.append("�G���[���������܂����B" + newline + "�ڍׂ́umetaTool.log�v���Q�Ƃ��Ă��������B" + newline);
					}else{
						taskOutput.append("�S�Ă̏������I�����܂����B" + newline);
					}

					btnNext.setEnabled(true);
				} else if (mtCreateTask.getIntStatus() != 0) {
					Toolkit.getDefaultToolkit().beep();
					timer.stop();
					if (mtCreateTask.getIntStatus() == 1000) { /**** See method MTActualTask#execute() in MTCreateTask.java ****/
						// ���^�Ǘ��e�[�u���`�F�b�N
						MTDialogBox.showWarningDialog("MetaTool", mtCreateTask.getStringStatus());
					} else {
						//�G���[
						MTDialogBox.showDBErrorDialog("MetaTool", mtCreateTask.getStringStatus(), mtCreateTask.getIntStatus());
					}
					btnExit.setEnabled(true);
					btnBack.setEnabled(true);
				}
			}
		});

//		this.initialize();
	}// �R���X�g���N�^�i�I�j

	// �I������
	public Hashtable getValue() {
		Hashtable val = new Hashtable();
		return val;
	}

	public void leaveExitButton(JButton btn) {
		btnExit = btn;
	}
	public void leaveBackButton(JButton btn) {
		btnBack = btn;
	}
	public void leaveNextButton(JButton btn) {
		btnNext = btn;
	}
	public void clearTextArea() {
		taskOutput.setText("");
	}

	public void start() {
		//�����\��
		strWorkMessage = mtCreateTask.getMessage();
		taskOutput.append(strWorkMessage + newline);
		//�^�C�}�[�X�^�[�g
		timer.start();
	}

}

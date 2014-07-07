import java.util.*;
import java.net.URL;

import java.awt.event.*;
import java.awt.*;

import javax.swing.*;
import javax.swing.border.*;	// �{�[�_

public class MTMainPanel extends JPanel implements GetPanelValue {

	static int EndCount = 4;	// �S���łS�X�e�b�v
	int current = 0;

	JButton btnExit = null;		//Cancel,Exit(���f�E�I��)�{�^��
	JButton btnBack = null;		//Back(�߂�)�{�^��
	JButton btnNext = null;		//Next(����)�{�^��

	JPanel pnlWizard;

	C2Panel c2 = null;
	C3Panel c3 = null;
	C4Panel c4 = null;
	C5Panel c5 = null;

	MTCreateTask mtCreateTask;

	EndPanel endPanel = null;

	//�R���X�g���N�^
	public MTMainPanel(){

		// �X�y�[�X���߂邪�`��͂��Ȃ��A��̓��߃{�[�_
		setBorder(new EmptyBorder(5,5,5,5));
		// �w�i�F�̕ύX�i���ɕύX���Ȃ��j
//		setBackground(Color.blue);
		// �S�̂̃��C�A�E�g�}�l�[�W�����{�b�N�X���C�A�E�g(Y_AXIS)�ɐݒ�
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		// ----------------------------------------------------------------------------------------
		// �p�[�c�쐬

		// �^�C�g���r���[�i���C���^�C�g���^�T�u�^�C�g���j
		JLabel lblTitleMain = new JLabel("MetaTool for OpenOLAP! ");
		JLabel lblTitleSub  = new JLabel("  ");
		lblTitleMain.setFont(new Font("Serif", Font.BOLD|Font.HANGING_BASELINE, 20));
		lblTitleSub.setFont(new Font("Serif", Font.PLAIN|Font.TRUETYPE_FONT, 11));
		// �C���[�W�r���[
		URL url = ClassLoader.getSystemResource("images/olap_image02.jpg");
		Icon icon = new ImageIcon(url);
		JLabel lblImage = new JLabel(icon);
		// �E�B�U�[�h�r���[
		// ���f�E�I���r���[�i���f�E�I���j
		btnExit = new JButton("�L�����Z��");
		// �R���g���[���r���[�i�߂�^���ցj
		btnBack = new JButton("< �߂�");
		btnNext = new JButton("���� >");
		btnNext.setSelected(true);
		//
		ButtonListener btnListener = new ButtonListener();
		btnExit.setActionCommand("Cancel");
		btnExit.addActionListener(btnListener);
		btnBack.setActionCommand("Back");
		btnBack.addActionListener(btnListener);
		btnBack.setEnabled(false);
		btnNext.setActionCommand("Next");
		btnNext.addActionListener(btnListener);

		// ----------------------------------------------------------------------------------------
		// JPanel�p�l���̐ݒ�

		//���ʕ��i�i�{�[�_�j
		Border emptyBorder = new EmptyBorder(5,5,5,5);

		// �^�C�g���r���[�i���C���^�C�g���^�T�u�^�C�g���j
		JPanel pnlTitle = new JPanel();
		JPanel pnlTitleMain = new JPanel();
		JPanel pnlTitleSub = new JPanel();
		pnlTitleMain.setLayout(new BoxLayout(pnlTitleMain, BoxLayout.X_AXIS));
		pnlTitleMain.setBorder(emptyBorder);
		pnlTitleMain.add(lblTitleMain);
		pnlTitleMain.add(Box.createHorizontalGlue());
		pnlTitleSub.setLayout(new BoxLayout(pnlTitleSub, BoxLayout.X_AXIS));
		pnlTitleSub.setBorder(emptyBorder);
		pnlTitleSub.add(Box.createHorizontalGlue());
		pnlTitleSub.add(lblTitleSub);
		pnlTitle.setLayout(new BoxLayout(pnlTitle, BoxLayout.Y_AXIS));
		pnlTitle.setBorder(emptyBorder);
		pnlTitle.add(pnlTitleMain);
		pnlTitle.add(pnlTitleSub);
		// �C���[�W�r���[
		JPanel pnlImage = new JPanel();
		pnlImage.add(lblImage);
		// �E�B�U�[�h�r���[
		pnlWizard = new JPanel();
		pnlWizard.setLayout(new CardLayout());
		pnlWizard.setBorder(emptyBorder);
		//
		c2 = new C2Panel();
		c3 = new C3Panel();
		c4 = new C4Panel();
		mtCreateTask = new MTCreateTask(c3.getValue());
		c5 = new C5Panel(mtCreateTask);
		endPanel = new EndPanel();

		//Start & select
		pnlWizard.add("C2Panel", c2); // (0)
		//Create steps
		pnlWizard.add("C3Panel", c3); // (1 - create)
		pnlWizard.add("C4Panel", c4); // (2 - create)
		pnlWizard.add("C5Panel", c5); // (3 - create)
		//End
		pnlWizard.add("EndPanel", endPanel); // (4 - common)

		// �C���[�W�{�E�B�U�[�h
		JPanel pnlContents = new JPanel();

		//
		GridBagLayout gb = new GridBagLayout();
		pnlContents.setLayout(gb);
		//
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.fill = GridBagConstraints.BOTH;
		gbc.insets = new Insets(5, 5, 5, 5);
		//
		gbc.gridx = 0; gbc.gridy = 0;
		gbc.gridwidth = 1; gbc.gridheight = 1;
		gbc.weightx = 0.1; gbc.weighty = 1.0;
		gb.setConstraints(pnlImage, gbc);
		pnlContents.add(pnlImage);
		//
		gbc.gridx = 1; gbc.gridy = 0;
		gbc.gridwidth = 4; gbc.gridheight = 1;
		gbc.weightx = 1.0; gbc.weighty = 1.0;
		gb.setConstraints(pnlWizard, gbc);
		pnlContents.add(pnlWizard);

		// ���f�E�I���r���[�i���f�E�I���j
		JPanel pnlControl = new JPanel();
		//
		pnlControl.setLayout(new BoxLayout(pnlControl, BoxLayout.X_AXIS));
		//
		pnlControl.add(Box.createHorizontalGlue());
		pnlControl.add(Box.createHorizontalGlue());
		pnlControl.add(btnExit);
		pnlControl.add(Box.createHorizontalGlue());
		pnlControl.add(btnBack);
		pnlControl.add(btnNext);
		pnlControl.add(Box.createHorizontalGlue());

		this.add(pnlTitle);
		this.add(pnlContents);
		this.add(pnlControl);

	}// �R���X�g���N�^�i�I�j

	//�I������
	public Hashtable getValue() {
		Hashtable val = new Hashtable();
		return val;	
	}

	class ButtonListener implements ActionListener {
		public void actionPerformed(ActionEvent ae) {
			Hashtable C2Hash = (Hashtable)c2.getValue();
			JButton tempButton = (JButton)ae.getSource();

			if (tempButton.getActionCommand().equals("Cancel")) {
				if (tempButton.getText().equals("Cancel")) {
					//�L�����Z���{�^���� "Cancel"   �̂Ƃ��͖₢���킹�u�A���v
					if (MTDialogBox.showYesNoInformationDialog("MetaTool", "Do you really want to exit?") == 0) {
						System.exit(0);
					}
				} else {
					//�L�����Z���{�^���� "Finish" �̂Ƃ��͖₢���킹�u�i�V�v
					System.exit(0);
				}
			}

			//�����^�C�v
			String strType = (String)C2Hash.get("TYPE");

//**********�u���ցv
			if (tempButton.getActionCommand().equals("Next")) {
				current += 1;
Dbg.out("(Next)+"+current+"/"+strType);

				//[CREATE]
				if (strType.equals("create")) {
					if (current == 1) {
						((CardLayout)pnlWizard.getLayout()).show(pnlWizard, "C3Panel");
						btnBack.setEnabled(true);
					} else if (current == 2) {
						//���͒l�`�F�b�N
						if (c3.checkValue() > 0) {
Dbg.out("c3.checkValue() :");
Dbg.out(c3.checkValue());
							MTDialogBox.showErrorDialog("MetaTool", "�ڑ���񂪖����͂ł��B���͂��Ă��������B");
							current -= 1;
						} else {
							//
							((CardLayout)pnlWizard.getLayout()).show(pnlWizard, "C4Panel");
							btnBack.setEnabled(true);
							c4.setValue(c3.getValue());
						}
					} else if (current == 3) {
						((CardLayout)pnlWizard.getLayout()).show(pnlWizard, "C5Panel");
						btnExit.setEnabled(false);
						btnBack.setEnabled(false);
						btnNext.setEnabled(false);
						//**********************
						c5.leaveExitButton(btnExit);
						c5.leaveBackButton(btnBack);
						c5.leaveNextButton(btnNext);
						c5.clearTextArea();
						// �R���X�g���N�g������l���ύX�����ꍇ�ɕK�v
Dbg.out("Set���܂�");
						mtCreateTask.setValue(c3.getValue());
						mtCreateTask.initStatus();
						mtCreateTask.go();
						c5.start();
						//**********************
//					} else {
//						((CardLayout)pnlWizard.getLayout()).next(pnlWizard);
					}
				} else {
					((CardLayout)pnlWizard.getLayout()).next(pnlWizard);
				}
				if (current == EndCount) {
					((CardLayout)pnlWizard.getLayout()).last(pnlWizard);
					endPanel.setValue(strType);
					btnBack.setEnabled(false);
					btnNext.setEnabled(false);
					btnExit.setEnabled(true);
					btnExit.setText("����");
				}
			}

//**********�u�߂�v
			if (tempButton.getActionCommand().equals("Back")) {
				current -= 1;
Dbg.out("(Back)-"+current+"/"+strType);

				//[CREATE]
				if (strType.equals("create")) {
					if (current == 0) {
						((CardLayout)pnlWizard.getLayout()).show(pnlWizard, "C2Panel");
						btnExit.setEnabled(true);
						btnNext.setEnabled(true);
					} else if (current == 1) {
						((CardLayout)pnlWizard.getLayout()).show(pnlWizard, "C3Panel");
						btnExit.setEnabled(true);
						btnBack.setEnabled(true);
						btnNext.setEnabled(true);
					} else if (current == 2) {
						((CardLayout)pnlWizard.getLayout()).show(pnlWizard, "C4Panel");
						btnExit.setEnabled(true);
						btnBack.setEnabled(true);
						btnNext.setEnabled(true);
					} else {
						btnBack.setEnabled(true);
						((CardLayout)pnlWizard.getLayout()).previous(pnlWizard);
					}

				//[BACKUP]
				} else if (strType.equals("backup")) {
					if (current == 0) {
						((CardLayout)pnlWizard.getLayout()).show(pnlWizard, "C2Panel");
					} else {
						btnBack.setEnabled(true);
						((CardLayout)pnlWizard.getLayout()).previous(pnlWizard);
					}

				//[ETC]
				} else {
					btnBack.setEnabled(true);
					((CardLayout)pnlWizard.getLayout()).previous(pnlWizard);
				}

				if (current == 0) {
					//�X�^�[�g��ʂŁu�߂�v�{�^����disable
					btnBack.setEnabled(false);
				}

			}
		}
	}

}

import java.util.*;
import java.net.URL;

import java.awt.event.*;
import java.awt.*;

import javax.swing.*;
import javax.swing.border.*;	// ボーダ

public class MTMainPanel extends JPanel implements GetPanelValue {

	static int EndCount = 4;	// 全部で４ステップ
	int current = 0;

	JButton btnExit = null;		//Cancel,Exit(中断・終了)ボタン
	JButton btnBack = null;		//Back(戻る)ボタン
	JButton btnNext = null;		//Next(次へ)ボタン

	JPanel pnlWizard;

	C2Panel c2 = null;
	C3Panel c3 = null;
	C4Panel c4 = null;
	C5Panel c5 = null;

	MTCreateTask mtCreateTask;

	EndPanel endPanel = null;

	//コンストラクタ
	public MTMainPanel(){

		// スペースを占めるが描画はしない、空の透過ボーダ
		setBorder(new EmptyBorder(5,5,5,5));
		// 背景色の変更（特に変更しない）
//		setBackground(Color.blue);
		// 全体のレイアウトマネージャをボックスレイアウト(Y_AXIS)に設定
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		// ----------------------------------------------------------------------------------------
		// パーツ作成

		// タイトルビュー（メインタイトル／サブタイトル）
		JLabel lblTitleMain = new JLabel("MetaTool for OpenOLAP! ");
		JLabel lblTitleSub  = new JLabel("  ");
		lblTitleMain.setFont(new Font("Serif", Font.BOLD|Font.HANGING_BASELINE, 20));
		lblTitleSub.setFont(new Font("Serif", Font.PLAIN|Font.TRUETYPE_FONT, 11));
		// イメージビュー
		URL url = ClassLoader.getSystemResource("images/olap_image02.jpg");
		Icon icon = new ImageIcon(url);
		JLabel lblImage = new JLabel(icon);
		// ウィザードビュー
		// 中断・終了ビュー（中断・終了）
		btnExit = new JButton("キャンセル");
		// コントロールビュー（戻る／次へ）
		btnBack = new JButton("< 戻る");
		btnNext = new JButton("次へ >");
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
		// JPanelパネルの設定

		//共通部品（ボーダ）
		Border emptyBorder = new EmptyBorder(5,5,5,5);

		// タイトルビュー（メインタイトル／サブタイトル）
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
		// イメージビュー
		JPanel pnlImage = new JPanel();
		pnlImage.add(lblImage);
		// ウィザードビュー
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

		// イメージ＋ウィザード
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

		// 中断・終了ビュー（中断・終了）
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

	}// コンストラクタ（終）

	//選択項目
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
					//キャンセルボタンが "Cancel"   のときは問い合わせ「アリ」
					if (MTDialogBox.showYesNoInformationDialog("MetaTool", "Do you really want to exit?") == 0) {
						System.exit(0);
					}
				} else {
					//キャンセルボタンが "Finish" のときは問い合わせ「ナシ」
					System.exit(0);
				}
			}

			//処理タイプ
			String strType = (String)C2Hash.get("TYPE");

//**********「次へ」
			if (tempButton.getActionCommand().equals("Next")) {
				current += 1;
Dbg.out("(Next)+"+current+"/"+strType);

				//[CREATE]
				if (strType.equals("create")) {
					if (current == 1) {
						((CardLayout)pnlWizard.getLayout()).show(pnlWizard, "C3Panel");
						btnBack.setEnabled(true);
					} else if (current == 2) {
						//入力値チェック
						if (c3.checkValue() > 0) {
Dbg.out("c3.checkValue() :");
Dbg.out(c3.checkValue());
							MTDialogBox.showErrorDialog("MetaTool", "接続情報が未入力です。入力してください。");
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
						// コンストラクト時から値が変更した場合に必要
Dbg.out("Setします");
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
					btnExit.setText("閉じる");
				}
			}

//**********「戻る」
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
					//スタート画面で「戻る」ボタンはdisable
					btnBack.setEnabled(false);
				}

			}
		}
	}

}

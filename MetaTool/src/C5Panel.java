import java.util.*;
import java.awt.event.*;
import java.awt.*;
import java.io.*;

import javax.swing.*;
import javax.swing.border.*;	// ボーダ

public class C5Panel extends JPanel  implements GetPanelValue {
	public final static int ONE_SECOND = 1000;

	private JLabel comment; // 説明用
	private JProgressBar progressBar;
	private javax.swing.Timer timer;
	private JTextArea taskOutput;
	private String newline = "\n";
	private String strWorkMessage = "";

	MTCreateTask mtCreateTask = null;

	JButton btnExit = null;
	JButton btnBack = null;
	JButton btnNext = null;

	// コンストラクタ
	public C5Panel(MTCreateTask mtct) {
		mtCreateTask = mtct;
		// スペースを占めるが描画はしない、空の透過ボーダ
		setBorder(new EmptyBorder(5,5,5,5));
		// 背景色の変更（特に変更しない）
//		setBackground(Color.blue);
		// 全体のレイアウトマネージャをボックスレイアウト(Y_AXIS)に設定
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		// ----------------------------------------------------------------------------------------
		// コメント作成
		comment = new JLabel("経過");

		// ----------------------------------------------------------------------------------------
		// プログレスバー作成
		progressBar = new JProgressBar(0, mtCreateTask.getLengthOfTask());
		progressBar.setValue(0);
		progressBar.setStringPainted(true);

		// ----------------------------------------------------------------------------------------
		// 出力表示用テキストエリア作成
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
				//強制ペイント
				progressBar.paintImmediately(progressBar.getVisibleRect());
				//表示メッセージの制御（メッセージが変化したらテキストエリアに追加表示する）
				if (!strWorkMessage.equals(mtCreateTask.getMessage())) {
					strWorkMessage = mtCreateTask.getMessage();
					taskOutput.append(strWorkMessage + newline);
				}
				taskOutput.setCaretPosition(
						taskOutput.getDocument().getLength());
				if (mtCreateTask.done()) {
					Toolkit.getDefaultToolkit().beep();
					timer.stop();
					//完了表示

					File file = new File("metaTool.log");

					if(file.exists()){
						taskOutput.append("エラーが発生しました。" + newline + "詳細は「metaTool.log」を参照してください。" + newline);
					}else{
						taskOutput.append("全ての処理が終了しました。" + newline);
					}

					btnNext.setEnabled(true);
				} else if (mtCreateTask.getIntStatus() != 0) {
					Toolkit.getDefaultToolkit().beep();
					timer.stop();
					if (mtCreateTask.getIntStatus() == 1000) { /**** See method MTActualTask#execute() in MTCreateTask.java ****/
						// メタ管理テーブルチェック
						MTDialogBox.showWarningDialog("MetaTool", mtCreateTask.getStringStatus());
					} else {
						//エラー
						MTDialogBox.showDBErrorDialog("MetaTool", mtCreateTask.getStringStatus(), mtCreateTask.getIntStatus());
					}
					btnExit.setEnabled(true);
					btnBack.setEnabled(true);
				}
			}
		});

//		this.initialize();
	}// コンストラクタ（終）

	// 選択項目
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
		//初期表示
		strWorkMessage = mtCreateTask.getMessage();
		taskOutput.append(strWorkMessage + newline);
		//タイマースタート
		timer.start();
	}

}

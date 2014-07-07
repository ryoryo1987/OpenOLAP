import java.util.*;
import java.awt.*;

import javax.swing.*;
import javax.swing.border.*;

public class C2Panel extends JPanel implements GetPanelValue {

	JLabel comment;	//説明用

	ButtonGroup group;
	JRadioButton aButton;
	JRadioButton bButton;
	JRadioButton cButton;

	// コンストラクタ
	public C2Panel() {
		// スペースを占めるが描画はしない、空の透過ボーダ
		setBorder(new EmptyBorder(5,5,5,5));
		// 背景色の変更（特に変更しない）
//		setBackground(Color.blue);
		// 全体のレイアウトマネージャをボックスレイアウト(Y_AXIS)に設定
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		// ----------------------------------------------------------------------------------------
		// コメント作成
//		comment = new JLabel("説明");
		comment = new JLabel("OpenOLAP のメタデータを作成します。次へを押してください。");

		// ----------------------------------------------------------------------------------------
		// ボタン作成
		group = new ButtonGroup();
		aButton = new JRadioButton("新規作成", true);
		group.add(aButton);

		// ----------------------------------------------------------------------------------------
		// JPanelパネルの設定
		JPanel radioPanel = new JPanel();
		radioPanel.setLayout(new BoxLayout(radioPanel, BoxLayout.Y_AXIS));
		Border radioBorder = new TitledBorder(null,"操作内容",
						       TitledBorder.LEFT, TitledBorder.TOP,
								new Font("Dialog", Font.BOLD, 12));
		Border emptyBorder = new EmptyBorder(5,5,5,5);
		Border compoundBorder = new CompoundBorder( radioBorder, emptyBorder);
		radioPanel.setBorder(compoundBorder);
		radioPanel.add(aButton);

		this.add(comment);
		this.add(radioPanel);
	}// コンストラクタ（終）

	// 選択項目
	public Hashtable getValue() {
		Hashtable val = new Hashtable();
		String str;
		if (aButton.isSelected() ) {
			str = "create";
		} else if (bButton.isSelected() ) {
			str = "backup";
		} else {
			str = "restore";
		}
		val.put("TYPE",str);
		return val;
	}
}

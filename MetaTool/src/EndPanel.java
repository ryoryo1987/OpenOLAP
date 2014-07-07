import java.util.*;
import java.io.*;

import javax.swing.*;
import javax.swing.border.*;	// ボーダ

public class EndPanel extends JPanel  implements GetPanelValue {

	JLabel comment; // 説明用

	// コンストラクタ
	public EndPanel() {
		// スペースを占めるが描画はしない、空の透過ボーダ
		setBorder(new EmptyBorder(5,5,5,5));
		// 背景色の変更（特に変更しない）
//		setBackground(Color.blue);
		// 全体のレイアウトマネージャをボックスレイアウト(Y_AXIS)に設定
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		// ----------------------------------------------------------------------------------------
		// コメント作成
//		comment = new JLabel("終了");
		comment = new JLabel("");

		this.add(comment);
	}// コンストラクタ（終）

	public void setValue(String strType) {
		if (strType.equals("create")) {
			File file = new File("metaTool.log");

			if(file.exists()){
				comment.setText("詳細は「metaTool.log」を参照してください。");
			}else{
				comment.setText("メタデータは正常に作成されました。");
			}

		} else if (strType.equals("backup")) {
			comment.setText("Metadata has been dumped successfully.");
		} else if (strType.equals("restore")) {
			comment.setText("Metadata has been restored successfully.");
		} else {
Dbg.out("Not support value was inputed.");
		}
	}

	// 選択項目
	public Hashtable getValue() {
		Hashtable val = new Hashtable();
		return val;
	}

}

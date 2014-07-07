import java.util.*;
import java.io.*;

import javax.swing.*;
import javax.swing.border.*;	// �{�[�_

public class EndPanel extends JPanel  implements GetPanelValue {

	JLabel comment; // �����p

	// �R���X�g���N�^
	public EndPanel() {
		// �X�y�[�X���߂邪�`��͂��Ȃ��A��̓��߃{�[�_
		setBorder(new EmptyBorder(5,5,5,5));
		// �w�i�F�̕ύX�i���ɕύX���Ȃ��j
//		setBackground(Color.blue);
		// �S�̂̃��C�A�E�g�}�l�[�W�����{�b�N�X���C�A�E�g(Y_AXIS)�ɐݒ�
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		// ----------------------------------------------------------------------------------------
		// �R�����g�쐬
//		comment = new JLabel("�I��");
		comment = new JLabel("");

		this.add(comment);
	}// �R���X�g���N�^�i�I�j

	public void setValue(String strType) {
		if (strType.equals("create")) {
			File file = new File("metaTool.log");

			if(file.exists()){
				comment.setText("�ڍׂ́umetaTool.log�v���Q�Ƃ��Ă��������B");
			}else{
				comment.setText("���^�f�[�^�͐���ɍ쐬����܂����B");
			}

		} else if (strType.equals("backup")) {
			comment.setText("Metadata has been dumped successfully.");
		} else if (strType.equals("restore")) {
			comment.setText("Metadata has been restored successfully.");
		} else {
Dbg.out("Not support value was inputed.");
		}
	}

	// �I������
	public Hashtable getValue() {
		Hashtable val = new Hashtable();
		return val;
	}

}

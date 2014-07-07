import java.util.*;
import java.awt.*;

import javax.swing.*;
import javax.swing.border.*;

public class C2Panel extends JPanel implements GetPanelValue {

	JLabel comment;	//�����p

	ButtonGroup group;
	JRadioButton aButton;
	JRadioButton bButton;
	JRadioButton cButton;

	// �R���X�g���N�^
	public C2Panel() {
		// �X�y�[�X���߂邪�`��͂��Ȃ��A��̓��߃{�[�_
		setBorder(new EmptyBorder(5,5,5,5));
		// �w�i�F�̕ύX�i���ɕύX���Ȃ��j
//		setBackground(Color.blue);
		// �S�̂̃��C�A�E�g�}�l�[�W�����{�b�N�X���C�A�E�g(Y_AXIS)�ɐݒ�
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		// ----------------------------------------------------------------------------------------
		// �R�����g�쐬
//		comment = new JLabel("����");
		comment = new JLabel("OpenOLAP �̃��^�f�[�^���쐬���܂��B���ւ������Ă��������B");

		// ----------------------------------------------------------------------------------------
		// �{�^���쐬
		group = new ButtonGroup();
		aButton = new JRadioButton("�V�K�쐬", true);
		group.add(aButton);

		// ----------------------------------------------------------------------------------------
		// JPanel�p�l���̐ݒ�
		JPanel radioPanel = new JPanel();
		radioPanel.setLayout(new BoxLayout(radioPanel, BoxLayout.Y_AXIS));
		Border radioBorder = new TitledBorder(null,"������e",
						       TitledBorder.LEFT, TitledBorder.TOP,
								new Font("Dialog", Font.BOLD, 12));
		Border emptyBorder = new EmptyBorder(5,5,5,5);
		Border compoundBorder = new CompoundBorder( radioBorder, emptyBorder);
		radioPanel.setBorder(compoundBorder);
		radioPanel.add(aButton);

		this.add(comment);
		this.add(radioPanel);
	}// �R���X�g���N�^�i�I�j

	// �I������
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

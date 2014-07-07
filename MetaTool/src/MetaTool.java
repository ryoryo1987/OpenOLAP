import java.net.URL;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class MetaTool extends JFrame implements LayoutManager {
	Dimension origin = new Dimension(0, 0);
	static String strVersion = "v2.0.0";
	static String strJavaVersion = "1.4.0";

	public MetaTool(String name) {
		// Create a Frame and put the main panel in it.
		super(name);
		addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
		});
		setBackground(Color.lightGray);
		pack();
		setVisible(false);

		//��ʃT�C�Y���Œ肷��
		setBounds(0, 0, 620, 400);
		// �A�C�R���C���[�W�i�ŏ������j
		URL url = ClassLoader.getSystemResource("images/bistroObjects1.gif");
		setIconImage((new ImageIcon(url)).getImage());

		//�R���e���g�y�C���̎擾
		Container containerMTMain = getContentPane();
		MTMainPanel pnlMTMain = new MTMainPanel();
		containerMTMain.add(pnlMTMain);

		// �t���[���Œ�i�~�F�ő剻�A���T�C�Y�G���F�ŏ����j
		setResizable(false);

		//��ʂ̒����ɔz�u
		Dimension DispSize = Toolkit.getDefaultToolkit().getScreenSize();
		int MainFrame_Left = (DispSize.width - getSize().width) / 2;
		int MainFrame_Top  = (DispSize.height - getSize().height - getInsets().top) / 2;
		setLocation(MainFrame_Left, MainFrame_Top);

		//�\��
		setVisible(true);
	}

	public static void main(String s[]) {
		// Define Look&Feel : Windows
		try {
			UIManager.setLookAndFeel("com.sun.java.swing.plaf.windows.WindowsLookAndFeel");
		} catch (UnsupportedLookAndFeelException e) {
		} catch (ClassNotFoundException e) {
		} catch (InstantiationException e) {
		} catch (IllegalAccessException e) {
		}
		// Check the Version : Java
		try {
			String vers = System.getProperty("java.version");
Dbg.out("JavaVM Version : " + vers);
			if (vers.compareTo(strJavaVersion) < 0) {
Dbg.out("!!! WARNING: Needs Java " + strJavaVersion + " or higher version !!!");
				//�_�C�A���O�{�b�N�X�̕\��
				MTDialogBox.showErrorDialog("MetaTool","Needs Java " + strJavaVersion + " or higher version.");
				System.exit(0);
			}
			new MetaTool("MetaTool for OpenOLAP! " + strVersion);
Dbg.out("MetaTool - New instance was created successfully.");
		} catch (Throwable t) {
			t.printStackTrace();
			System.exit(0);
		}
	}

	//Methods which "LayoutManager" needs
	public void addLayoutComponent(String s, Component c) {}
	public Dimension minimumLayoutSize(Container c) {return origin;}
	public Dimension preferredLayoutSize(Container c) {return origin;}
	public void removeLayoutComponent(Component c) {}
	public void layoutContainer(Container c) {
		Rectangle b = c.getBounds();
		int topHeight = 90;
		int inset = 4;
	}
}
import javax.swing.*;

public class MTDialogBox {
	public MTDialogBox() {
		// 何もしないコンストラクタ
	}

	/**
	 *  Message Dialog Boxes
	 */

	// Show Plain Dialog Box
	public static void showPlainDialog(String title, String message) {
			JTextArea messageArea = new JTextArea(message);
			messageArea.setEditable(false);
			messageArea.setBackground(UIManager.getColor("JOptionPane.background"));
			JOptionPane.showMessageDialog(null, messageArea, title, JOptionPane.PLAIN_MESSAGE);
	}
	// Show Information Dialog Box
	public static void showInformationDialog(String title, String message) {
			JTextArea messageArea = new JTextArea(message);
			messageArea.setEditable(false);
			messageArea.setBackground(UIManager.getColor("JOptionPane.background"));
			JOptionPane.showMessageDialog(null, messageArea, title, JOptionPane.INFORMATION_MESSAGE);
	}
	// Show Qustion Dialog Box
	public static void showQuestionDialog(String title, String message) {
			JTextArea messageArea = new JTextArea(message);
			messageArea.setEditable(false);
			messageArea.setBackground(UIManager.getColor("JOptionPane.background"));
			JOptionPane.showMessageDialog(null, messageArea, title, JOptionPane.QUESTION_MESSAGE);
	}
	// Show Warning Dialog Box
	public static void showWarningDialog(String title, String message) {
			JTextArea messageArea = new JTextArea(message);
			messageArea.setEditable(false);
			messageArea.setBackground(UIManager.getColor("JOptionPane.background"));
			JOptionPane.showMessageDialog(null, messageArea, title, JOptionPane.WARNING_MESSAGE);
	}
	// Show Error Dialog Box
	public static void showErrorDialog(String title, String message) {
			JTextArea messageArea = new JTextArea(message);
			messageArea.setEditable(false);
			messageArea.setBackground(UIManager.getColor("JOptionPane.background"));
			JOptionPane.showMessageDialog(null, messageArea, title, JOptionPane.ERROR_MESSAGE);
	}
	// Show (Yes/No) Information Dialog Box
	public static int showYesNoInformationDialog(String title, String message) {
			// Yes->return 0;
			//  No->return 1;
			JTextArea messageArea = new JTextArea(message);
			messageArea.setEditable(false);
			messageArea.setBackground(UIManager.getColor("JOptionPane.background"));
			return JOptionPane.showConfirmDialog(null, messageArea, title, JOptionPane.YES_NO_OPTION);
	}
	// Show (Yes/No) Warning Dialog Box
	public static int showYesNoWarningDialog(String title, String message) {
			// Yes->return 0;
			//  No->return 1;
			JTextArea messageArea = new JTextArea(message);
			messageArea.setEditable(false);
			messageArea.setBackground(UIManager.getColor("JOptionPane.background"));
			return JOptionPane.showConfirmDialog(null, messageArea, title, JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);
	}
	// Show "Database" Error Dialog Box
	public static void showDBErrorDialog(String title, String message, int iDBStatus) {
			String strStatus = "Meta Tool - エラー番号 : ";
			strStatus = strStatus + (new Integer(iDBStatus)).toString();
			strStatus = strStatus + "\n";
			strStatus = strStatus + message;

//			JTextArea messageArea = new JTextArea(message);
			JTextArea messageArea = new JTextArea(strStatus);
			messageArea.setEditable(false);
			messageArea.setBackground(UIManager.getColor("JOptionPane.background"));
			JOptionPane.showMessageDialog(null, messageArea, title, JOptionPane.ERROR_MESSAGE);
	}
}

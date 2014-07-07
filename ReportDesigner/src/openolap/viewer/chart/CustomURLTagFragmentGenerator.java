package openolap.viewer.chart;
import org.jfree.chart.imagemap.*;

/**
 * @author Administrator
 */
public class CustomURLTagFragmentGenerator implements URLTagFragmentGenerator {


	// ********** ƒƒ\ƒbƒh **********

	/**
	 * URL•¶š—ñ‚ğ‚à‚Æ‚Éæ“¾‚·‚é
	 * @param urlText URL‚ğ‚ ‚ç‚í‚·•¶š—ñ
	 */
    public String generateURLFragment(String urlText) {

		return " onClick=\"alert('" + urlText + "');\" ";
    }

}

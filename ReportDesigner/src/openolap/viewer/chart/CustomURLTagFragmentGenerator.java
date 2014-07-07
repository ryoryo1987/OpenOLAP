package openolap.viewer.chart;
import org.jfree.chart.imagemap.*;

/**
 * @author Administrator
 */
public class CustomURLTagFragmentGenerator implements URLTagFragmentGenerator {


	// ********** メソッド **********

	/**
	 * URL文字列をもとに取得する
	 * @param urlText URLをあらわす文字列
	 */
    public String generateURLFragment(String urlText) {

		return " onClick=\"alert('" + urlText + "');\" ";
    }

}

package openolap.viewer.chart;
import org.jfree.chart.imagemap.*;

/**
 * @author Administrator
 */
public class CustomURLTagFragmentGenerator implements URLTagFragmentGenerator {


	// ********** ���\�b�h **********

	/**
	 * URL����������ƂɎ擾����
	 * @param urlText URL������킷������
	 */
    public String generateURLFragment(String urlText) {

		return " onClick=\"alert('" + urlText + "');\" ";
    }

}

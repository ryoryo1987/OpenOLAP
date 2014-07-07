/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：MeasureMemberType.java
 *  説明：メジャーメンバーをあらわすクラスです。
 *
 *  作成日: 2004/01/07
 */
package openolap.viewer;

import java.io.Serializable;

/**
 *  クラス：MeasureMemberType<br>
 *  説明：メジャーメンバーをあらわすクラスです。
 */
public class MeasureMemberType implements Serializable {

	final private String id;
	final private String name;
	final private String discription;
	final private String groupName;
	final private String imageURL;
	final private String xmlSpreadsheetFormat;
	final private String function_name;
	final private String unitFunctionID;

	// コンストラクタ
	public MeasureMemberType(String id, String name, String discription, String groupName, String imageURL, String xmlSpreadsheetFormat, String function_name, String unitFunctionID) {
		this.id = id;
		this.name = name;
		this.discription = discription;
		this.groupName = groupName;
		this.imageURL = imageURL;
		this.xmlSpreadsheetFormat = xmlSpreadsheetFormat;
		this.function_name = function_name;
		this.unitFunctionID = unitFunctionID;
	}

	// ********** Getter メソッド **********
	public String getId() {
		return id;
	}
	public String getName() {
		return name;
	}
	public String getDiscription() {
		return discription;
	}
	public String getGroupName() {
		return groupName;
	}
	public String getImageURL() {
		return imageURL;
	}
	public String getXMLSpreadsheetFormat() {
		return xmlSpreadsheetFormat;
	}
	public String getFunction_name() {
		return function_name;
	}
	public String getUnitFunctionID() {
		return unitFunctionID;
	}


}

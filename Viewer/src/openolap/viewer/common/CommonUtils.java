/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.common
 *  �t�@�C���FCommonUtils.java
 *  �����F���[�e�B���e�B�N���X�ł��B
 *
 *  �쐬��: 2004/01/14
 */
package openolap.viewer.common;

import java.util.ArrayList;
import java.util.Enumeration;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

import openolap.viewer.Report;
import openolap.viewer.User;
import openolap.viewer.controller.RequestHelper;

import org.apache.log4j.Logger;

/**
 *  �N���X�FCommonUtils<br>
 *  �����F���[�e�B���e�B�N���X�ł��B
 */
public class CommonUtils {

	// ********** ���\�b�h **********

	/**
	 * �^����ꂽboolean��true�ł����"1"�Afalse�ł����"0"��߂��B
	 * @param b boolean
	 * @return "1"(true) ���邢�� "0"(false)
	 */
	public static String boolToFLG(boolean b){
		if (b){
			return "1";
		} else {
			return "0";
		}
	}

	/**
	 * �^����ꂽString��"1"�ł����true�A"0"�ł����false��߂��B
	 * @param sting String�I�u�W�F�N�g
	 * @return true("1") ���邢�� false("0")
	 */
	public static boolean FLGTobool(String string) {
		if ("1".equals(string)) {
			return true;
		} else {
			return false;
		}
	}


	/**
	 * �z���ArrayList�Ɋi�[����B
	 * @param objects �z��
	 * @return ArrayList�I�u�W�F�N�g
	 */
	public static ArrayList<Object> arrayToArrayList(Object[] objects) {
		if (objects == null) {
			throw new IllegalArgumentException();
		}

		ArrayList<Object> arrayList = new ArrayList<Object>();
		for (int i = 0; i < objects.length; i++ ){
			arrayList.add(objects[i]);
		}
		return arrayList;
	}

	/**
	 * Exception���AStackTrace��������擾����B
	 * @param Exception �z��
	 * @return �I�u�W�F�N�g
	 */
	public static String getStackTrace(Exception e) {
		
		StackTraceElement[] stElement = e.getStackTrace();
		StringBuffer stb = new StringBuffer();
		for (int i=0; i<stElement.length; i++ ) {
			stb.append("    at " + stElement[i].toString() + "\n");
		}

		return stb.toString();
	}

	/**
	 * Request���AKey��Value������킷��������擾����B
	 * @param request ���N�G�X�g�I�u�W�F�N�g
	 * @return StringBuffer�I�u�W�F�N�g
	 */
	public static StringBuffer getRequestParameters(ServletRequest request) {

		StringBuffer params = new StringBuffer(512);
		String sep = System.getProperty("line.separator");

		params.append("Request Parameter Lists start ====================== " + sep);

		Enumeration e = request.getParameterNames();
		while (e.hasMoreElements()) {
			String attrName  = (String) e.nextElement();
			String attrValue = request.getParameter(attrName);
			
			params.append(attrName + ": " + attrValue + sep);
		}

		params.append("Request Parameter Lists end   ====================== " + sep);

		return params;
	}

	/**
	 * Session�����擾����B
	 * @param request ���N�G�X�g�I�u�W�F�N�g
	 * @return StringBuffer�I�u�W�F�N�g
	 */
	public static StringBuffer getSessionParameters(HttpServletRequest request) {
		
		StringBuffer sessionInfo = new StringBuffer(512);
		String sep = System.getProperty("line.separator");
		
		sessionInfo.append("Session Information start ====================== " + sep);

		Enumeration e = request.getSession().getAttributeNames();
		while (e.hasMoreElements()) {
			String attrName  = (String) e.nextElement();
			String attrValue = request.getSession().getAttribute(attrName).toString();
			
			sessionInfo.append("<session attribue name>" + attrName + sep);
			sessionInfo.append(attrValue + sep);

		}

		sessionInfo.append("Session Information end   ====================== " + sep);
		
		return sessionInfo;
	}


	/**
	 * ���O�����o�͂���B
	 * @param RequestHelper ���N�G�X�g�w���p�[�I�u�W�F�N�g
	 * @param log ���M���O�I�u�W�F�N�g
	 * @param args1Key   ��v�ȃ��b�Z�[�W
	 * @param args1Value ��v�ȃ��b�Z�[�W�̒l
	 */
	public static void loggingMessage(RequestHelper helper, Logger log, String args1Key, String args1Value) {
		
		if(log.isInfoEnabled()) {	// ���O�o��
			User user = (User) helper.getRequest().getSession().getAttribute("user");
			Report report = (Report)helper.getRequest().getSession().getAttribute("report");

			String sep = System.getProperty("line.separator");

			log.info(args1Key + ": " + args1Value + sep +
					 "ReportID: " + report.getReportID() + sep +
					 "UserID: " + user.getUserID()
					 );

		}

	}

}

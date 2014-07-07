/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresRReportDAO.java
 *  �����F���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2005/01/07
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;

import org.apache.log4j.Logger;

import openolap.viewer.common.StringTool;
import openolap.viewer.common.StringTool2;
import openolap.viewer.controller.RequestHelper;

/**
 *  �N���X�FPostgresRReportDAO
 *  �����F���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresRReportDAO implements RReportDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	/** DAOFactory�I�u�W�F�N�g */
	DAOFactory daoFactory = DAOFactory.getDAOFactory();

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresRReportDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 * ���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresRReportDAO(Connection conn) {
		this.conn = conn;
	}

	/**
	 * R���|�[�g�I�u�W�F�N�gXML�𐶐�����B
	 * @return R���|�[�g�����p��XML���i�[����StringBuffer�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public StringBuffer getRReportXML(RequestHelper helper) throws SQLException {

		// �e���v���[�gXML�A���s����SQL��������擾
		String templateXMLString = null;	// �e���v���[�gXML
		String getDataSQL        = null;	// SQL������擾


		  // source �̒l�ɂ��A�e���v���[�gXML�ASQL�̎擾����ύX����

		  String source = helper.getRequest().getParameter("source"); // �e���v���[�gXML�ASQL�̎擾��
	
		  if ( "post".equals(source) ) { // �擾���F�|�X�g
			  templateXMLString = helper.getRequest().getParameter("templateXML");
			  getDataSQL = helper.getRequest().getParameter("getDataSQL");
		  } else if ( "session".equals(source) ) { // �擾���F�Z�b�V����
			  templateXMLString = (String) helper.getRequest().getSession().getAttribute("RsourceXML");
			  getDataSQL        = (String) helper.getRequest().getSession().getAttribute("Rsql");
		  } else if ( "db".equals(source) ) { // �擾���F�f�[�^�x�[�X

			  String sourceTable = "oo_v_report";// �e���v���[�gXML,SQL �̎擾���e�[�u����
			  String reportID    = helper.getRequest().getParameter("rId"); // sourceTable �̍i���ݏ����i���|�[�gID�j

			  ReportDAO reportDAO = daoFactory.getReportDAO(conn);
			  HashMap<String, String> hashMap = reportDAO.getTemplateInfo(sourceTable, reportID);

			  templateXMLString = hashMap.get("templateXMLString");
			  getDataSQL        = hashMap.get("getDataSQL");

		  } else {
			  throw new UnsupportedOperationException();
		  }
		

//System.out.println("==========================================================================================================");
//System.out.println("templateXMLString:" + templateXMLString);
//System.out.println("getDataSQL:" + getDataSQL);
//System.out.println("==========================================================================================================");

		  StringTool2 stTool2 = new StringTool2(templateXMLString);
	
		  // XML���u���Ώە��݂̂�؂�o��
		  String replaceString = stTool2.getInnerDataNodeString();
  //		String replaceString = "<row �N���XID='%%�N���XID%%' �N���X���V���[�g='%%�N���X���V���[�g%%'/>";
  //		String replaceString = "<row �N���XID--11--='%%�N���XID--11--%%' �N���X���V���[�g--2--='%%�N���X���V���[�g--2--%%' �t�@�~���[ID='%%�t�@�~���[ID%%' �t�@�~���[���V���[�g='%%�t�@�~���[���V���[�g%%' �v���_�N�gID='%%�v���_�N�gID%%' �v���_�N�g���V���[�g='%%�v���_�N�g���V���[�g%%'/>";
		  StringTool stTool = new StringTool(replaceString);
//System.out.println(replaceString);
	
		  // ����SQL���s
		  Statement stmt = conn.createStatement();
		  ResultSet rset = stmt.executeQuery (getDataSQL);
	
		  // �e���v���[�g�w�l�k�Ɏ擾���ʂ𖄂ߍ��񂾂w�l�k�𐶐����AJSP�ł̏o�͗p��request�I�u�W�F�N�g�֕ۑ��B
		  StringBuffer dataXMLText = new StringBuffer();
	
		  // �u�������ȑO���i�[
		  dataXMLText.append(stTool2.getBeforeDataNodeString());
		  dataXMLText.append(StringTool2.dataMarkStartStr);
	
		  // �u������(data�^�O��)���i�[
		  int cnt = stTool.getdivCount();
		  String[] divXMLStr = stTool.getXMLString();
		  String[] divSQLStr = stTool.getSQLString();
	
		  while (rset.next ()){
			  String resultXML="";
			  for(int i=0;i<cnt;i++){
				  resultXML+=divXMLStr[i]+rset.getString(divSQLStr[i]);
			  }
			  resultXML+=divXMLStr[cnt];
			  dataXMLText.append(resultXML);
		  }
//	  dataXMLText.append(stTool.dispStr());

		  // �u�������ȍ~���i�[
		  dataXMLText.append(StringTool2.dataMarkEndStr);
		  dataXMLText.append(stTool2.getAfterDataNodeString());
			
		return dataXMLText;
	}

}

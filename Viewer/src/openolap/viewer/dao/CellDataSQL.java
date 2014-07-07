/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FCellDataSQL.java
 *  �����F�Z���f�[�^�擾���Ɏg�p����SQL������킷�N���X�ł��B
 *
 *  �쐬��: 2004/02/01
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.StringTokenizer;

import openolap.viewer.Axis;
import openolap.viewer.Dimension;
import openolap.viewer.Edge;
import openolap.viewer.MeasureMember;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.common.StringUtil;

/**
 *  �N���X�FCellDataSQL<br>
 *  �����F�Z���f�[�^�擾���Ɏg�p����SQL������킷�N���X�ł��B
 */
public class CellDataSQL {

	// ********** �C���X�^���X�ϐ� **********

	/** Report�I�u�W�F�N�g */
	private Report report = null;

	/** ��G�b�W�ɔz�u���ꂽ���ɑΉ�����Fact�e�[�u���̃J�����A�擾�Ώۃ��W���[���X�g */
	private ArrayList<String> colFactKeyColumnList = new ArrayList<String>();

	/** �s�G�b�W�ɔz�u���ꂽ���ɑΉ�����Fact�e�[�u���̃J�����A�擾�Ώۃ��W���[���X�g */
	private ArrayList<String> rowFactKeyColumnList = new ArrayList<String>();

	/** �y�[�W�G�b�W�ɔz�u���ꂽ���ɑΉ�����Fact�e�[�u���̃J�����A�擾�Ώۃ��W���[���X�g */
	private ArrayList<String> pageFactKeyColumnList = new ArrayList<String>();


	/** Fact�e�[�u���� */
	private String factTableName = null;


	/** 
	 * ��ɔz�u���ꂽ����WHERE�߂�����킷�I�u�W�F�N�g�B
	 * ���̎�������킷Fact�e�[�u���̃L�[�J������Key�Ƃ��A�擾�ΏۂƂȂ郁���o�[�L�[���X�g��Value�Ɏ��B
	 */
	private LinkedHashMap<String, ArrayList<String>> colWhereClauseMap = new LinkedHashMap<String, ArrayList<String>>();

	/** 
	 * �s�ɔz�u���ꂽ����WHERE�߂�����킷�I�u�W�F�N�g�B
	 * ���̎�������킷Fact�e�[�u���̃L�[�J������Key�Ƃ��A�擾�ΏۂƂȂ郁���o�[�L�[���X�g��Value�Ɏ��B
	 */
	private LinkedHashMap<String, ArrayList<String>> rowWhereClauseMap = new LinkedHashMap<String, ArrayList<String>>();

	/** 
	 * �y�[�W�ɔz�u���ꂽ����WHERE�߂�����킷�I�u�W�F�N�g�B
	 * ���̎�������킷Fact�e�[�u���̃L�[�J������Key�Ƃ��A�擾�ΏۂƂȂ郁���o�[�L�[���X�g��Value�Ɏ��B
	 */
	private LinkedHashMap<String, ArrayList<String>> pageWhereClauseMap = new LinkedHashMap<String, ArrayList<String>>();

	/** ���W���[���y�[�W�G�b�W�ɂ���Ƃ��̃f�t�H���g�����o�[�L�[(UName) */
	private String measureDefaultMember = null;

	/** ���W���[���y�[�W�G�b�W�ɂ���Ƃ��̃f�t�H���g�����o�[�̃��W���[�V�[�P���X */
	private String measureDefaultSeq = null;

	// ********** static ���\�b�h **********

	/**
	 * CellDataSQL�I�u�W�F�N�g�𐶐�����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param conn Connecion�I�u�W�F�N�g
	 * @param items �e�G�b�W�̎�ID���X�g
	 * @param selectKeys �f�[�^�擾�ΏۂƂȂ��E�s�w�b�_��Key�������X�g
	 *		  selectKeys[0]�F��w�b�_��Key�������X�g������
	 *		  selectKeys[1]�F�s�w�b�_��Key�������X�g������
	 * @param formatValue �l�Ƀ��W���[�����o�[���ɐݒ肳�ꂽMeasureMemberType�̏�����K�p����Ȃ�true�A�P�ʂ݂̂����낦�鏑����K�p����Ȃ��false
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ������킷�I�u�W�F�N�g
	 * @return CellDataSQL�I�u�W�F�N�g
	 */
	public static CellDataSQL getSelectReportDataSQL(Report report, Connection conn, Object[] items, Object[] selectKeys, boolean formatValue, CommonSettings commonSettings) {

		CellDataSQL cellDataSQL = new CellDataSQL();

		int i;
		int j;
		int k;
		StringTokenizer st;

		// ���|�[�g�I�u�W�F�N�g���Z�b�g
		cellDataSQL.setReport(report);

		// �t�@�N�g�e�[�u������ݒ�
		cellDataSQL.setFactTableName(DAOFactory.getDAOFactory().getCubeDAO(null).getFactTableName(report.getCube().getCubeSeq()));

		
		String[] edgeAxisInfoList;		// ����G�b�W�̎������i�[����I�u�W�F�N�g
		String axisID;					// ��ID
		String tmpItemValuePair[];		// �e�[�u��ID��KEY���i�[����z��
										// �Y��0�F�e�[�u��ID�A�Y��1�FKEY

		String measureMemberKey = "";	// �擾�����ɐݒ肷�郁�W���[��Key
		String meaIndex = "";			// ���W���[��Index
		int selectedMeasureNum = 1;	// �f�[�^�擾�ΏۂƂȂ郁�W���[�̃����o�[��
	
		for ( i = 0; i < items.length; i++ ) {	// �G�b�W�̐��������s
			edgeAxisInfoList = (String[])items[i];
			for ( j = 0; j < edgeAxisInfoList.length; j++ ) {	//�G�b�W�ɔz�u���ꂽ���������s
				if ( i == 2 ) {	
				// �y�[�W�G�b�W�̏ꍇ
				// tmpHieItems�̔z��̊e�v�f�́A�e�[�u��ID��KEY����Ȃ�B
				// �����j<����ID>:<KEY> 
				// 	��F�����̏ꍇ�j     1:0
				// 	��F���W���[�̏ꍇ�j 16:<UNAME>(1�`50)
					st = new StringTokenizer(edgeAxisInfoList[j],":");
					tmpItemValuePair = new String[st.countTokens()];
					k = 0;
					while ( st.hasMoreTokens() ) {
						tmpItemValuePair[k] = st.nextToken();
						k++;
					}
					axisID      		= tmpItemValuePair[0];	// ��ID
					measureMemberKey 	= tmpItemValuePair[1];	// �������o�[KEY
					selectedMeasureNum 	= 1;
				} else {		// �s�E��G�b�W�̏ꍇ
					axisID = edgeAxisInfoList[j];
					selectedMeasureNum = report.getTotalMeasureMemberNumber();	// �L���[�u�̎��S���W���[��
				}
	
				if ( Constants.MeasureID.equals(axisID) ) {	// ���W���[
					String measureLists = "";	// ���W���[���X�g
					for ( k = 0; k < selectedMeasureNum; k++ ) {
						if ( i == 2 ) {
							meaIndex = measureMemberKey.substring(measureMemberKey.indexOf("_") + 1, measureMemberKey.length());
	
							if ( (meaIndex.length() == 2) && (meaIndex.substring(0,1).equals("0") ) ) {
								meaIndex = meaIndex.substring(1,2);
							}
	
							// (�y�[�W�ɔz�u���ꂽ�ꍇ)���W���[�̃f�t�H���g�����o�[(key)��o�^
							cellDataSQL.setMeasureDefaultMember(meaIndex);

							// (�y�[�W�ɔz�u���ꂽ�ꍇ)���W���[�̃f�t�H���g�����o�[(measureSeq)��o�^
							cellDataSQL.setMeasureDefaultSeq(( (MeasureMember) report.getMeasure().getAxisMemberByUniqueName(meaIndex)).getMeasureSeq());
	
						} else {
							meaIndex = Integer.toString(k+1);
						}
						MeasureMember measureMember = (MeasureMember) report.getMeasure().getAxisMemberByUniqueName(meaIndex);
						if ( measureMember.isSelected() ) {	// �Z���N�^�ł͂�����Ă��Ȃ��Ȃ��
							if ( measureLists != "" ) {
								measureLists += ",";
							}

							String measureString = null;
							if (formatValue) { // �l���t�H�[�}�b�g�t�Ŏ擾
								measureString = StringUtil.regReplaceAll("%measure%", "MEASURE[" + meaIndex + "]", measureMember.getMeasureMemberType().getFunction_name());
							} else { // �l��P�ʃt�H�[�}�b�g�݂̂Ŏ擾
								String unitFunctionID = measureMember.getMeasureMemberType().getUnitFunctionID();
								measureString = StringUtil.regReplaceAll("%measure%", "MEASURE[" + meaIndex + "]", commonSettings.getMeasureMemberTypeByID(unitFunctionID).getFunction_name());
							}
							measureLists += measureString + " as measure_" + meaIndex;

						}
					}

					// SELECT��
					cellDataSQL.addFactKeyColumnList(i, measureLists);

				} else {	// �f�B�����V����

					String factKeyColumn = "";

					// �Z���N�g��
					if ( Integer.valueOf(axisID).intValue() < 10 ) {
						factKeyColumn = "DIM_0" + axisID;
					} else {

						factKeyColumn = "DIM_"  + axisID;
					}
					cellDataSQL.addFactKeyColumnList(i, factKeyColumn);
	
					// WHERE��
					if ( i == 2 ) {// �y�[�W�G�b�W
						ArrayList<String> tmpList = new ArrayList<String>();
						tmpList.add(measureMemberKey);
						cellDataSQL.putWhereClauseMap(i, factKeyColumn, tmpList);

					} else {		// �s�A��G�b�W
						String[] selectEdgeKeys = (String[])selectKeys[i];		// �I�����ꂽ�������o�[���X�g�̏W��(�G�b�W�P��)
						String   selectAxisKeys = selectEdgeKeys[j];			// �I�����ꂽ�������o�[���X�g
						cellDataSQL.putWhereClauseMap(i, factKeyColumn, StringUtil.splitString(selectAxisKeys,","));

					}
				}
			}
		}
		
		return cellDataSQL;
	}

	// ********** ���\�b�h **********

	/**
	 * �Z���f�[�^���擾����SQL����������߂�B
	 * @return SQL������
	 */
	public String getSQLString() {

		// SELECT����o�́i�f�B�����V�����{���W���[�j
		// ���W���[�̍i���݂͂����Ŕ��f
		String SQL = this.getSelectClause();

		SQL += " FROM ";
		SQL += getFactTableName();

		// WHERE����o�́i�f�B�����V�����̂݁j
		SQL += " WHERE ";

		SQL += this.getWhereClause(this.getColWhereClauseMap());
		if (colWhereClauseMap.size()>0) { // COL�Ƀf�B�����V�������z�u����Ă���
			if (rowWhereClauseMap.size()>0) {	// ROW�Ƀf�B�����V�������z�u����Ă���
				SQL += " and ";
			}
		}
		SQL += this.getWhereClause(this.getRowWhereClauseMap());

		if (pageWhereClauseMap.size()>0) {	// �y�[�W�Ɏ����z�u����Ă��Ȃ��ꍇ������
				SQL += " and ";
			SQL += this.getWhereClause(this.getPageWhereClauseMap());
		}
		
		return SQL;
	}




	/**
	 * �\�[�g�ς݂̃Z���f�[�^���擾����SQL����������߂�B
	 * @return SQL������
	 */
	public String getSQLStringForSortData() {
		
		// SELECT����o��
		String SQL = this.getSelectClause();

		SQL += " FROM (";
		SQL += "   SELECT * FROM ";
		SQL += getFactTableName();		
		
		// FROM��̕��₢���킹��WHERE��𐶐�
		SQL += " WHERE " + this.getWhereClause(this.getColWhereClauseMap());
		if (colWhereClauseMap.size()>0) { // COL�Ƀf�B�����V�������z�u����Ă���
			if (rowWhereClauseMap.size()>0) {	// ROW�Ƀf�B�����V�������z�u����Ă���
				SQL += " and ";
			}
		}
		SQL += this.getWhereClause(this.getRowWhereClauseMap());

		if (pageWhereClauseMap.size()>0) {	// �y�[�W�Ɏ����z�u����Ă��Ȃ��ꍇ������
				SQL += " and ";
			SQL += this.getWhereClause(this.getPageWhereClauseMap());
		}
		
		// FROM��̕��₢���킹����镔���𐶐�
		SQL += " ) as fact ";

		Iterator<Edge> edgeIt = report.getEdgeList().iterator();

		while (edgeIt.hasNext()) {
			Edge edge = edgeIt.next();
			Iterator<Axis> axisIt = edge.getAxisList().iterator();
			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();

				if (axis instanceof Dimension) {
					Dimension dimension = (Dimension) axis;

					SQL += ",(SELECT * FROM oo_dim_tree('";
					SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + "'";
					SQL +=     ",null,',";

					String factColumnName = "DIM_";
					if (dimension.getId().length() < 2){
						factColumnName += "0";
					}
					factColumnName += dimension.getId();

					LinkedHashMap<String, ArrayList<String>> map = this.getAxisWhereClauseMap(edge.getPosition());
					ArrayList<String> memberKeyList = map.get(factColumnName);
					SQL += StringUtil.joinList(memberKeyList, ",");

					SQL +=     ",')) as oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq();

				}
			}
		}

		// WHERE��i�t�@�N�g�ƃf�B�����V������Join���`�j�𐶐�
		// Orderby��𐶐�
		SQL += " where ";
		edgeIt = report.getEdgeList().iterator();
		int i = 0;
		while (edgeIt.hasNext()) {
			Edge edge = edgeIt.next();
			Iterator<Axis> axisIt = edge.getAxisList().iterator();
			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();
				if (axis instanceof Dimension) {
					Dimension dimension = (Dimension) axis;
					if (i!=0) {
						SQL += " and ";
					}

					String factColumnName = "DIM_";
					if (dimension.getId().length() < 2){
						factColumnName += "0";
					}
					factColumnName += dimension.getId();
					SQL +=     "fact." + factColumnName + "=";
					SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + ".key";
					i++;
				}
			}
		}

		// Orderby��𐶐�(��A�s�A�y�[�W�̏�)
		SQL += " order by ";

		// Row
		Edge edge = report.getEdgeByType(Constants.Row);
		Iterator<Axis> it = edge.getAxisList().iterator();
		i = 0;
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis instanceof Dimension) {
				Dimension dimension = (Dimension) axis;
				if (i!=0) {
					SQL += ",";
				}
				SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + ".rownum";
				i++;
			}
		}

		// Col
		edge = report.getEdgeByType(Constants.Col);
		it = edge.getAxisList().iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis instanceof Dimension) {
				Dimension dimension = (Dimension) axis;
				if (i!=0) {
					SQL += ",";
				}
				SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + ".rownum";
				i++;
			}
		}		
		
		
		// Page
		edge = report.getEdgeByType(Constants.Page);
		it = edge.getAxisList().iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis instanceof Dimension) {
				Dimension dimension = (Dimension) axis;
				if (i!=0) {
					SQL += ",";
				}
				SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + ".rownum";
				i++;
			}
		}		



//		edgeIt = report.getEdgeList().iterator();
//		i = 0;
//		while (edgeIt.hasNext()) {
//			Edge edge = (Edge) edgeIt.next();
//			Iterator axisIt = edge.getAxisList().iterator();
//			while (axisIt.hasNext()) {
//				Axis axis = (Axis) axisIt.next();
//				if (axis instanceof Dimension) {
//					Dimension dimension = (Dimension) axis;
//					if (i!=0) {
//						SQL += ",";
//					}
//					SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + ".rownum";
//					i++;
//				}
//			}
//		}


		return SQL;
	}



	// �t�@�N�g�e�[�u������f�B�����V�����e�[�u���փ}�b�s���O����J�������̂̃��X�g(�J���}��؂�̕�����)���G�b�W���ƂɎ擾����
	// �Ȃ��A���W���[���͏��O����
	// return)
	//   string[0]:��G�b�W�̃J�������X�g(String,�J���}��؂�)
	//   string[1]:��G�b�W�̃J�������X�g(String,�J���}��؂�)
	//   string[2]:�y�[�W�G�b�W�̃J�������X�g(String,�J���}��؂�)

	public String[] getDimsFactKeyColumnList() {
		String axesFactKeyColumnList[] = new String[3];
		axesFactKeyColumnList[0] = StringUtil.joinList(StringUtil.exceptElement(colFactKeyColumnList, "MEASURE"), ",");
		axesFactKeyColumnList[1] = StringUtil.joinList(StringUtil.exceptElement(rowFactKeyColumnList, "MEASURE"), ",");
		axesFactKeyColumnList[2] = StringUtil.joinList(StringUtil.exceptElement(pageFactKeyColumnList, "MEASURE"), ",");
		
		return axesFactKeyColumnList;
	}



	// ********** private���\�b�h **********

	/**
	 * �Z���f�[�^�����߂�SQL��WHERE�߂����߂�B
	 * @param edgeWhereClauseMap
	 * @return WHERE��
	 */
	private String getWhereClause(LinkedHashMap<String, ArrayList<String>> edgeWhereClauseMap) {
		
		String edgeWhereClause = "";
		
		Iterator<String> iter = edgeWhereClauseMap.keySet().iterator();
		int i = 0;
		while (iter.hasNext()) {
			if(i>0) {
				edgeWhereClause += " and ";
			}
			String factKeyColumn = iter.next();
			edgeWhereClause += factKeyColumn + " in (";

			ArrayList<String> memberKeyList = (ArrayList<String>) edgeWhereClauseMap.get(factKeyColumn);
			edgeWhereClause += StringUtil.joinList(memberKeyList, ",");
			edgeWhereClause += ")";

			i++;
		}
		
		return edgeWhereClause;
	}

	/**
	 * �Z���f�[�^�����߂�SQL��SELECT�߂����߂�B
	 * @return SELECT��
	 */
	private String getSelectClause() {

		String SQL = "SELECT ";		
		SQL += StringUtil.joinList(this.getColFactKeyColumnList(), ",");
		SQL += "," + StringUtil.joinList(this.getRowFactKeyColumnList(), ",");
		if (pageFactKeyColumnList.size()>0) {
			SQL += "," + StringUtil.joinList(this.getPageFactKeyColumnList(), ",");
		}
		
		return SQL;
	}

	// ********** Setter ���\�b�h **********


	/**
	 * ���|�[�g�I�u�W�F�N�g��ǉ�����
	 * @param report Report�I�u�W�F�N�g
	 */
	public void setReport(Report report) {
		this.report = report;
	}


	/**
	 * �t�@�N�g�̃L�[�J�������X�g��ǉ�����
	 * @param edgePositionID �G�b�WID(0:��A1:�s�A2:�y�[�W)
	 * @param factKeyColumn
	 */
	public void addFactKeyColumnList(int edgePositionID, String factKeyColumn) {
		if (edgePositionID==0) {
			this.colFactKeyColumnList.add(factKeyColumn);
		} else if (edgePositionID==1){
			this.rowFactKeyColumnList.add(factKeyColumn);
		} else if (edgePositionID==2){
			this.pageFactKeyColumnList.add(factKeyColumn);
		} else {
			throw new IllegalArgumentException();
		}
	}

	/**
	 * �s�G�b�W�փt�@�N�g�̃L�[�J������ǉ�����B
	 * @param factKeyColumn �L�[�J����
	 */
	public void addColFactKeyColumnList(String factKeyColumn) {
		this.colFactKeyColumnList.add(factKeyColumn);
	}

	/**
	 * ��G�b�W�փt�@�N�g�̃L�[�J������ǉ�����B
	 * @param factKeyColumn �L�[�J����
	 */
	public void addRowFactKeyColumnList(String factKeyColumn) {
		this.rowFactKeyColumnList.add(factKeyColumn);
	}

	/**
	 * �y�[�W�G�b�W�փt�@�N�g�̃L�[�J������ǉ�����B
	 * @param factKeyColumn �L�[�J����
	 */
	public void addPageFactKeyColumnList(String factKeyColumn) {
		this.pageFactKeyColumnList.add(factKeyColumn);
	}

	/**
	 * �t�@�N�g�e�[�u������ݒ肷��B
	 * @param string �t�@�N�g�e�[�u����
	 */
	public void setFactTableName(String string) {
		this.factTableName = string;
	}

	/**
	 * �t�@�N�g�e�[�u������ݒ肷��B
	 * @param edgePositionID �G�b�WID(0:��A1:�s�A2:�y�[�W)
	 * @param factKeyColumn �L�[�J����
	 * @param memberKeyList �����o�[�L�[���X�g
	 */
	public void putWhereClauseMap(int edgePositionID, String factKeyColumn, ArrayList<String> memberKeyList) {
		if (edgePositionID == 0){
			this.colWhereClauseMap.put(factKeyColumn, memberKeyList);
		} else if (edgePositionID == 1) {
			this.rowWhereClauseMap.put(factKeyColumn, memberKeyList);
		} else if (edgePositionID == 2) {
			this.pageWhereClauseMap.put(factKeyColumn, memberKeyList);
		} else {
			throw new IllegalArgumentException();
		}
	}

	/**
	 * ���WHERE�߂�����킷Map�I�u�W�F�N�g��ǉ�����B
	 * @param factKeyColumn �L�[�J����
	 * @param memberKeyList �����o�[�L�[���X�g
	 */
	public void putColWhereClauseMap(String factKeyColumn, ArrayList<String> memberKeyList) {
		this.colWhereClauseMap.put(factKeyColumn, memberKeyList);
	}


	/**
	 * �s��WHERE�߂�����킷Map�I�u�W�F�N�g��ǉ�����B
	 * @param factKeyColumn �L�[�J����
	 * @param memberKeyList �����o�[�L�[���X�g
	 */
	public void putRowWhereClauseMap(String factKeyColumn, ArrayList<String> memberKeyList) {
		this.rowWhereClauseMap.put(factKeyColumn, memberKeyList);
	}

	/**
	 * �y�[�W��WHERE�߂�����킷Map�I�u�W�F�N�g��ǉ�����B
	 * @param factKeyColumn �L�[�J����
	 * @param memberKeyList �����o�[�L�[���X�g
	 */
	public void putPageWhereClauseMap(String factKeyColumn, ArrayList<String> memberKeyList) {
		this.pageWhereClauseMap.put(factKeyColumn, memberKeyList);
	}

	/**
	 * �y�[�W��WHERE�߂�����킷Map�I�u�W�F�N�g��ǉ�����B
	 * @param string ���W���[�̃f�t�H���g�����o�[KEY
	 */
	public void setMeasureDefaultMember(String string) {
		measureDefaultMember = string;
	}

	/**
	 * ���W���[�̃f�t�H���g�����o�[�̃��W���[�V�[�P���X��ǉ�����B
	 * @param meaDefaultSeq ���W���[�̃f�t�H���g�����o�[�̃��W���[�V�[�P���X
	 */
	public void setMeasureDefaultSeq(String meaDefaultSeq) {
		this.measureDefaultSeq = meaDefaultSeq;
	}

	// ********** Getter ���\�b�h **********

	/**
	 * ���|�[�g�I�u�W�F�N�g�����߂�B
	 * @return ���|�[�g�I�u�W�F�N�g
	 */
	public Report getReport() {
		return report;
	}

	/**
	 * �w�肳�ꂽ�G�b�W�ɔz�u���ꂽ����WHERE�߂�����킷�I�u�W�F�N�g�����߂�B
	 * @return �w�肳�ꂽ�G�b�W�ɔz�u���ꂽ����WHERE�߂�����킷�I�u�W�F�N�g
	 */
	public LinkedHashMap<String, ArrayList<String>> getAxisWhereClauseMap(String edgePosition) {
		if (edgePosition == null){
			return null;
		}

		if (Constants.Col.equals(edgePosition)) {
			return colWhereClauseMap;
		} else if (Constants.Row.equals(edgePosition)) {
			return rowWhereClauseMap;
		} else if (Constants.Page.equals(edgePosition)) {
			return pageWhereClauseMap;
		} else {
			return null;
		}
		
	}
	


	/**
	 * ��G�b�W�ɔz�u���ꂽ���ɑΉ�����Fact�e�[�u���̃J�����A�擾�Ώۃ��W���[���X�g�����߂�B
	 * @return �L�[�J�������X�g
	 */
	public ArrayList<String> getColFactKeyColumnList() {
		return colFactKeyColumnList;
	}

	/**
	 * ��ɔz�u���ꂽ����WHERE�߂�����킷�I�u�W�F�N�g�����߂�B
	 * @return ��ɔz�u���ꂽ����WHERE�߂�����킷�I�u�W�F�N�g
	 */
	public LinkedHashMap<String, ArrayList<String>> getColWhereClauseMap() {
		return colWhereClauseMap;
	}

	/**
	 * �t�@�N�g�e�[�u���������߂�B
	 * @return �t�@�N�g�e�[�u����
	 */
	public String getFactTableName() {
		return factTableName;
	}

	/**
	 * �y�[�W�G�b�W�ɔz�u���ꂽ���ɑΉ�����Fact�e�[�u���̃J�����A�擾�Ώۃ��W���[���X�g�����߂�B
	 * @return �L�[�J�������X�g
	 */
	public ArrayList<String> getPageFactKeyColumnList() {
		return pageFactKeyColumnList;
	}

	/**
	 * �y�[�W�ɔz�u���ꂽ����WHERE�߂�����킷�I�u�W�F�N�g�����߂�B
	 * @return �y�[�W�ɔz�u���ꂽ����WHERE�߂�����킷�I�u�W�F�N�g
	 */
	public LinkedHashMap<String, ArrayList<String>> getPageWhereClauseMap() {
		return pageWhereClauseMap;
	}

	/**
	 * �s�G�b�W�ɔz�u���ꂽ���ɑΉ�����Fact�e�[�u���̃J�����A�擾�Ώۃ��W���[���X�g�����߂�B
	 * @return �L�[�J�������X�g
	 */
	public ArrayList<String> getRowFactKeyColumnList() {
		return rowFactKeyColumnList;
	}

	/**
	 * �s�ɔz�u���ꂽ����WHERE�߂�����킷�I�u�W�F�N�g�����߂�B
	 * @return �y�[�W�ɔz�u���ꂽ����WHERE�߂�����킷�I�u�W�F�N�g
	 */
	public LinkedHashMap<String, ArrayList<String>> getRowWhereClauseMap() {
		return rowWhereClauseMap;
	}

	/**
	 * ���W���[���y�[�W�G�b�W�ɂ���Ƃ��̃f�t�H���g�����o�[�L�[(UName)�����߂�B
	 * @return �f�t�H���g�����o�[�L�[
	 */
	public String getMeasureDefaultMember() {
		return measureDefaultMember;
	}

	/**
	 * ���W���[���y�[�W�G�b�W�ɂ���Ƃ��̃f�t�H���g�����o�[�̃��W���[�V�[�P���X(measureSeq)�����߂�B
	 * @return �f�t�H���g�����o�[�̃��W���[�V�[�P���X
	 */
	public String getMeasureDefaultMeasureSeq() {
		return measureDefaultSeq;
	}


}

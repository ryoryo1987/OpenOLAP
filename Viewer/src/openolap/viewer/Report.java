/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FReport.java
 *  �����F���|�[�g������킷�N���X�ł��B
 *
 *  �쐬��: 2003/12/29
 */

package openolap.viewer;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeMap;

import openolap.viewer.common.Constants;
import openolap.viewer.common.Messages;
import openolap.viewer.controller.RequestHelper;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionMemberDAO;
import openolap.viewer.dao.ReportDAO;

/**
 *  �N���X�FReport
 *  �����F���|�[�g������킷�N���X�ł��B
 */
public class Report implements Serializable {

	// ********** �ÓI�ϐ� **********

	/** ��{���|�[�g ���[�U�h�c */
	static public String basicReportUserID = "0";

	/** ��{���|�[�g �Q�ƌ����|�[�g�h�c */
	static public String basicReportReferenceReportID = null;

	/** ��{���|�[�g ���|�[�g�̎�� */
	static public String basicReportOwnerFLG = "1";

	/** �l���|�[�g ���|�[�g�̎�� */
	static public String personalReportOwnerFLG = "2";

	/** �l���|�[�g �l���|�[�g�̖��̂ɂ���ڔ��� */
	static public String personalReportNameSuffix = "�i�l���|�[�g�j";

	// ********** �C���X�^���X�ϐ� **********

	/** ���|�[�gID */
	final private String reportID;

	/** ���|�[�g�� */
	private String reportName = null;

	/** �eID(���|�[�g���i�[����t�H���_��ID) */
	private String parentID;

	/** �l���|�[�g���쐬�������[�U��ID */
	protected String userID = null;

	/** �l���|�[�g���Q�Ƃ��Ă����{���|�[�g��ID */
	protected String referenceReportID = null;

	/** ���|�[�g�̎��(��{���|�[�g�A�l���|�[�g�̊e�ꍇ�łƂ�l�́AbasicReportOwnerFLG,personalReportOwnerFLG�Q�ƁB) */
	private String reportOwnerFLG = null;

	/** ��ʃ^�C�v�i0:�S��ʕ\���i�\�j�A1:�S��ʕ\���i�O���t�j�A2:�c�����i�\�A�O���t)�j **/
	private String displayScreenType = "0";
	
	/** �f�t�H���g�ŕ\������`���[�g�̖��� **/
	private String currentChart = "NA";

	/** �L���[�u */
	final private Cube cube;

	/** �G�b�W������킷�I�u�W�F�N�g���X�g */
	final private ArrayList<Edge> edgeList;

	/** �n�C���C�g�����i�[����XML������ */
	private String highLightXML;

	/** �F�ݒ�̃^�C�v�i1�F�h��Ԃ��A2�F�n�C���C�g�j */
	private String colorType = "1";

	/** �F������킷�I�u�W�F�N�g�̃��X�g */
	final private ArrayList<Color> colorList;

	/** ���Ԏ��������� */
	final private boolean hasTimeDim;

	/** �V�K�쐬���Ŗ��ۑ��̃��|�[�g(true)���A�������|�[�g(false)�� */
	private boolean isNewReport = false;

	// ********** �R���X�g���N�^ **********

	/**
	 * ���|�[�g�I�u�W�F�N�g�𐶐����܂��B
	 */
	public Report(String reportID, String reportName, String userID, String referenceReportID, String reportOwnerFLG, Cube cube, ArrayList<Edge> edgeList, ArrayList<Color> colorList, boolean hasTimeDim){
		this.reportID = reportID;
		this.reportName = reportName;
		this.parentID = null;
		this.userID = userID;
		this.referenceReportID = referenceReportID;
		this.reportOwnerFLG = reportOwnerFLG;
		this.cube = cube;
		this.edgeList = edgeList;
		this.highLightXML = null;
		this.colorList = colorList;
		this.hasTimeDim = hasTimeDim;
	}


	// ********** �ÓI���\�b�h **********

	/**
	 * ���Ԏ������ꍇtrue�A�����Ȃ��ꍇfalse��߂��B
	 * @param edgeList �����X�g
	 */
	public static boolean investigateTimeDimension(ArrayList<Edge> edgeList) {
		Edge col = Edge.getTheEdge("COL",edgeList);
		Edge row = Edge.getTheEdge("ROW",edgeList);
		Edge page = Edge.getTheEdge("PAGE",edgeList);

		return (col.investigateTimeDimension() || row.investigateTimeDimension() || page.investigateTimeDimension());
	}

	/**
	 * �^����ꂽ�f�B�����V�������X�g�A���W���[���X�g��z�u�����G�b�W������킷�I�u�W�F�N�g�̃��X�g��߂��B
	 * @param dimList �f�B�����V����������킷�I�u�W�F�N�g�̃��X�g
	 * @param measure ���W���[������킷�I�u�W�F�N�g
	 * @return �G�b�W������킷�I�u�W�F�N�g�̃��X�g
	 */
	public static ArrayList<Edge> initializeEdge(ArrayList<Dimension> dimList, Measure measure) {
		if ( (dimList == null) || (measure == null) ) { throw new IllegalArgumentException(); }
		if (dimList.size() < 1) { throw new IllegalArgumentException(); }

		ArrayList<Axis> sourceAxisList = new ArrayList<Axis>();
		Iterator<Dimension> dimIt = dimList.iterator();
		while (dimIt.hasNext()) {
			sourceAxisList.add((Axis)dimIt.next());
		}
		sourceAxisList.add((Axis)measure);


		Col col = null;
		Row row = null;
		Page page = null;
		ArrayList<Axis> pageAxisList = new ArrayList<Axis>();


		col = new Col((Axis)sourceAxisList.get(0));
		row = new Row((Axis)sourceAxisList.get(1));

		if ( sourceAxisList.size()-2 > 0 ) { // �f�B�����V�������ӂ��ȏ㎝�i�y�[�W�G�b�W���������j�ꍇ
			for(int i=0; i<(sourceAxisList.size()-2); i++){
				pageAxisList.add(sourceAxisList.get(i+2));
				page = new Page(pageAxisList);
			}
		} else {	// �y�[�W�G�b�W�Ɏ������݂��Ȃ��ꍇ�A���ArrayList����������
			page = new Page(new ArrayList<Axis>());
		}

		ArrayList<Edge> edgeList = new ArrayList<Edge>();
		edgeList.add(col);
		edgeList.add(row);
		edgeList.add(page);

		return edgeList;
	}

	public static String getInitialReportName() {
		return Messages.getString("Report.tempInitialReportName"); //$NON-NLS-1$
	}

	// ********** ���\�b�h **********

	/**
	 * Report�I�u�W�F�N�g�̍s�A��G�b�W�ɔz�u���ꂽ�f�B�����V�����ɁA�������o�[�I�u�W�F�N�g���Z�b�g����
	 * @param helper RequestHelper������킷�I�u�W�F�N�g�̃��X�g
	 * @param report ���|�[�g������킷�I�u�W�F�N�g
	 * @param conn �R�l�N�V����������킷�I�u�W�F�N�g
	 */
	public void setSelectedCOLROWDimensionMembers(RequestHelper helper, Report report, Connection conn) throws SQLException {

		DimensionMemberDAO dimMemberDAO = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn);

		Iterator<Edge> it = report.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			Iterator<Axis> it2 = edge.getAxisList().iterator();

			if (edge.getPosition().equals(Constants.Page)) {
				continue;
			}

			int i = 0;
			while (it2.hasNext()) {
				Axis axis = it2.next();
				Dimension dim = null;
				if(axis instanceof Dimension) {
					dim = (Dimension) axis;
				} else {
					i++;
					continue;
				}

				String selectedMemberList = "";
				if (edge.getPosition().equals(Constants.Col)) {
					selectedMemberList = "'," + helper.getRequest().getSession().getAttribute("viewCol" + i + "KeyList_hidden") + ",'";
				} else if (edge.getPosition().equals(Constants.Row)) {
					selectedMemberList = "'," + helper.getRequest().getSession().getAttribute("viewRow" + i + "KeyList_hidden") + ",'";
				}

				ArrayList<AxisMember> dimMemberList = dimMemberDAO.selectDimensionMembers(dim, null, null, null, selectedMemberList);
				dim.clearAxisMember();
				dim.addAllAxisMember(dimMemberList);

				i++;
			}
		}
	}


	/**
	 * ���|�[�g�̃f�B�����V�����I�u�W�F�N�g���������o�[���폜����
	 */
	public void clearDimensionMembers() {

		Iterator<Edge> it = edgeList.iterator();
		while (it.hasNext()) {
			Edge edge =  it.next();
			Iterator<Axis> it2 = edge.getAxisList().iterator();
			while (it2.hasNext()) {
				Axis axis = it2.next();
				if(!axis.isMeasure()){
					axis.clearAxisMember();
				}
			}
		}
	}


	/**
	 * ���|�[�g�̎����f�B�����V�����������߂�B
	 * @return ���f�B�����V������
	 */
	public int getTotalDimensionNumber(){

		Iterator<Edge> it = edgeList.iterator();
		int dimCounter = 0;
		while (it.hasNext()) {
			Edge edge = it.next();
			Iterator<Axis> it2 = edge.getAxisList().iterator();
			while (it2.hasNext()) {
				Axis axis = it2.next();
				if(!axis.isMeasure()){
					dimCounter++;
				}
			}
		}

		return dimCounter;
	}

	/**
	 * ���|�[�g�̎������W���[�����o�[�������߂�B
	 * @return �����W���[�����o�[��
	 */
	public int getTotalMeasureMemberNumber(){
		ArrayList<AxisMember> measureMemberList = this.getMeasure().getAxisMemberList();
		return measureMemberList.size();
	}

	/**
	 * �^����ꂽ���̂̃G�b�W�I�u�W�F�N�g�����߂�B
	 * @param edgeType �G�b�W������킷���́iCOL,ROW,PAGE�j
	 * @return �G�b�W�I�u�W�F�N�g
	 */
	public Edge getEdgeByType(String edgeType) {
		Iterator<Edge> it = edgeList.iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if (edge.getPosition().equals(edgeType)){
				return edge;
			}
		}
		return null;
	}

	/**
	 * ���W���[�I�u�W�F�N�g�����߂�B
	 * @return ���W���[�I�u�W�F�N�g
	 */
	public Measure getMeasure() {
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if(edge.getMeasure() != null) {
				return edge.getMeasure();
			}
		}
		throw new IllegalStateException();
	}

	/**
	 * �^����ꂽID�̎��I�u�W�F�N�g�����߂�B
	 * ���I�u�W�F�N�g�����݂��Ȃ��ꍇ��null��߂��B
	 * @return ���I�u�W�F�N�g
	 */
	public Axis getAxisByID(String sourceID) {
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			Iterator<Axis> axisIt = edge.getAxisList().iterator();

			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();

				if(axis.getId().equals(sourceID)) {
					return axis;
				}
			}
		}
		return null;
	}


	/**
	 * ���|�[�g�����S�Ă̎��I�u�W�F�N�g���w�肳�ꂽ�G�b�W�̏��Ŏ擾����B
	 * �e�G�b�W���ɕ����̎������݂���ꍇ�́A�iIndex�̏��Ƃ���B
	 * @param firstEdgePosition  ORDER BY��ň�ԖڂɎw�肳���G�b�W�^�C�v(Constants.Col or Constants.Row or Constants.Page)
	 * @param secondEdgePosition ORDER BY��œ�ԖڂɎw�肳���G�b�W�^�C�v(Constants.Col or Constants.Row or Constants.Page)
	 * @param thirdEdgePosition  ORDER BY��ŎO�ԖڂɎw�肳���G�b�W�^�C�v(Constants.Col or Constants.Row or Constants.Page)
	 * @param includeMeasure   ���W���[���܂߂邩�ǂ����H
	 * @return ���I�u�W�F�N�g�̃��X�g
	 */
	public ArrayList<Axis> getAxisOrderByEdgePosition(String firstEdgePosition, String secondEdgePosition, String thirdEdgePosition, boolean includeMeasure) {
		if((!Constants.Col.equals(firstEdgePosition)) && (!Constants.Col.equals(secondEdgePosition)) && (Constants.Col.equals(thirdEdgePosition)) ) {
			throw new IllegalArgumentException();
		}
		if((!Constants.Row.equals(firstEdgePosition)) && (!Constants.Row.equals(secondEdgePosition)) && (Constants.Row.equals(thirdEdgePosition)) ) {
			throw new IllegalArgumentException();
		}
		if((!Constants.Page.equals(firstEdgePosition)) && (!Constants.Page.equals(secondEdgePosition)) && (Constants.Page.equals(thirdEdgePosition)) ) {
			throw new IllegalArgumentException();
		}
		if((firstEdgePosition.equals(secondEdgePosition)) || (firstEdgePosition.equals(thirdEdgePosition)) || (secondEdgePosition.equals(thirdEdgePosition))) {
			throw new IllegalArgumentException();
		}

		ArrayList<Axis> axisList = new ArrayList<Axis>();

		// first
			Edge edge = this.getEdgeByType(firstEdgePosition);
			Iterator<Axis> it = edge.getAxisList().iterator();
			while (it.hasNext()) {
				Axis axis = it.next();
				if ((!includeMeasure) && axis instanceof Measure) {
					continue;
				} else {
					axisList.add(axis);
				}
			}

		// second
			edge = this.getEdgeByType(secondEdgePosition);
			it = edge.getAxisList().iterator();
			while (it.hasNext()) {
				Axis axis = (Axis) it.next();
				if ((!includeMeasure) && axis instanceof Measure) {
					continue;
				} else {
					axisList.add(axis);
				}
			}

		// third
			edge = this.getEdgeByType(thirdEdgePosition);
			it = edge.getAxisList().iterator();
			while (it.hasNext()) {
				Axis axis = (Axis) it.next();
				if ((!includeMeasure) && axis instanceof Measure) {
					continue;
				} else {
					axisList.add(axis);
				}
			}

		return axisList;
	}

	/**
	 * ���|�[�g�����S�Ă̎��I�u�W�F�N�g��AxisId �̏����Ŏ擾����B
	 * @return ���I�u�W�F�N�g�̃��X�g
	 */
	public ArrayList<Axis> getAxisOrderByID() {
		ArrayList<Axis> axisList = new ArrayList<Axis>();

		TreeMap<Integer, Axis> axisIdObjMap = new TreeMap<Integer, Axis>();
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			Iterator<Axis> axisIt = edge.getAxisList().iterator();

			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();
				axisIdObjMap.put(Integer.decode(axis.getId()), axis);
			}
		}

		Iterator<Integer> axisIt = axisIdObjMap.keySet().iterator();
		while (axisIt.hasNext()) {
			Integer axisID = axisIt.next();
			Axis axis = axisIdObjMap.get(axisID) ;
			axisList.add(axis);
		}

		return axisList;
	}

	/**
	 * �^����ꂽ�����z�u����Ă���G�b�W�̖��̂����߂�B
	 * ���I�u�W�F�N�g�����݂��Ȃ��ꍇ��null��߂��B
	 * @param oAxis ��������킷�I�u�W�F�N�g
	 * @return �G�b�W�̖���
	 */
	public String getThisAxisPosition(Axis oAxis) {
		if (oAxis == null){ return null; }
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if (edge.hasThisAxis(oAxis)){
				return edge.getPosition();
			}
		}
		return null;
	}

	/**
	 * �^����ꂽ�����z�u����Ă���G�b�W�̖��̂����߂�B
	 * ���I�u�W�F�N�g�����݂��Ȃ��ꍇ��null��߂��B
	 * @param id ��ID
	 * @return �G�b�W�̖���
	 */
	public String getThisAxisPosition(String id) {
		if (id == null){ return null; }
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if (edge.hasThisAxis(id)){
				return edge.getPosition();
			}
		}
		return null;
	}

	/**
	 * �^����ꂽ��ID�̎��I�u�W�F�N�g���G�b�W����폜����
	 * @param id ��ID
	 */
	public void deleteAxis(String axisID) {

		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			Iterator<Axis> axisIt = edge.getAxisList().iterator();

			int i = 0;
			while (axisIt.hasNext()) {
				Axis axis =  axisIt.next();
				if(axis.getId().equals(axisID)) {
					// �G�b�W���������X�g���A����^����ꂽ�����폜
					edge.getAxisList().remove(i);					
					break;
				}
				i++;
			}
		}
	}



	/**
	 * �^����ꂽ������G�b�W�ɔz�u����Ă���ꍇ��true�A�z�u����Ă��Ȃ��ꍇ��false��߂��B
	 * @param oAxis ���I�u�W�F�N�g
	 * @return ��G�b�W�ɔz�u����Ă��邩
	 */
	public boolean isInCol(Axis oAxis) {
		if (oAxis == null){ return false; }
		if (this.getThisAxisPosition(oAxis).equals(Constants.Col)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * �^����ꂽ������G�b�W�ɔz�u����Ă���ꍇ��true�A�z�u����Ă��Ȃ��ꍇ��false��߂��B
	 * @param axisId ��ID
	 * @return ��G�b�W�ɔz�u����Ă��邩
	 */
	public boolean isInCol(String axisId) {
		if (axisId == null){ return false; }
		if (this.getThisAxisPosition(axisId).equals(Constants.Col)) {
			return true;
		} else {
			return false;
		}
	}


	/**
	 * �^����ꂽ�����s�G�b�W�ɔz�u����Ă���ꍇ��true�A�z�u����Ă��Ȃ��ꍇ��false��߂��B
	 * @param oAxis ���I�u�W�F�N�g
	 * @return �s�G�b�W�ɔz�u����Ă��邩
	 */
	public boolean isInRow(Axis oAxis) {
		if (oAxis == null){ return false; }
		if (this.getThisAxisPosition(oAxis).equals(Constants.Row)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * �^����ꂽ�����s�G�b�W�ɔz�u����Ă���ꍇ��true�A�z�u����Ă��Ȃ��ꍇ��false��߂��B
	 * @param axisId ��ID
	 * @return �s�G�b�W�ɔz�u����Ă��邩
	 */
	public boolean isInRow(String axisId) {
		if (axisId == null){ return false; }
		if (this.getThisAxisPosition(axisId).equals(Constants.Row)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * �^����ꂽ�����y�[�W�G�b�W�ɔz�u����Ă���ꍇ��true�A�z�u����Ă��Ȃ��ꍇ��false��߂��B
	 * @param oAxis ���I�u�W�F�N�g
	 * @return �y�[�W�G�b�W�ɔz�u����Ă��邩
	 */
	public boolean isInPage(Axis oAxis) {
		if (oAxis == null){ return false; }
		if (this.getThisAxisPosition(oAxis).equals(Constants.Page)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * �^����ꂽ�����y�[�W�G�b�W�ɔz�u����Ă���ꍇ��true�A�z�u����Ă��Ȃ��ꍇ��false��߂��B
	 * @param axisId ��ID
	 * @return �y�[�W�G�b�W�ɔz�u����Ă��邩
	 */
	public boolean isInPage(String axisId) {
		if (axisId == null){ return false; }
		if (this.getThisAxisPosition(axisId).equals(Constants.Page)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * �^����ꂽ�����z�u����Ă���G�b�W���ł̒i�C���f�b�N�X�����߂�B
	 * �C���f�b�N�X�́u0�vstart�̒l�ł���B
	 * �����Ƃ���null���n���Ă����ꍇ�́u-1�v��߂��B
	 * �^����ꂽ�������݂��Ȃ��ꍇ�́u0�v��߂��B
	 * @param oAxis ���I�u�W�F�N�g
	 * @return �G�b�W���ł̒i�C���f�b�N�X
	 */
	public int getHieIndex(Axis oAxis) {
		if (oAxis == null){ return -1; }
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if (edge.getAxisIndexInEdge(oAxis) != -1) {
				return edge.getAxisIndexInEdge(oAxis);
			}
		}
		return 0;
	}

	/**
	 * �^����ꂽ�����z�u����Ă���G�b�W���ł̒i�C���f�b�N�X�����߂�B
	 * �C���f�b�N�X�́u0�vstart�̒l�ł���B
	 * �����Ƃ���null���n���Ă����ꍇ�́u-1�v��߂��B
	 * �^����ꂽ�������݂��Ȃ��ꍇ�́u-1�v��߂��B
	 * @param axisID ��ID
	 * @return �G�b�W���ł̒i�C���f�b�N�X
	 */
	public int getHieIndex(String axisID) {
		if (axisID == null){ return -1; }
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if (edge.getAxisIndexInEdge(axisID) != -1) {
				return edge.getAxisIndexInEdge(axisID);
			}
		}
		return -1;
	}

	/**
	 * �w�肳�ꂽ�G�b�W�ɔz�u���ꂽ�������o�[�̑g�ݍ��킹�������߂�B
	 * @param edgeName ������
	 * @return �����o�[�̑g�ݍ��킹��
	 */
	public int getAxisMeberComboNum(String edgeName) {
		if ( (!Constants.Col.equals(edgeName)) && (!Constants.Row.equals(edgeName)) && (!Constants.Page.equals(edgeName)) ) {
			throw new IllegalStateException();
		}

		int totalNumber = 1;
		ArrayList<Axis> edgeAxesList = this.getEdgeByType(Constants.Col).getAxisList();
		Iterator<Axis> iter = edgeAxesList.iterator();
		while (iter.hasNext()) {
			Axis axis = iter.next();
			totalNumber = totalNumber * (axis.getAxisMemberList().size());
		} 

		return totalNumber;
	}

	/**
	 * �F��\���I�u�W�F�N�g�����|�[�g�ɒǉ�����B
	 * @param color �F������킷�I�u�W�F�N�g
	 */
	public void addColor(Color color) {
		if(color == null) { throw new IllegalArgumentException(); }
		this.colorList.add(color);
	}

	/**
	 * �F��\���I�u�W�F�N�g�̃��X�g�����|�[�g�ɒǉ�����B
	 * @param color �F������킷�I�u�W�F�N�g
	 */
	public void addColor(ArrayList<Color> colorList) {
		if(colorList == null) { throw new IllegalArgumentException(); }

		Iterator<Color> it = colorList.iterator();
		while (it.hasNext()) {
			Color color = it.next();
			this.colorList.add(color);
		}
	}

	/**
	 * �F��\���I�u�W�F�N�g�̃��X�g���N���A����B
	 */
	public void clearColorList() {
		this.colorList.clear();
		
	}

	/**
	 * �w�b�_�[�̐F��\���I�u�W�F�N�g�̃��X�g�����߂�B
	 * @return color �F������킷�I�u�W�F�N�g
	 */
	public ArrayList<Color> getHeaderColorList() {
		ArrayList<Color> headerColorList = new ArrayList<Color>();
		Iterator<Color> it = this.colorList.iterator();
		while (it.hasNext()) {
			Color color = it.next();
			if(color.isHeader()){
				headerColorList.add(color);
			}
		}
		return headerColorList;
	}

	/**
	 * �f�[�^�e�[�u���̐F��\���I�u�W�F�N�g�̃��X�g�����߂�B
	 * @return color �F������킷�I�u�W�F�N�g
	 */
	public ArrayList<Color> getSpreadColorList() {
		ArrayList<Color> spreadColorList = new ArrayList<Color>();
		Iterator<Color> it = this.colorList.iterator();
		while (it.hasNext()) {
			Color color = it.next();
			if(!color.isHeader()){
				spreadColorList.add(color);
			}
		}
		return spreadColorList;
	}

	/**
	 * ���|�[�g��ۑ�����B
	 * @param conn �R�l�N�V����������킷�I�u�W�F�N�g
	 * @exception SQLException DB�ւ̃��|�[�g�ۑ������ŗ�O����������
	 */
	public void saveReport(Connection conn) throws SQLException {
		DAOFactory daoFactory = DAOFactory.getDAOFactory();

		ReportDAO reportDAO = daoFactory.getReportDAO(conn);
		reportDAO.saveReport(this, conn);
	}

	/**
	 * �V�K�l���|�[�g��ۑ�����B
	 * @param conn �R�l�N�V����������킷�I�u�W�F�N�g
	 * @exception SQLException DB�ւ̃��|�[�g�ۑ������ŗ�O����������
	 */
	public void saveNewPersonalReport(String newReportName, String userID, Connection conn) throws SQLException {
		DAOFactory daoFactory = DAOFactory.getDAOFactory();

		ReportDAO reportDAO = daoFactory.getReportDAO(conn);
		reportDAO.saveNewPersonalReport(this, newReportName, userID, conn);
	}



	/**
	 * ���̃C���X�^���X�̕�����\�������߂�B
	 * @return String�I�u�W�F�N�g
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";
		stringInfo += "Report.reportID:" + this.reportID + sep;
		stringInfo += "Report.reportName:" + this.reportName + sep;
		stringInfo += "Report.parentID:" + this.parentID + sep;
		stringInfo += "Report.userID:" + this.userID + sep;
		stringInfo += "Report.referenceReportID:" + this.referenceReportID + sep;
		stringInfo += "Report.reportOwnerFLG:" + this.reportOwnerFLG + sep;
		stringInfo += "Report.displayScreenType:" + this.displayScreenType + sep;
		stringInfo += "Report.currentChart:" + this.currentChart + sep;
		stringInfo += "Report.highLightXML:" + this.highLightXML + sep;
		stringInfo += "Report.colorType:" + this.colorType + sep;
		stringInfo += "Report.hasTimeDim:" + String.valueOf(this.hasTimeDim) + sep;
		stringInfo += "Report.isNewReport:" + String.valueOf(this.isNewReport) + sep;

		stringInfo += "--- cube info ---" + sep;
		stringInfo += this.cube.toString();

		stringInfo += "--- edge info ---" + sep;		
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();

			stringInfo += "edge position:" + edge.getPosition() + " -- start " + sep;

			Iterator<Axis> axisIt = edge.getAxisList().iterator();
			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();

				stringInfo += "-- axis -- " + sep;
				stringInfo += axis.toString();
			}

			stringInfo += "edge position:" + edge.getPosition() + " -- end  " + sep;

		}		
		
//		stringInfo += "--- color info ---" + sep;

		return stringInfo;

	}

	// ********** Setter ���\�b�h **********

	/**
	 * ���[�UID���Z�b�g����B
	 * @param ���[�UID
	 */
	public void setUserID(String userID) {
		this.userID = userID;
	}

	/**
	 * �Q�ƌ����|�[�gID���Z�b�g����B
	 * @param �Q�ƌ����|�[�gID
	 */
	public void setReferenceReportID(String referenceReportID) {
		this.referenceReportID = referenceReportID;
	}

	/**
	 * ���|�[�g�̎�ނ��Z�b�g����B
	 * @param ���|�[�g�̎��
	 */
	public void setScopeKindFLG(String reportOwnerFLG) {
		this.reportOwnerFLG = reportOwnerFLG;
	}

	/**
	 * ���|�[�g�����Z�b�g����B
	 * @param string ���|�[�g��
	 */
	public void setReportName(String string) {
		reportName = string;
	}

	/**
	 * ���|�[�gID���Z�b�g����B
	 * @param string ���|�[�gID
	 */
	public void setParentID(String string) {
		parentID = string;
	}

	public void setHighLightXML(String string) {
		highLightXML = string;
	}


	public void setColorType(String string) {
		colorType = string;
	}

	/**
	 * �V�K���|�[�g�t���O���Z�b�g����B
	 * @param string ���|�[�gID
	 */
	public void setNewReport(boolean b) {
		isNewReport = b;
	}

	/**
	 * ��ʃ^�C�v���Z�b�g����B
	 * @param screenType ��ʃ^�C�v
	 */
	public void setDisplayScreenType(String screenType) {
		this.displayScreenType = screenType;
	}


	/**
	 * �f�t�H���g�`���[�g�̖��̂��Z�b�g����B
	 * @param currentChart �`���[�g�̖���
	 */
	public void setCurrentChart(String currentChart) {
		this.currentChart = currentChart;
	}



	// ********** Getter ���\�b�h **********

	/**
	 * ���|�[�g�������߂�B
	 * @return ���|�[�g��
	 */
	public String getReportName() {
		return reportName;
	}

	/**
	 * ���|�[�gID�����߂�B
	 * @return ���|�[�gID
	 */
	public String getReportID() {
		return reportID;
	}

	/**
	 * ���|�[�g�̐eID�i���|�[�g�i�[����t�H���_��ID�j�����߂�B
	 * @return ���|�[�gID
	 */
	public String getParentID() {
		return parentID;
	}

	public String getHighLightXML() {
		return highLightXML;
	}

	public String getColorType() {
		return colorType;
	}

	/**
	 * ���[�UID�����߂�B
	 * @return ���[�UID
	 */
	public String getUserID() {
		return userID;
	}
	
	/**
	 * �Q�ƌ����|�[�gID�����߂�B
	 * @return �Q�ƌ����|�[�gID
	 */
	public String getReferenceReportID() {
		return referenceReportID;
	}
	
	/**
	 * ���|�[�g�̎�ނ����߂�B
	 * @return ���|�[�g�̎��
	 *            ��{���|�[�g(=Report.basicReportOwnerFLG)
	 *            �l���|�[�g(=Report.personalReportOwnerFLG)
	 */
	public String getReportOwnerFLG() {
		return reportOwnerFLG;
	}

	/**
	 * ��ʃ^�C�v�����߂�B
	 * @return screenType ��ʃ^�C�v
	 */
	public String getDisplayScreenType() {
		return displayScreenType;
	}


	/**
	 * �f�t�H���g�`���[�g�̖��̂����߂�B
	 * @return currentChart �`���[�g�̖���
	 */
	public String getCurrentChart() {
		return currentChart;
	}

	/**
	 * �L���[�u�����߂�B
	 * @return ���|�[�gID
	 */
	public Cube getCube() {
		return cube;
	}

	/**
	 * ���I�u�W�F�N�g�̃��X�g�����߂�B
	 * @return ���I�u�W�F�N�g�̃��X�g
	 */
	public ArrayList<Edge> getEdgeList() {
		return edgeList;
	}

	/**
	 * �F�I�u�W�F�N�g�̃��X�g�����߂�B
	 * @return �F�I�u�W�F�N�g�̃��X�g
	 */
	public ArrayList<Color> getColorList() {
		return colorList;
	}

	/**
	 * ���Ԏ������Ă�true�A�����Ȃ����false��߂��B
	 * @return ���I�u�W�F�N�g�̃��X�g
	 */
	public boolean hasTimeDim() {
		return hasTimeDim;
	}

	/**
	 * �V�K�쐬���Ŗ��ۑ��̃��|�[�g�ł����true�A�������|�[�g�ł����false��߂��B
	 * @return �V�K���|�[�g��
	 */
	public boolean isNewReport() {
		return isNewReport;
	}

}

/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FAxis.java
 *  �����F���|�[�g�̃G�b�W�ɔz�u����鎲������킷abstract�N���X�ł��B
 *
 *  �쐬��: 2003/12/28
 */
package openolap.viewer;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionMemberDAO;


/**
 *  ���ۃN���X�FAxis<br>
 *  �����F���|�[�g�̃G�b�W�ɔz�u����鎲������킷���ۃN���X�ł��B
 */
public abstract class Axis implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** ����ID */
	final private String id;

	/** ���̖��� */
	final private String name;

	/** ���̃R�����g */
	final private String comment;

	/** ���̎��S���x����� */
	final private ArrayList<AxisLevel> axisLevelList;

	/** ���̃f�t�H���g�����o�[��Key(uniqueName) */
	protected String defaultMemberKey = null;

	/** ���̎������W���[��(true:���W���[,false:����) */
	final private boolean isMeasure;

	/** ���̎����Z���N�^�ɂ�郁���o�̍i���݂��s���Ă��邩�H */
	private boolean isUsedSelecter = false;

	/** ���̎������������o�[�̃��X�g */
	protected ArrayList<AxisMember> axisMemberList = new ArrayList<AxisMember>();

	// ********** �R���X�g���N�^ **********

	/**
	 *  ���|�[�g�̃G�b�W�ɔz�u����鎲������킷�I�u�W�F�N�g�𐶐����܂��B
	 */
	public Axis(String id, String name, String comment, ArrayList<AxisLevel> axisLevelList, String defaultMemberKey, boolean isMeasure, boolean isUsedSelecter) {
		this.id = id;
		this.name = name;
		this.comment = comment;
		this.axisLevelList = axisLevelList;
		this.isMeasure = isMeasure;
		this.isUsedSelecter = isUsedSelecter;
	}



	// ********** ���\�b�h **********

	/**
	 *  ���̃��x�����X�g�Ƀ��x�����iAxisLevel�I�u�W�F�N�g�j��o�^����B
	 */
	public void addAxisLevelList(AxisLevel axisLevel) {
		this.axisLevelList.add(axisLevel);
	}

	/**
	 *  �������o�[���X�g�Ɏ������o�[��o�^����B
	 * @param axisMem �������o�[������킷AxisMember�I�u�W�F�N�g
	 */
	public void addAxisMember(AxisMember axisMem) {
		this.axisMemberList.add(axisMem);
	}

	/**
	 *  �������o�[���X�g�Ɏ������o�[�̏W����o�^����B
	 * @param axisMemberList �������o�[������킷AxisMember�I�u�W�F�N�g�̏W���iArrayList�j
	 */	
	public void addAllAxisMember(ArrayList<AxisMember> axisMemberList) {
		this.axisMemberList.addAll(axisMemberList);
	}

	/**
	 *  �������o�[���X�g���N���A����B
	 */
	public void clearAxisMember() {
		this.axisMemberList.clear();
	}

	/**
	 *  ���̎��������o�[���X�g���A�w�肳�ꂽID�����������o�[�����߂�B
	 * @param id �������o�[��ID
	 * @return �������o�[���������AxisMember�I�u�W�F�N�g�A������Ȃ����null
	 */	
	public AxisMember getAxisMemberById(String id) {
		Iterator<AxisMember> it = this.axisMemberList.iterator();
		while (it.hasNext()) {
			AxisMember axisMember = it.next();
			if(axisMember.getId().equals(id)){
				return axisMember;
			}
		}
		return null;
	}

	/**
	 *  ���̎��������o�[���X�g���A�w�肳�ꂽuniqueName�����������o�[�����߂�B
	 * @param uName �������o�[��uniqueName
	 * @return �������o�[���������AxisMember�I�u�W�F�N�g�A������Ȃ����null
	 */	
	public AxisMember getAxisMemberByUniqueName(String uName) {
		Iterator<AxisMember> it = this.axisMemberList.iterator();

		while (it.hasNext()) {
			AxisMember axisMember = it.next();
			if(axisMember.getUniqueName().equals(uName)){
				return axisMember;
			}
		}
		return null;
	}


	/**
	 * ���̃f�t�H���g�����o�[�ł��鎲�����o�[�����߂�B<br>
	 * ���̃f�t�H���g�����o�[������ł���ꍇ�́A���̎������o�[���X�g�̂����A�擪�̎������o�[��߂��B<br>
	 * �����������o���X�g�Ƀf�t�H���g�����o�ł��鎲�����o���܂܂�Ă��Ȃ��ꍇ�́ADB�������擾����B
	 * @param conn Connection�I�u�W�F�N�g
	 * @return �������o�[���Aconn��null�̏ꍇ�܂��͎����Y�����郁���o�[�������Ȃ��ꍇ�Anull
	 * @exception SQLException DB����̎������o�擾�����ŗ�O����������
	 */
	public AxisMember getDefaultMember(Connection conn) throws SQLException {

		String defaultMemberKey = this.getDefaultMemberKey();		
		if (defaultMemberKey == null) { // �f�t�H���g�����o�[������

			if (this instanceof Dimension) {
				Dimension dim = (Dimension) this;
				DimensionMemberDAO dimMemDAO = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn);
				DimensionMember firstMember = dimMemDAO.getFirstMember(dim);
				return firstMember;

			} else {
				Measure measure = (Measure) this;
				MeasureMember firstMember = (MeasureMember) measure.getAxisMemberList().get(0);
				return firstMember;
			}

		} else { // �f�t�H���g�����o�[�����肵�Ă���

			AxisMember axisMember = this.getAxisMemberByUniqueName(defaultMemberKey);
			if ( axisMember == null ) {	// ���������o�������Ă��Ȃ��ꍇ(�����̏ꍇ�̂�)�ADB���猟��
				Dimension dim = null;
				if (this instanceof Dimension) {
					dim = (Dimension) this;
				} else {
					throw new IllegalStateException();
				}
				
				if (conn == null) {
					return null; 
				} else {
					DimensionMemberDAO dimMemDAO = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn);
					
					ArrayList<AxisMember> dimMemberList = dimMemDAO.selectDimensionMembers(dim, null,null,null,"'," + defaultMemberKey + ",'");
					if (dimMemberList.size() > 1) {
						throw new IllegalStateException();
					}
					
					return (DimensionMember) dimMemberList.get(0);
				}
			} else {
				return axisMember;
			}
		}
	}

	/**
	 * ���̃f�t�H���g�����o�[�ł��鎲�����o�[�̖��̂����߂�B<br>
	 * ���W���[�̏ꍇ�A���̂̓��W���[���ƂȂ邪�A�f�B�����V�����̏ꍇ��Dimension�̃C���X�^���X�ϐ�dispMemberNameType��<br>
	 * �ݒ肳�ꂽ���́i�����O�l�[�����V���[�g�l�[���̂��Âꂩ�j�ƂȂ�B 
	 * ���̃f�t�H���g�����o�[������ł���ꍇ�́A���̎������o�[���X�g�̂����A�擪�̎������o�[�̖��̂�߂��B<br>
	 * �����������o���X�g�Ƀf�t�H���g�����o�ł��鎲�����o���܂܂�Ă��Ȃ��ꍇ�́ADB�������擾����B
	 * @param conn Connection�I�u�W�F�N�g
	 * @return �������o�[���Aconn��null�̏ꍇ�܂��͎����Y�����郁���o�[�������Ȃ��ꍇ�Anull
	 * @exception SQLException DB����̎������o�擾�����ŗ�O����������
	 */
	public String getDefaultMemberName(Connection conn) throws SQLException {

		String defaultMemberKey = this.getDefaultMemberKey();		
		if (defaultMemberKey == null) { // �f�t�H���g�����o�[������

			if (this instanceof Dimension) {
				Dimension dim = (Dimension) this;
				DimensionMemberDAO dimMemDAO = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn);
				DimensionMember firstMember = dimMemDAO.getFirstMember(dim);
				return firstMember.getSpecifiedDisplayName(dim);

			} else {
				Measure measure = (Measure) this;
				MeasureMember firstMember = (MeasureMember) measure.getAxisMemberList().get(0);
				return firstMember.getMeasureName();
			}

		} else { // �f�t�H���g�����o�[�����肵�Ă���

			AxisMember axisMember = this.getAxisMemberByUniqueName(defaultMemberKey);
			if ( axisMember == null ) {	// ���������o�������Ă��Ȃ��ꍇ(�����̏ꍇ�̂�)�ADB���猟��
				Dimension dim = null;
				if (this instanceof Dimension) {
					dim = (Dimension) this;
				} else {
					throw new IllegalStateException();
				}
				
				if (conn == null) {
					return null; 
				} else {
					DimensionMemberDAO dimMemDAO = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn);
					
					ArrayList<AxisMember> dimMemberList = dimMemDAO.selectDimensionMembers(dim, null,null,null,"'," + defaultMemberKey + ",'");
					if (dimMemberList.size() > 1) {
						throw new IllegalStateException();
					}
					
					return ((DimensionMember) dimMemberList.get(0)).getSpecifiedDisplayName(dim);
				}
			} else {
				return axisMember.getSpecifiedDisplayName(this);
			}
		}
	}

	/**
	 * �f�t�H���g�����o�[���^����ꂽMap�I�u�W�F�N�g�Ɋ܂܂�Ȃ��ꍇ�́A�f�t�H���g�����o�[����������(null)����B
	 * @param memberNameDrillMap �V���Ɏ������o�Ƃ��đI�����ꂽ�����o�[�̖��̂ƃh������Ԃ�Map�I�u�W�F�N�g
	 */
	public void modifyDefaultMember(HashMap<String, String> memberNameDrillMap) {
		if(!memberNameDrillMap.containsKey(this.getDefaultMemberKey())) {
			this.setDefaultMemberKey(null);
		}
	}


	/**
	 * ���̃C���X�^���X�̕�����\�������߂�B
	 * @return String�I�u�W�F�N�g
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";
		stringInfo += "Axis.id:" + this.id + sep;
		stringInfo += "Axis.name:" + this.name + sep;
		stringInfo += "Axis.comment:" + this.comment + sep;
		stringInfo += "Axis.defaultMemberKey:" + this.defaultMemberKey + sep;

		stringInfo += "Axis.isMeasure:" + String.valueOf(this.isMeasure) + sep;
		stringInfo += "Axis.isUsedSelecter:" + String.valueOf(this.isUsedSelecter) + sep;

		//axisLevelList		// ���̎��S���x����� 
		//axisMemberList	// ���̎������������o�[�̃��X�g

		return stringInfo;

	}


	// ********** Setter ���\�b�h **********

	/**
	 * �f�t�H���g�����o�[�̃L�[���Z�b�g����B
	 * @param memberKey �������o�[�̃L�[(uniqueName)
	 */
	public void setDefaultMemberKey(String memberKey) {
		this.defaultMemberKey = memberKey;
	}
	/**
	 * �������o�[���X�g���Z�b�g����B
	 * @param axisMemberList �������o�[�̏W��
	 */
	public void setAxisMemberList(ArrayList<AxisMember> axisMemberList) {
		this.axisMemberList = axisMemberList;
	}
	/**
	 * ���̃Z���N�^���g�p����ă����o���i�荞�܂�Ă��邩�ǂ������Z�b�g����B
	 * @param b ���̃����o���Z���N�^�ɂ��i�荞�܂�Ă��邩
	 */
	public void setUsedSelecter(boolean b) {
		isUsedSelecter = b;
	}

	// ********** Getter ���\�b�h **********

	/**
	 * ��ID�����߂�B
	 * @return ��ID
	 */
	public String getId() {
		return id;
	}
	/**
	 * �����̂����߂�B
	 * @return ������
	 */
	public String getName() {
		return name;
	}
	/**
	 * ���̃R�����g�����߂�B
	 * @return ���R�����g
	 */
	public String getComment() {
		return comment;
	}
	/**
	 * ���̃��x����񃊃X�g�����߂�B
	 * @return ���̃��x����񃊃X�g
	 */	
	public ArrayList<AxisLevel> getAxisLevelList() {
		return axisLevelList;
	}
	/**
	 * ���̃f�t�H���g�����o�[�ł��鎲�����o�[��Key(uniqueName)�����߂�B
	 * @return �������o�[��Key(uniqueName)
	 */
	public String getDefaultMemberKey() {
		return defaultMemberKey;
	}
	/**
	 * �������W���[���ǂ��������߂�B
	 * @return �������W���[�ł���ꍇtrue�A���W���[�ł͂Ȃ��ꍇ�i���f�B�����V�����jfalse
	 */
	public boolean isMeasure() {
		return isMeasure;
	}
	/**
	 * ���̃Z���N�^���g�p����ă����o���i�荞�܂�Ă��邩�ǂ��������߂�B
	 * @return �Z���N�^�ɂ�胁���o���i�荞�܂�Ă���ꍇtrue�A�i�荞�܂�Ă��Ȃ��ꍇfalse
	 */
	public boolean isUsedSelecter() {
		return isUsedSelecter;
	}
	/**
	 * �������o�[���X�g�����߂�B<br>
	 * �f�B�����V�����̏ꍇ�́ADB�Ȃǂ��狁�߂�ꂽ�������o�[���X�g�̈ꎞ�ۑ��p�Ƃ��Ďg�p����A<br>��ɑS�Ă̎������o�[��ێ�����킯�ł͂Ȃ����Ƃɒ��ӂ���B
	 * @return �������o�[�̃��X�g
	 */
	public ArrayList<AxisMember> getAxisMemberList() {
		return axisMemberList;
	}

}

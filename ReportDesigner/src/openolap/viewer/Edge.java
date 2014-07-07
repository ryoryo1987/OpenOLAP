/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FEdge.java
 *  �����F�G�b�W������킷���ۃN���X�ł��B
 *
 *  �쐬��: 2004/12/29
 */

package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;

import openolap.viewer.common.Constants;

/**
 *  �N���X�FEdge<br>
 *  �����F�G�b�W������킷���ۃN���X�ł��B
 */
public abstract class Edge implements Serializable {

	// ********** �C���X�^���X�ϐ� **********	

	/** ���I�u�W�F�N�g�̃��X�g */
	final private ArrayList<Axis> axisList;

	// ********** �R���X�g���N�^ **********

	/**
	 * �G�b�W�I�u�W�F�N�g�𐶐����܂��B
	 */
	public Edge(ArrayList<Axis> axisList){
		this.axisList = axisList;
	}

	/**
	 * �G�b�W�I�u�W�F�N�g�𐶐����܂��B
	 */
	public Edge(Axis axis) {
		this.axisList = new ArrayList<Axis>();
		this.axisList.add(axis);
	}


	// ********** abstract ���\�b�h **********

	/**
	 * �G�b�W�̖��̂����߂�B
	 * @return �G�b�W�̖���
	 */
	public abstract String getPosition();

	// ********** �ÓI���\�b�h **********

	/**
	 * �G�b�W�����߂�B
	 * @param position ��A�s�A�y�[�W������킷���́iCOL,ROW,PAGE�j
	 * @param edgeList �G�b�W���X�g
	 * @return �G�b�W
	 */
	public static Edge getTheEdge(String position, ArrayList<Edge> edgeList) {
		if ((position == null) || (edgeList == null)) { throw new IllegalArgumentException();}
		if (edgeList.size() < 2) { throw new IllegalStateException();}

		if (position.equals(Constants.Col)) {
			return edgeList.get(0);
		} else if (position.equals(Constants.Row)) {
			return edgeList.get(1);
		} else if (position.equals(Constants.Page)) {
			return edgeList.get(2);
		} else {
			throw new IllegalStateException();
		}
	}


	// ********** ���\�b�h **********

	/**
	 * �^����ꂽ�������ꍇtrue�A�����Ȃ��ꍇfalse��߂��B
	 * @param oAxis ��������킷�I�u�W�F�N�g
	 * @return ���������ǂ���
	 */
	public boolean hasThisAxis(Axis oAxis){
		if (oAxis == null){ return false; }
		Iterator<Axis> it = this.getAxisList().iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis.getId().equals(oAxis.getId())) {
				return true;
			}
		}
		return false;
	}

	/**
	 * �^����ꂽ�������ꍇtrue�A�����Ȃ��ꍇfalse��߂��B
	 * @param oAxis ��ID
	 * @return ���������ǂ���
	 */
	public boolean hasThisAxis(String axisId) {
		if (axisList == null){ return false; }
		Iterator<Axis> it = this.getAxisList().iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis.getId().equals(axisId)) {
				return true;
			}
		}
		return false;
	}


	/**
	 * �^����ꂽ���̃G�b�W���ɂ����鎟�i�ɔz�u���ꂽ���̃����o�[�������߂�B
	 * (�Z���N�^�ŏ��O����Ă�����̂͊܂܂Ȃ�)
	 * �f�B�����V�����̎������o�[���X�g�͈ꎞ�I�Ɏg�p�������ł��邱�Ƃɒ��ӁB
	 * @param axis ��������킷�I�u�W�F�N�g
	 * @return �����o�[��
	 */
	public Integer getNextAxisMemberNums(Axis axis) {
		if (axis == null) { throw new IllegalArgumentException(); }
		if (this.hasThisAxis(axis) == false) { throw new IllegalArgumentException(); }
		Iterator<Axis> it = this.getAxisList().iterator();
		int i = 0;
		while (it.hasNext()) {
			Axis tmpAxis = it.next();
			if (axis.getId().equals(tmpAxis.getId())) {
				if(i == (this.getAxisList().size()-1)) { // �ŏI�i���w�肳�ꂽ�ꍇ
					return null;
				} else {

					Axis nextAxis = it.next();
//System.out.println("nextAxis:" + nextAxis.getName());
					Integer nextAxisMemberNums = null;
					if (nextAxis.isUsedSelecter()) {// �Z���N�^�ɂ��i���ݒ�
						Iterator<AxisMember> nextAxisMemIt = nextAxis.getAxisMemberList().iterator();
						int count = 0;
						while (nextAxisMemIt.hasNext()) {
							AxisMember axisMember = nextAxisMemIt.next();
							if (axisMember.isSelected()){
								count++;
							}
						}
						nextAxisMemberNums = new Integer(count);
					} else { // �Z���N�^�ɂ��i���ݒ��ł͂Ȃ�

						nextAxisMemberNums = new Integer( nextAxis.getAxisMemberList().size());
					}

					return nextAxisMemberNums;
				}
			}
			i++;
		}
		return null;
	}


	/**
	 * �^����ꂽ���̃G�b�W���ɂ����鎟�i�ȍ~�ɔz�u���ꂽ���̃����o�[���̐ς����߂�B
	 * (�Z���N�^�ŏ��O����Ă�����̂͊܂܂Ȃ�)
	 * �f�B�����V�����̎������o�[���X�g�͈ꎞ�I�Ɏg�p�������ł��邱�Ƃɒ��ӁB
	 * @param axis ��������킷�I�u�W�F�N�g
	 * @return �����o�[��
	 */
	public Integer getNextAxesMembersComboNums(Axis axis) {
		if (axis == null) { throw new IllegalArgumentException(); }
		if (this.hasThisAxis(axis) == false) { throw new IllegalArgumentException(); }
		Iterator<Axis> it = this.getAxisList().iterator();
		int i = 0;
		while (it.hasNext()) {
			Axis tmpAxis = it.next();
			if (axis.getId().equals(tmpAxis.getId())) {
				if(i == (this.getAxisList().size()-1)) { // �ŏI�i���w�肳�ꂽ�ꍇ
					return null;
				} else {

//System.out.println("nextAxis:" + nextAxis.getName());
					int nextAxesComboNums = 1;
					while (it.hasNext()) {
						Axis nextAxis = (Axis)it.next();

						if (nextAxis.isUsedSelecter()) {// �Z���N�^�ɂ��i���ݒ�
							Iterator<AxisMember> nextAxisMemIt = nextAxis.getAxisMemberList().iterator();
							int count = 0;
							while (nextAxisMemIt.hasNext()) {
								AxisMember axisMember = nextAxisMemIt.next();
								if (axisMember.isSelected()){
									count++;
								}
							}
							nextAxesComboNums = nextAxesComboNums * count;
						} else { // �Z���N�^�ɂ��i���ݒ��ł͂Ȃ�
	
							nextAxesComboNums = nextAxesComboNums * nextAxis.getAxisMemberList().size();
						}
					}

					return new Integer(nextAxesComboNums);
				}
			}
			i++;
		}
		return null;
	}

	/**
	 * �G�b�W���̗^����ꂽ�����O�ɔz�u���ꂽ���̃����o�[���̐ς����߂�B
	 * (�Z���N�^�ŏ��O����Ă�����̂͊܂܂Ȃ�)
	 * �f�B�����V�����̎������o���X�g�͈ꎞ�I�Ɏg�p�������ł��邱�Ƃɒ��ӁB
	 * @param axis ��������킷�I�u�W�F�N�g
	 * @return �����o�[��
	 */
	public Integer getBeforeAxesMembersComboNums(Axis axis) {
		if (axis == null) { throw new IllegalArgumentException(); }
		if (this.hasThisAxis(axis) == false) { throw new IllegalArgumentException(); }
		Iterator<Axis> it = this.getAxisList().iterator();
		ArrayList<Axis> beforeAxisList = new ArrayList<Axis>();
		while (it.hasNext()) {
			Axis tmpAxis = it.next();
			if (axis.getId().equals(tmpAxis.getId())) {
				if (beforeAxisList.size() == 0) {// 0�i�ڂ��w�肳�ꂽ�ꍇ
					return null;
				} else {
					int beforeAxesComboNums = 1;

					Iterator<Axis> beforeAxisIt = beforeAxisList.iterator();
					while (beforeAxisIt.hasNext()) {
						Axis beforeAxis = beforeAxisIt.next();
						if(beforeAxis.isUsedSelecter()) { // �Z���N�^�ɂ��i���ݒ�
							Iterator<AxisMember> beforeAxisMemIt = beforeAxis.getAxisMemberList().iterator();
							int count = 0;
							while (beforeAxisMemIt.hasNext()) {
								AxisMember axisMember = beforeAxisMemIt.next();
								if (axisMember.isSelected()) {
									count++;
								}
							}
							beforeAxesComboNums = beforeAxesComboNums * count;

						} else {// �Z���N�^�ɂ��i���ݒ��ł͂Ȃ�
							beforeAxesComboNums = beforeAxesComboNums * beforeAxis.getAxisMemberList().size();
						}
					}
					return new Integer(beforeAxesComboNums);
				}
			}
			beforeAxisList.add(tmpAxis);
		}
		return null;
	}


	/**
	 * �^����ꂽ���̃G�b�W�ɂ�����C���f�b�N�X�����߂�B
	 * �^����ꂽ�����G�b�W�ɂȂ��ꍇ�́A-1��߂��B
	 * @param oAxis ��������킷�I�u�W�F�N�g
	 * @return ���̃G�b�W�ɂ�����C���f�b�N�X
	 */
	public int getAxisIndexInEdge(Axis oAxis) {
		if (oAxis == null){ return -1; }
		Iterator<Axis> it = this.getAxisList().iterator();
		int i = 0;
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis.getId().equals(oAxis.getId())) {
				return i;
			}
			i++;
		}
		return -1;
	}

	/**
	 * �^����ꂽ���̃G�b�W�ɂ�����C���f�b�N�X�����߂�B
	 * �^����ꂽ�����G�b�W�ɂȂ��ꍇ�́A-1��߂��B
	 * @param axisId ��ID
	 * @return ���̃G�b�W�ɂ�����C���f�b�N�X
	 */
	public int getAxisIndexInEdge(String axisId) {
		if (axisId == null) { return -1; }
		Iterator<Axis> it = this.getAxisList().iterator();
		int i = 0;
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis.getId().equals(axisId)) {
				return i;
			}
			i++;
		}
		return -1;
	}

	/**
	 * ���Ԏ������ꍇtrue�A�����Ȃ��ꍇfalse��߂��B
	 * @return ���Ԏ�������
	 */
	public boolean investigateTimeDimension() {
		Iterator<Axis> it = this.axisList.iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if(!axis.isMeasure()) {
				Dimension dim = (Dimension)axis;
				if(dim.isTimeDimension()){
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * ���W���[�����߂�B
	 * ���W���[�������Ȃ��ꍇ�́Anull��߂��B
	 * @return ���W���[�I�u�W�F�N�g
	 */
	public Measure getMeasure() {
		Iterator<Axis> it = this.axisList.iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if(axis.isMeasure()) {
				return (Measure)axis;
			}
		}
		return null;
	}

	/**
	 * �G�b�W�Ɏ���ǉ�����B
	 * @param axis ��������킷�I�u�W�F�N�g
	 */
	public void addAxis(Axis axis) {
		if (axis == null){ throw new IllegalArgumentException(); }

		this.axisList.add(axis);
	}

	/**
	 * �G�b�W�̎������N���A����B
	 */
	public void clearAxis() {
		this.axisList.clear();
	}

	// ********** Getter ���\�b�h **********

	/**
	 * �G�b�W�̎������X�g�����߂�B
	 * @return ���I�u�W�F�N�g�̃��X�g
	 */
	public ArrayList<Axis> getAxisList() {
		return axisList;
	}

}

package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Sun Mar 19 23:17:45 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Sun Mar 19 23:17:45 CST 2023
     */
    int insert(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Sun Mar 19 23:17:45 CST 2023
     */
    int insertSelective(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Sun Mar 19 23:17:45 CST 2023
     */
    Clue selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Sun Mar 19 23:17:45 CST 2023
     */
    int updateByPrimaryKeySelective(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Sun Mar 19 23:17:45 CST 2023
     */
    int updateByPrimaryKey(Clue record);


    int insertClue(Clue clue);


    List<Clue> selectCluesByConditionsForPage(Map<String,Object> map);

    int selectCountOfClueByCondition(Map<String,Object> map);

    int deleteCluesByIds(String[] id);
}
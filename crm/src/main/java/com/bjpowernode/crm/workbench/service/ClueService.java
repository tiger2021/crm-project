package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Clue;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/19 23:23
 */

public interface ClueService {
    int saveClue(Clue clue);

    List<Clue> queryClueByConditionsForPage(Clue clue);
}

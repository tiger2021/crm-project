package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.mapper.ClueMapper;
import com.bjpowernode.crm.workbench.mapper.CustomerMapper;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/19 23:22
 */
@Service("clueService")
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    CustomerMapper customerMapper;

    @Override
    public int saveClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionsForPage(Map<String,Object> map) {
        return clueMapper.selectCluesByConditionsForPage(map);
    }

    @Override
    public int queryCountOfClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public int deleteCluesByIds(String[] id) {
        return clueMapper.deleteCluesByIds(id);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int updateClueById(Clue clue) {
        return clueMapper.updateClueById(clue);
    }

    @Override
    public Clue selectClueByIdForDetail(String id) {
        return clueMapper.selectClueByIdForDetail(id);
    }

    @Override
    public void saveConvertClue(Map<String, Object> map) {
        String clueId=(String)map.get("clueId");
        //根据ClueId查询线索
        Clue clue = clueMapper.selectClueByIdForConvert(clueId);
        User user = (User) map.get(Contants.SESSION_USER);
        //将线索中有关客户相关的内容保存到客户表中
          //封装参数
        Customer customer=new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setOwner(user.getId());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        //将封装好的Customer保存到客户表中
        int num = customerMapper.insertCustomer(customer);


//        Tran tran=new Tran();
//        //初始化tran
//        tran.setId(UUIDUtils.getUUID());
//        tran.setCreateBy(user.getId());
//        tran.setCreateTime(DateUtils.formateDateTime(new Date()));
//        String activityId=(String) map.get("activityId");
//        tran.setActivityId(activityId);
//        String money=(String)map.get("money");
//        tran.setMoney(money);
//        String name=(String)map.get("name");
//        tran.setMoney(name);


    }
}

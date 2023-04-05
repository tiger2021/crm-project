package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.FunnelVO;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.mapper.CustomerMapper;
import com.bjpowernode.crm.workbench.mapper.TranHistoryMapper;
import com.bjpowernode.crm.workbench.mapper.TranMapper;
import com.bjpowernode.crm.workbench.mapper.TranRemarkMapper;
import com.bjpowernode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;


/**
 * @Author 小镇做题家
 * @create 2023/4/3 21:58
 * @Description:
 */

@Service("transactionService")
public class TransactionServiceImpl implements TransactionService {
    @Autowired
    private TranMapper tranMapper;

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private TranHistoryMapper tranHistoryMapper;



    @Override
    public List<Tran> selectTransactionByCondition(Map<String, Object> map) {
        return tranMapper.selectTransactionByCondition(map);
    }

    @Override
    public int queryCountOfTransactionByConditionForPage(Map<String, Object> map) {
        return tranMapper.selectCountOfTransactionByConditionForPage(map);
    }

    @Override
    public void saveCreateTran(Map<String, Object> map) {
        User user=(User)map.get(Contants.SESSION_USER);
        //获取CustomerName
        String customerName = (String) map.get("customerName");
        //根据customerName查询customer
        Customer customer = customerMapper.selectCustomerByName(customerName);
        //判断是否customer是否存在
        if(customer==null){
            customer=new Customer();
            //封装参数，保存customer
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formateDateTime(new Date()));

            //调用Service保存
            customerMapper.insertCustomer(customer);
        }

        //保存创建的交易
        Tran tran=new Tran();
        tran.setStage((String) map.get("stage"));
        tran.setOwner((String) map.get("owner"));
        tran.setNextContactTime((String) map.get("nextContactTime"));
        tran.setName((String) map.get("name"));
        tran.setMoney((String) map.get("money"));
        tran.setId(UUIDUtils.getUUID());
        tran.setExpectedDate((String) map.get("expectedDate"));
        tran.setCustomerId(customer.getId());
        tran.setCreateTime(DateUtils.formateDateTime(new Date()));
        tran.setCreateBy(user.getId());
        tran.setContactSummary((String) map.get("contactSummary"));
        tran.setContactsId((String) map.get("contactsId"));
        tran.setActivityId((String) map.get("activityId"));
        tran.setDescription((String) map.get("description"));
        tran.setSource((String) map.get("source"));
        tran.setType((String) map.get("type"));
        //调用tranMapper保存tran
        tranMapper.insertTran(tran);

        //保存交易历史
        TranHistory tranHistory=new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formateDateTime(new Date()));
        tranHistory.setTranId(tran.getId());

        //调用service保存交易历史
        tranHistoryMapper.insertTransactionHistory(tranHistory);

    }

    @Override
    public Tran queryTransactionForDetailById(String id) {
        return tranMapper.selectTransactionForDetailById(id);
    }

    @Override
    public List<FunnelVO> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }

    @Override
    public List<Tran> queryTransactionByCustomerId(String customerId) {
        return tranMapper.selectTransactionByCustomerId(customerId);
    }

    @Override
    public void deleteTransactionAndTransactionRemarkByTransactionId(String id) {
        //先删除评论
        tranRemarkMapper.deleteTransactionRemarkByTranId(id);
        tranMapper.deleteTransactionById(id);
    }
}

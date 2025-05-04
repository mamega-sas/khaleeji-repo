/* 
    Rule Name : Number of transactions 
    Rule Description : If the total number of Financial transactions in a day(Debit/Credit) exceeds 7 and the cumulative  transaction value of all these transactions exceeds BD 300, trigger a fraud alert
*/
if message.solution.channelType in ('DM','DI')
   and message.solution.customerType = 'PE'
   and message.solution.source in ('ONEPAY','FDEFTSTRF','FDTRF','CCREDPAY','BILLPAY') then do;
    
   if profile.Customer.daily_fin_trx_count[1] > 7 and profile.Customer.total_amt_spent_daily[1] > 300 then do;
        detection.Alert();
    end;
end;
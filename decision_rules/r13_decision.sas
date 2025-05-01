/* 
    Rule Name: High Velocity
    Rule Desctiption:If the number of transactions are more than 10 in a 10 minute time frame ( single/multiple accounts), regardless of value, decline the transaction and alert is created.( Time being- Restrict to specific nationalities)
*/

dcl int tran_count;
tran_count = 0;

if message.solution.channelType in ('DM','DI')
and message.solution.customerType in  ('PE')
and message.solution.source in ('ONEPAY','FDEFTSTRF','FDTRF','CCREDPAY','BILLPAY')
and lists.Restricted_Nationalities.contains(message.Customer.nationality)
then do;
    do i = 1 to 50;
        if message.solution.messageDtTm - profile.Customer.financial_trx_dtm_arr[i] < dhms(0,0,10,0)
        and not missing(profile.Customer.financial_trx_dtm_arr[i])
        then do;
            tran_count = tran_count + 1;
        end;
    end;

    if tran_count > 10
    then do;
        detection.Alert();
        detection.Decline();
    end; 
end;

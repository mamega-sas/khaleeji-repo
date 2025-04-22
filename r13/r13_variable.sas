/* 
    Rule Name: High Velocity
    Rule Desctiption:If the number of transactions are more than 10 in a 10 minute time frame ( single/multiple accounts), regardless of value, decline the transaction and alert is created.( Time being- Restrict to specific nationalities)
*/


if message.solution.channelType in ('DM','DI')
and message.solution.customerType in  ('PE')
and message.solution.source in ('ONEPAY','FDEFTSTRF','FDTRF','CCREDPAY','BILLPAY','LOGIN','DEVICEREG','KYCUPDT','BENREG')
then do;
dcl int k;

    do i= 50 to 2 by -1;
    k=i-1;
    profile.Customer.transaction_dt[i]=profile.Customer.transaction_dt[k];
    end;

    profile.Customer.transaction_dt[1]= message.solution.messageDtTm;
end;
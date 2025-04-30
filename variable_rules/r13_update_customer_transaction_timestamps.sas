/* 
    Rule Name: High Velocity
    Rule Desctiption:If the number of transactions are more than 10 in a 10 minute time frame ( single/multiple accounts), regardless of value, decline the transaction and alert is created.( Time being- Restrict to specific nationalities)
*/


if message.solution.channelType in ('DM','DI')
and message.solution.source in ('ONEPAY','FDEFTSTRF','FDTRF','CCREDPAY','BILLPAY')
then do;
dcl int k;

    do i= 50 to 2 by -1;
        k=i-1;
        profile.customer.transaction_dt[i]=profile.customer.transaction_dt[k];
    end;

    profile.customer.transaction_dt[1]= message.solution.messageDtTm;
end;

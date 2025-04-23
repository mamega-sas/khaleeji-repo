/* 
    Rule Name: High Velocity
    Rule Desctiption:If the number of transactions are more than 10 in a 10 minute time frame ( single/multiple accounts), regardless of value, decline the transaction and alert is created.( Time being- Restrict to specific nationalities)
*/

dcl int x;
x=0;

if message.solution.channelType in ('DM','DI')
and message.solution.customerType in  ('PE')
and message.solution.source in ('ONEPAY','FDEFTSTRF','FDTRF','CCREDPAY','BILLPAY','LOGIN','DEVICEREG','KYCUPDT','BENREG')
then do;
    do i = 1 to 50;
        if lists.BlackListed_Nationalities.contains(message.customer.nationality)
        and message.solution.messageDtTm - profile.Customer.transaction_dt[i] < dhms(0,0,10,0)
        and not missing(profile.Customer.transaction_dt[i])
        then do;
        x=x+1;
        end;
    end;

    if x > 10
    then do;
    detection.Alert();
    detection.Decline();
    end; 

end;

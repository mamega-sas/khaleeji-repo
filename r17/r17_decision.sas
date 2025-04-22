/* 
    Rule Name: Multiple payments to same beneficiary
    Rule Desctiption: If there are more than 3 payments were made to a single beneficiary(from single customer with single/multiple accounts), payment amount is same and all were in last 15 minutes. Next transaction is declined( Specific Nationalitie
*/

if message.solution.channelType in ('DM','DI')
and message.solution.customerType in ('PE','BU')
and message.solution.source in ('ONEPAY','FDEFTSTRF','FDTRF','CCREDPAY','BILLPAY')
then do;
dcl int counter;
dcl int find_flag;
counter = 0;


    /*if payment amoun exist at the array*/
    do j = 1 to 50;
        if lists.nationality.contains(message.customer.nationality)
        and profile.beneficiary_customer.transaction_amount[j] = message.payment.amount
        and message.solution.messageDtTm - profile.beneficiary_customer.transaction_dt[j] < dhms(0,0,15,0)
        and profile.beneficiary_customer.transaction_amount[j] ^= 0
        and  profile.beneficiary_customer.transaction_dt[j] ^=0
        then do;
            counter = counter+1;
        end;
    end;
    profile.beneficiary_customer.counter = counter;
    if counter > 3
    then do;
    detection.Alert();
    detection.Decline();
    end;
end;


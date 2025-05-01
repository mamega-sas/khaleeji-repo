/* 
    Rule Name: Multiple payments to same beneficiary
    Rule Desctiption: If there are more than 3 payments were made to a single beneficiary(from single Customer with single/multiple accounts), payment amount is same and all were in last 15 minutes. Next transaction is declined( Specific Nationalitie
*/


if message.solution.channelType in ('DM','DI')
and message.solution.source in ('ONEPAY','FDEFTSTRF','FDTRF','CCREDPAY','BILLPAY')
then do;
    dcl int k;

    do i = 50 to 2 by -1;
        k=i-1;
        profile.beneficiary_customer.transaction_amount[i] = profile.beneficiary_customer.transaction_amount[k];
        profile.beneficiary_customer.transaction_dt[i]=profile.beneficiary_customer.transaction_dt[k];
    end;

    profile.beneficiary_customer.transaction_amount[1]= message.payment.amount;
    profile.beneficiary_customer.transaction_dt[1] = message.solution.messageDtTm;
end;

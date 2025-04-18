/* 
    Rule Name : Dormant/Low /Inactive Account
    Rule Description : No Transaction Happen in last 90 Days followed by a Transaction (Dr/Cr) more than BD 300 the Monthly Account Turnover as stated in account profile( Specific Nationalities)
*/

if message.solution.source in ('ONEPAY', 'FDEFTSTRE', 'FDTRE', 'CCREDPAY', 'BILLPAY')
 and message.solution.customerType = 'PE'
 and message.solution.channeltype in ('DM', 'DI')
 and message.authentication.decision = 'A'
 then do;
    if message.solution.messageDtTm - profile.Customer.last_tran_dt[2] >= dhms(90, 0, 0, 0)
    and message.payment.amount >= 300
    and lists.BlackListed_Nationalities.contains(message.customer.nationality)
    then do;
        detection.Alert();
    end;
end;
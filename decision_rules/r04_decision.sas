/* 
    Rule Name : Dormant/Low /Inactive Account
    Rule Description : No Transaction Happen in last 90 Days followed by a Transaction (Dr/Cr) more than BD 300 ( Specific Nationalities)
*/

if message.solution.source in ('ONEPAY', 'FDEFTSTRE', 'FDTRE', 'CCREDPAY', 'BILLPAY')
 and message.solution.customerType = 'PE'
 and message.solution.channeltype in ('DM', 'DI')
 and message.solution.messageDtTm - profile.Customer.financial_trx_dtm_arr[2] >= dhms(90, 0, 0, 0)
 and message.payment.amount >= 300
 and lists.Restricted_Nationalities.contains(message.Customer.nationality)
 and not missing(profile.Customer.financial_trx_dtm_arr[2])
 then do;
        detection.Alert();
    
end;

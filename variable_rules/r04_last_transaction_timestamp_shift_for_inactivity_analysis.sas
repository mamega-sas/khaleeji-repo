/* 
    Rule Name : Dormant/Low /Inactive Account
    Rule Description : No Transaction Happen in last 90 Days followed by a Transaction (Dr/Cr) more than BD 300 ( Specific Nationalities)
*/

if message.solution.source in ('ONEPAY', 'FDEFTSTRE', 'FDTRE', 'CCREDPAY', 'BILLPAY')
and message.solution.channeltype in ('DM', 'DI')
then do;
    profile.Customer.last_tran_dt[2] = profile.Customer.last_tran_dt[1];

    profile.Customer.last_tran_dt[1] = message.solution.messageDtTm;
end;
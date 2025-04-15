/* 
    Rule Name : Dormant/Low /Inactive Account
    Rule Description : No Transaction Happen in last 90 Days followed by a Transaction (Dr/Cr) more than BD 300 the Monthly Account Turnover as stated in account profile( Specific Nationalities)
*/

if message.solution.source in ('ONEPAY', 'FDEFTSTRE', 'FDTRE', 'CCREDPAY', 'BILLPAY')
and message.authentication.decision = 'A'
then do;
    profile.Customer.last_tran_dt[2] = profile.Customer.last_tran_dt[1];

    profile.Customer.last_tran_dt[1] = message.solution.messageDtTm;
end;
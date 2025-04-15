/* 
    Rule Name: Transactions occuring between 1 am to 5 am
    Rule Desctiption: If financial transactions are initiated between 1 am to 5am, an alert is generated
*/

Last Transaction Datetime(variable)
if message.solution.source in ('ONEPAY', 'FDEFTSTRE', 'FDTRE', 'CCREDPAY', 'BILLPAY')
and message.authentication.decision = 'A'
then do;
    profile.Customer.last_tran_dt[2] = profile.Customer.last_tran_dt[1];

    profile.Customer.last_tran_dt[1] = message.solution.messageDtTm;
end;
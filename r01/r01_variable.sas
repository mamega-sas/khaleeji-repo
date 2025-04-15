Last Transaction Datetime(variable)
if message.solution.source in ('ONEPAY', 'FDEFTSTRE', 'FDTRE', 'CCREDPAY', 'BILLPAY')
and message.authentication.decision = 'A'
then do;
    profile.Customer.last_tran_dt[2] = profile.Customer.last_tran_dt[1];

    profile.Customer.last_tran_dt[1] = message.solution.messageDtTm;
end;
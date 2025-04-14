Last Transaction Datetime(variable)
if message.solution.source in ('ONEPAY', 'FDEFTSTRE', 'FDTRE', 'CCREDPAY', 'BILLPAY')
and message.authentication.decision = 'A'
then do;
    profile.Customer.last_tran_dt[2] = profile.Customer.last_tran_dt[1];

    profile.Customer.last_tran_dt[1] = message.solution.messageDtTm;
end;

R004_Inactive Account (Decision)
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
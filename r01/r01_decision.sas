if message.solution.source in ('ONEPAY', 'FDEFTSTRE', 'FDTRE', 'CCREDPAY', 'BILLPAY')
 and message.solution.customerType = 'PE'
 and message.solution.channeltype in ('DM', 'DI')
 and message.authentication.decision = 'A'
 then do;
    if hms(0, 0, timepart(message.solution.messageDtTm)) >= hms(1,0,0) 
    and hms(0, 0, timepart(message.solution.messageDtTm)) <= hms(5,0,0)
    and message.demographic.status = 'A'
    then do;
        detection.Alert();
    end;
end;
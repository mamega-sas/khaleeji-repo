/* 
    Rule Name: Transactions occuring between 1 am to 5 am
    Rule Desctiption: If financial transactions are initiated between 1 am to 5am, an alert is generated
*/
if message.solution.source in ('ONEPAY', 'FDEFTSTRE', 'FDTRE', 'CCREDPAY', 'BILLPAY')
 and message.solution.customerType = 'PE'
 and message.solution.channeltype in ('DM', 'DI')
 and hms(0, 0, timepart(message.solution.messageDtTm)) >= hms(1,0,0) 
 and hms(0, 0, timepart(message.solution.messageDtTm)) <= hms(5,0,0)   
 then do;
        detection.Alert();
    
end;
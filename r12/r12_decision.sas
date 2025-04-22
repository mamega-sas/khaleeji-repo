/* 
    Rule Name: Blacklisted
    Rule Desctiption:Transaction made to blacklisted IBAN/mobile numbernationalities)
*/



if message.solution.source in ('ONEPAY', 'FDEFTSTRE', 'FDTRE', 'CCREDPAY', 'BILLPAY')
and message.solution.customerType in ('PE', 'BU')
and message.solution.channelType in ('DI', 'DM')
and  (lists.BlackList_Ibans.contains(message.creditaccount.iban) or
        lists.BlackListed_MobileNumbers.contains(message.creditaccount.mobilePhone))
then do;
    detection.Alert();
    detection.Decline();
end;
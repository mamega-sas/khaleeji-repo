/* 
    Rule Name: Blacklisted
    Rule Desctiption:Transaction made to blacklisted IBAN/mobile numbernationalities)
*/

if message.solution.source in ('ONEPAY', 'FDEFTSTRE', 'FDTRE', 'CCREDPAY', 'BILLPAY')
and message.solution.customerType in ('PE', 'BU')
and message.solution.channelType in ('DI', 'DM')
and  (lists.Blacklisted_IBANS.contains(message.creditaccount.iban) or
        lists.Blacklisted_Mobile_Numbers.contains(message.creditaccount.mobilePhone))
then do;
    detection.Alert();
    detection.Decline();
end;
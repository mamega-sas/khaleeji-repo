/* 
    Rule Name: Account profile changes
    Rule Desctiption: If there are changes in account profile like change in mobile number and if duration has not crossed more than12 hours. Decline the transaction if value is BHD 300 or its equivalent ( Restricted nationalities
*/

if message.solution.source in ('FDTRF', 'ONEPAY', 'FDEFTSTRF', 'BILLPAY','CCREDPAY') 
and message.solution.customerType = 'PE'
and not missing( profile.Customer.last_acc_change )
and message.solution.messageDtTm - profile.Customer.last_acc_change < dhms(0, 12, 0, 0) 
and message.payment.amount > 300 
and lists.Restricted_Nationalities.contains(message.Customer.nationality)then do;
    detection.Alert();
    detection.Decline();
end; 

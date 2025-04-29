/* 
    Rule Name: Account profile changes
    Rule Desctiption: If there are changes in account profile like change in mobile number and if duration has not crossed more than12 hours. Decline the transaction if value is BHD 300 or its equivalent ( Restricted nationalities
*/

if message.solution.source = 'KYCUPDT'
and message.authentication.decision = 'A' then do;
    profile.customer.last_acc_change = message.solution.messageDtTm;
end;

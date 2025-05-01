/* 
    Rule Name: High Velocity and Value
    Rule Desctiption: If payment is to a new single beneficiary(within 12 Hours)/one time payment  exceeds BD 300, transaction is declined and alert is created.( Specific Nationalities
*/



if message.solution.customerType = 'PE'
and message.solution.channelType in ('DI', 'DM')
and message.payment.amount > 300
and lists.BlackListed_Nationalities.contains(message.Customer.nationality)
and (
    (message.solution.source in ('FDEFTSTRF', 'FDTRF', 'CCREDPAY', 'BILLPAY')
    and message.solution.messageDtTm - profile.customer_and_Beneficiary.bene_reg_dt <= hms(12, 0, 0)
    and not missing(profile.customer_and_Beneficiary.bene_reg_dt))
    or
    message.solution.source = 'ONEPAY'
    )
then do;
    detection.Alert();
    detection.Decline();   
end;

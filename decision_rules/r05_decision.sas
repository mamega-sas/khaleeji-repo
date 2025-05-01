/* 
    Rule Name: Transaction Volume/Velocity
    Rule Desctiption: Trigger an alert if daily transaction value( Dr/Cr) is more than BD 300 (Specific Nationality)
*/

if message.solution.channelType in ('DM','DI')
and message.solution.customerType = 'PE'
and message.solution.source in ('ONEPAY','FDEFTSTRF','FDTRF','CCREDPAY','BILLPAY')
and  lists.Restricted_Nationalities.contains(message.Customer.nationality)
and profile.Customer.total_spend_daily_sum[1] >300
then do;
    detection.Alert();
end;

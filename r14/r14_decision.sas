if message.solution.source in ('FDTRF', 'ONEPAY', 'FDEFTSTRF', 'BILLPAY') 
and message.solution.customerType = 'PE'
and not missing( profile.customer_vs.last_acc_change )
and message.solution.messageDtTm - profile.customer_vs.last_acc_change < dhms(0, 12, 0, 0) 
and message.payment.amount > 300 
and lists.BlackListed_Nationalities.contains(message.customer.nationality)then do;
    detection.Alert();
    detection.Decline();
end; 
dcl int failed_login_count;
dcl double last_failed_login_dtm; 
dcl double current_dtm;
dcl int k;
dcl double interval;

if message.solution.source in ('FDTRF', 'ONEPAY', 'FDEFTSTRF', 'BILLPAY') 
and message.solution.customerType = 'PE' then do;
    failed_login_count = 0;
    current_dtm = message.solution.messageDtTm;
    last_failed_login_dtm = profile.customer_vs.failed_login_dtm_ar[1];
    do i = 2 to 6;        
        if not missing(profile.customer_vs.failed_login_dtm_ar[i]) 
        and profile.customer_vs.failed_login_dtm_ar[i] > last_failed_login_dtm then do;
            last_failed_login_dtm = profile.customer_vs.failed_login_dtm_ar[i];
        end;
    end;
    do k = 1 to 6;
        if abs(last_failed_login_dtm - profile.customer_vs.failed_login_dtm_ar[i]) < dhms(0,0,10,0)then failed_login_count = failed_login_count + 1;
    end;

    if failed_login_count > 1 and message.payment.amount > 300 and current_dtm < (last_failed_login_dtm + dhms(0,2,0,0)) then do;
        profile.customer_vs.last_failed_login_dtm = last_failed_login_dtm;
        detection.Alert();
        detection.Decline();
    end;
end;
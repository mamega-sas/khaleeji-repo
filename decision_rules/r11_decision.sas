/*
    Rule Name: Multiple failed login attempts 
    Rule Desctiption:If the customer consecutively  fails to login twice within 10 min time frame before the current outward financial transaction,  decline only if total of all such outward payment( in the next 2 hours post failed attempts) is exceeding BD 300.
        
    Key Variables:
    - failed_login_count: Tracks the number of failed login attempts within the specified time frame.
    - last_failed_login_dtm: Stores the timestamp of the most recent failed login attempt.
    - current_dtm: Captures the current transaction's timestamp.
    - interval: Represents the time difference between failed login attempts.

*/


dcl int failed_login_count;
dcl double last_failed_login_dtm; 
dcl double current_dtm;
dcl int k;
dcl double interval;

if message.solution.source in ('FDTRF', 'ONEPAY', 'FDEFTSTRF', 'BILLPAY', 'CCREDPAY') 
and message.solution.customerType = 'PE' then do;
    failed_login_count = 0;
    current_dtm = message.solution.messageDtTm;
    last_failed_login_dtm = profile.customer.failed_login_dtm_arr[1];
    do i = 2 to 6;        
        if not missing(profile.customer.failed_login_dtm_arr[i]) 
        and profile.customer.failed_login_dtm_arr[i] > last_failed_login_dtm then do;
            last_failed_login_dtm = profile.customer.failed_login_dtm_arr[i];
        end;
    end;
    do k = 1 to 6;
        if not missing(profile.customer.failed_login_dtm_arr[k]) and abs(last_failed_login_dtm - profile.customer.failed_login_dtm_arr[k]) < dhms(0,0,10,0) then failed_login_count = failed_login_count + 1;
    end;

    if failed_login_count > 1 and message.payment.amount > 300 and current_dtm < (last_failed_login_dtm + dhms(0,2,0,0)) then do;
        detection.Alert();
        detection.Decline();
    end;
end;
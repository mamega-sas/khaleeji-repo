/* 
    Rule Name : Failed login attempts
    Rule Description : If CIFholder has more than 5 failed login attempts in a week. Please generate an alert
*/

dcl int fail_count;
fail_count = 0;
if message.solution.channelType in ('DM','DI')
and message.solution.customerType in  ('PE', 'BU')
and message.solution.source in ('LOGIN')
and message.authentication.decision = 'R'
then do;
    do i = 1 to 6;
        if not missing(profile.customer.failed_login_dtm_arr[i])
        and message.solution.messageDtTm - profile.customer.failed_login_dtm_arr[i] < dhms(7,0,0,0)
        then do;
            fail_count = fail_count + 1;
        end;
    end;

    if fail_count > 5
    then do;
        detection.Alert();
    end;
end;

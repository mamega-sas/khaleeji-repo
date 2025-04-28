/* 
    Rule Name: Multiple failed login attempts 
    Rule Description:
    If the customer consecutively fails to login twice within a 10-minute time frame before the current outward financial transaction:
    - Decline the transaction only if:
        (a) Such outward financial transaction is to high-risk countries, and
        (b) The total of all such outward payments (in the next 2 hours post failed attempts) exceeds BD 300
*/

dcl int k;
if message.solution.source = 'LOGIN' 
   and message.authentication.decision = 'R'
   and message.solution.channelType in ('DM', 'DI')
   and message.solution.customerType = 'PE' then do;

    /* Set the array to zeros instead of nulls once only once, for safer comparisons */
    if profile.customer.null_array_flag = 0 then do;
        do j = 1 to 6;
            if missing(profile.customer.failed_login_dtm_ar[j]) then do;
                profile.customer.failed_login_dtm_ar[j] = 0;
            end;
        end;
        profile.customer.null_array_flag = 1;
    end;

    do i = 6 to 2 by -1;
        k = (i - 1);
        profile.customer.failed_login_dtm_ar[i] = profile.customer.failed_login_dtm_ar[k];
    end;
    profile.customer.failed_login_dtm_ar[1] = message.solution.messageDtTm;
end;
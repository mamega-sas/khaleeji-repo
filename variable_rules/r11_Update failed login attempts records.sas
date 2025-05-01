dcl int k;
if message.solution.source = 'LOGIN' 
   and message.authentication.decision = 'R'
   and message.solution.channelType in ('DM', 'DI') then do;

    /* Set the array to zeros instead of nulls once only once, for safer comparisons */
    if profile.Customer.null_array_flag = 0 then do;
        do j = 1 to 6;
            if missing(profile.Customer.failed_login_dtm_arr[j]) then do;
                profile.Customer.failed_login_dtm_arr[j] = 0;
            end;
        end;
        profile.Customer.null_array_flag = 1;
    end;

    do i = 6 to 2 by -1;
        k = (i - 1);
        profile.Customer.failed_login_dtm_arr[i] = profile.Customer.failed_login_dtm_arr[k];
    end;
    profile.Customer.failed_login_dtm_arr[1] = message.solution.messageDtTm;
end;
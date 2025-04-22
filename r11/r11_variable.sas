dcl int k;
if  message.solution.source = 'LOGIN' 
and message.authentication.decision = 'R'
and message.solution.customerType = 'PE' then do;

if profile.customer_vs.null_array_flag = 0 then do;
     do j = 1 to 6;
        if missing(profile.customer_vs.failed_login_dtm_ar[j]) then do;
            profile.customer_vs.failed_login_dtm_ar[j] = 0;
        end;
    end;
    profile.customer_vs.null_array_flag = 1;
end;
    do i = 6 to 2 by -1;
        k = (i-1);
        profile.customer_vs.failed_login_dtm_ar[i] = profile.customer_vs.failed_login_dtm_ar[k];
    end;
    profile.customer_vs.failed_login_dtm_ar[1] = message.solution.messageDtTm;
end;
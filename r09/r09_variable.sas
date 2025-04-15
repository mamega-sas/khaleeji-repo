/* 
    Rule Name : Failed login attempts
    Rule Description : If CIFholder has more than 5 failed login attempts in  a week. Please generate a alert
*/

if message.solution.channelType in ('DM','DI')
and message.solution.customerType in  ('PE', 'BU')
and message.solution.source in ('LOGIN','DEVICEREG','KYCUPDT','BENREG')
and message.authentication.decision = 'FAIL'
then do;
    dcl int k;

    do i= 6 to 2 by -1;
        k=i-1;
        profile.Customer.failed_login_dt[i]=profile.Customer.failed_login_dt[k];
    end;
    profile.Customer.failed_login_dt[1]= message.solution.messageDtTm;
end;

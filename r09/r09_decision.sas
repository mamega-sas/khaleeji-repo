/* 
    Rule Name : Failed login attempts
    Rule Description : If CIFholder has more than 5 failed login attempts in  a week. Please generate a alert
*/

dcl int y;
y=0;
if message.solution.channelType in ('DM','DI')
and message.solution.customerType in  ('PE', 'BU')
and message.solution.source in ('LOGIN','DEVICEREG','KYCUPDT','BENREG')
and message.authentication.decision = 'R'
then do;
    do i = 1 to 6;
        if message.solution.messageDtTm - profile.Customer.failed_login_dt[i] < dhms(7,0,0,0)
        and not missing (profile.Customer.failed_login_dt[i])
        then do;
        y =y+1;
        end; 
    end;
end;

profile.Customer.count = y;

if y > 5
then do;
detection.Alert();
end; 

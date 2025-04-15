/* 
    Rule Name : Multiple trusted  devices
    Rule Description : If an account holder logs in from multiple trusted devices within 30 minutes ( More than 2 devices) 
*/

dcl int counter;
counter =0;

if message.solution.source = 'LOGIN'
and message.solution.customerType = 'BU'
and message.solution.channelType = 'DM'
and message.authentication.decision = 'A'
then do;
    do i=1 to 5;
        if message.solution.messageDtTm - profile.Customer.devices_login_dt[i] <= hms(0, 30, 0)
        then counter =counter +1;
    end;
end;
profile.Customer.testcount = counter;

if counter > 2
then do;
detection.Alert();
 detection.Decline();
 end;
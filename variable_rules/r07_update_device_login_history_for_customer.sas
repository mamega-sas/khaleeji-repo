/* 
    Rule Name : Multiple trusted  devices
    Rule Description : If an account holder logs in from multiple trusted devices within 30 minutes ( More than 2 devices) 
*/

dcl int exist;
dcl int min_ind;
dcl double min_dt;

exist =0;
min_ind=1;
min_dt = 0;

if message.solution.source = 'LOGIN'
and message.authentication.decision = 'A'
and not missing(message.device.macAddress)
then do;
    do i =1 to 5;
		/* replace null values with 0 */
        if missing(profile.Customer.devices_login_dt[i] )
        then profile.Customer.devices_login_dt[i]= 0;
		
		/* check if device is exist */
        if profile.Customer.devices_id[i] = message.device.macAddress
        then do;
            exist =1;
            /* if device exists update the date */
            profile.Customer.devices_login_dt[i] = message.solution.messageDtTm;
        end;
		
		/* get min datetime */
	min_dt = min(min_dt,profile.Customer.devices_login_dt[i]);
	if min_dt = profile.Customer.devices_login_dt[i]
	then min_ind = i;
    end;


    if exist = 0
    then do;
        profile.Customer.devices_login_dt[min_ind] = message.solution.messageDtTm;
        profile.Customer.devices_id[min_ind] = message.device.macAddress;   
    end;
end;

dcl int exist;
dcl int min_ind;
dcl double min_dt;

exist =0;
min_ind=1;

if message.solution.source = 'LOGIN'
and message.authentication.decision = 'A'
then do;
    /* replace null values with 0 */
    do i =1 to 5;
        if missing(profile.Customer.devices_login_dt[i] )
            then profile.Customer.devices_login_dt[i]= 0;
    end;

    /* check if device is exist */
    do i =1 to 5;
        if profile.Customer.devices_id[i] = message.device.macAddress
        then exist =1;
    end;

    if exist = 0
    then do;
        /* get min datetime */
        min_dt = profile.Customer.devices_login_dt[1];
        do i=2 to 5;
            if profile.Customer.devices_login_dt[i] < min_dt
            then do;
                min_ind = i;
                min_dt = profile.Customer.devices_login_dt[i];
            end;
        end;
        profile.Customer.devices_login_dt[min_ind] = message.solution.messageDtTm;
        profile.Customer.devices_id[min_ind] = message.device.macAddress;   
    end;

    /* if device is exist update the date */
    else if exist =1
    then do;
        do i=1 to 5;
            if profile.Customer.devices_id[i] = message.device.macAddress
                then do;
                  profile.Customer.devices_login_dt[i] = message.solution.messageDtTm;
                end;
        end;
    end;
end; 
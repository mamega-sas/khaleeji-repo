/* 
    Rule Name: Single Device accessing multiple CIFs
    Rule Desctiption:If a single device is accessing multiple CIF( More than 2)( Time frame-in 30 minutes)
*/


dcl double current_dtm; 
dcl int login_count;

if message.solution.source = 'LOGIN' 
and message.authentication.decision = 'A' 
and message.solution.customerType = 'BU' 
and message.solution.channelType = 'DM' then do;
    current_dtm = message.solution.messageDtTm;
    login_count = 0;
    do i = 1 to 5;
        if not missing(profile.device.access_to_cif_dtm_arr[i]) and current_dtm - profile.device.access_to_cif_dtm_arr[i] < dhms(0,0,30,0)  then do;
        login_count = login_count + 1;
        end;
    end;

    if login_count > 1 then do;
        detection.Alert();
    end;
end;
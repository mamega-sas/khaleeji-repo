dcl double current_dtm; 
dcl int login_count;

if message.solution.source = 'LOGIN' and message.solution.customerType = 'BU' then do;
    current_dtm = message.solution.messageDtTm;
    login_count = 0;
    do i = 1 to 5;
        if not missing(profile.device_vs.cif_dtm_arr_of5_v2[i]) and current_dtm - profile.device_vs.cif_dtm_arr_of5_v2[i] < dhms(0,0,30,0)  then do;
        login_count = login_count + 1;
        end;
    end;

    if login_count > 1 then do;
        detection.Fire();
        detection.Alert();
    end;
end;
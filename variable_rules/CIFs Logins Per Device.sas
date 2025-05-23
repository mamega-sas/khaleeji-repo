/* 
    Rule Name: Single Device accessing multiple CIFs
    Rule Desctiption:If a single device is accessing multiple CIF( More than 2)( Time frame-in 30 minutes)
*/

dcl double current_time;
dcl varchar current_cif;
dcl int found_flag ;
dcl int arr_size;
dcl double oldest_dtm;
dcl int index_found;

if message.solution.source = 'LOGIN' 
and not missing(message.device.macAddress)
and message.authentication.decision = 'A' then do;

    current_time = message.solution.messageDtTm;
    current_cif = message.Customer.identifier;
    found_flag = 0;
    arr_size = hbound(profile.device.access_to_cif_dtm_arr);

    /* check if incoming cif exist in the arr  and update dtm if found*/
    do j = 1 to arr_size;
        if profile.device.cifs_accessed[j] = current_cif then do;
            profile.device.access_to_cif_dtm_arr[j] = current_time;
            found_flag = 1;
        end;
    end;
    
    /* if cif was not found */
    if found_flag = 0 then do;
        /* check for the oldest datetime in the array and return its index */
        oldest_dtm = profile.device.access_to_cif_dtm_arr[1];
        index_found = 1;
        do k = 2 to arr_size;
            if profile.device.access_to_cif_dtm_arr[k] < oldest_dtm then do;
                oldest_dtm = profile.device.access_to_cif_dtm_arr[k];
                index_found = k;
            end;
        end;
        
        if not missing(index_found) then do;
            profile.device.cifs_accessed[index_found] = current_cif;
            profile.device.access_to_cif_dtm_arr[index_found] = current_time;
        end;
    end;
end;
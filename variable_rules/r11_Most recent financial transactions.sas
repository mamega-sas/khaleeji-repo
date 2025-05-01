if message.solution.source in ('FDTRF', 'ONEPAY', 'FDEFTSTRF', 'BILLPAY', 'CCREDPAY')
and message.solution.channeltype in ('DM', 'DI')then do;
    dcl int k;
    do i = 50 to 2 by -1;
        k = (i-1);
        profile.Customer.financial_trx_amount_arr[i] = profile.Customer.financial_trx_amount_arr[k];
        profile.Customer.financial_trx_dtm_arr[i] = profile.Customer.financial_trx_dtm_arr[k];
    end;

    profile.Customer.financial_trx_dtm_arr[1] = message.solution.messageDtTm;
    profile.Customer.financial_trx_amount_arr[1] = message.payment.amount;
end;
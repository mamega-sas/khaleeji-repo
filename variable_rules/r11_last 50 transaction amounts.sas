if message.solution.source in ('FDTRF', 'ONEPAY', 'FDEFTSTRF', 'BILLPAY')
and message.solution.channeltype in ('DM', 'DI')then do;
    dcl int k;
    do i = 50 to 2 by -1;
        k = (i-1);
        profile.customer.last_50_trx_amount[i] = profile.customer.last_50_trx_amount[k];
        profile.customer.last_50_trx_dtm[i] = profile.customer.last_50_trx_dtm[k];
    end;

    profile.customer.last_50_trx_dtm[1] = message.solution.messageDtTm;
    profile.customer.last_50_trx_amount[1] = message.payment.amount;
end;
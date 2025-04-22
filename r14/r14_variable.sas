if message.solution.source = 'KYCUPDT' then do;
    profile.customer_vs.last_acc_change = message.solution.messageDtTm;
    detection.Fire();
end;
/* 
    Rule Name : Number of transactions 
    Rule Description : If the total number of Financial transactions in a day(Debit/Credit) exceeds 7 and the cumulative  transaction value of all these transactions exceeds BD 300, trigger a fraud alert.( Intially restricting alerts to specific nationalities)
*/

if profile.customer_vs.total_spend_daily_ct[1] > 7 and profile.customer_vs.total_spend_daily_sum[1] > 300 then do;
    detection.Alert();
end;
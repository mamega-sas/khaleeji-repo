/* 
    Rule Name : Number of transactions 
    Rule Description : If the total number of Financial transactions in a day(Debit/Credit) exceeds 7 and the cumulative  transaction value of all these transactions exceeds BD 300, trigger a fraud alert.( Intially restricting alerts to specific nationalities)
    Rule variables:
    - profile.customer_vs.total_spend_daily_dtm: Stores the timestamp of the last transaction.
    - profile.customer_vs.total_spend_daily_sum: An array tracking the total transaction amount per day.
    - profile.customer_vs.total_spend_daily_ct: An array tracking the count of transactions per day.
    - profile.customer_vs.interval: Stores the number of full days passed since the last transaction.
    - profile.customer_vs.interval_start: Stores the start time (midnight) of the last transaction's timestamp.
    - profile.customer_vs.interval_p: Stores the absolute value of the interval for backdated transactions.
    - profile.customer_vs.position: Maps interval to the array position for tracking backdated transactions.

*/

dcl double interval_start;
dcl int interval;
dcl int k;
dcl int absolute_p;
dcl int interval_p;
dcl int position;


/* calculate the sart time of daily interval */
/* get the start time (midnight) of the last transaction's timestamp */
/* interval_start = intnx('day', profile.customer_vs.total_spend_daily_dtm, 0);  */
interval_start = datepart(profile.customer_vs.total_spend_daily_dtm);


/* calculate how many full days passed since the last transaction */
/* interval = intck('day', interval_start, message.solution.messageDtTm); */
interval = datepart(message.solution.messageDtTm) - interval_start; 


/* update profile variables with interval data */
profile.customer_vs.interval = interval;
profile.customer_vs.interval_start = interval_start;

/*CASE(1): first transaction ever */
if profile.customer_vs.total_spend_daily_dtm = 0 then do;  
   /* initialize the first day's data with the current transaction */
   profile.customer_vs.total_spend_daily_sum[1] = message.payment.amount;
   profile.customer_vs.total_spend_daily_ct[1] = 1;
   profile.customer_vs.total_spend_daily_dtm = message.solution.messageDtTm;

   /* initialize the elements from 2->5 with 0 */
   do r = 5 to 2 by -1;
      profile.customer_vs.total_spend_daily_ct[r] = 0;
      profile.customer_vs.total_spend_daily_sum[r] = 0;
   end;
end;

/* CASE(2): subsecuent transactions */
else do;
   /* subcase(2-A) transaction in the same day */
   if interval = 0 then do;
      /* accumulate amount array and count array element no1 (current day) */
      profile.customer_vs.total_spend_daily_sum[1] = profile.customer_vs.total_spend_daily_sum[1] + message.payment.amount;
      profile.customer_vs.total_spend_daily_ct[1] = profile.customer_vs.total_spend_daily_ct[1] + 1;
   end;

   /* subcase(2-B) new day(s) passed already */
   else if interval > 0 then do;
      /* shift the array data one time for each day passed */
      do i = interval to 1 by -1;
         do j = 5 to 2 by -1;
            k = j - 1;
            profile.customer_vs.total_spend_daily_ct[j] = profile.customer_vs.total_spend_daily_ct[k];
            profile.customer_vs.total_spend_daily_sum[j] = profile.customer_vs.total_spend_daily_sum[k];
         end;
      /* if multiple days has passed reset element no1 as intermediate daysshould have no data */
      if i > 1 then do;
         profile.customer_vs.total_spend_daily_ct[1] = 0;
         profile.customer_vs.total_spend_daily_sum[1] = 0;
      end;
      else do;
         profile.customer_vs.total_spend_daily_dtm = message.solution.messageDtTm;
         profile.customer_vs.total_spend_daily_ct[1] = 1;
         profile.customer_vs.total_spend_daily_sum[1] = message.payment.amount;
      end;
      end;
   end;

   /* subcase(2-C) backdated transactions */
   interval_p = abs(interval);
   /* map interval to array position */
   position = interval_p + 1;
   profile.customer_vs.interval_p = interval_p;
   profile.customer_vs.position = position;

   if interval < 0 and interval_p <= 5 then do;
      profile.customer_vs.total_spend_daily_sum[position] = profile.customer_vs.total_spend_daily_sum[position] + message.payment.amount;
      profile.customer_vs.total_spend_daily_ct[position] = profile.customer_vs.total_spend_daily_ct[position] + 1;
   end;
end;
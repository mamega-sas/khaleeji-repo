/* 
    Rule variables:
    - profile.Customer.total_spend_daily_dtm: Stores the timestamp of the last transaction.
    - profile.Customer.total_amt_spent_daily: An array tracking the total transaction amount per day.
    - profile.Customer.daily_fin_trx_count: An array tracking the count of transactions per day.
    - profile.Customer.interval: Stores the number of full days passed since the last transaction.
    - profile.Customer.interval_start: Stores the start time (midnight) of the last transaction's timestamp.
    - profile.Customer.interval_p: Stores the absolute value of the interval for backdated transactions.
    - profile.Customer.position: Maps interval to the array position for tracking backdated transactions.

*/
if message.solution.channelType in ('DM','DI')
and message.solution.source in ('ONEPAY','FDEFTSTRF','FDTRF','CCREDPAY','BILLPAY')
then do;
   /* Declare variables */
   dcl double interval_start;
   dcl int interval;
   dcl int k;
   dcl int absolute_p;
   dcl int interval_p;
   dcl int position;


   /* calculate the sart time of daily interval */
   /* get the start time (midnight) of the last transaction's timestamp */
   /* interval_start = intnx('day', profile.Customer.total_spend_daily_dtm, 0);  */
   interval_start = datepart(profile.Customer.total_spend_daily_dtm);


   /* calculate how many full days passed since the last transaction */
   /* interval = intck('day', interval_start, message.solution.messageDtTm); */
   interval = datepart(message.solution.messageDtTm) - interval_start; 


   /* update profile variables with interval data */
   profile.Customer.interval = interval;
   profile.Customer.interval_start = interval_start;

   /*CASE(1): first transaction ever */
   if profile.Customer.total_spend_daily_dtm = 0 then do;  
      /* initialize the first day's data with the current transaction */
      profile.Customer.total_amt_spent_daily[1] = message.payment.amount;
      profile.Customer.daily_fin_trx_count[1] = 1;
      profile.Customer.total_spend_daily_dtm = message.solution.messageDtTm;

      /* initialize the elements from 2->5 with 0 */
      do r = 20 to 2 by -1;
         profile.Customer.daily_fin_trx_count[r] = 0;
         profile.Customer.total_amt_spent_daily[r] = 0;
      end;
   end;

   /* CASE(2): subsecuent transactions */
   else do;
      /* subcase(2-A) transaction in the same day */
      if interval = 0 then do;
         /* accumulate amount array and count array element no1 (current day) */
         profile.Customer.total_amt_spent_daily[1] = profile.Customer.total_amt_spent_daily[1] + message.payment.amount;
         profile.Customer.daily_fin_trx_count[1] = profile.Customer.daily_fin_trx_count[1] + 1;
      end;

      /* subcase(2-B) new day(s) passed already */
      else if interval > 0 then do;
         /* shift the array data one time for each day passed */
         do i = interval to 1 by -1;
            do j = 20 to 2 by -1;
               k = j - 1;
               profile.Customer.daily_fin_trx_count[j] = profile.Customer.daily_fin_trx_count[k];
               profile.Customer.total_amt_spent_daily[j] = profile.Customer.total_amt_spent_daily[k];
            end;
         /* if multiple days has passed reset element no1 as intermediate daysshould have no data */
         if i > 1 then do;
            profile.Customer.daily_fin_trx_count[1] = 0;
            profile.Customer.total_amt_spent_daily[1] = 0;
         end;
         else do;
            profile.Customer.total_spend_daily_dtm = message.solution.messageDtTm;
            profile.Customer.daily_fin_trx_count[1] = 1;
            profile.Customer.total_amt_spent_daily[1] = message.payment.amount;
         end;
         end;
      end;
      
      else if interval < 0 and interval >= -20 then do;
         /* subcase(2-C) backdated transactions */
         interval_p = abs(interval);
         /* map interval to array position */
         position = interval_p + 1;
         profile.Customer.interval_p = interval_p;
         profile.Customer.position = position;
         profile.Customer.total_amt_spent_daily[position] = profile.Customer.total_amt_spent_daily[position] + message.payment.amount;
         profile.Customer.daily_fin_trx_count[position] = profile.Customer.daily_fin_trx_count[position] + 1;
      end;
   end;
end;
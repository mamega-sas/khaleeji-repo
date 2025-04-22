/* 
    Rule Name: Transaction Volume/Velocity
    Rule Desctiption: Trigger an alert if daily transaction value( Dr/Cr) is more than BD 300 the total monthly account turnover as stated in account profile( Specific Nationality)
*/

if message.solution.channelType in ('DM','DI')
and message.solution.customerType = 'PE'
and message.solution.source in ('ONEPAY','FDEFTSTRF','FDTRF','CCREDPAY','BILLPAY')
then do;
	dcl double interval_start;
	dcl int interval;
	dcl int k;
	dcl int absolute_p;
	dcl int interval_p;
	dcl int position;

	interval_start = datepart(profile.Customer.total_spend_daily_dt);
	interval = datepart(message.solution.messageDtTm) - interval_start;

	/*set interval data at profile variables*/
	profile.customer.interval_start = interval_start;
	profile.customer.interval = interval;

	/*case(1): first transaction ever */
	if profile.Customer.total_spend_daily_dt =0
	then do;
	profile.Customer.total_spend_daily_sum[1] =message.payment.amount;
	profile.Customer.total_spend_daily_dt= message.solution.messageDtTm;
	profile.Customer.total_spend_daily_ct[1] =1;


	/*initialize fron 2 t0 20*/
		do r = 20 to 2 by -1 ;
		profile.customer.total_spend_daily_sum[r]=0;
		profile.customer.total_spend_daily_ct[r]=0;
		end;
	end;

	else do;
	if interval = 0
	then do;
	profile.customer.total_spend_daily_sum[1] = profile.customer.total_spend_daily_sum[1] + message.payment.amount;
	profile.customer.total_spend_daily_ct[1] = profile.customer.total_spend_daily_ct[1] + 1;
	end;

	else if interval > 0
		then do;
			do i = interval to 1 by -1; 
				do j= 20 to 2 by -1;
				k = j-1;
				profile.customer.total_spend_daily_ct[j] = profile.customer.total_spend_daily_ct[k];
				profile.customer.total_spend_daily_sum[j] = profile.customer.total_spend_daily_sum[k];
		end;

			if i > 1 
			then do;
			profile.customer.total_spend_daily_ct[1]=0;
			profile.customer.total_spend_daily_sum[1]=0;
			end;

			else do;
			profile.Customer.total_spend_daily_dt = message.solution.messageDtTm;
			profile.customer.total_spend_daily_ct[1]=1;
			profile.customer.total_spend_daily_sum[1] = message.payment.amount;
			end;
			end;
		end;

		interval_p=abs(interval);
		position = interval_p +1;
		profile.Customer.interval_p= interval_p;
		profile.Customer.position=position ;

		if interval < 0 and interval_p <= 20 
		then do;
		profile.Customer.total_spend_daily_sum[position]= profile.Customer.total_spend_daily_sum[position] + message.payment.amount;
		profile.Customer.total_spend_daily_ct[position] = profile.Customer.total_spend_daily_ct[position]  + 1 ;
		end;
	end;
end;

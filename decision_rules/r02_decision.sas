/* 
    Rule Name : Transactions occuring beyond working hours( 7pm- 6am) and transaction occuring on holiday 
    Rule Description : If any corporate account does any transactions outside working hours, holiday( Friday) and during holiday period 
 */
 
if message.solution.channelType in ('DM','DI')
and message.solution.customerType = 'BU'
and message.solution.source in ('ONEPAY','FDEFTSTRF','FDTRF','CCREDPAY','BILLPAY')
then do;
declare double transaction_datetime having format datetime20.;
declare double transaction_date having format date9. ;
declare double transaction_time having format time8. ;
declare int week_day;

transaction_datetime = message.solution.messageDtTm;
transaction_date = datepart(transaction_datetime);
transaction_time = timepart(transaction_datetime);
week_day = weekday(transaction_date);

    if lists.holiday_date.contains(put(transaction_date , date9.))
    or (transaction_time  >= hms(19,0,0) or transaction_time < hms(6,0,0))
    or week_day in (6,7)
    then do;
    detection.Alert();
    end;
end;

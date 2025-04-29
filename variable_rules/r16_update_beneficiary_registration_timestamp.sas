/* 
    Rule Name: High Velocity and Value
    Rule Desctiption: If payment is to a new single beneficiary(within 12 Hours)/one time payment  exceeds BD 300, transaction is declined and alert is created.( Specific Nationalities
*/

if message.solution.source = 'BENREG'
and message.authentication.decision = 'A'
then do;
   profile.Customer_and_Beneficiary.bene_reg_dt = message.solution.messageDtTm;
end;
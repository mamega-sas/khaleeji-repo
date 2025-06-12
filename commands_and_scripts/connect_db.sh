kubectl exec -it sas-crunchy-platform-postgres-00-mvnc-0 -- /bin/bash
psql -h sas-crunchy-platform-postgres-primary.sfdnp.svc -p 5432 -U dbmsowner -d SharedServices
59DR0XFvxm1kk8w1Tj9MSK4Q
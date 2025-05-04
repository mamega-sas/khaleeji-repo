#Stopping All Pods in sfdprem namespace
kubectl create job sas-stop-all-`date +%s` --from cronjobs/sas-stop-all -n sfdprem

#starting All Pods in sfdprem namespace
kubectl create job sas-start-all-`date +%s` --from cronjobs/sas-start-all -n sfdprem

#Getting All Pods in sfdprem
kubectl get pods -n sfdprem

#creating new image for docker
	1- docker pull ip-10-243-19-191.me-south-1.compute.internal:5000/fraudrepo/khaleejiorg:latest

	2- docker tag ip-10-243-19-191.me-south-1.compute.internal:5000/fraudrepo/khaleejiorg:latest 583616729562.dkr.ecr.me-south-1.amazonaws.com/fraud-repository/khaleejiorg:latest

	3- aws ecr get-login-password --region me-south-1 | docker login --username AWS --password-stdin 583616729562.dkr.ecr.me-south-1.amazonaws.com

	4- docker push 583616729562.dkr.ecr.me-south-1.amazonaws.com/fraud-repository/khaleejiorg:latest

#getting all pods in sfdnp
kubectl get pods -n sfdnp

#getting all pods in scr
kubectl get pods -n scr

#deleting scr pod
kubectl delete po "pod-name" -n scr
kubectl delete po "pod-name" -n sfdnp
kubectl delete po sas-sda-scr-khalorg-6d88fd95f-264lf -n scr


#Getting the configs for openlens
kubectl config view --minify --raw

#to run curl from inside pod
kubectl -n default exec -it debug-pod -- /bin/sh

#to connect to Postgres DB

	#get all pods related to crun
	kubectl get pods | grep crun
	
	#access one of the crunchy pods
	kubectl exec -it sas-crunchy-platform-postgres-00-mvnc-0 -- /bin/bash
	
	#connect to PSQL sharedservices
	psql -h sas-crunchy-platform-postgres-primary.sfdnp.svc -p 5432 -U dbmsowner -d SharedServices

	#enter password
	59DR0XFvxm1kk8w1Tj9MSK4Q
	
	#write SQL commands (CASE SENSITIVE and end with semi-colon)
	ex: SELECT * FROM alerts."domain";

#Message via CURL
curl -X POST 'http://10.243.10.205:32080/detection/decision/execute' -H "Content-Type: text/plain" -d '{"message":{"request":{"messageClassificationName":"SAMPLEmcns","restResponseFlg":0,"schemaName":"Card Fraud"},"solution":{"customerType":"NA","originationType":"NA","authenticationType":"NA","channelType":"NA","activityType":"CS"}}}'

#Query to get Access Token
ACCESS_TOKEN=`curl -skX POST "https://sfdnp.khaleeji.bank/SASLogon/oauth/token"  -H "Content-Type: application/x-www-form-urlencoded"  -d "grant_type=client_credentials" -u "client.cli:client.secret"| awk -F: '{print $2}'|awk -F\" '{print $2}'`; echo "The client access-token is: " ${ACCESS_TOKEN}; echo ${ACCESS_TOKEN} > ~/idtoken.txt



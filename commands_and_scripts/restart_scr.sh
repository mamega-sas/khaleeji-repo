# Creating a new Docker image
echo "Starting Docker image creation process..."

docker pull ip-10-243-19-191.me-south-1.compute.internal:5000/fraudrepo/khaleejiorg:latest
docker tag ip-10-243-19-191.me-south-1.compute.internal:5000/fraudrepo/khaleejiorg:latest 583616729562.dkr.ecr.me-south-1.amazonaws.com/fraud-repository/khaleejiorg:latest
aws ecr get-login-password --region me-south-1 | docker login --username AWS --password-stdin 583616729562.dkr.ecr.me-south-1.amazonaws.com
docker push 583616729562.dkr.ecr.me-south-1.amazonaws.com/fraud-repository/khaleejiorg:latest

echo "Docker image creation completed successfully!"

# Get all pod names in the "scr" namespace
echo "Retrieving pod names in the 'scr' namespace..."
pod_names=$(kubectl get pods -n scr --no-headers -o custom-columns=":metadata.name")

#deleting scr pod
if [ -n "$pod_names" ]; then
    echo "Deleting pods: $pod_names"
    kubectl delete pod $pod_names -n scr
else
    echo "No pods found in the namespace 'scr'."
fi
# camudna bpmn demo with docker and kubernetes
m254

kubectl run camunda-test --image camunda/camunda-bpm-platform:latest
kubectl get deployments camunda-test -o yaml
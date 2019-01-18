# camudna bpmn demo with docker and kubernetes
m254

kubectl run camunda-test --image camunda/camunda-bpm-platform:latest
kubectl get deployments camunda-test -o yaml


curl -w "\n" \
-H "Accept: application/json" \
-F "deployment-name=bestellung_verarbeiten" \
-F "enable-duplicate-filtering=true" \
-F "deploy-changed-only=true" \
-F "Bestellung_verarbeiten2.bpmn=@Bestellung_verarbeiten2.bpmn" \
http://localhost:8080/engine-rest/deployment/create


kubectl port-forward -n weave "$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040


find . -name '.DS_Store' -type f -delete
# DEPLOYMENT INSTRUCTIONS
This code can be deployed via manually or through Jenkins as a pipeline.
Below are the steps for provisioning via Manually and through Jenkins as a Pipeline Job.
## 1. Manual way
### Azure Auth and Create SP
Log in to Azure
- az login
- Create Service Principal
- az ad sp create-for-rbac -n az-fmc --role="Contributor" --scopes="/subscriptions/83780e21-6190-4668-a1bd-493f5527f0fd"
Note: Use the values generated here to export the variables in the next step
{
  "appId": "q43546576yjfewehjnbffr4567",
  "displayName": "az-fmc",
  "password": "324567kmjhgngbfvffgnhmjdbfd ",
  "tenant": "7679ihbvt67890ojhg678i"
}

### Set ENV Variable for Terraform Authentication to Azure
- Set env vars so that the service principal is used for authentication
export ARM_CLIENT_ID="SCDSBNHMYUJHXGFFNGHMTJY"
export ARM_CLIENT_SECRET=" aegtrhrtfgvfgtyjtyukyuhfvdfsdc "
export ARM_SUBSCRIPTION_ID="ldsjnvoejnfjldvn;jng;jn;jd "
export ARM_TENANT_ID="j4nt549jiwnveu9b92nd02"

### Create Storage Account and Storage Container for TF state Remote Backend (user defined for storage account)
- az group create --name tfbackend-fmc --location eastus
- az storage account create --resource-group tfbackend-fmc --name tfbackendfmcsatya --sku Standard_LRS --encryption-services blob
- az storage container create --name tfstate --account-name tfbackendfmcsatya
### Update providers TF file with the above created Storage Account and Container and initialize Terraform
- terraform init
- terraform apply -var=domain_name=domainname -var=ENV=ENVNAME -var=region=regionname -var=client_id="${client_id}" -var=client_secret="${client_secret}" -var=tenant_id="${tenant_id}" -var=subscription_id="${subscription_id}"  --auto-approve


## 2.Jenkins Pipeline

- Second method using the Jenkins, create a Jenkins JOb as a pipeline and provide this repo and jenkinsfile as find on this path.
You can first execute so, it will fetch the Jenkinsfile to create build with parameters and it would fail .i.e expected.
- Create a file /var/lib/jenkins/azurecreds with above azure credentials like below, as these will loaded to jenkins.
- env.client_id=" 2435467uyhgngbvdcaDwat54y6yh"
- env.client_secret=" 334566jghvdcsaewfrthhgbvcd "
- env.subscription_id="987tgky78jbtujkj"
- env.tenant_id="39876tfvbjoyghuonj hbj"
- On the second execution just click  on Build With Parameters and select/provide the region, environment, domain name, Terraform action and execute.

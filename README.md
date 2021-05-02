### deploy-url-status


### Terraform code example to automate deployment of the code inside [url-status]([https://github.com/itsabisek/url-status) repo to gcp.
Does the follow tasks-

- Creates a vpc
- Creates firewall rules to allow tcp, ssh and icmp
- Creates a e2-small compute engine instance with ubuntu boot disk 
- Bootstraps the environment on the vm by running the script <b>bootstrap_env.sh</b>.
  - Bootstrapping takes time and the log for the same can be found at /tmp/bootstrap.log inside the vm.

### Tasks to do
- Create a terraform.tfvars file inside main directory.
- Initialize the following variables in it
  - sa_creds - the json key file downloaded for the service account to be used by terraform
  - gcp_project - Name of the project inside which all the resources would be created
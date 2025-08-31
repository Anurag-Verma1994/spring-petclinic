project_id = "assessment-vermaanurag1794"
primary_region = "europe-west4"
secondary_region = "europe-west3"
environment = "prod"
domain_name = "gorillaclinic.nl"
min_instances = 50
max_instances = 400
container_concurrency = 80
service_account_name = "petclinic-sa"
github_owner = "Anurag-Verma1994"
github_repo = "spring-petclinic"
branch_pattern = "main"
location = "europe-west4"
repository_id = "petclinic"
lb_name = "petclinic-prod"
image = "gcr.io/assessment-vermaanurag1794/petclinic:latest"
primary_service_name = "petclinic-prod-primary"
secondary_service_name = "petclinic-prod-secondary"

# Note: global_lb_ip will be set automatically from the load balancer module output

environment_branch_mappings = {
  prod = {
    branch = "main"
    approval_required = false
  }
  staging = {
    branch = "staging"
    approval_required = false
  }
  test = {
    branch = "test"
    approval_required = false
  }
}
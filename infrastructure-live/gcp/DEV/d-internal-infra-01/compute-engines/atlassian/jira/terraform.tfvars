terragrunt = {
  terraform {
   source = "./../../../../../../../terraform-modules/gcp/modules/internal-infrastructure/compute-engines/"

    extra_arguments "common_var" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      arguments = [
        "-var-file=${get_tfvars_dir()}/../../../environment.tfvars",
        "-var-file=${get_tfvars_dir()}/../../../../folder.tfvars",
        "-var-file=${get_tfvars_dir()}/../../../../../org.tfvars",
      ]
    }
  }

  include {
    path = "${find_in_parent_folders("terraform-state.tfvars")}"
  }
}



instance_name = "d-atlassian-jira"
machine_type = "n1-standard-4"
image_name = "atlassian-jira-7-12-1-packer-1541627229"
boot_disk_size = 30
attached_disk_name = "d-jira-ssd-pd-01"
metadata_startup_script = "sudo mount /dev/sdb /atlassian/ && sudo /opt/atlassian/jira/bin/stop-jira.sh && sudo /opt/atlassian/jira/bin/start-jira.sh && sudo iptables -A INPUT -i ens4 -p tcp --dport 80 -j ACCEPT && sudo iptables -A INPUT -i ens4 -p tcp --dport 8080 -j ACCEPT && sudo iptables -A PREROUTING -t nat -i ens4 -p tcp --dport 80 -j REDIRECT --to-port 8080 && sudo iptables -t nat -I OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8080 && sudo iptables -A INPUT -i ens4 -p tcp --dport 443 -j ACCEPT && sudo iptables -A INPUT -i ens4 -p tcp --dport 8443 -j ACCEPT && sudo iptables -A PREROUTING -t nat -i ens4 -p tcp --dport 443 -j REDIRECT --to-port 8443 && iptables -t nat -I OUTPUT -p tcp -o lo --dport 443 -j REDIRECT --to-ports 8443"

labels = {
  owner="tf_artnet_resource",
  project="atlassian",
  application="jira"
}

project_remote_state_config = {
  project = "artnet-terraform-admin"
  bucket  = "artnet-terraform-admin"
  prefix  = "d-internal-infra-01/project/terraform.tfstate"
}

vpc_remote_state_config = {
  project = "artnet-terraform-admin"
  bucket  = "artnet-terraform-admin"
  prefix  = "d-internal-infra-01/vpc/vpc-1/terraform.tfstate"
}


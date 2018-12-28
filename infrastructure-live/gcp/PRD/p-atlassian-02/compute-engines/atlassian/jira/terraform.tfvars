terragrunt = {
  terraform {
   source = "git::git@github.com:artnetworldwide/terraform-modules.git//gcp/modules/compute-engines?ref=feature/gcp-atlassian-tf"

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


region   = "us-east4"
zone = "us-east4-b"
instance_name = "p-atlassian-jira"
machine_type = "n1-standard-4"
image_name = "atlassian-jira-7-12-1-packer-1538503118"
boot_disk_size = 30
attached_disk_name = "p-jira-ssd-pd-01"
metadata_startup_script = "sudo mount /dev/sdb /atlassian/ && sudo /opt/atlassian/jira/bin/stop-jira.sh && sudo /opt/atlassian/jira/bin/start-jira.sh && sudo iptables -A INPUT -i ens4 -p tcp --dport 80 -j ACCEPT && sudo iptables -A INPUT -i ens4 -p tcp --dport 8080 -j ACCEPT && sudo iptables -A PREROUTING -t nat -i ens4 -p tcp --dport 80 -j REDIRECT --to-port 8080 && sudo iptables -t nat -I OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8080 && sudo iptables -A INPUT -i ens4 -p tcp --dport 443 -j ACCEPT && sudo iptables -A INPUT -i ens4 -p tcp --dport 8443 -j ACCEPT && sudo iptables -A PREROUTING -t nat -i ens4 -p tcp --dport 443 -j REDIRECT --to-port 8443 && iptables -t nat -I OUTPUT -p tcp -o lo --dport 443 -j REDIRECT --to-ports 8443"

labels = {
  owner="tf_artnet_resource",
  project="atlassian",
  application="jira"
}

shared_vpc_project_remote_state_config = {
  project = "p-artnet-terraform-admin"
  bucket  = "p-artnet-terraform-admin"
  prefix  = "p-atlassian-02/vpc/terraform.tfstate"
}
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
project = "d-atlassian-02-4c84b6"
instance_name = "d-atlassian-confluence"
machine_type = "n1-standard-4"
image_name = "atlassian-confluence-7-12-1-packer-1538501141"
boot_disk_size = 30
attached_disk_name = "d-confluence-ssd-pd-01"
subnet_name = "subnet-1"
metadata_startup_script = "sudo mount /dev/sdb /atlassian/ && sudo sudo service confluence stop  && sudo service confluence start && sudo iptables -A INPUT -i ens4 -p tcp --dport 80 -j ACCEPT && sudo iptables -A INPUT -i ens4 -p tcp --dport 8090 -j ACCEPT && sudo iptables -A PREROUTING -t nat -i ens4 -p tcp --dport 80 -j REDIRECT --to-port 8090 && iptables -t nat -I OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8090"

labels = {
  owner="tf_artnet_resource",
  project="atlassian",
  application="confluence"
}

shared_vpc_project_remote_state_config = {
  project = "artnet-terraform-admin"
  bucket  = "artnet-terraform-admin"
  prefix  = "d-atlassian-02/vpc/terraform.tfstate"
}
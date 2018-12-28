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

instance_name = "p-atlassian-confluence"
machine_type = "n1-standard-4"
image_name = "atlassian-confluence-7-12-1-packer-1542235573"
boot_disk_size = 30
attached_disk_name = "p-confluence-ssd-pd-01"
metadata_startup_script = "sudo mount /dev/sdb /atlassian/ && sudo sudo service confluence stop  && sudo service confluence start && sudo iptables -A INPUT -i ens4 -p tcp --dport 80 -j ACCEPT && sudo iptables -A INPUT -i ens4 -p tcp --dport 8090 -j ACCEPT && sudo iptables -A PREROUTING -t nat -i ens4 -p tcp --dport 80 -j REDIRECT --to-port 8090 && iptables -t nat -I OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8090"

labels = {
  owner="tf_artnet_resource",
  project="atlassian",
  application="confluence"
}


project_remote_state_config = {
  project = "p-artnet-terraform-admin"
  bucket  = "p-artnet-terraform-admin"
  prefix  = "p-internal-infra-01/project/terraform.tfstate"
}

vpc_remote_state_config = {
  project = "p-artnet-terraform-admin"
  bucket  = "p-artnet-terraform-admin"
  prefix  = "p-internal-infra-01/vpc/vpc-1/terraform.tfstate"
}


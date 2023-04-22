variable "tenancy_id" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaaxnv3cwg4hc6knwgykm2scciq3jxu72ddwyi2ourwiejrp5fzaxda"
}

variable "root_compartment_id" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaaxnv3cwg4hc6knwgykm2scciq3jxu72ddwyi2ourwiejrp5fzaxda"
}

variable "user_id" {
  type    = string
  default = "ocid1.user.oc1..aaaaaaaaluexb6hltomjeyluqr6yz6sp6tw2pxisbq7cpuzhugtt4r3dnp3a"
}

variable "fingerprint" {
  type    = string
  default = "ab:3f:e4:f4:59:ce:2a:2c:c7:6f:23:1f:3d:3a:b9:c3"
}

variable "key_file_path" {
  type    = string
  default = "/home/jmangs/.oci/jmangs.key"
}

variable "ssh_public_key" {
  type    = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHz6ZnHBWSQqw9yw1YmguSzkFogeFSWtNbIETnnCZGQ5 jmangs@gmail.com"
}

variable "region" {
  type    = string
  default = "us-ashburn-1"
}
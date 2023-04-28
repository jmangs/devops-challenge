variable "compartment_id" {
  type = string
}

variable "availability_domain_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "image_id" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "shape" {
  type    = string
  default = "VM.Standard.E2.1.Micro"
}

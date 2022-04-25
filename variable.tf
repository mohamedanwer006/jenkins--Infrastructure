variable "instance_type" {
  default = "t2.micro"
  type    = string
}
variable "instance_ami" {
  type = string
}

variable "slave_ubuntu_ami" {
  type = string
}

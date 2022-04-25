variable "vm_admin_username" {
    default = "ubuntu"
    type    = string
}

variable "vm_size" {
    default = "Standard_F2"
    type    = string
}

variable "vm_user_data" {
 type = string   
}
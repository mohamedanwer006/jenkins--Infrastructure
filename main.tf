# VPC configuration

data "aws_vpc" "default_vpc" {
  default = true
}


# Add puplic key pair to allow SSH access to the instance
resource "aws_key_pair" "jenkins_key_pair" {
  key_name   = "jenkins_key_pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUvCew+1qRHPdMelxRfPWyrCYfZ1dC15uCAZHwzestNCaC2q4RUssm29e+rErIibfsTzdgQ6K3GOATP6N0WLckxoWZ49An5/1Qb9aSLnaSLsz7c4dP6EYRYwMSGUQJhQA5OphrFsq43s92xE6rE+2UnsTTEtZg4cAUcgX39VhvP7FnuGaBBha4JiDKYi59NOt47BmNXT/9jOHpQ55/phFXf30VXlp9hqZxhxdoBigIqbrownsRKWuMf2Um+D/zVs0hEiYQ0yrXGGhPHeBmlEpi/o4qIPHGIsXnJfaG1gedjHN0zOhxD7MX8qat5pnJs6HPgGakNrwu0a/8BRsOCMFoKKjUc8oH8LPuejJ7V9vgeiik/usuOEAaVacGWlMxjAfDU9smx0IHz3ntFF6XM5TraMavWXpn1lZlmL3NcCXIJahiNCu16V31zAzpnLcdh/DdZBEqMuaGTEPQaZnqBI8MPU5HrTM/KIiTVDdeqSN++LUsl1PUEPOKE8AQxudfcjc= mohamed@mohamed"
}



/*
*************************************************************
*               Master Instance  
*************************************************************
*/

resource "aws_instance" "jenkins_server" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = aws_key_pair.jenkins_key_pair.key_name
  user_data              = file("jenkins_init.sh")
  tags = {
    Name      = "jenkins_server"
    createdBy = "terraform"
  }
  root_block_device {
    delete_on_termination = true
  }
}



resource "aws_instance" "jenkins_server_slave" {
  ami                    = var.slave_ubuntu_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = aws_key_pair.jenkins_key_pair.key_name
  user_data              = file("slave_init.sh")
  tags = {
    Name      = "jenkins_server_slave"
    createdBy = "terraform"
  }
  root_block_device {
    delete_on_termination = true
  }

}


/*
*************************************************************
*               Slave Instance  
*************************************************************
*/


# module "slave_server" {
#   source            = "./modules/az-slave"
#   vm_user_data      = file("slave_init.sh")
#   vm_admin_username = "mohamed"
# }





# security group for jenkins server

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "security group for jenkins server"
  vpc_id      = data.aws_vpc.default_vpc.id
  tags = {
    Name      = "jenkins_sg"
    createdBy = "terraform : mohamedanwer006_admin"
  }
}

/*
*************************************************************
*                Inbound traffic 
*************************************************************
*/

# allow ssh 
resource "aws_security_group_rule" "jenkins_inbound_allow_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # allows ssh from anywhere just for easy testing 
  security_group_id = aws_security_group.jenkins_sg.id
}
# allow http traffic at port 8080
resource "aws_security_group_rule" "jenkins_inbound_allow_http" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # allows ssh from anywhere just for easy testing 
  security_group_id = aws_security_group.jenkins_sg.id

}


/*
*************************************************************
*               Outbound traffic 
*************************************************************
*/

# allow ssh to other instances
resource "aws_security_group_rule" "jenkins_outbound_allow_ssh" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_sg.id
}


# allow http / https for yum
resource "aws_security_group_rule" "jenkins_outbound_allow_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_sg.id
}

resource "aws_security_group_rule" "jenkins_outbound_allow_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_sg.id
}

output "jenkins_server" {
  value ="Jenkins master at = > http://${aws_instance.jenkins_server.public_ip}:8080 \n ssh ec2-user@${aws_instance.jenkins_server.public_ip} -i ~/.ssh/jenkins_key_pair.pem"
}

output "slave_server" {
  value ="   Slave at       = > http://${aws_instance.jenkins_server_slave.public_ip} \n ssh ec2-user@${aws_instance.jenkins_server_slave.public_ip} -i ~/.ssh/jenkins_key_pair.pem "
}
# output "slave_server" {
#   value ="Slave at         = > http://${module.slave_server.az-salve-ip}"
# }

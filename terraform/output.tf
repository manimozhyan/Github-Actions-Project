output "instance_id" {
  value = aws_instance.githubactions_vm.id
}

output "public_ip" {
  value = aws_instance.githubactions_vm.public_ip
}

output "security_group_id" {
  value = aws_security_group.githubaction_vm_sg.id
}
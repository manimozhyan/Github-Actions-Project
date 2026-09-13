resource "aws_security_group" "githubaction_vm_sg" {
  name        = "githubaction-vm-sg"
  description = "Security group for GitHub Actions VM"

  dynamic "ingress" {
    for_each = var.ingress_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "githubaction-vm-sg"
  }
}

resource "aws_instance" "githubactions_vm" {
  ami                         = var.ami_id
  instance_type               = "t2.medium"
  key_name                    = "linux-vm-key"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.githubaction_vm_sg.id
  ]

  root_block_device {
    volume_size = 40
    volume_type = "gp3"
  }

  tags = {
    Name = "githubactions"
  }
}
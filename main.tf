
resource "aws_s3_bucket" "aws-s3-december" {

  bucket = "mantesh-bucket-2025"

  tags = {
    name = "new-bucket"
    #Env  = "Dev"
  }

}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "${var.env}-ec2-key-pair"
  public_key = file("id_ed25519.pub")
}

resource "aws_default_vpc" "my_vpc" {
  tags = {
    name = "my_vpc"
  }
}

resource "aws_security_group" "globant_sg" {

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]

  }

}

# locals {
#   instance_name = ["web","api","batch"]
# }

resource "aws_instance" "my_ec2_instance" {
  for_each =  tomap({             # meta argument
    aws_first_instance = "t2.micro",
    #aws_second_instance = "t2.medium"
  })               

  ami                    = var.ec2_instance_ami
  instance_type          = each.value
  region                 = "us-east-1"
  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.globant_sg.id]
  user_data = file("install_nginx.sh")

  root_block_device {
    volume_size = var.env == "prod" ? 15  : var.roor_block_device_size
    volume_type = "gp3"
  }

  tags = {
    name = each.key
    Environment = var.env
  }
  depends_on = [ 
          aws_key_pair.my_key_pair,
          aws_default_vpc.my_vpc,
          aws_security_group.globant_sg
   ]  
}

# import {
#   to = aws_key_pair.my_key_pair
#   id = "ec2-key-pair"
# }


# resource "aws_instance" "my_vm" {

  
# }
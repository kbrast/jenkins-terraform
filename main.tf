resource "aws_instance" "jenkins" {
  ami           = var.ami_id
  instance_type = var.instance_type

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install java-1.8.0-openjdk -y
              wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
              rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
              sudo yum install jenkins -y
              sudo service jenkins start
              EOF

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_security_group" "jenkins-sg" {
  name_prefix = "jenkins-sg-"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_s3_bucket" "jenkins-artifacts" {
  bucket = "jenkins-artifacts-${random_id.random.hex}"
  acl    = "private"

  tags = {
    Name = "jenkins-artifacts"
  }
}
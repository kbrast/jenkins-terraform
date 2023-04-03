# Create a new EC2 instance
resource "aws_instance" "jenkins" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # Bootstrap the instance with a script that installs and starts Jenkins
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y java-1.8.0-openjdk-devel
              sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
              sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
              sudo yum install -y jenkins
              sudo systemctl start jenkins
              sudo systemctl enable jenkins
              EOF

  # Create and assign a security group to the Jenkins EC2 instance
  vpc_security_group_ids = [aws_security_group.jenkins.id]

  # Add tags to the EC2 instance
  tags = {
    Name = "Jenkins"
  }
}

# Create a new security group for the Jenkins EC2 instance
resource "aws_security_group" "jenkins" {
  name_prefix = "jenkins"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["Your_Public_IP/32"]
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
}

# Create a new S3 bucket for Jenkins artifacts
resource "aws_s3_bucket" "jenkins" {
  bucket = var.jenkins_s3_bucket_name
}

# Deny public access to the S3 bucket
resource "aws_s3_bucket_acl" "jenkins" {
  bucket = aws_s3_bucket.jenkins.id
  acl    = "private"
}

# Output the Jenkins server URL
output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080/"
}

# Retrieve the default VPC ID
data "aws_vpc" "default" {
  default = true
}
variable "region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-09e67e426f25ce0d7" # Amazon Linux 2 AMI
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ssh_key_name" {
  default = "KWBkey"
}

variable "jenkins_s3_bucket_name" {
  default = "terraform-jenkins-bucket-04022023"
}
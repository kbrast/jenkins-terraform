variable "region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-04581fbf744a7d11f" # Amazon Linux 2 AMI
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ssh_key_name" {
  default = "KWBkey"
}

variable "jenkins_s3_bucket_name" {
  default = "your-jenkins-bucket-name-040223a"
}
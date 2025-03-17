variable "instance_count" {
  type = string
  default = "1"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "instance_type" {
  type = string
  default = "t2.nano"
}

variable "network" {
  type = string
  default = "vpc-596aa03e"
}

variable "subnet" {
  type = string
  default = "subnet-7e3fd71a"
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "tags" {
  type = map
  default = {
    us-east-1 = "image-1234"
    us-west-2 = "image-4567"
  }
}

variable "cluster-name" {
  type = string
  default = "new"
}

variable "availability_zone" {
  description = "AWS availability zone to launch the VM into"
  default     = "us-east-1a"
}

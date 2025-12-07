variable "ec2_instance_ami" {
  type        = string
  description = "the ami value for ec2 instance"
  default     = "ami-0ecb62995f68bb549"
}

variable "ec2_instance_type" {
  type        = string
  description = "the instance type value for ec2 instance"
  default     = "t2.micro"

}

variable "roor_block_device_size" {
  type    = number
  default = 10

}

variable "env" {
    type = string
    default = "dev" 
}


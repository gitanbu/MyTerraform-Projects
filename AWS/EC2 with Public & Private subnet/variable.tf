variable "cidr_block" {
  default     = " "
  type        = string
  description = "CIDR block for the VPC"
}

variable "AWS_REGION" {
  default     = " "
  type        = string
}

variable "KEY_PAIR" {
  description = "KEY PAIR"
}

variable "availability_zone" {
  default     = " "
  description = "availability_zone"
}

variable "instance_type" {
  default     = " "
  description = "instance_type"
  
}

variable "ami_id" {
  default = " "
  description = "ami_id"
  
}

variable "secgrpname" {
  default = ""
  description = "security group name"

}
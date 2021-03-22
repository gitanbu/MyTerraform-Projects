#--------------- AWS tfvars----------------------#
AWS_REGION            = "us-east-2"

KEY_PAIR              = "sha-backend-test-key"

cidr_block            = "10.0.0.0/24"

availability_zone     = "us-east-1a"

instance_type         = "t2.micro"

ami_id                = "ami-0ac019f4fcb7cb7e6"

secgrpname            = "allow_ssh_sg"
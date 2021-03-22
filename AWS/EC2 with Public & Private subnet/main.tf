resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

resource "aws_route_table" "my_vpc_us_east_1a_public" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_igw.id
    }

    tags = {
        Name = "Public Subnet Route Table."
    }
}

resource "aws_route_table_association" "my_vpc_us_east_1a_public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.my_vpc_us_east_1a_public.id
}

resource "aws_security_group" "allow_ssh" {
  name        = var.secgrpname 
  description = "Allow SSH inbound connections"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.secgrpname 
  }
}


resource "aws_instance" "my_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = var.KEY_PAIR
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true

  tags = {
    Name = "My Instance"
  }
}

resource "aws_subnet" "nated" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "NATed Subnet"
  }
}


resource "aws_eip" "nat_gw_eip" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public.id
}


resource "aws_route_table" "my_vpc_us_east_1a_nated" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.gw.id
    }

    tags = {
        Name = "Main Route Table for NAT-ed subnet"
    }
}

resource "aws_route_table_association" "my_vpc_us_east_1a_nated" {
    subnet_id = aws_subnet.nated.id
    route_table_id = aws_route_table.my_vpc_us_east_1a_nated.id
}

resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = var.KEY_PAIR
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  subnet_id = aws_subnet.nated.id
  associate_public_ip_address = false

  tags = {
    Name = "Private Instance"
  }
}
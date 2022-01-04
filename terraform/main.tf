provider "aws"{
    region = "us-east-1"
    access_key  = ""
    secret_key = ""
}

### VPC, INTERNET GATEWAY AND NAT GATEWAY###

# Create a VPC
resource "aws_vpc" "main"{
    cidr_block = "10.2.0.0/16"

    tags = {
        Name = "my-vpc"
    }
}


# Create an Internet Gateway and attach to a VPC
resource "aws_internet_gateway" "default"{
    depends_on = [
        aws_vpc.main,
    ]

    vpc_id = aws_vpc.main.id

    tags = {
        Name = "my-igw"
    }
}


# Create 1 nat gateway
resource "aws_eip" "elastic_ip"{
    vpc = true

    tags = {
        Name = "nat_gw_elastic_ip"
    }
}

resource "aws_nat_gateway" "nat_gw"{
    depends_on = [
        aws_subnet.public_3,
        aws_eip.elastic_ip,
    ]

    allocation_id = aws_eip.elastic_ip.id
    subnet_id = aws_subnet.public_3.id

    tags = {
        Name = "nat-gw"
    }
}


# Create private route table
resource "aws_route_table" "nat_rt"{
    depends_on = [
        aws_vpc.main,
        aws_nat_gateway.nat_gw,
    ]

    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_gw.id
    }

    tags = {
        Name = "nat_rt"
    }
}

resource "aws_route_table_association" "associate_rt_to_private_subnet"{
    depends_on = [
        aws_subnet.private_1,
        aws_route_table.nat_rt,
    ]

    subnet_id = aws_subnet.private_1.id
    route_table_id = aws_route_table.nat_rt.id
}

### SECURITY GROUPS ###

# Bastion host security group
resource "aws_security_group" "sg_default"{
    depends_on = [
        aws_vpc.main,
    ]

    name = "sg bastion host"
    description = "bastion host security group"
    vpc_id = aws_vpc.main.id

  # ssh access from anywhere  
  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      description =  "All IPV4 ICMP"
      from_port = -1
      to_port = -1
      protocol = "icmp"
      cidr_blocks = ["10.2.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "sg_default"
  }
}


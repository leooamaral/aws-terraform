### SUBNETS ###

# Create 4 subnets - 1 private and 3 public in different az
resource "aws_subnet" "public_1"{
    depends_on = [
        aws_vpc.main,
    ]

    vpc_id = aws_vpc.main.id
    cidr_block = "10.2.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "Public 1"
    }
}

resource "aws_subnet" "public_2"{
    depends_on = [
        aws_vpc.main,
    ]

    vpc_id = aws_vpc.main.id
    cidr_block = "10.2.2.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Name = "Public 2"
    }
}

resource "aws_subnet" "public_3"{
    depends_on = [
        aws_vpc.main,
    ]

    vpc_id = aws_vpc.main.id
    cidr_block = "10.2.3.0/24"
    availability_zone = "us-east-1c"

    tags = {
        Name = "Public 2"
    }
}

resource "aws_subnet" "private_1"{
    depends_on = [
        aws_vpc.main,
    ]

    vpc_id = aws_vpc.main.id
    cidr_block = "10.2.4.0/24"
    availability_zone = "us-east-1d"

    tags = {
        Name = "Private"
    }
}


# Create pub route table
resource "aws_route_table" "ig_rt"{
    depends_on = [
        aws_vpc.main,
        aws_internet_gateway.default,
    ]

    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.default.id
    }

    tags = {
        Name = "igw_rt"
    }
}

locals {
    subs = concat([aws_subnet.public_1.id], [aws_subnet.public_2.id], [aws_subnet.public_3.id])
}

resource "aws_route_table_association" "associate_rt_to_public_subnet"{
    depends_on = [
        aws_subnet.public_1,
        aws_subnet.public_2,
        aws_subnet.public_3,
        aws_route_table.ig_rt,
    ]

    count = 3

    subnet_id = element(local.subs, count.index)

    route_table_id = aws_route_table.ig_rt.id
}


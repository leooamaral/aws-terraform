# Bastion Host instance
resource "aws_instance" "bastion_host"{
    depends_on = [
        aws_subnet.public_3,
        aws_security_group.sg_default,
    ]

    ami = "ami-0ed9277fb7eb570c9"
    instance_type = "t2.micro"
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sg_default.id]
    subnet_id = aws_subnet.public_3.id

    tags = {
        Name = "bastion host"
    }
}

resource "aws_eip" "bastion_eip" {
    vpc = true
    instance                  = aws_instance.bastion_host.id
    depends_on                = [aws_internet_gateway.default]

    tags = {
        Name = "bastion_elastic_ip"
    }
}


# 2 Public instances
resource "aws_instance" "pub_1"{
        depends_on = [
        aws_subnet.public_1,
        aws_security_group.sg_default,
    ]

    ami = "ami-061ac2e015473fbe2"
    instance_type = "t2.micro"
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sg_default.id]
    subnet_id = aws_subnet.public_1.id

    tags = {
        Name = "Public 1 host"
    }
}

resource "aws_eip" "pub_1" {
    vpc = true
    instance                  = aws_instance.pub_1.id
    depends_on                = [aws_internet_gateway.default]
    
    tags = {
        Name = "pub_1_elastic_ip"
    }
}

resource "aws_instance" "pub_2"{
        depends_on = [
        aws_subnet.public_2,
        aws_security_group.sg_default,
    ]

    ami = "ami-0b0af3577fe5e3532"
    instance_type = "t2.micro"
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sg_default.id]
    subnet_id = aws_subnet.public_2.id

    tags = {
        Name = "Public 2 host"
    }
}

resource "aws_eip" "pub_2" {
    vpc = true
    instance                  = aws_instance.pub_2.id
    depends_on                = [aws_internet_gateway.default]

    tags = {
        Name = "pub_2_ip"
    }
}


# Private instance
resource "aws_instance" "private"{
        depends_on = [
        aws_subnet.private_1,
        aws_security_group.sg_default,
    ]

    ami = "ami-04505e74c0741db8d"
    instance_type = "t2.micro"
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sg_default.id]
    subnet_id = aws_subnet.private_1.id

    tags = {
        Name = "Private host"
    }
}
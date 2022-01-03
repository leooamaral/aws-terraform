# Bastion host public ip
output "bastion_public_ip"{                            
     value = aws_eip.bastion_eip.public_ip
}

output "ec2_pub_1_ip"{
    value = aws_eip.pub_1.public_ip
}

output "ec2_pub_2_ip"{
    value = aws_eip.pub_2.public_ip
}
resource "aws_instance" "Bastion" {

  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t3.small"

  key_name               = "ca"
  
  
  subnet_id              = aws_subnet.ca-public-subnet-1a.id
  security_groups        = [aws_security_group.bastion-host134_SG.name]

  tags = {
    Sg  = "bastion"
  }
}




resource "aws_instance" "Jenkins" {

  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t3.small"
 
  subnet_id              = aws_subnet.ca-private-subnet-1a.id
  security_groups        = [aws_security_group.private_SG.name]
  key_name               = "ca"

  tags = {
    Sg  = "jenkins"
 }

}




resource "aws_instance" "App" {

  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t3.small"
  key_name               = "ca"
  
  subnet_id              = aws_subnet.ca-private-subnet-1b.id
  security_groups        = [aws_security_group.Public-web_SG.name]


  tags = {
    Sg  = "App"
  }
}

provider "aws" {
region     = "us-east-1"
}


# ---  Creating a VPC ------


resource "aws_vpc" "ca-vpc" {
  cidr_block       = "10.10.0.0/16"
  tags = {
    Name = "cavpc"
  }
}



#--- Creating Internet Gateway


resource "aws_internet_gateway" "ca-igw" {
 vpc_id = "${aws_vpc.ca-vpc.id}"
 tags = {
    Name = "ca-igw"
 }
}


# - Creating Elastic IP


resource "aws_eip" "ca-eip" {
  vpc=true
}

# -- Creating Subnet


data "aws_availability_zones" "ca-azs" {
  state = "available"
}



        #  creating public subnet


resource "aws_subnet" "ca-public-subnet-1a" {
  availability_zone = "${data.aws_availability_zones.ca-azs.names[0]}"
  cidr_block        = "10.10.20.0/24"
  vpc_id            = "${aws_vpc.ca-vpc.id}"
  map_public_ip_on_launch = "true"
  tags = {
   Name = "ca-public-subnet-1a"
   }
}

resource "aws_subnet" "ca-public-subnet-1b" {
  availability_zone = "${data.aws_availability_zones.ca-azs.names[1]}"
  cidr_block        = "10.10.21.0/24"
  vpc_id            = "${aws_vpc.ca-vpc.id}"
  map_public_ip_on_launch = "true"
  tags = {
   Name = "ca-public-subnet-1b"
   }
}


        #  Creating  private subnet


resource "aws_subnet" "ca-private-subnet-1a" {
  availability_zone = "${data.aws_availability_zones.ca-azs.names[0]}"
  cidr_block        = "10.10.30.0/24"
  vpc_id            = "${aws_vpc.ca-vpc.id}"
  tags = {
   Name = "ca-private-subnet-1a"
   }
}


resource "aws_subnet" "ca-private-subnet-1b" {
  availability_zone = "${data.aws_availability_zones.ca-azs.names[1]}"
  cidr_block        = "10.10.31.0/24"
  vpc_id            = "${aws_vpc.ca-vpc.id}"
  tags = {
   Name = "ca-private-subnet-1b"
   }
}





# --------------  NAT Gateway

resource "aws_nat_gateway" "ca-ngw" {
  allocation_id = "${aws_eip.ca-eip.id}"
  subnet_id = "${aws_subnet.ca-public-subnet-1b.id}"
  tags = {
      Name = "ca-Nat Gateway"
  }
}




# ------------------- Routing ----------


resource "aws_route_table" "ca-public-route" {
  vpc_id =  "${aws_vpc.ca-vpc.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.ca-igw.id}"
  }

   tags = {
       Name = "ca-public-route"
   }
}


resource "aws_default_route_table" "ca-private-route" {
  private_route_table_id = "${aws_vpc.ca.private_route_table_id}" 
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.ca-igw.id}"
  }
  
  
  tags = {
      Name = "ca-default-route"
  }
}



#--- Subnet Association -----

resource "aws_route_table_association" "ca-1a" {
  subnet_id = "${aws_subnet.ca-public-subnet-1a.id}"
  route_table_id = "${aws_route_table.ca-public-route.id}"
}


resource "aws_route_table_association" "ca-1b" {
  subnet_id = "${aws_subnet.ca-public-subnet-1b.id}"
  route_table_id = "${aws_route_table.ca-public-route.id}"
}


resource "aws_route_table_association" "ca-p-1a" {
  subnet_id = "${aws_subnet.ca-private-subnet-1a.id}"
  route_table_id = "${aws_vpc.ca-vpc.default_route_table_id}"
}

resource "aws_route_table_association" "ca-p-1b" {
  subnet_id = "${aws_subnet.ca-private-subnet-1b.id}"
  route_table_id = "${aws_vpc.ca-vpc.default_route_table_id}"
}

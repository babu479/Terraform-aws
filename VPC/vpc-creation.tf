provider "aws" {
  AWS_DEFAULT_REGION    = "${var.region}"
  AWS_ACCESS_KEY_ID     = "${var.access-key}"
  AWS_SECRET_ACCESS_KEY = "${var.secret-key}"

}
resource "aws_vpc_dhcp_options" "this" {
  domain_name         = "${var.aws-vpc-dhcp-options-domain-name}"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    Name = "${var.aws-vpc-dhcp-options-domain-name}"
  }
}

resource "aws_vpc" "this" {
  cidr_block                       = "${var.aws-vpc-cidr-block}"
  instance_tenancy                 = "${var.aws-vpc-instance-tenancy}"
  enable_dns_hostnames             = "${var.aws-vpc-enable-dns-hostnames}"
  enable_dns_support               = "${var.aws-vpc-enable-dns-support}"
  assign_generated_ipv6_cidr_block = "${var.aws-vpc-assign-generated-ipv6-cidr-block}"

  tags = {
    Name = "${var.aws-vpc-name}"
  }
}
resource "aws_network_acl" "this" {
    vpc_id = "${aws_vpc.this.id}"
    subnet_ids = [
        "${aws_subnet.public-1a.id}",
        "${aws_subnet.public-1b.id}",
        "${aws_subnet.private-1a.id}",
        "${aws_subnet.private-1b.id}",
    ]
    egress{
        protocol = "-1"
        rule_no=100
        action="allow"
        cidr_block="0.0.0.0/0"
        from_port=0
        to_port=0
    }
    ingress{
        protocol = "-1"
        rule_no=100
        action="allow"
        cidr_block="0.0.0.0/0"
        from_port=0
        to_port=0
    }
    tags = {
        Name = "Network-Acl"
    }
}

resource "aws_subnet" "public-1a" {
    vpc_id="${aws_vpc.this.id}"
    cidr_block="${var.aws-subnet-public-1a-cidr-block}"
    availability_zone="${var.aws-subnet-public-1a-availability-zone}"
    map_public_ip_on_launch ="true"

    tags ={
        Name = "aws-subnet-public-1a"
    }
}
resource "aws_subnet" "public-1b" {
    vpc_id="${aws_vpc.this.id}"
    cidr_block="${var.aws-subnet-public-1b-cidr-block}"
    availability_zone="${var.aws-subnet-public-1b-availability-zone}"
    map_public_ip_on_launch="true"

    tags={
        Name = "aws-subnet-public-1b"
    }
}
resource "aws_subnet" "private-1a" {
    vpc_id="${aws_vpc.this.id}"
    cidr_block="${var.aws-subnet-private-1a-cidr-block}"
    availability_zone="${var.aws-subnet-private-1a-availability-zone}"
    map_public_ip_on_launch="false"

    tags={
        Name="aws-subnet-private-1a"
    }
  
}
resource "aws_subnet" "private-1b" {
    vpc_id="${aws_vpc.this.id}"
    cidr_block="${var.aws-subnet-private-1b-cidr-block}"
    availability_zone="${var.aws-subnet-private-1b-availability-zone}"
    map_public_ip_on_launch="false"
    tags={
        Name="aws-subnet-private-1b"
    }
  
}
/*resource "aws_route_table" "public" {
    vpc_id="${aws_vpc.this.id}"

    tags ={
        Name="${var.aws-route-table-public-name}"
    }
}
*/
resource "aws_route_table" "private" {
    vpc_id="${aws_vpc.this.id}"
    tags ={
        Name="${var.aws-route-table-private-name}"
    }
  
}
resource "aws_route_table_association" "private-1a" {
    subnet_id="${aws_subnet.private-1a.id}"
    route_table_id="${aws_route_table.private.id}"
  
}
resource "aws_route_table_association" "private-1b" {
    subnet_id="${aws_subnet.private-1b.id}"
    route_table_id="${aws_route_table.private.id}"
  
}
/* /*resource "aws_route_table_association" "public-1a" {
    subnet_id="${aws_subnet.public-1a.id}"
    route_table_id="${aws_route_table.public.id}"
} */
  
resource "aws_route_table_association" "public-1b" {
    subnet_id="${aws_subnet.public-1b.id}"
    route_table_id="${aws_default_route_table.this.id}"
  
}
resource "aws_route_table_association" "public-1a" {
    subnet_id="${aws_subnet.public-1a.id}"
    route_table_id="${aws_default_route_table.this.id}"
  
}

resource "aws_default_route_table" "this" {
    default_route_table_id="${aws_vpc.this.default_route_table_id}"
tags ={
    Name ="aws-route-table-public"
}
 
}
/* resource "aws_main_route_table_association" "this" {
    subnet_id="${aws_subnet.public-1a.id}"
    route_table_id="${aws_default_route_table.this.id}"
  
} */

resource "aws_internet_gateway" "this" {
    vpc_id="${aws_vpc.this.id}"
    tags ={
        Name = "${var.aws-internet-gateway-name}"
    }
  
}
resource "aws_eip" "this" {
/*     count="${var.aws-create-nat-gateway}" */
    vpc="true"

    tags ={
        Name="${var.aws-eip-name}"
    }
  
}
resource "aws_nat_gateway" "this" {
    allocation_id="${aws_eip.this.id}"
    subnet_id="${aws_subnet.public-1a.id}"
    depends_on=["aws_internet_gateway.this"]
    tags ={
        Name="${var.aws-nat-gateway-name}"
    }
}

resource "aws_route" "public_internet_gateway" {
    route_table_id="${aws_default_route_table.this.id}"
    destination_cidr_block="0.0.0.0/0"
    gateway_id="${aws_internet_gateway.this.id}"
  
}
resource "aws_route" "private_nat_gateway" {
    route_table_id="${aws_route_table.private.id}"
    destination_cidr_block="0.0.0.0/0"
    nat_gateway_id="${aws_nat_gateway.this.id}"
  
}
resource "aws_vpc_endpoint" "private_endpoint_s3" {
    vpc_id="${aws_vpc.this.id}"
    service_name="${var.aws-endpoint-s3-service-name}"
    #route_table_ids="${aws_route_table.private.id}"

}
resource "aws_vpc_endpoint_route_table_association" "private_endpoint_rt_s3" {
  route_table_id  = "${aws_route_table.private.id}"
  vpc_endpoint_id = "${aws_vpc_endpoint.private_endpoint_s3.id}"
}
resource "aws_vpc_endpoint" "public_endpoint_s3" {
    count="${var.aws-create-endpoint-s3}"
    vpc_id="${aws_vpc.this.id}"
    service_name="${var.aws-endpoint-s3-service-name}"
    vpc_endpoint_type="Interface"
    route_table_ids=["${aws_default_route_table.this.id}"]
    tags = {
        Name = "aws-s3-endpoint"
    }
}

 /*resource "aws_vpc_endpoint_route_table_association" "public_endpoint_rt_s3" {
  route_table_id  = "${aws_default_route_table.this.id}"
  vpc_endpoint_id = "${aws_vpc_endpoint.public_endpoint_s3.id}"
} */
resource "aws_vpc_peering_connection" "this" {
    peer_owner_id="vpc-0c611b594aa90894e"
    peer_vpc_id="vpc-0d24e89c98bc54c4d"
    vpc_id="${aws_vpc.this.id}"
    accepter{
        allow_remote_vpc_dns_resolution=true
    }
    requester{
        allow_remote_vpc_dns_resolution=true
    }
}














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








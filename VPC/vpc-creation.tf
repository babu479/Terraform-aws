provider "aws" {
    AWS_DEFAULT_REGION = "${var.region}"
    AWS_ACCESS_KEY_ID = "${var.access-key}"
    AWS_SECRET_ACCESS_KEY = "${var.secret-key}"
  
}
resource "aws_vpc_dhcp_options" "this" {
  domain_name = "${var.aws-vpc-dhcp-options-domain-name}"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags ={
      Name = "${var.aws-vpc-dhcp-options-domain-name}"
  }
}

resource "aws_vpc" "this" {
    cidr_block = "${var.aws-vpc-cidr-block}"
    instance_tenancy="${var.aws-vpc-instance-tenancy}"
    enable_dns_hostnames="${var.aws-vpc-enable-dns-hostnames}"
    enable_dns_support="${var.aws-vpc-enable-dns-support}"
    assign_generated_ipv6_cidr_block="${var.aws-vpc-assign-generated-ipv6-cidr-block}"

    tags ={
        Name ="${var.aws-vpc-name}"
    }


  
}





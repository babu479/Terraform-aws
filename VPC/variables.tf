variable "region" {
  default = "us-east-1"
}
variable "access-key" {
  default = "AKIAUFYYXYY4UHFAF64P"

}
variable "secret-key" {
  default = "dxVWszqyYVmTXVRr/79GuKo4OCqql0wmqImDA9vm"
}
variable "aws-vpc-dhcp-options-domain-name" {
  description = "Specifies DNS name for DHCP options set"
  default     = "localdomain"
}

variable "aws-vpc-cidr-block" {
  description = "The CIDR block for the VPC. Default value is 10.0.1.0/24"
  default     = "10.0.0.0/16"

}

variable "aws-vpc-instance-tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "aws-vpc-enable-dns-hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = true
}

variable "aws-vpc-enable-dns-support" {
  description = "Should be true to enable DNS support in the VPC"
  default     = true
}

variable "aws-vpc-assign-generated-ipv6-cidr-block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC."
  default     = false
}

variable "aws-create-nat-gateway" {
  description = "Should be true to enable NAT gateway creation"
  default     = true
}

variable "aws-vpc-name" {
  description = "Name to be used on all the resources as identifier."
  default     = "terraform-vpc"
}

variable "aws-subnet-public-1a-cidr-block" {
  description = "Subnet public 1a cidr block"
  default     = "10.0.1.0/25"

}

variable "aws-subnet-public-1a-availability-zone" {
  description = "AZ  public 1a cidr block"
  default     = "us-east-1a"

}

variable "aws-subnet-public-1b-cidr-block" {
  description = "Subnet public 1b cidr block"
  default     = "10.0.2.0/25"

}

variable "aws-subnet-public-1b-availability-zone" {
  description = "AZ  public 1b cidr block"
  default     = "us-east-1b"

}

variable "aws-subnet-private-1a-cidr-block" {
  description = "Subnet private 1a cidr block"
  default     = "10.0.3.0/25"
}

variable "aws-subnet-private-1a-availability-zone" {
  description = "AZ private 1a cidr block"
  default     = "us-east-1a"

}

variable "aws-subnet-private-1b-cidr-block" {
  description = "Subnet private 1b cidr block"
  default     = "10.0.4.0/25"
}

variable "aws-subnet-private-1b-availability-zone" {
  description = "AZ private 1b cidr block"
  default     = "us-east-1b"
}
variable "aws-internet-gateway-name" {
  description = "AWS Internet Gateway Name"
  default     = "default"
}

variable "aws-eip-name" {
  description = "AWS EIP name"
  default     = "default"
}

variable "aws-nat-gateway-name" {
  description = "AWS Internet Gateway Name"
  default     = "default"
}

variable "aws-route-table-public-name" {
  description = "AWS Internet Gateway Name"
  default     = "aws-route-table-public"
}

variable "aws-route-table-private-name" {
  description = "AWS Internet Gateway Name"
  default     = "aws-route-table-private"
}

variable "aws-create-endpoint-s3" {
  description = "Create S3 service endpoint"
  default     = 0
}

variable "aws-endpoint-s3-service-name" {
  description = "Service name for endpoint"
  default     = "com.amazonaws.us-east-1.s3"
}

variable "Peering_vpc_id" {
  description= "this is for aws peering  id"
  default="vpc-0d24e89c98bc54c4d"

}
variable "Peering_owner_id" {
  description="This is for aws peering owner id"
  default="vpc-0c611b594aa90894e"
}


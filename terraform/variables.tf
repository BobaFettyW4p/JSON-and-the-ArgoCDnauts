variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    default = "10.0.0.0/16"
}

variable "project" {
    description = "The name of the project"
    default = "ArgoCD"
}

variable "subnet_cidr_bits" {
    description = "The number of bits for the subnet CIDR"
    default = 8
}

variable "availability_zones_count" {
    description = "The number of availability zones to use"
    default = 2
}

variable "region" {
    description = "The region to deploy to"
    default = "us-east-2"
}

variable "tags" {
    description = "The tags to apply to all resources"
    type = map(string)
    default = {
        Project = "ArgoCD"
        Environment = "Dev"
        Owner = "Matthew Ivancic"
    }
}
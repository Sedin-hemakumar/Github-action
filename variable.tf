############################################
# VPC BASE SETTINGS
############################################

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "status_enable_dns_support" {
  type        = bool
  description = "Whether to enable DNS support"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Whether to enable DNS hostnames"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Common tags for VPC"
  default     = {}
}

############################################
# PUBLIC SUBNETS
############################################

variable "public_subnets" {
  type = map(object({
    cidr                   = string
    az                     = string
    map_public_ip_on_launch = bool
    tags                   = map(string)
  }))
  description = "Map of public subnet configurations"
  default     = {}
}

############################################
# PRIVATE SUBNETS
############################################

variable "private_subnets" {
  type = map(object({
    cidr                   = string
    az                     = string
    map_public_ip_on_launch = bool
    tags                   = map(string)
  }))
  description = "Map of private subnet configurations"
  default     = {}
}

############################################
# INTERNET GATEWAY TAGS
############################################

variable "igw_tags" {
  type        = map(string)
  description = "Tags to apply to the Internet Gateway"
  default     = {}
}

############################################
# ROUTE TABLE TAGS
############################################

variable "main_rt_tags" {
  type    = map(string)
  default = {}
}

variable "manage_main_igw_route" {
  type    = bool
  default = false
}


variable "public_rt_tags" {
  type        = map(string)
  description = "Tags for the public route table"
  default     = {}
}

variable "private_rt_tags" {
  type        = map(string)
  description = "Tags for the private route table"
  default     = {}
}

############################################
# SUBNET ASSOCIATIONS (USED IN IMPORT MODE)
############################################

variable "subnet_associations" {
  type = map(object({
    subnet_id = string
  }))
  description = "Explicit route table associations"
  default     = {}
}

variable "manage_public_assoc" {
  type        = bool
  default     = false
  description = "Whether Terraform manages public subnet associations"
}

variable "manage_private_assoc" {
  type        = bool
  default     = false
  description = "Whether Terraform manages private subnet associations"
}

############################################
# NAT GATEWAY ENABLE/DISABLE
############################################

variable "nat_enabled" {
  type        = bool
  description = "Enable NAT Gateway for private subnets"
  default     = false
}
variable "nat_subnet_id" {
  type        = string
  description = "Subnet ID where NAT Gateway should be created"
  default = "null"
}

########################################

#########################################

variable "create_public_route_table" {
  type    = bool
  default = true
}

variable "existing_public_route_table_id" {
  type    = string
  default = null
}

variable "create_private_route_table" {
  type    = bool
  default = true
}

variable "existing_private_route_table_id" {
  type    = string
  default = null
}

###########################################
#########################################

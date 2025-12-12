############################################
# VPC
############################################

resource "aws_vpc" "this" {
  cidr_block                           = var.vpc_cidr
  enable_dns_support                   = var.status_enable_dns_support
  enable_dns_hostnames                 = var.enable_dns_hostnames
  instance_tenancy                     = "default"
  tags                                 = var.tags
}

############################################
# PUBLIC SUBNETS
############################################

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags                    = each.value.tags
}

############################################
# PRIVATE SUBNETS
############################################

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags                    = each.value.tags
}

############################################
# INTERNET GATEWAY
############################################

resource "aws_internet_gateway" "this" {
  count = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = var.igw_tags
}

############################################
# MAIN ROUTE TABLE (Existing)
############################################

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.this.id
  tags   = var.main_rt_tags
}

locals {
  main_route_table_id = aws_route_table.main.id
}

###########################################
#MAIN RT ASSOCIATION (Set as Main)
###########################################

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.this.id
  route_table_id = local.main_route_table_id
}

############################################
# OPTIONAL MAIN IGW ROUTE (0.0.0.0/0)
############################################

resource "aws_route" "main_internet_route" {
  count = var.manage_main_igw_route && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = local.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

############################################
# PUBLIC ROUTE TABLE (Optional)
############################################

resource "aws_route_table" "public" {
  count = var.create_public_route_table ? 1 : 0

  vpc_id = aws_vpc.this.id
  tags   = var.public_rt_tags
}

locals {
  public_route_table_id = (
    var.create_public_route_table
    ? aws_route_table.public[0].id
    : var.existing_public_route_table_id
  )
}

############################################
# PUBLIC ROUTE: IGW
############################################

resource "aws_route" "public_internet_route" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = local.public_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

############################################
# PRIVATE ROUTE TABLE (Optional)
############################################

resource "aws_route_table" "private" {
  count = var.create_private_route_table ? 1 : 0

  vpc_id = aws_vpc.this.id
  tags   = var.private_rt_tags
}

locals {
  private_route_table_id = (
    var.create_private_route_table
    ? aws_route_table.private[0].id
    : var.existing_private_route_table_id
  )
}

############################################
# NAT EIP
############################################

resource "aws_eip" "nat" {
  count  = var.nat_enabled ? 1 : 0
  domain = "vpc"
}

############################################
# NAT GATEWAY
############################################

resource "aws_nat_gateway" "this" {
  count = var.nat_enabled ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = var.nat_subnet_id != null ? var.nat_subnet_id : element(values(aws_subnet.public), 0).id

  depends_on = [aws_internet_gateway.this]
  lifecycle {
    ignore_changes = [
      regional_nat_gateway_address
    ]
  }
}

############################################
# PRIVATE NAT ROUTE
############################################

resource "aws_route" "private_nat_route" {
  count = var.nat_enabled && length(var.private_subnets) > 0 ? 1 : 0

  route_table_id         = local.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

############################################
# PUBLIC SUBNET → PUBLIC RT
############################################

resource "aws_route_table_association" "public_assoc" {
  for_each = var.manage_public_assoc ? var.public_subnets : {}

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = local.public_route_table_id
}

############################################
# PRIVATE SUBNET → PRIVATE RT
############################################

resource "aws_route_table_association" "private_assoc" {
  for_each = var.manage_private_assoc ? var.private_subnets : {}

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = local.private_route_table_id
}

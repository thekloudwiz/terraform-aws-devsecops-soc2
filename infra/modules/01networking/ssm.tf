# Store VPC and Subnet IDs in SSM
resource "aws_ssm_parameter" "vpc_id" {
  name       = "/${var.owner}/${var.project_name}/${terraform.workspace}/vpc_id"
  type       = "String"
  value      = aws_vpc.main.id
  tags       = local.common_tags
  depends_on = [aws_vpc.main]

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
}

# Store Public Subnet IDs in SSM
resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.owner}/${var.project_name}/${terraform.workspace}/public_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.public[*].id)


  tags       = local.common_tags
  depends_on = [aws_subnet.public]

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
}

# Store Private Subnet IDs in SSM
resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.owner}/${var.project_name}/${terraform.workspace}/private_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.private[*].id)


  tags       = local.common_tags
  depends_on = [aws_subnet.private]

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
}

# Store Internet Gateway ID in SSM
resource "aws_ssm_parameter" "igw_id" {
  name       = "/${var.owner}/${var.project_name}/${terraform.workspace}/igw_id"
  type       = "String"
  value      = aws_internet_gateway.igw.id
  depends_on = [aws_internet_gateway.igw]

  tags = local.common_tags

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
}

resource "aws_ssm_parameter" "public_rt_id" {
  name       = "/${var.owner}/${var.project_name}/${terraform.workspace}/public_rt_id"
  type       = "String"
  value      = aws_route_table.public.id
  depends_on = [aws_route_table.public]

  tags = local.common_tags

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
}

# Store Private Route Table ID in SSM
resource "aws_ssm_parameter" "private_rt_id" {
  name       = "/${var.owner}/${var.project_name}/${terraform.workspace}/private_rt_id"
  type       = "String"
  value      = aws_route_table.private.id
  depends_on = [aws_route_table.private]

  tags = local.common_tags

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
}

# Store NAT Gateway ID in SSM
resource "aws_ssm_parameter" "nat_id" {
  name       = "/${var.owner}/${var.project_name}/${terraform.workspace}/nat_id"
  type       = "String"
  value      = aws_nat_gateway.nat.id
  depends_on = [aws_nat_gateway.nat]

  tags = local.common_tags

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
}
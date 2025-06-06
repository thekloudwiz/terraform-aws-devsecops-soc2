resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_actions" {
  name               = "${var.prefix}-github-actions-role"
  assume_role_policy = templatefile("${path.module}/../../policies/github-oidc-assume-role-policy.json", {
    aws_iam_openid_connect_provider_arn = aws_iam_openid_connect_provider.github.arn
    owner                               = var.github_owner
    infra_repo                          = var.infra_repo
    app_repo                            = var.app_repo
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "github_actions" {
  name   = "${var.prefix}-github-actions-policy"
  role   = aws_iam_role.github_actions.id
  policy = file("${path.module}/../../policies/github-actions-policy.json")
}
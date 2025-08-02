resource "aws_s3_bucket" "tempo-stack-bucket" {
  bucket = "${var.cluster_name}-tempo-stack"

  tags = {
    Name        = "${var.cluster_name}-tempo-stack"
    Environment = "tempo-stack"
  }
}


resource "aws_iam_policy" "tempo_stack_s3_access_policy" {
  name        = "${var.cluster_name}-tempo-stack-s3-access-policy"
  path        = "/"
  description = "tempo-stack-s3-access-policy"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "s3:*"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role" "tempo_stack_s3_access_role" {
  name = "${var.cluster_name}-tempo-stack-s3-access-role"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Federated : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.rosa-hcp.oidc_endpoint_url}"
        },
        Action : "sts:AssumeRoleWithWebIdentity",
        Condition : {
          StringEquals : {
            "${module.rosa-hcp.oidc_endpoint_url}:sub" = [
                "system:serviceaccount:tempo-stack:tempo-simple",
                "system:serviceaccount:tempo-stack:tempo-simple-gateway"
             ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tempo_stack_s3_access_attach_role" {
  role       = aws_iam_role.tempo_stack_s3_access_role.name
  policy_arn = aws_iam_policy.tempo_stack_s3_access_policy.arn
}

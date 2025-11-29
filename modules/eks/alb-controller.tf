# --- ALB Controller IAM Policy ---
# Uses the policy you provided.
resource "aws_iam_policy" "alb_controller" {
  name        = "${local.name_prefix}-alb-controller-policy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("alb-controller-policy.json") # Ensure this file exists in your module path
}

# --- ALB Controller IAM Role for Service Account (IRSA) ---
resource "aws_iam_role" "alb_controller" {
  name = "${local.name_prefix}-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.cluster.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            # The name of the Service Account the controller will run as
            "${aws_iam_openid_connect_provider.cluster.url}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  policy_arn = aws_iam_policy.alb_controller.arn
  role       = aws_iam_role.alb_controller.name
}


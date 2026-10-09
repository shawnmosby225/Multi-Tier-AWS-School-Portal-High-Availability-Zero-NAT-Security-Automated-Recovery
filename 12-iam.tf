resource "aws_iam_role" "portal_ec2_role" {
  name = "school-portal-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "portal_ec2_secrets_policy" {
  name = "portal-ec2-secrets-policy"
  role = aws_iam_role.portal_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = aws_db_instance.portal_db.master_user_secret[0].secret_arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "portal_ec2_profile" {
  name = "school-portal-ec2-profile"
  role = aws_iam_role.portal_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_attachment" {
  role       = aws_iam_role.portal_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "portal_ec2_parameter_policy" {
  name = "portal_ec2_parameter_policy"
  role = aws_iam_role.portal_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "ssm:GetParameter"
      ]

      Resource = aws_ssm_parameter.db_endpoint.arn
    }]
  })
}
provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_user" "iam_users" {
  count = 40
  name  = "user${count.index + 1}"
}

resource "aws_iam_user_policy_attachment" "admin_policy_attachment" {
  count       = 40
  user        = aws_iam_user.iam_users[count.index].name
  policy_arn  = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_login_profile" "user_login_profile" {
  count      = 40
  user       = aws_iam_user.iam_users[count.index].name
  password   = "user@1234"
  pgp_key    = ""
  depends_on = [aws_iam_user_policy_attachment.admin_policy_attachment[count.index]]
}

resource "aws_iam_user_policy" "no_change_password_policy" {
  count = 40
  name  = "NoChangePasswordPolicy${count.index + 1}"
  user  = aws_iam_user.iam_users[count.index].name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny",
        Action = "iam:ChangePassword",
        Resource = "*",
      },
    ],
  })
}

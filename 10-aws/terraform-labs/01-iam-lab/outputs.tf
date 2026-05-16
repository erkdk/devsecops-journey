output "users" {
  value = [
    data.aws_iam_user.user1.user_name,
    data.aws_iam_user.user2.user_name,
    data.aws_iam_user.user3.user_name
  ]
}


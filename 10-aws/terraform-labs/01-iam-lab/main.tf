#############################################
# EXISTING IAM USERS
#############################################

data "aws_iam_user" "user1" {
  user_name = "user-1"
}

data "aws_iam_user" "user2" {
  user_name = "user-2"
}

data "aws_iam_user" "user3" {
  user_name = "user-3"
}

#############################################
# EXISTING IAM GROUPS
#############################################

data "aws_iam_group" "s3_support" {
  group_name = "S3-Support"
}

data "aws_iam_group" "ec2_support" {
  group_name = "EC2-Support"
}

data "aws_iam_group" "ec2_admin" {
  group_name = "EC2-Admin"
}

#############################################
# USER GROUP MEMBERSHIPS
#############################################

resource "aws_iam_user_group_membership" "user1_membership" {
  user = data.aws_iam_user.user1.user_name

  groups = [
    data.aws_iam_group.s3_support.group_name
  ]
}

resource "aws_iam_user_group_membership" "user2_membership" {
  user = data.aws_iam_user.user2.user_name

  groups = [
    data.aws_iam_group.ec2_support.group_name
  ]
}

resource "aws_iam_user_group_membership" "user3_membership" {
  user = data.aws_iam_user.user3.user_name

  groups = [
    data.aws_iam_group.ec2_admin.group_name
  ]
}

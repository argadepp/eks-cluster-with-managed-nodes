

resource "aws_iam_policy" "bucket-access" {
  name = "thanos-bucket-access-policy"
    path        = "/"
  description = "Thanos Policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::terraform-backend-pratik/*",
                "arn:aws:s3:::terraform-backend-pratik"
            ]
        }
    ]
}

  )
}
resource "aws_iam_role" "thanos-bucket-access-role" {
  name = "${var.product}-${var.environment}-thanos-bucket-access-role"
  
  assume_role_policy = jsonencode(
    {
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Principal": {
"Service": "ec2.amazonaws.com"
},
"Action": "sts:AssumeRole"
},
{
"Effect": "Allow",
"Principal": {
"Federated": "arn:aws:iam::734522607489:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/54BD288C3267D2984CBBDD79FEFC709A"
},
"Action": "sts:AssumeRoleWithWebIdentity",
"Condition": {
"StringLike": {
"oidc.eks.us-east-2.amazonaws.com/id/54BD288C3267D2984CBBDD79FEFC709A:sub": "system:serviceaccount:*:*",
"oidc.eks.us-east-2.amazonaws.com/id/54BD288C3267D2984CBBDD79FEFC709A:aud": "sts.amazonaws.com"
}
}
}
]
}
  )
}
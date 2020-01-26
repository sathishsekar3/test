resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#iam_policy
resource "aws_iam_policy" "policy" {
  name = "policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "ec2:CreateNetworkInterface",
              "ec2:DescribeNetworkInterfaces",
              "ec2:DeleteNetworkInterface"
            ],
            "Resource": "*"
        }
  ]
}
EOF
}


resource "aws_iam_policy_attachment" "policy_attachment" {
  name       = "attachment"
  roles      = ["${aws_iam_role.iam_for_lambda.name}"]
  policy_arn = aws_iam_policy.policy.arn
}


### function

resource "aws_lambda_function" "nodejsapp" {
   function_name = "APIserverfunction"

   # The bucket name as created earlier with "aws s3api create-bucket"
   s3_bucket = var.s3_bucket
   s3_key    = var.s3_key

   # "main" is the filename within the zip file (main.js) and "handler"
   # is the name of the property under which the handler function was
   # exported in that file.
   handler = "main.handler"
   runtime = "nodejs10.x"

   role = aws_iam_role.iam_for_lambda.arn

   vpc_config {
     subnet_ids          =  var.subnet_id
     security_group_ids  =  [var.lambda_sg]
   }
 }

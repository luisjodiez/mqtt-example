# Create the aws_iam_role referenced in aws_lambda_function
resource "aws_iam_role" "lambda_role" {
    name = var.lambda_role_name
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "dynamodb_policy" {
    name    = var.dynamodb_policy_name
    description = "Allow access to dynamodb"
    policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
            "dynamodb:PutItem",
            "dynamodb:GetItem",
            "dynamodb:UpdateItem",
            "dynamodb:DeleteItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:BatchWriteItem",
            "dynamodb:BatchGetItem"
        ],
        Effect   = "Allow",
        Resource = "*",
        },
    ],
    })
}

resource "aws_iam_policy_attachment" "dynamodb_policy_attachment" {
    name       = "dynamodb_policy_attachment"
    roles      = [aws_iam_role.lambda_role.name]
    policy_arn = aws_iam_policy.dynamodb_policy.arn
}
# Create the Lambda function
resource "aws_lambda_function" "my_lambda" {
    function_name = var.function_name
    runtime       = var.runtime
    handler       = "reader.lambda_handler"
    role          = aws_iam_role.lambda_role.arn
    filename      = var.filename
}

# Create the Lambda function URL
resource "aws_lambda_function_url" "my_lambda_url" {
    function_name      = aws_lambda_function.my_lambda.function_name
    authorization_type = "NONE"
}

# Create the aws_iam_role referenced in aws_lambda_function
resource "aws_iam_role" "lambda_role" {
    name = var.role_name
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
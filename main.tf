# Create the Lambda function
resource "aws_lambda_function" "my_lambda" {
    function_name = var.function_name
    runtime       = var.runtime
    handler       = "index.handler"
    role          = aws_iam_role.lambda_role.arn
    filename      = var.filename
}

# Create the Lambda function URL
resource "aws_lambda_function_url" "my_lambda_url" {
    function_name      = aws_lambda_function.my_lambda.function_name
    authorization_type = "NONE"
}

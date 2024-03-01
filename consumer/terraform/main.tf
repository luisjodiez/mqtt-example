# Create the Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name = "my-lambda-function"
  runtime       = "python3.12"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "consumer.py"
}

# Create the Lambda function URL
resource "aws_lambda_function_url" "my_lambda_url" {
  function_name      = aws_lambda_function.my_lambda.function_name
  authorization_type = "NONE"
}

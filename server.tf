# Create the Lambda function
resource "aws_lambda_function" "my_lambda" {
    function_name = var.server_function_name
    runtime       = var.runtime
    handler       = "server.lambda_handler"
    role          = aws_iam_role.lambda_role.arn
    filename      = var.server_filename
    source_code_hash = "9/gwhDBVoxLA6+yN6kWp+O8VPQablGGpHS9VyLoEyIo="
    environment {
        variables = {
            USERNAME       = var.mqtt_username
            PASSWORD       = var.mqtt_password
        }
    }
}

# Create the Lambda function URL
resource "aws_lambda_function_url" "my_lambda_url" {
    function_name      = aws_lambda_function.my_lambda.function_name
    authorization_type = "NONE"
}

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
# Create the Lambda function
resource "aws_lambda_function" "server_lambda" {
    function_name = var.server_function_name
    runtime       = var.runtime
    handler       = "server.lambda_handler"
    role          = aws_iam_role.lambda_role.arn
    filename      = var.server_filename
    source_code_hash = "bsSHEccveyoMpRE3gCaciAZ0fjHu0U4JcFFa+KnXTYQ="
    environment {
        variables = {
            USERNAME       = var.mqtt_username
            PASSWORD       = var.mqtt_password
        }
    }
}

# Create the Lambda function URL
resource "aws_lambda_function_url" "server_lambda_url" {
    function_name      = aws_lambda_function.server_lambda.function_name
    authorization_type = "NONE"
}

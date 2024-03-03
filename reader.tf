# Create the Lambda function
resource "aws_lambda_function" "reader_lambda" {
    function_name = var.reader_function_name
    runtime       = var.runtime
    handler       = "reader.lambda_handler"
    role          = aws_iam_role.lambda_role.arn
    filename      = var.reader_filename
    source_code_hash = "Lf99g5h9SfvzoXp7+xxaRJR4dYFKI1J0AJvvRzZuIGc="
    timeout = 30
    environment {
        variables = {
            USERNAME       = var.mqtt_username
            PASSWORD       = var.mqtt_password
            BROKER         = var.mqtt_broker
        }
    }
}

# Create the Lambda function URL
resource "aws_lambda_function_url" "reader_lambda_url" {
    function_name      = aws_lambda_function.reader_lambda.function_name
    authorization_type = "NONE"
}

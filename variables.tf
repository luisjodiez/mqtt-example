variable "runtime" {
    description = "The runtime for the function"
    type        = string
    default     = "python3.12"
}

variable "server_function_name" {
    description = "The name of the function"
    type        = string
    default     = "server-lambda-function"
}

variable "server_filename" {
    description = "The file for the function"
    type        = string
    default     = "server.zip"
}

variable "reader_function_name" {
    description = "The name of the function"
    type        = string
    default     = "reader-lambda-function"
}

variable "server_code_hash" {
    description = "The hash of the code for the server function"
    type        = string
}

variable "reader_code_hash" {
    description = "The hash of the code for the reader function"
    type        = string
}

variable "reader_filename" {
    description = "The file for the function"
    type        = string
    default     = "reader.zip"
}

variable "lambda_role_name" {
    description = "The name of the role"
    type        = string
    default     = "lambda-role"
}

variable "dynamodb_policy_name" {
    type        = string
    description = "Name of the DynamoDB policy"
    default     = "dynamodb-policy"
}

variable "mqtt_username" {
    description = "The username for the MQTT broker"
    type        = string
}

variable "mqtt_password" {
    description = "The password for the MQTT broker"
    type        = string
}

variable "mqtt_broker" {
    description = "The address of the MQTT broker"
    type        = string
}


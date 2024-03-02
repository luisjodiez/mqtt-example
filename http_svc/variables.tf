variable "runtime" {
    description = "The runtime for the function"
    type        = string
    default     = "python3.12"
}

variable "function_name" {
    description = "The name of the function"
    type        = string
    default     = "server-lambda-function"
}

variable "filename" {
    description = "The file for the function"
    type        = string
    default     = "bundle.zip"
}

variable "role_name" {
    description = "The name of the role"
    type        = string
    default     = "server-lambda-role"
}
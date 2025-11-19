variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "tag_key" {
  description = "Tag key to identify instances to manage"
  type        = string
  default     = "AutoSchedule"
}

variable "tag_value" {
  description = "Tag value to identify instances to manage"
  type        = string
  default     = "true"
}
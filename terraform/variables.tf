variable "prefix" {
  default = ""
}

variable "suffix" {
  default = ""
}

variable "schedule" {
  default = "cron(0 3 * * ? *)"
}

variable "python_version" {
  default = "3.6"
}

variable "tags" {
  description = "Tags to apply"
  default = {
    Name = "budget-bot"
  }
}
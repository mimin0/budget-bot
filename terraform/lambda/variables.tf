variable "name" {}

variable "python_version" {
  default = "3.6"
}

variable "tags" {
  description = "Tags to apply"
  default = {
    Name = "budget-bot"
  }
}
variable "region" {}



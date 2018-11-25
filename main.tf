provider "aws" {
  region = "eu-central-1"
  version = "~> 1.35.0"
}

module "frontend" {
  source = "terraform"
}


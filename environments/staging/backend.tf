terraform {
  backend "s3" {
    bucket = "your-tf-state-bucket"
    key    = "staging/terraform.tfstate"
    region = "us-east-1"
  }
}
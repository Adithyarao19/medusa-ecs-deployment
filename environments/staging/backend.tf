terraform {
  backend "s3" {
    bucket = "your-tf-state-bucket"
    region = "us-east-1"
    key    = "staging/terraform.tfstate"
  }
}

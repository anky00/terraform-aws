provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAWOCZIMROMTGGANJV"
  secret_key = "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"
}

resource "aws_instance" "myEC2" {
ami="ami-033b95fb8079dc481"
instance_type="t2.micro" 
  
}

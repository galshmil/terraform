include "root" {
  path = find_in_parent_folders("common.hcl")
}

terraform {
  source = "../../../module//ec2"
}

inputs = {
  ami_id          = "ami-01aaced2fbebf58e5"
  instance_type   = "t3.micro"
  security_groups = ["sg-05b300c2520694e33"]
  subnet_id       = "subnet-0a194b352989553cf"
}

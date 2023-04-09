resource "aws_instance" "my_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_groups
  subnet_id              = var.subnet_id

  tags = {
    Name = "gal_ec2_test"
  }
}

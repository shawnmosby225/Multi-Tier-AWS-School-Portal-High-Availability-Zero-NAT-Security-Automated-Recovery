data "aws_ami" "portal" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["school-portal-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}


resource "aws_launch_template" "portal_app_template" {
  name_prefix   = "portal-app-"
  image_id      = data.aws_ami.portal.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.portal_ec2_profile.name
  }
  network_interfaces { #explicitly prevents the instances from receiving public IPv4 addresses
    associate_public_ip_address = false

    security_groups = [
      aws_security_group.ec2_app_security_group.id #states that all instances within this security group does not receive public IPv4 addresses
    ]
  }
  user_data = base64encode(<<-EOF
#!/bin/bash

apt-get update -y
apt-get install -y nginx

systemctl start nginx
systemctl enable nginx

echo "<h1>Hello World from Ubuntu EC2!</h1>" > /var/www/html/index.html
echo "healthy" > /var/www/html/health
EOF
  )
}
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "portal" {
  region        = "us-east-1"
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      virtualization-type = "hvm"
    }

    owners      = ["099720109477"]
    most_recent = true
  }

  ami_name = "school-portal-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.portal"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx awscli",
      "echo '<h1>Hello World from Ubuntu EC2!</h1>' | sudo tee /var/www/html/index.html",
      "echo 'healthy' | sudo tee /var/www/html/health",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "nginx -v",
      "aws --version",
      "curl -f http://localhost/health"
    ]
  }
}

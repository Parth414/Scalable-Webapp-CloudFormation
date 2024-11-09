provider "aws" {
  region = "us-west-2"  # Update as needed
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Example Amazon Linux 2 AMI; update as needed
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet_a.id
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "web-instance"
  }
}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.subnet_a.id]
  desired_capacity    = 2
  min_size            = 1
  max_size            = 3
  launch_configuration = aws_launch_configuration.web_lc.id
}

resource "aws_launch_configuration" "web_lc" {
  image_id        = aws_instance.web.ami
  instance_type   = aws_instance.web.instance_type
  security_groups = [aws_security_group.web_sg.name]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web_elb" {
  availability_zones = ["us-west-2a", "us-west-2b"]  # Update with your region zones
  name               = "web-elb"
  security_groups    = [aws_security_group.web_sg.name]
}

resource "aws_db_instance" "db_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  instance_class       = "db.t3.micro"
  engine               = "mysql"
  name                 = "mydatabase"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql8.0"
}

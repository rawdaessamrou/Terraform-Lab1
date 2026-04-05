# 7- SG: Allow SSH from Public Internet
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from anywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 8- SG: Allow SSH and Port 3000 from VPC CIDR only
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow traffic from VPC only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 9- Bastion EC2 (Public)
resource "aws_instance" "bastion" {
  ami                    = "ami-0440d3b780d96b29d" # Amazon Linux 2023 (us-east-1)
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  tags                   = { Name = "bastion-host" }
}

# 10- Application EC2 (Private)
resource "aws_instance" "app" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  tags                   = { Name = "application-server" }
}
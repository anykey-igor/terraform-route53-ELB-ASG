resource "aws_security_group" "alb" {
    name = "terraform-alb-security-group"

    # Разрешить входящие HTTP
    ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    # Разрешить все исходящие
    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "instance" {
  name = "terraform-instance-security-group"
  ingress {
    from_port        = 8080
    to_port            = 8080
    protocol        = "tcp"
    cidr_blocks        = ["0.0.0.0/0"]
    }
}

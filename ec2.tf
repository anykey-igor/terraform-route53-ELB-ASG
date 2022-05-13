resource "aws_launch_configuration" "ubuntu-ec2" {
    image_id = "ami-015c25ad8763b2f11"
    instance_type = "t2.micro"

    security_groups = [aws_security_group.instance.id]
                user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    lifecycle {
        create_before_destroy = true
    }
}

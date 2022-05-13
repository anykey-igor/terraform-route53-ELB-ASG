provider "aws" {
    region = "eu-central-1"
}

data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}

data "aws_vpc" "default" {
default = true
}

resource "aws_lb" "alb" {
    name = "terraform-alb"
    load_balancer_type = "application"
    subnets = data.aws_subnet_ids.default.ids
    security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "fixed-response"
        fixed_response {
        content_type = "text/plain"
        message_body = "404: страница не найдена"
        status_code = 404
        }
    }
}

resource "aws_lb_listener_rule" "asg-listener_rule" {
    listener_arn    = aws_lb_listener.http.arn
    priority        = 100
    
    condition {
        path_pattern {
           values  = ["*"]
	}
    }
    
    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.asg-target-group.arn
    }
}

resource "aws_lb_target_group" "asg-target-group" {
    name = "terraform-aws-lb-target-group"
    port = 8080
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 20 
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
}

resource "aws_autoscaling_group" "ubuntu-ec2" {
    launch_configuration = aws_launch_configuration.ubuntu-ec2.name
    vpc_zone_identifier = data.aws_subnet_ids.default.ids
    
    target_group_arns = [aws_lb_target_group.asg-target-group.arn]
    health_check_type = "ELB"
        
    min_size = 1 
    max_size = 3
    
    tag {
    key = "Name"
    value = "terraform-asg-ubuntu-ec2"
    propagate_at_launch = true
    }
}

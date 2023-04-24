
# Security group for the ALB
resource "aws_security_group" "alb_sg" {
  name_prefix = "this-alb-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your desired CIDR block
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Target group for the ALB
resource "aws_lb_target_group" "this_tg" {
  name_prefix = "tg-"
  port        = 5000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    path = "/"
  }
}

resource "aws_autoscaling_group" "this_asg" {
  name_prefix               = "this-asg-"
  max_size                  = 2
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_template {
    id      = var.aws_launch_template
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.this_tg.arn]
  # This needs to be fixed
  vpc_zone_identifier = var.public_subnets[*]
}

# Application Load Balancer (ALB)
resource "aws_lb" "this_lb" {
  name               = "this-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets
}

# Listener for the ALB
resource "aws_lb_listener" "this_listener" {
  load_balancer_arn = aws_lb.this_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.this_tg.arn
    type             = "forward"
  }
}






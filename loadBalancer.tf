
# Create Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.HTTP_Security_Group.id, aws_security_group.Out_Security_Group.id]
  subnets            = aws_db_subnet_group.wordpress_db_subnet_group.subnet_ids

  tags = {
    Name = "app-lb"
  }
}

# # Create a new load balancer attachment
# resource "aws_autoscaling_attachment" "example" {
#   autoscaling_group_name = aws_autoscaling_group.Wordpress_asg.name
#   elb                    = aws_lb.app_lb.id
# }

# Create ALB Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Wordpress_VPC.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# Create ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

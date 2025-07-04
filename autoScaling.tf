
resource "aws_launch_template" "wordpress_launch_template" {
  name        = "wordpress-launch-template"
  description = "Launch template for Wordpress EC2 instances"

  # Instance type
  instance_type = "t2.micro"

  # AMI ID
  image_id = data.aws_ssm_parameter.AL2023AMISSM.value # Amazon Linux 2023 AMI ID

  key_name = data.aws_key_pair.keypair.key_name

  # Network configuration
  network_interfaces {
    subnet_id = aws_subnet.Public_Subnet1.id
    security_groups = [
      aws_security_group.SSH_Security_Group.id,
      aws_security_group.HTTP_Security_Group.id,
      aws_security_group.DB_Security_Group.id,
      aws_security_group.Out_Security_Group.id
    ]
  }

  # User data script
  user_data = base64encode(templatefile(
    "user_data.sh", {
      db_address        = aws_db_instance.Wordpress_DB.address,
      db_port           = aws_db_instance.Wordpress_DB.port,
      db_password       = var.DB_PASSWORD,
      refreshLabService = file("refreshLab.service"),
      refreshLabTimer   = file("refreshLab.timer"),
      refreshLabScript = templatefile("refreshLab.sh", {
        cookies = data.external.getCookies.result.result
      })
    }
  ))

  # Instance tags
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "Wordpress_Server"
      Environment = "dev"
    }
  }
}

# AWS Auto Scaling Group
resource "aws_autoscaling_group" "Wordpress_asg" {
  name = "Wordpress-autoscaling-group"

  # Launch template
  launch_template {
    id = aws_launch_template.wordpress_launch_template.id
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  # VPC zone identifier (subnets)
  vpc_zone_identifier = aws_db_subnet_group.wordpress_db_subnet_group.subnet_ids

  # Desired capacity
  desired_capacity = 1
  min_size         = 1
  max_size         = 4

  # Health check
  health_check_type         = "EC2"
  health_check_grace_period = 300

  # Tags
  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }

  # Termination policies
  termination_policies = ["OldestInstance"]

  # Cooldown period
  default_cooldown = 300

  # Instance protection
  protect_from_scale_in = false
}

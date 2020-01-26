resource "aws_key_pair" "nginx-key" {
  key_name   = "nginx-key"
  public_key = var.ssh_pub_key
}

resource "aws_launch_template" "nodejs" {
  name_prefix            = var.name
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.nginx-key.key_name
  user_data              = base64encode(file("install_nodejs.sh"))
  vpc_security_group_ids = [var.vpc_security_group_ids]
}

resource "aws_autoscaling_group" "nodejsapp" {
  availability_zones        = var.availability_zones
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  vpc_zone_identifier       = var.vpc_zone_identifier

  launch_template {
    id      = aws_launch_template.nodejs.id
    version = "$Latest"
  }
}

### autoscaling policy ###

resource "aws_autoscaling_policy" "mem-scale-up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nodejsapp.name
}

resource "aws_autoscaling_policy" "mem-scale-down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nodejsapp.name
}


resource "aws_cloudwatch_metric_alarm" "high-mem" {
  alarm_name          = "Nodejs-app-high-mem"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"
  alarm_description   = "High MemoryUtilization"

  alarm_actions = [
      aws_autoscaling_policy.mem-scale-up.arn,
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nodejsapp.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low-mem" {
  alarm_name          = "Nodejs-app-low-mem"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "Low MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "45"
  alarm_description   = "This metric monitors ec2 memory for low utilization on agent hosts"

  alarm_actions = [
    aws_autoscaling_policy.mem-scale-down.arn,
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nodejsapp.name
  }
}

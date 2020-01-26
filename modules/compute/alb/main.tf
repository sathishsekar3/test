### Target group for Lambda ###

resource "aws_lb_target_group" "lambda-nginx" {
  name        = "lambda-nginx"
  target_type = "lambda"
}

resource "aws_lambda_permission" "with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda-nginx.arn
}

resource "aws_lb_target_group_attachment" "nodejs" {
  target_group_arn = aws_lb_target_group.lambda-nginx.arn
  target_id        = var.lambda_arn
  depends_on       = [aws_lambda_permission.with_lb]
}

### Target group for Nginx ASG ###

resource "aws_lb_target_group" "asg-nginx" {
  name        = "asg-nginx"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}

resource "aws_autoscaling_attachment" "asg-nginx" {
  alb_target_group_arn   = aws_lb_target_group.asg-nginx.arn
  autoscaling_group_name = var.asg_arn
}

#### ALB ####

resource "aws_alb" "alb" {
  name            = "nginxalb"
  subnets         = var.pub_sub
  security_groups = [var.alb_sg]
  internal        = false
  idle_timeout    = 400
}

### Listeners ###

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.asg-nginx.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = [aws_lb_target_group.lambda-nginx]
  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda-nginx.id
  }
  condition {
    path_pattern {
      values = ["/api"]
    }
  }

}

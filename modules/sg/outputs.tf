output rds_sg {
  value = "${aws_security_group.rds_sg.id}"
}

output ec_sg {
  value = "${aws_security_group.ec_sg.id}"
}

output lambda_sg {
  value = "${aws_security_group.lambda_sg.id}"
}

output alb_sg {
  value = "${aws_security_group.alb_sg.id}"
}

output ec2_sg {
  value = "${aws_security_group.ec2_sg.id}"
}

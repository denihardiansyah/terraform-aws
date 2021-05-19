#Create template
resource "aws_launch_template" "core_stockbit_internal_tmp" {
  provider      = aws.region-master
  image_id      = var.image_id
  instance_type = var.instance_type

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = 9
    }
  }
}

#Create autoscaling group
resource "aws_autoscaling_group" "core_stockbit_group" {
  provider                  = aws.region-master
  name                      = "core_stockbit_group"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  vpc_zone_identifier       = ["${aws_subnet.private_subnet_zone_b.id}"]


  launch_template {
    id      = aws_launch_template.core_stockbit_internal_tmp.id
    version = "$Latest"

  }
}

#Create scling policy
resource "aws_autoscaling_policy" "core_stockbit_policy" {
    provider                     = aws.region-master
    name                         = "core_stockbit_policy"
    autoscaling_group_name       = aws_autoscaling_group.core_stockbit_group.name
    policy_type                  = var.policy_type
    
    target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type     = "ASGAverageCPUUtilization"
    }

    target_value = 45.0
  }
}
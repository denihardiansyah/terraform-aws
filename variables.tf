variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type        = string
  description = "default assign region singapore "
  default     = "ap-southeast-1"
}

#Ubuntu 18.04
variable "image_id" {
  type        = string
  description = "The EC2 image ID to launch"
  default     = "ami-055147723b7bca09a"
}

variable "instance_type" {
  type        = string
  description = "Instance type to launch"
  default     = "t2.medium"
}

variable "health_check_type" {
  type        = string
  description = "Controls how health checking is done. Valid values are `EC2` or `ELB`"
  default     = "ELB"
}

variable "health_check_grace_period" {
  type        = number
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = 300
}

variable "max_size" {
  type        = number
  description = "The maximum size of the autoscale group"
  default     = 5
}

variable "min_size" {
  type        = number
  description = "The minimum size of the autoscale group"
  default     = 2
}

variable "cpu_utilization_high_threshold_percent" {
  type        = number
  description = "CPU utilization high threshold"
  default     = 45.0
}

variable "cpu_utilization_low_threshold_percent" {
  type        = number
  description = "CPU utilization low threshold"
  default     = 44.9
}

variable "policy_type" {
  type        = string
  description = "type of scling group"
  default     = "TargetTrackingScaling"
}

variable "scale_up_scaling_adjustment" {
  type        = number
  default     = 1
  description = "The number of instances by which to scale"
}
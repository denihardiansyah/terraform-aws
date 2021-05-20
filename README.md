# terraform-aws
terraform aws
Terraform = v0.15.3

AWS CLI	  = 2.2.5 Python/3.9.5 Darwin/20.3.0 source/x86_64 prompt/off

OS	  = macOS 11.2.3 (20D91)

Defautl Region = Singapore

a. 1 VPC

b. 1 subnet public

c. 1 subnet private yg terhubung dengan 1 NAT Gateway

d. 1 autoscaling group dengan config :
minimum 2 instance EC2 T2.medium dan max 5 instance, dimana scaling policy
adalah CPU >= 45%. Instance harus ditempatkan di 1 subnet Private yang dibuat di
poin 3 diatas
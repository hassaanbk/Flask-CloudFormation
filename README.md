# Flask-CloudFormation
# AWS CloudFormation Template - Readme

This AWS CloudFormation template creates a network infrastructure along with security groups, EC2 instances, and an application load balancer (ALB). The infrastructure includes the following resources:

## Network Resources
- Virtual Private Cloud (VPC): Creates a VPC with a CIDR block of `10.100.0.0/16`, DNS support enabled, and DNS hostnames enabled.
- Internet Gateway: Creates an internet gateway and attaches it to the VPC.
- VPC Gateway Attachment: Attaches the internet gateway to the VPC.
- Public Subnets: Creates two public subnets (`PublicSubnetA` and `PublicSubnetB`) within the VPC with CIDR blocks `10.100.1.0/24` and `10.100.2.0/24`, respectively.
- Private Subnets: Creates two private subnets (`PrivateSubnetA` and `PrivateSubnetB`) within the VPC with CIDR blocks `10.100.3.0/24` and `10.100.4.0/24`, respectively.
- Public Route Table: Creates a route table for the public subnets and adds a route to the internet gateway.
- Private Route Table: Creates a route table for the private subnets.
- NAT Gateway: Creates a NAT gateway and associates it with `PublicSubnetA`.
- Route to NAT Gateway: Adds a route in the private route table to the NAT gateway.

## Security Groups
- ALB Security Group: Creates a security group for the application load balancer (ALB) that allows incoming traffic on port 80.
- Bastion Host Security Group: Creates a security group for the bastion host that allows SSH access from anywhere.
- EC2 Instance Security Group: Creates a security group for the EC2 instances that allows incoming traffic on port 5000 from the ALB security group and SSH access from the bastion host security group.
- RDS Security Group: Creates a security group for the RDS instance that allows incoming traffic on port 3306 from the EC2 instance security group.

## EC2 Resources
- EC2 Key Pair: Creates an EC2 key pair for SSH access to the instances.
- EC2 Instance Role: Creates an IAM role that allows EC2 instances to assume the role.
- EC2 Instance Profile: Creates an IAM instance profile and associates it with the EC2 instance role.
- Bastion Host: Creates an EC2 instance (bastion host) with the specified AMI, instance type, security group, and subnet.

## ALB Resources
- Target Group: Creates a target group for the ALB that performs health checks on port 5000.
- EC2 Launch Template: Creates an EC2 launch template with the specified image, instance type, security group, and user data. The launch template is used by the auto scaling group.
- Auto Scaling Group: Creates an auto scaling group with a desired capacity of 2 instances, using the EC2 launch template. The instances are launched in the private subnets and registered with the target group.
- ALB: Creates an application load balancer (ALB) that listens on port 80 and distributes traffic to the instances in the auto scaling group.

## RDS Resources
- RDS Subnet Group: Creates an RDS subnet group with the specified subnets.
- Master DB: Creates an RDS DB instance using the specified snapshot and subnet group.

**Note**: This readme file provides an overview of the AWS CloudFormation template and the resources it creates. For more detailed information, refer to the template itself.

**Important**: Before launching the CloudFormation stack using this template, make sure to review and modify the template parameters and

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

# Flask User Authentication Application

This is a Flask application that provides user authentication functionality. Users can sign up, sign in, and log out. The application uses a MySQL database for user data storage and relies on AWS Systems Manager (SSM) for securely storing and retrieving sensitive database connection parameters.

## Prerequisites

Before running this application, make sure you have the following prerequisites installed:

- Python
- Flask
- Flask-MySQLdb
- Flask-Session
- Flask-WTF
- PyMySQL
- Boto3

## Setup

1. Clone the repository or download the source code files.

2. Install the required dependencies using pip:
   ```shell
   pip install flask flask-mysqldb flask-session flask-wtf pymysql boto3
   ```

3. Configure AWS Systems Manager (SSM) to store the following parameters for your MySQL database:
   - username: The username for the database connection.
   - password: The password for the database connection.
   - host: The host name or IP address of the database server.
   - port: The port number of the database server.
   - database: The name of the database.

4. Update the `dbconn` function in the code to use your own AWS region instead of `'us-east-1'`.

## Usage

To run the application, execute the following command in the project directory:

```shell
python app.py
```

The application will be accessible at `http://localhost:80/`.

## Endpoints

- `/`: The main page of the application. Displays the homepage.
- `/signup`: Shows the sign-up form for new users.
- `/signin`: Shows the sign-in form for existing users.
- `/api/validateLogin` (POST): Validates the user's login credentials and redirects to `/userhome` on success.
- `/api/signup` (POST): Registers a new user with the provided information.
- `/userhome`: Displays the user's home page if the user is authenticated. Otherwise, redirects to the error page.
- `/logout`: Logs out the user and redirects to the main page.

## Logging

The application logs events and errors using the Python `logging` module. The logs are written to the `app.log` file in the same directory.

## Error Handling

If an error occurs during the execution of the application or the database connection fails, an error page is displayed with the corresponding error message.

## Security

The application uses session-based authentication to keep track of logged-in users. The session secret key is set to `'the random string'` in the code. Make sure to generate a secure random secret key and replace it in the code before deploying the application to a production environment.

## License

This application is released under the [MIT License](https://opensource.org/licenses/MIT). Feel free to modify and distribute it as per your requirements.

---

**Note:** This application should be used for educational purposes only and may require additional security measures and enhancements before being used in a production environment.

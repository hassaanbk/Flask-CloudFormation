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

# Description
Python FLASK app to be deployed in AWS for the Skills Ontario Cloud competition

This app connects to the parameter store to get the DB connection parameters and shows the home screen.

The user can signup or signin to the app in index page. Appropriate error messages are shown when there is error in signup or sign in.

# RDS snapshot ARN:
arn:aws:rds:us-east-1:156463586173:snapshot:skillsdb-snapshot

# Flash App AMI id:
ami-0e8a20c6da2c1ffbe


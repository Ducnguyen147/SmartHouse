# How to run the application

## Requirements

- **Java version**: Version 21.
- **Database**: Download PostgreSQL to your local computer.
- **Create DB**: Create database called `smart_house` in yout local db. `createdb smart_house`
- **Create User**: `createuser -s group2`
- **Create Password**:
`psql postgres`
`ALTER USER group2 WITH PASSWORD 'password';`
- **IDE**: Depends on you choice. e.g., VS Code, Eclipse, etc.

## How to run

- **Go to correct folder**: cd smarthouse
- **Run the project**: Go to SmarthouseApplication.java and run the project using 'Start' button.
- **Testting db connection**: Check if the tables are correctly create in your database `smart_house`
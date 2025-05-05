# PG Games API

## Overview
PG Games API is a RESTful API for managing game data. It allows users to perform CRUD operations on games, including retrieving, creating, updating, and deleting game entries.

## Project Structure
```
pg_games_api
├── src
│   ├── app.js                # Entry point of the application
│   ├── controllers           # Contains controllers for handling requests
│   │   └── gamesController.js # Controller for game-related API requests
│   ├── models                # Contains data models
│   │   └── gameModel.js      # Game model defining the schema
│   ├── routes                # Contains route definitions
│   │   └── gamesRoutes.js     # Routes for the games API
│   └── utils                 # Utility functions
│       └── db.js             # Database connection utility
├── package.json              # NPM configuration file
├── .env                      # Environment variables
├── .gitignore                # Files and directories to ignore by Git
└── README.md                 # Project documentation
```

## Setup Instructions
1. Clone the repository:
   ```
   git clone <repository-url>
   cd pg_games_api
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Create a `.env` file in the root directory and add your environment variables, such as database connection strings.

4. Start the application:
   ```
   npm start
   ```

## API Usage
- **GET /games**: Retrieve a list of all games.
- **GET /games/:id**: Retrieve a specific game by ID.
- **POST /games**: Create a new game.
- **PUT /games/:id**: Update an existing game by ID.
- **DELETE /games/:id**: Delete a game by ID.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License
This project is licensed under the MIT License.
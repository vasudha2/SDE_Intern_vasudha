const express = require('express');
const mysql = require('mysql');
const { check, validationResult } = require('express-validator');

const app = express();
const PORT = process.env.PORT || 3000;

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',  // Replace with your MySQL username
  password: '',  // Replace with your MySQL password
  database: 'movie_search_db'
});

connection.connect((err) => {
  if (err) throw err;
  console.log('Connected to MySQL database');
});

const authenticateUser = (req, res, next) => {
  // Mock authentication: Assume user is authenticated
  req.user = { id: 1, username: 'exampleuser' };
  next();
};

app.get('/api/movies',
  [
    check('page').isInt({ min: 1 }).withMessage('Invalid page number'),
    check('limit').isInt({ min: 1, max: 50 }).withMessage('Invalid limit')
  ],
  authenticateUser,
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { page = 1, limit = 5 } = req.query;
    const offset = (page - 1) * limit;

    const query = 'SELECT * FROM Movies LIMIT ?, ?';
    const values = [offset, parseInt(limit)];

    connection.query(query, values, (error, results) => {
      if (error) {
        console.error('Error fetching movies:', error);
        res.status(500).json({ error: 'Internal Server Error' });
      } else {
        res.json(results);
      }
    });
  }
);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

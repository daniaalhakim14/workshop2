const express = require('express');
const router = express.Router();
const pool = require('./db'); // Ensure the correct path to db.js

// Route to handle login
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const client = await pool.connect();
    const query = 'SELECT * FROM public.appuser WHERE email = $1 AND password = $2';
    const result = await client.query(query, [email, password]);
    client.release();

    if (result.rows.length > 0) {
      res.status(200).json({ user: result.rows[0] });
    } else {
      res.status(401).json({ message: 'Invalid credentials' });
    }
  } catch (error) {
    console.error('Error executing query', error.stack);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Route to handle signup
router.post('/signup', async (req, res) => {
  const {password, name, email, phonenumber, address } = req.body;

  try {
    const client = await pool.connect();
    const query = 'INSERT INTO public.appuser (password, name, email, phonenumber, address, personalimage, adminid) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *';
    const values = [password, name, email, phonenumber, address, null, null];
    const result = await client.query(query, values);
    client.release();

    res.status(201).json({ user: result.rows[0] });
  } catch (error) {
    console.error('Error executing query:', error); // Log the error to the console

    if (error.code === '23505') { // Unique constraint violation
      res.status(409).json({ message: 'User with this email already exists' });
    } else {
      // Send the error message back in the response
      res.status(500).json({ message: 'Internal server error'});
    }
  }
});


// Route to handle email status
router.post('/passrecovery', async (req, res) => {
  const { email} = req.body;

  try {
    const client = await pool.connect();
    const query = 'SELECT * FROM public.appuser WHERE email = $1';
    const result = await client.query(query, [email]);
    client.release();

    if (result.rows.length > 0) {
      res.status(200).json({ user: result.rows[0] });
    } else {
      res.status(401).json({ message: 'Invalid credentials' });
    }
  } catch (error) {
    console.error('Error executing query', error.stack);
    res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router;
const pool = require('../../config/dbConnection');

module.exports = app => {



  app.get('/', (req, res) => {
    
      res.render('./index', {
      
      });
    });
  

  app.get('/vista1', async (req, res) => {
  const connection = await pool.getConnection();
  const rows = await connection.query('SELECT * FROM vista1');
    res.render('./vista1', {
      vista1: rows
    });
  });

  app.get('/vista2', async (req, res) => {
    const connection = await pool.getConnection();
    const rows = await connection.query('SELECT * FROM vista2');
      res.render('./vista2', {
        vista2: rows
      });
  });


  app.get('/vista3', async (req, res) => {
    const connection = await pool.getConnection();
    const rows = await connection.query('SELECT * FROM vista4');
      res.render('./vista3', {
        vista3: rows
      });
  });
  





};
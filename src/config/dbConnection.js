const mariadb = require('mariadb');

const pool = mariadb.createPool({
    host: '188.166.64.33',
    user: 'root',
    password: 'Johanpianchiche2020*',
    database: 'spotify'
});


async function getConnection(){
  try {
    const connection = await pool.getConnection();
    return connection;
  } catch (error) {
    console.log(error);
  }

}

module.exports = {getConnection};
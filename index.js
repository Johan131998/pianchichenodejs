const app = require('./src/config/server');

require('./src/app/routes/cargardatos')(app);

app.listen(app.get('port'), () => {
    console.log('server on port', app.get('port'));
  });
 
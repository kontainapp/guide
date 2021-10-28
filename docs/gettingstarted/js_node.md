# Javascript/NodeJS (ExpressJS)

Given a Javascript Express server:

```javascript
'use strict';
 
const express = require('express');
 
// Constants
const PORT = 8080;
const HOST = '0.0.0.0';
 
// App
const app = express();
app.get('/', (req, res) => {
 res.send('Hello World');
});
 
app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
```

And a package.json identifying its dependencies:

```javascript
{
   "name": "docker_web_app",
   "version": "1.0.0",
   "description": "Node.js on Docker",
   "author": "First Last <first.last@example.com>",
   "main": "server.js",
   "scripts": {
     "start": "node server.js"
   },
   "dependencies": {
     "express": "^4.16.1"
   }
 }

```

And a Dockerfile packaging it:

```shell
FROM node:12 as build
 
# Create app directory
WORKDIR /opt/src/app
 
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
 
RUN npm install
# If you are building your code for production
# RUN npm ci --only=production
 
# Bundle app source
COPY . .
 
FROM kontainapp/runenv-node as release
COPY --from=build /opt/src /opt/src
WORKDIR /opt/src/app
 
EXPOSE 8080
CMD [ "node", "server.js" ]
```

To build:

```
$ docker build -t kg/jsexpress .

```

To run:

```
$ docker run --runtime=krun kg/jsexpress
```

Check the size:

- Kontain-based image - kg/express is 46.1MB in size
- Whereas, the Original node image is 918MB in size

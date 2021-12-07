---
label: Javascript and Node (ExpressJS)
icon: /images/Expressjs.svg
order: 700
---

# Javascript/NodeJS (ExpressJS)

## Javascript Express server

```javascript
'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello from Kontain!');
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

## Docker
### Dockerfile

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

### To build Docker Container

```
$ docker build -t kg/jsexpress:latest .

```

### To run Docker Container
```
$ docker run --rm --runtime=krun -p 8080:8080  kg/jsexpress:latest
```

In another window:
```
$ curl  http://localhost:8080/
Hello from Kontain!
```

### Check the Container Image size

- Kontain-based image - kg/express is 46.1MB in size
- Whereas, the Original node image is 918MB in size

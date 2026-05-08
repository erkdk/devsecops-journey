FROM node

# Metadata
LABEL "np.com.weather"="sitename"
MAINTAINER "erkdk"

WORKDIR /app

COPY simple-nodejs-weather-app/ /app

RUN npm install

CMD ["node", "server.js"]

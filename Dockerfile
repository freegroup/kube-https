# just 66MB !!!
FROM mhart/alpine-node:8

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package.json package-lock.json src ./
RUN  npm install --only=production

EXPOSE 8080

# run just one instace with the process monitor
CMD [ "node",  "server.js"]

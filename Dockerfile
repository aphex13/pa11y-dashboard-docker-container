FROM node:18-bullseye-slim

# Install Chrome and dependencies
RUN apt-get update && \
    apt-get install -y wget gnupg git && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone the repositories
RUN git clone https://github.com/pa11y/dashboard.git /dashboard && \
    git clone https://github.com/pa11y/pa11y-webservice.git /pa11y-webservice

# Install dependencies
WORKDIR /dashboard
RUN npm install

WORKDIR /pa11y-webservice
RUN npm install

# Create config directories
RUN mkdir -p /dashboard/config /pa11y-webservice/config

# Create start script
RUN echo '#!/bin/bash \n\
cd /pa11y-webservice \n\
NODE_ENV=production node index.js & \n\
sleep 5 \n\
cd /dashboard \n\
NODE_ENV=production node index.js' > /start.sh && \
chmod +x /start.sh

ENV NODE_ENV=production
CMD ["/start.sh"]

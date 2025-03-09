FROM alekzonder/puppeteer:latest

# Install Node dependencies
RUN apt-get update && apt-get install -y git

# Clone the repositories
RUN git clone https://github.com/pa11y/dashboard.git /dashboard && \
    git clone https://github.com/pa11y/pa11y-webservice.git /pa11y-webservice

# Install dependencies
WORKDIR /dashboard
RUN npm install

WORKDIR /pa11y-webservice
RUN npm install

# Setup configs
RUN mkdir -p /dashboard/config && \
    mkdir -p /pa11y-webservice/config 

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

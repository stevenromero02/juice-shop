FROM node:12 as installer
COPY . /juice-shop
WORKDIR /juice-shop
RUN npm install --production --unsafe-perm
RUN npm dedupe
RUN rm -rf frontend/node_modules

FROM node:12-alpine

# Create ubuntu user and directories for Labtainer

# Add Bash to Alpine Linux

RUN apk update
RUN apk upgrade
RUN apk add bash
RUN apk add bash-completion

RUN mkdir -p /home/ubuntu/.local/bin
RUN mkdir -p /home/ubuntu/.local/zip
RUN mkdir -p /home/root/.local/bin
RUN mkdir -p /home/root/.local/zip
RUN mkdir -p /home/root/.local/result

# Create ubuntu user and directories for Labtainer

WORKDIR /juice-shop
RUN addgroup juicer && \
    adduser -D -G juicer juicer
RUN addgroup ubuntu && \
    adduser -h /home/ubuntu -D -G ubuntu ubuntu
COPY --from=installer --chown=juicer /juice-shop .
RUN mkdir logs && \
    chown -R juicer logs && \
    chgrp -R 0 ftp/ frontend/dist/ logs/ data/ i18n/ && \
    chmod -R g=u ftp/ frontend/dist/ logs/ data/ i18n/
USER juicer
EXPOSE 3000
CMD ["npm", "start"]

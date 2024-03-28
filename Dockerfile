FROM ubuntu:22.04 as COPY_FILE
LABEL maintainer='NANJA R.'
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git
RUN rm -Rf  /var/www/html/*
RUN git clone https://github.com/ravelonanosy/static-website-example.git  /var/www/html/

FROM nginx:alpine
COPY --from=COPY_FILE /var/www/html/* /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'

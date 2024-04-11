FROM nginx
LABEL maintainer='NANJA RAVELO.'
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y git && \
rm -Rf /usr/share/nginx/html/*
RUN git clone https://github.com/ravelonanosy/static-website-example.git  /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'

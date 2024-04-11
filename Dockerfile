FROM nginx
LABEL maintainer='NANJA RAVELO.'
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y git && \
rm -Rf /usr/share/nginx/html/*
RUN git clone https://github.com/ravelonanosy/static-website-example.git  /usr/share/nginx/html/
CMD ["nginx", "-g", "0.0.0.0:$PORT" , "daemon off;"]

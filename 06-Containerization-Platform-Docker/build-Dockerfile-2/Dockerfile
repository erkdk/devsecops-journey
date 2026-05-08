FROM nginx
LABEL owner=erkdk
COPY index.html /usr/share/nginx/html/index.html
RUN apt update
RUN apt install net-tools -y
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


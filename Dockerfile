FROM nginx:latest

WORKDIR /DevOps_Project_Front

EXPOSE 80

COPY dist/workshop-angular /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]

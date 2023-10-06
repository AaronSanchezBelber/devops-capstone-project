#Defino la imagen que voy a utilizar, imagen pequeña con bibliotecas esenciales
#Una imagen grande es ubuntu:20.04
FROM python:3.9-slim

#Establezco el directorio de trabajo
WORKDIR /app

#Copio el arquivo de mi directorio local al directio app que he creado
COPY requirements.txt .

#Corro el codigo en app, le quito el cache para que sea mas ligero e instalo el archivo requirements
RUN pip install --no-cache-dir -r requirements.txt

#Copio todo el directorio services a app
COPY service/ ./service/

#Creo un usuario theia.Esto es una práctica común cuando se desea ejecutar una aplicación como un usuario no privilegiado dentro del contenedor para mejorar la seguridad
#Le doy un id de 1000
RUN useradd --uid 1000 theia && chown -R theia /app

#Cambio el usuario a theia
USER theia

#Pongo o expongo mi serviccio en un contendor
EXPOSE 8080

#Inicio el contendor, la app sera servida por gunicorn, sobre el servicio app, mi directorio
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--log-level=info", "service:app"]
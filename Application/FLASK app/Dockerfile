FROM python:alpine3.7
COPY . /app
WORKDIR /app
RUN chmod +x bash.sh
RUN ./bash.sh
EXPOSE 5002
ENTRYPOINT [ "python" ]
CMD [ "app.py" ]

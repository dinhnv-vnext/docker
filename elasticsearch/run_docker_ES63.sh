docker build -t es:6.3 .
docker run -it -d -p 9200:9200 es:6.3
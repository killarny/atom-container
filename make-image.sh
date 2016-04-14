#! /bin/bash
docker rm atom-editor
echo "Containerizing latest Atom release.. (this may show a browser window for a few seconds, be patient)"
docker build -t atom-editor container

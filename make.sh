#!/bin/bash
elm make src/Main.elm --output index.html
sed -i '/<meta charset="UTF-8">/a\  <meta name="viewport" content="width=device-width, initial-scale=1">' index.html

python3 -m http.server 8000 --bind 127.0.0.1
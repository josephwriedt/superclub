#!/bin/bash
elm make src/Main.elm --output index.html

python3 -m http.server 8000 --bind 127.0.0.1
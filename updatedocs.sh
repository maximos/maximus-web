#!/bin/bash
git submodule update
podsite --name Maximus -m Maximus -t --doc-root=docs --base-uri="/" lib script
cd docs/
git add .
git commit -a -m "Updated docs"
git push origin gh-pages


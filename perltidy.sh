#!/bin/bash
find . -type f -name '*.pl' -or -name '*.pm' -or -name '*.t' | grep -v -E "^\./(inc|blib)" | xargs perltidy --profile=.perltidyrc
find ./ -name *.bak | xargs rm


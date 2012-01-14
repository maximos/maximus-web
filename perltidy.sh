#!/bin/bash
find . -type f -name '*.pl' -or -name '*.pm' | grep -v -E "^\./(inc|lib\/Maximus\/Schema\.pm|lib\/Maximus\/Schema\/Result)" | xargs perltidy --profile=.perltidyrc
find ./ -name *.bak | xargs rm


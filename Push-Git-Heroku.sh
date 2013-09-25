#!/bin/bash

rake assets:precompile
git add .
git commit -m "Add precompiled assets for Heroku"
git co master
git push
git push heroku master
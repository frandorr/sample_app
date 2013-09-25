#!/bin/bash

echo "Do you want to PUSH it to Github and Heroku? y/N"
read cans
echo "Have you change statics (CSS, etc)? y/N"
read ans
if [ "$ans" = "y" ]; then
	echo "Raking precompiled assets..\n"
	rake assets:precompile
fi
git add .
echo "Enter commit message: "
read msg
git commit -m msg
echo "Commited done\n"
if [ "$cans" = "y" ]; then
	echo "Checkout master..."
	git co master
	echo "Pushing into github"
	git push
	echo "Pushing into heroku"
	git push heroku master
fi
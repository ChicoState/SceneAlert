#!/bin/bash
cd ~/github/SceneAlert
HEADHASH=$(git rev-parse HEAD)
UPSTREAMHASH=$(git rev-parse master@{upstream})

echo "Checking Git Repo..."
git fetch

if [ "$HEADHASH" != "$UPSTREAMHASH" ]
then
	echo "Not up to date with origin. Pulling."
	sleep 5s
	git pull
	cp -R ~/github/SceneAlert/web/* /var/www/html/scenealert
	git log --date=short --pretty=format:"%cd %s: %b" | head -n 20 > ~/logs/git-changelog.txt
else
	echo "Up to date with current master branch"
fi


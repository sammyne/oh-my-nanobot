#!/bin/bash

rev=v0.1.4.post2

repo_tag=sammyne/nanobot:${rev//v}-`git rev-parse --short HEAD`
repo_tag_latest=sammyne/nanobot:latest

docker build --build-arg REV=$rev -t $repo_tag .

docker tag $repo_tag $repo_tag_latest

docker push $repo_tag

docker push $repo_tag_latest

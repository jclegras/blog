#!/bin/bash

BLOG_DIRECTORY="../jclegras.github.io"

git add -A . && \
git commit -m "update the blog" && \
git push origin master && \ # ligne ajoutée pour pusher aussi sur blog
rm -rf $BLOG_DIRECTORY/* && \
hugo && \
cp -vr public/* $BLOG_DIRECTORY && \
cd $BLOG_DIRECTORY && \
git add -A . && \
git commit -m "update the blog" && \
git push origin master



#!/bin/sh
set -ex

if [ $1 = "build" ]; then
  #make clean
  make html
elif [ $1 = "serve" ]; then
  #make clean
  make html
  cd build/html
  python -m SimpleHTTPServer 4000
elif [ $1 = "deploy" ]; then
  make clean
  make html
  git add -A
  git commit -m 'Update source'
  git push origin master
elif [ $1 = "circle" ]; then
  make clean
  make html
  git clone -b gh-pages git@github.com:gosyujin/be-side.git ~/gh-pages
  rm -rf ~/gh-pages/*
  cp -R build/html/* ~/gh-pages

  cd ~/gh-pages

  git add -A
  git status -s > /tmp/gitstatus
  ls -l /tmp/gitstatus
  if [ -s /tmp/gitstatus ]; then
    git commit -m 'Commit at CircleCI'
    git push origin gh-pages
  else
    echo 'no change source'
  fi
fi

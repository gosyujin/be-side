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
  if [ $? -eq 1 ]; then
    echo 'nothing to commit (working directory clean)?'
    exit 0
  fi
  git push origin master
elif [ $1 = "circle" ]; then
  make clean
  make html
  git clone -b gh-pages git@github.com:gosyujin/be-side.git ~/gh-pages
  rm -rf ~/gh-pages/*
  cp -R build/html/* ~/gh-pages

  cd ~/gh-pages

  git add -A
  git commit -m 'Commit at CircleCI'
  if [ $? -eq 1 ]; then
    echo 'nothing to commit (working directory clean)?'
    exit 0
  fi
  git push origin gh-pages
fi

#!bin/bash
if [ ! -d 'deploy.git' ]; then
  mkdir deploy.git && cd deploy.git
  git init --bare
  echo '#!/bin/sh' > hooks/post-receive
  echo 'while read oldrev newrev ref' >> hooks/post-receive
  echo 'do' >> hooks/post-receive
  echo 'GIT_WORK_TREE=.. git checkout -f -B `basename "$ref"` "$newrev"' >> hooks/post-receive
  echo 'done' >> hooks/post-receive
  chmod +x hooks/post-receive
fi

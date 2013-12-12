#!bin/bash
if [ ! -d 'deploy.git' ]; then
  mkdir deploy.git && cd deploy.git
  git init --bare
  echo '#!/bin/sh' > hooks/post-receive
  echo 'GIT_WORK_TREE=.. git checkout -f' >> hooks/post-receive
  chmod +x hooks/post-receive
fi

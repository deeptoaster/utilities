#!/bin/bash
git filter-branch --force --env-filter '
  OLD_EMAIL_1="yizhenwilliam@gmail.com"
  CORRECT_NAME="Deep Toaster"
  CORRECT_EMAIL="deeptoaster@gmail.com"
  if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL_1" ] || [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL_2" ]; then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
  fi
  if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL_1" ] || [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL_2" ]; then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
  fi
' --tag-name-filter cat -- --branches --tags

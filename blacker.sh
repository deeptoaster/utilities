git clone --recursive ssh://git@github.com/blacker-hovse/blacker
cd blacker
git submodule foreach --recursive 'git --git-dir=$toplevel/$sm_path/.git remote add web ssh://'$TITANIC_USERNAME'@titanic.caltech.edu/srv/git/$(git --git-dir=$toplevel/$sm_path/.git remote -v | sed -En '\''s/^origin\t.*\/(\w+(-\w+)*) \(fetch\)/\1/p'\'').git'

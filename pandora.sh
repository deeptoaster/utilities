find . -name '*.aac' -exec ffmpeg -i "{}" -acodec copy -f mp4 "{}".m4a \;
rename 's/\.aac\.m4a$/\.m4a/' *

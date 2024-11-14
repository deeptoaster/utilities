$(dirname "$0")/$(ls $(dirname "$0") | grep '.AppImage$' | head -n 1) --no-sandbox "$@"

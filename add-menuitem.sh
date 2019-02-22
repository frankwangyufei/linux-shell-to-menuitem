#!/bin/bash
if [ -z "$1" ]; then
    read -p "Input the path of the script: " APP_PATH
else
    APP_PATH=$1
fi
read -p "Input the name of the app: " APP_NAME
read -p "Show terminal?(Y/n) " SHOW_TERMINAL
if [ -z "$SHOW_TERMINAL" ] || [ "$SHOW_TERMINAL" != "n" ]; then
    SHOW_TERMINAL=true
else
    SHOW_TERMINAL=false
fi
APP_DIR=$(dirname "${APP_PATH}")
ICON_NAME=$(basename "$APP_PATH" ".sh")
TMP_DIR=`mktemp --directory`
DESKTOP_FILE=$TMP_DIR/$ICON_NAME.desktop
cat << EOF > $DESKTOP_FILE
[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=$APP_NAME
Keywords=$APP_NAME
Comment=$APP_NAME
Type=Application
Terminal=$SHOW_TERMINAL
Exec="$APP_PATH"
Icon=$ICON_NAME
EOF

# seems necessary to refresh immediately:
chmod 644 $DESKTOP_FILE

xdg-desktop-menu install $DESKTOP_FILE
xdg-icon-resource install --size 512 "$APP_DIR/$ICON_NAME.png" $ICON_NAME

rm $DESKTOP_FILE
rm -R $TMP_DIR

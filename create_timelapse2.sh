#!/bin/bash

# Verzeichnis, in dem die Bilder gespeichert sind
IMAGE_DIR="/home/karsten/bilder"

# Temporäres Verzeichnis für umbenannte Bilder
TEMP_DIR="/home/karsten/temp_bilder"

# Name der Ausgabedatei
DATESTAMP=$(date +"%Y-%m-%d")
OUTPUT_VIDEO="zeitraffer_$DATESTAMP.mp4"

# Bildrate für das Video (z.B. 25 Bilder pro Sekunde)
FRAMERATE=25

# Erstelle das temporäre Verzeichnis, falls es nicht existiert
mkdir -p "$TEMP_DIR"
# Lösche alte temporäre Dateien
rm -f "$TEMP_DIR"/*.jpg

# Kopiere die Bilder nach dem Zeitstempel sortiert ins temporäre Verzeichnis und nummeriere sie fortlaufend
COUNT=1
for img in $(ls "$IMAGE_DIR"/*"$DATESTAMP"*.jpg | sort); do
  NEW_NAME=$(printf "$TEMP_DIR/image_%04d.jpg" $COUNT)
  cp "$img" "$NEW_NAME"
  COUNT=$((COUNT + 1))
done

# Erstelle das Zeitraffervideo aus den umbenannten Bildern
ffmpeg -framerate $FRAMERATE -i "$TEMP_DIR/image_%04d.jpg" -c:v libx264 -r 30 -pix_fmt yuv420p -y "$IMAGE_DIR/$OUTPUT_VIDEO"

# Entferne das temporäre Verzeichnis nach dem Erstellen des Videos (optional)
rm -rf "$TEMP_DIR"
# link auf das aktuelle videi erstellen
ln -sf $OUTPUT_VIDEO ${IMAGE_DIR}/capture.mp4
echo "Das Zeitraffervideo wurde als $OUTPUT_VIDEO erstellt."

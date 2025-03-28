#!/bin/bash 

# set -x

# URL der ESP32-Kamera
URL="http://esp32-C26278.fritz.box/capture"

# Verzeichnis, in dem die Bilder gespeichert werden sollen
OUTPUT_DIR="/home/karsten/bilder"

# Sicherstellen, dass das Verzeichnis existiert
mkdir -p "$OUTPUT_DIR"
for i in {1..2}; do
# Endlosschleife zum periodischen Herunterladen der Bilder
  # Zeitstempel erzeugen (Format: Jahr-Monat-Tag_Stunde-Minute-Sekunde)
  TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
  
  # Bild herunterladen und mit Zeitstempel speichern
  FILENAME="$OUTPUT_DIR/image_$TIMESTAMP.jpg"
  curl -o "$FILENAME" "$URL"
#  ln -sf   $FILENAME ${OUTPUT_DIR}/current.jpg
# Dateinamen
OUTPUT="$OUTPUT_DIR/current.jpg"


# Zeitstempel erzeugen (z.B. „2025-03-28 14:35:12“)
TIMESTAMP2=$(date "+%Y-%m-%d %H:%M:%S")

# Zeitstempel ins Bild schreiben (unten rechts)
convert "$FILENAME" -gravity southeast -pointsize 24 -fill white -annotate +10+10 "$TIMESTAMP2" "$OUTPUT"

#  cp   $FILENAME ${OUTPUT_DIR}/current.jpg
  # 10 Sekunden warten

  if [ -f "novideo.txt" ]; then
    # Prüfen, ob die zu löschende Datei existiert
    if [ -f "$FILENAME" ]; then
        rm "$FILENAME"
        echo "$FILENAME wurde gelöscht."
    fi
  fi
  sleep 30
done

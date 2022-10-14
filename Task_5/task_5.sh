#!/bin/bash
set -euo pipefail

ARCHIVES=/var/logs/archive

INPUT_FILENAME=backup.tar.gz
OUTPUT_FILENAME=backup

SOURCE="$ARCHIVES/$INPUT_FILENAME"
TARGET="$ARCHIVES/$OUTPUT_FILENAME"


# a. Установить права на запись для всех пользователей.

chmod a+w "$ARCHIVES"
echo '----------------------'


# b. Распаковать архив [в подпапку].

# Удаляем папку с распакованным бэкапом, если таковая имеется, чтобы случайно не получить помесь двух архивов.
# Можно еще убрать флаг -type d, чтобы скрипт не останавливался, если есть файл с именем $OUTPUT_FILENAME.
find $ARCHIVES -maxdepth 1 -name "$OUTPUT_FILENAME" -type d -exec rm -rf {} \;

# Распаковываем в эту папку.
mkdir "$TARGET" && tar -xvzf "$SOURCE" -C "$TARGET"
echo '----------------------'


# c. Удалить [из этой подпапки] все файлы, которые заканчиваются на .tmp.

find "$TARGET" -name "*.tmp" -type f -delete
echo '----------------------'


# d. Имена всех файлов, содержащие строку.

grep -r -l 'user deleted' "$TARGET" | xargs -n 1 basename

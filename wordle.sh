#!/bin/bash

WORDLIST="/usr/share/dict/words"

# Check that words file exists
if [[ ! -f "$WORDLIST" ]]; then
dialog --msgbox "File '$WORDLIST' not found" 6 40
clear
exit 1
fi

RESULTS=$(egrep "^[a-z]{5}$" "$WORDLIST")

green_filter() {
local WORDLIST="$1"
PATTERN=$(dialog –inputbox "Enter letters (use _ for blanks) " \
8 40 2>&1 >/dev/tty)

# Cancel button
if [[ $? -ne 0 ]]; then
clear
exit 1
fi

if [[ ${#PATTERN} -ne 5 ]]; then
echo "Input must be 5 characters"
exit 1
fi

local REGEX=${PATTERN//_/.}
echo "$WORDLIST" | egrep "^$REGEX$"
}

grey_filter() {
local WORDLIST="$1"
EXCLUDED=$(dialog --inputbox "Enter letters NOT in the word " \
8 40 2>&1 > /dev/tty)

if [[ $? -ne 0 ]]; then
clear
exit 1
fi

for LETTER in $(echo "$EXCLUDED" | grep -E -o .); do
WORDLIST=$(echo "$WORDLIST" | grep -E -v "$LETTER")
done
echo "$WORDLIST"
}

RESULTS=$(green_filter "$RESULTS")
RESULTS=$(grey_filter “$RESULTS”)

TEMPFILE=$(mktemp)
echo “$RESULTS” > “$TMPFILE”

dialog  --title “Matching Words” --textbox "$TMPFILE" 20 50

clear

#!/bin/bash

cd $(dirname $0)
echo starting
output=$(casperjs --verbose --log-level=debug grades.js "$USERNAME" "$PASSWORD")
markup=$(echo "$output" | grep -Ev '^.\[')
logs=$(echo "$output" | grep -E '^.\[')
echo "$logs" >&2
grades=$(echo "$markup" | grep grade_summary | grep -Eo "[^<>]{30,}" | sed -E 's/\.[0-9]{2}|%//g')
for to in $(echo $TO | tr ";,:" " "); do
	email=$(printf "MIME-Version: 1.0\nContent-Type: text/html\nTo: $to\nFrom: $FROM\nSubject: Grades: "; echo "$grades"; echo; echo '<html><body>'; echo "$markup"; echo '</body></html>') 
	echo "$email" | curl --url "smtp://smtp.cox.net" --ssl-reqd --mail-from "$FROM" --mail-rcpt "$to" --upload-file - -v
done

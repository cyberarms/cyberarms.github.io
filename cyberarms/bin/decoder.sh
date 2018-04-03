#!/bin/bash
for i in *.b64; do
	[ -f "$i" ] || break
	fname=$(echo "$i" | cut -f 1 -d '.')
	b64 -d "$i" "$fname".1
	xxd -r "$fname".1 "$fname".2
	scrypt dec -P "$fname".2 "$fname".link <<< cyberarms
	rm "$fname".1 "$fname".2 "$fname".hex &> /dev/null
done

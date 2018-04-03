#!/bin/bash
for i in *.b64; do
	[ -f "$i" ] || break
	b64 -d "$i" "$i".1
	xxd -r "$i".1 "$i.2"
	scrypt dec -P "$i.2" "$i.link" <<< cyberarms
	rm "$i".1 "$i".2
done

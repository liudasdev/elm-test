#!/bin/sh

set -e

folder="public/"
js="elm.js"
min="elm.min.js"

js_path=$folder$js
min_path=$folder$min

elm make --optimize --output=$js_path $@

uglifyjs $js_path --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=$min_path

echo "Compiled size:$(cat $js_path | wc -c) bytes  ($js)"
echo "Minified size:$(cat $min_path | wc -c) bytes  ($min)"
echo "Gzipped size: $(cat $min_path | gzip -c | wc -c) bytes"
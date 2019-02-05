#!/bin/bash

filename=$1
shift

name=$(basename ${filename%.*})
infile="$name.md"
outfile="../_posts/$(date -I)-$infile"
title=${name//-/ }

echo $infile $outfile $title

cat >$outfile <<EOF
---
title: "$title"
tags: $@
---
EOF

# ignore knitr header, first three lines
tail -n +4 $infile >> $outfile

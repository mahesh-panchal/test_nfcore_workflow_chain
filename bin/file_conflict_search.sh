#! /usr/bin/env bash

find subworkflows/*/{assets,bin,lib} -type f -exec md5sum {} + | \
    awk '{
            fname = $2
            sub(".*/", "", fname)
        }
        ((fname in c) && ($1 != c[fname])) {
            printf "%s %s\t%s %s\n", p[fname], c[fname], $2, $1
        }
        {
            c[fname] = $1; p[fname] = $2
        }'
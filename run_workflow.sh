#! /usr/bin/env bash

WORKDIR=${WORKDIR:-$HOME/nxf-work}
nextflow run main.nf \
    -w "$WORKDIR" \
    -profile docker \
    -params-file params.yml
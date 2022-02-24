#! /usr/bin/env bash

PROFILE=${PROFILE:-docker}
WORKDIR=${WORKDIR:-/workspace/nxf-work}
nextflow run main.nf \
    -w "$WORKDIR" \
    -profile "$PROFILE" \
    -params-file params.yml
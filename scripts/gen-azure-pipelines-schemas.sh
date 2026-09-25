#!/usr/bin/env bash
#
#
set -euo pipefail
shopt -s nullglob

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
SOURCES=(
    "https://github.com/jfrog/jfrog-azure-devops-extension"
)
REPOS_DIR="$SCRIPT_DIR/repos"
SCHEMA_OUTPUT="$SCRIPT_DIR/../schemas/azure-pipelines-jfrog.schema.json"
readonly SCRIPT_DIR SOURCES REPOS_DIR SCHEMA_OUTPUT

function cleanup { rm --recursive --force "${REPOS_DIR:?}"; }
trap cleanup EXIT TERM INT

function main {
    cleanup
    mkdir --parents "$REPOS_DIR"
    rm --force "$SCHEMA_OUTPUT"
    (
        cd "$REPOS_DIR"
        for s in "${SOURCES[@]}"; do
            git clone --depth=1 "$s"
        done

        for d in ./*; do
            "$SCRIPT_DIR"/gen-azure-pipelines-schema.py "$d" "$SCHEMA_OUTPUT"
        done

    )
    prettier --write "$SCHEMA_OUTPUT"
}

main "$@"

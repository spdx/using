#! /bin/bash
#
# Validates SPDX example, both in separate files and inline in the
# documentation
#
# SPDX-License-Identifier: MIT

set -e

THIS_DIR=$(dirname $0)

T=$(mktemp -d)

cleanup() {
    rm -rf "$T"
}

trap cleanup EXIT

check_files() {
    local args=""
    for a in $@; do
        args="$args --json=$a"
    done
    spdx3-validate --quiet $args
}


for f in $THIS_DIR/../docs/*.md; do
    if ! grep -q '^```json' $f; then
        continue
    fi
    echo "Checking $f"
    DEST=$T/$(basename $f)
    mkdir -p $DEST

    cat $f | awk -v DEST="$DEST" 'BEGIN{flag=0} /^```json/, $0=="```" { if (/^---$/){flag++} else if ($0 !~ /^```.*/ ) print $0 > DEST "/doc-" flag ".spdx.json"}'

    for doc in $DEST/*.spdx.json; do
        if ! grep -q '@context' $doc; then
            mv $doc $doc.fragment
            cat >> $doc <<HEREDOC
{
    "@context": "https://spdx.org/rdf/3.0.1/spdx-context.jsonld",
    "@graph": [
HEREDOC
            cat $doc.fragment >> $doc
            cat >> $doc <<HEREDOC
        {
            "type": "CreationInfo",
            "@id": "_:creationInfo",
            "specVersion": "3.0.1",
            "created": "2024-04-23T00:00:00Z",
            "createdBy": [
                {
                    "type": "Agent",
                    "spdxId": "http://spdx.dev/dummy-agent",
                    "creationInfo": "_:creationInfo"
                }
            ]
        }
    ]
}
HEREDOC
        fi
    done

    check_files $DEST/*.spdx.json
done



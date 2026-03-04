project_root := justfile_directory()

@help:
    just --list

@generate-options:
    #!/usr/bin/env bash
    set -euo pipefail
    cd ./script/generate-options
    spago run {{project_root}}

@download-docs:
    #!/usr/bin/env bash
    set -euo pipefail
    cd {{project_root}}
    bash ./script/download-docs.sh

@run-example:
    spago --config test.dhall run --main Example

project_root := justfile_directory()

@help:
    just --list

@generate-options:
    #!/usr/bin/env bash
    set -euo pipefail
    cd ./script/generate-options
    spago run {{project_root}}

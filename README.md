# Chaining nf-core workflows

## Setup

```bash
git subtree add --prefix subworkflows/fetchngs https://github.com/nf-core/fetchngs master --squash
git subtree add --prefix subworkflows/rnaseq https://github.com/nf-core/rnaseq master --squash
git subtree add --prefix subworkflows/viralrecon https://github.com/nf-core/viralrecon master --squash
```

### Adding fetchngs
- `include` workflow in main.nf and use `addParams` to override certain options.
- Include fetchngs config with `includeConfig`
- `cp -r subworkflows/fetchngs/lib lib` in $projectDir: WorkflowMain class and it's functions are needed for nfcore functionality
- `nf-core schema build`: Builds the schema needed for nf-core workflow validation. There are bugs!
- `cp -r subworkflows/fetchngs/bin bin` in $projectDir: bin scripts need to be in root of project
- Add `check_max` function to nextflow.config. It's not sourced from the `includeConfig` unlike the rest for some reason.

### Adding rnaseq
- `include` workflow in main.nf and use `addParams` to override certain options.
- Include rnaseq config with `includeConfig`
- Add emit statements to fetchngs workflow
- Copy `getGenomeAttribute` function into `lib/WorkflowMain.groovy`
- Copy `WorkflowRnaseq.groovy` to lib.
- update params.yml
- `cp -r subworkflows/rnaseq/assets assets` in $projectDir.
- `cp -n subworkflows/rnaseq/bin/* bin/` in $projectDir. This folder is specifically mounted in the container. This is why scripts need to be copied, and not symlinked. Alternatively modifying the PATH and adding the correct paths as container mount points should also work.
- remove params.input from file checklist in rnaseq.nf

## Updating

```bash
git subtree pull --prefix subworkflows/fetchngs https://github.com/nf-core/fetchngs master --squash
git subtree pull --prefix subworkflows/rnaseq https://github.com/nf-core/rnaseq master --squash
```

## Notes:

- Check codebase differences with:
    ```
    cd ..
    git clone https://github.com/nf-core/fetchngs
    diff -qr --exclude=.git fetchngs myrepo/subworkflows/fetchngs | cut -d" " -f2,4 | xargs -t -n 2 diff
    ```
- Cannot comment out WorkflowMain (i.e. Groovy classes in lib). Includes functions for autodetecting ID type.

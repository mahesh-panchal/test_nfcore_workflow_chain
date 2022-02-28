# Chaining nf-core workflows

Aim: Chain together nf-core Fetchngs, Rnaseq, and Viralrecon into a single workflow that allows updates to be pulled from source repos.

Disclaimer: Prototype for learning how to chain together nf-core workflows. Output is not tested for accuracy. Bugs are likely.
It's probably less hassle to run the workflows separately than deal with the merge conflicts and code base management when updating.

Status: Leaving as is. Generates results, but stops at final summary step with [this error](https://github.com/mahesh-panchal/test_nfcore_workflow_chain/issues/3). This is because my initial strategy was to try merging files with same names, but this leads to too many method conflicts (and hidden conflicts when methods have the same input but do different things). Files with common names should be made distinct to the workflow. It also allows one to use the commands below to see which files are often in conflict. 

## Basic steps
1. Add workflows with `git subtree`.
2. Find duplicate filenames with different content in assets, bin, and lib. Rename them to be pipeline specific, and update the code bases (run `make file-conflict-search` here).
3. Copy assets, bin, and lib subworkflow folders to their respective folders in the root of the mega-workflow. 
4. Include workflows and includeConfig nextflow.configs, and copy `check_max` function.
5. Add emit, take, and main statements where necessary to be able to chain workflows.
6. Connect it all up.

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
- Add take statements to rnaseq workflow
- Copy `getGenomeAttribute` function into `lib/WorkflowMain.groovy`
- Copy `WorkflowRnaseq.groovy` to lib.
- update params.yml
- `cp -r subworkflows/rnaseq/assets assets` in $projectDir.
- `cp -n subworkflows/rnaseq/bin/* bin/` in $projectDir. This folder is specifically mounted in the container. This is why scripts need to be copied, and not symlinked. Alternatively modifying the PATH and adding the correct paths as container mount points should also work.
- remove params.input from file checklist in rnaseq.nf

### Adding viralrecon
- `include` workflow in main.nf and use `addParams` to override certain options.
- Include viralrecon config with `includeConfig`
- Add conditional to select between viralrecon and rnaseq workflows.
- Copy `subworkflows/viralrecon/lib/Workflow{Commons,Illumina,Nanopore}.groovy` to lib in $projectDir
- Copy `getGenomeAttribute` function to `lib/WorkflowMain.groovy` and differentiate methods as `getViralreconGenomeAttribute` and `getRnaseqGenomeAttribute` in respective workflows.
- `cp -irv subworkflows/viralrecon/assets assets`
- copy bin scripts and rename workflow specific scripts (check diffs with `diff subworkflows/{viralrecon,rnaseq}/bin/check_samplesheet.py`)

### To do:
- Fix schema validation

## Updating

```bash
git subtree pull --prefix subworkflows/fetchngs https://github.com/nf-core/fetchngs master --squash
git subtree pull --prefix subworkflows/rnaseq https://github.com/nf-core/rnaseq master --squash
git subtree pull --prefix subworkflows/viralrecon https://github.com/nf-core/viralrecon master --squash
```

## Notes:

- Check codebase differences with:
    ```
    cd ..
    git clone https://github.com/nf-core/fetchngs
    diff -qr --exclude=.git fetchngs myrepo/subworkflows/fetchngs | cut -d" " -f2,4 | xargs -t -n 2 diff
    ```
- Cannot comment out WorkflowMain (i.e. Groovy classes in lib). Includes functions for autodetecting ID type.
- Be careful about overwriting files in lib, bin, assets, etc. Use `cp -irv source target` to prompt, recurse, and be verbose. Use `diff` to check for file differences, and rename as necessary.
- Probably better to rename duplicate files with different checksums rather than merge and rename functions.

# Chaining nf-core workflows

## Setup

```bash
git subtree add --prefix subworkflows/fetchngs https://github.com/nf-core/fetchngs master --squash
git subtree add --prefix subworkflows/rnaseq https://github.com/nf-core/rnaseq master --squash
```

- `include` workflow in main.nf and use `addParams` to override certain options.
- Include fetchngs config with `includeConfig`
- `mkdir lib && cd lib && ln -s ../subworkflows/fetchngs/lib/* .` in $projectDir: WorkflowMain class and it's functions are needed for nfcore functionality
- `nf-core schema build`: Builds the schema needed for nf-core workflow validation. There are bugs!
- `mkdir bin && cd bin && ln -s ../subworkflows/fetchngs/bin/* .` in $projectDir: bin scripts need to be in root of project

## Updating

```bash
git subtree pull --prefix subworkflows/fetchngs https://github.com/nf-core/fetchngs master --squash
git subtree pull --prefix subworkflows/rnaseq https://github.com/nf-core/rnaseq master --squash
```

## Notes:

- Cannot comment out WorkflowMain (i.e. Groovy classes in lib). Includes functions for autodetecting ID type.
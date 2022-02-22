# Chaining nf-core workflows

## Setup

```bash
git subtree add --prefix subworkflows/fetchngs https://github.com/nf-core/fetchngs master --squash
git subtree add --prefix subworkflows/rnaseq https://github.com/nf-core/rnaseq master --squash
```

- Include fetchngs config with `includeConfig`
- `cp -r subworkflows/fetchngs/lib lib` into $projectDir

## Updating

```bash
git subtree pull --prefix subworkflows/fetchngs https://github.com/nf-core/fetchngs master --squash
git subtree pull --prefix subworkflows/rnaseq https://github.com/nf-core/rnaseq master --squash
```

## Notes:

- Cannot comment out WorkflowMain (i.e. Groovy classes in lib). Includes functions for autodetecting ID type.
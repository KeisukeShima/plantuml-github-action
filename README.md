# PlantUML GitHub action

This action runs the [PlantUML](https://plantuml.com/) tool to generate images from PlantUML text diagrams.

## Inputs

### `args`

**Required** The arguments for PlantUML tool. Default `"-h"`.

## Outputs


## Example usage

This is an an example of a workflow which generates the svg and png images from PlantUML text digram. It will
trigger every time there is a change in a `puml` file.

`.github/worksflows/main.yml`:

```yaml
name: Generate PlantUML Diagrams
on:
  push:
    paths:
      - '**.puml'
    branches:
      - master
jobs:
  ci:
    runs-on: ubuntu-latest
    env:
        UML_FILES: ".puml"
    steps:
      - name: Checkout Source
        uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - name: Get changed UML files
        id: getfile
        run: |
          git diff-tree -r --no-commit-id --summary ${{ github.sha }} \
          | awk -F' ' '{
            # ensure we are not trying to process deleted files
            # only process puml files
            # do not try to process our theme or custom config
            if ( $1 !~ /^delete$/ && $4 ~ /\.puml$/ && $4 !~ /(theme|config)\.puml$/ )
            {
              # only print the file name and strip newlines for spaces
              printf "::set-output name=files::" "%s ", $4
            }
          }
          END { print "" } # ensure we do print a newline at the end
          '
      - name: UML files considered echo output
        run: |
          echo ${{ steps.getfile.outputs.files }}
      - name: Generate SVG Diagrams
        uses: KeisukeShima/plantuml-github-action@master
        with:
            args: -v -tsvg ${{ steps.getfile.outputs.files }}
      - name: Generate PNG Diagrams
        uses: KeisukeShima/plantuml-github-action@master
        with:
            args: -v -tpng ${{ steps.getfile.outputs.files }}
      - name: Push Local Changes
        uses:  stefanzweifel/git-auto-commit-action@v4.1.2
        with:
          commit_user_name: "my user name"
          commit_user_email: "me@email.org"
          commit_author: "My User <me@email.org>"
          commit_message: "Generate SVG and PNG images for PlantUML diagrams"
          branch: ${{ github.head_ref }}
```

The last step will commit the generated images back into the master branch.

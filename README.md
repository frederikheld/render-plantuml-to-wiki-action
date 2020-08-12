# Render PlantUML to Wiki

This GitHub action renders [PlantUML](https://plantuml.com/) diagrams and pushes them to your wiki.

In order to do so, it uses an instance of the [PlantUML Java app](https://plantuml.com/download) that runs within your GitHub project instead of the [public PlantUML render service](http://www.plantuml.com/plantuml/uml/). Therefore this action can be safely used in private GitHub projects as it doesn't leak your diagrams to the public.

## Usage

First you need to create an authentication token that gives the action access to your repo.

Follow [this documentation](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) to create the token. Then follow [this documentation](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets) to add the secret to your organization. Name the Secret `WIKI_AUTH_TOKEN`.

Now add the following lines to your workflow script:

```sh
    - name: Render PlantUML to wiki
      uses: frederikheld/plantuml-github-action@alpha
      env:
        WIKI_AUTH_TOKEN: ${{ secrets.WIKI_AUTH_TOKEN }}
        INPUT_DIR: 'input_directory'
        OUTPUT_DIR: 'output_directory'
```

## Environment variables in detail

| Variable | Expected content |
| - | - |
| WIKI_AUTH_TOKEN | The token you have created above. You can access the token via `${{ secrets.WIKI_AUTH_TOKEN }}`. If you have named it differently, you need to change the name accordingly.
| INPUT_DIR | Relative path from the root of your _source code repository_ to the _PlantUML_ source files |
| OUTPUT_DIR | Relative path from the root of your _wiki repo_<sup>1</sup> to the directory you want to have the generated diagrams being placed in

<sup>1</sup> although the wiki is part of your repository on GitHub, it technically is a separate git repository, that you can clone and push changes to. Note that this repo has limited capabilities, e.g. missing support for [Git LFS](https://git-lfs.github.com/)!

## What will be generated?

This action will recursively look for files that contain `@startXYZ` in `INPUT_DIR` of the _repo you run this action in_ and render them into `.png` files. Those generated files are then copied to `OUTPUT_DIR` in the _wiki of your repo_.

You can then embed the images into your wiki pages like this:

```md
[[/output_directory/my-image.png|Alt text]]
```

You can add this step multiple times to your workflow with different input and output directories, e.g. `/planning` with Gantt charts and `/architecture` with UML diagrams.

NOTE: The generated files be will named after the `diagram name` specified in `@startXYZ diagram name`, not after it's original file name! If a file contains multiple diagrams, a separate output file will be generated for each diagram!

To make this easier for you, the action will print embedding markup for all available images after rendering is completed.

## Next Steps

- [ ] improve speed of docker build by using an image that comes with pre-installed jre and git (right now the preparation takes >1 minute while the rendering only takes seconds)
- [ ] allow generation of other file types than PNG
- [ ] allow user to set git config user.name and user.email via env variables

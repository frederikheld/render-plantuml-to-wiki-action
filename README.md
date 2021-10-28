# Render PlantUML to Wiki

This GitHub action renders [PlantUML](https://plantuml.com/) diagrams and pushes the images to your wiki. You can then embed them into your wiki pages.

For rendering, it uses an instance of the [PlantUML Java app](https://plantuml.com/download) that runs within your GitHub project instead of the [public PlantUML render service](http://www.plantuml.com/plantuml/uml/). Therefore this action can be safely used in private GitHub projects as it doesn't leak your diagrams to the public.

> The following documentation describes the use of this action within an organization, but should work with personal repositories as well.

## Usage

First make sure that your wiki is initalized. This means that you need to create at least one page in the wiki before this action can push the rendered diagrams to it. Otherwise the action will fail.

Then you need to create an authentication token that gives this action access to your wiki. This is neccessary since `${{ secrets.GITHUB_TOKEN }}`, which is automatically available within workflows, doesn't work with the wiki.

Follow [this documentation](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) to create the token. Then follow [this documentation](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets) to add the secret to your organization. Name the secret `WIKI_TOKEN`.

Now add the following lines to your workflow script:

```sh
    - name: Render PlantUML to wiki
      uses: frederikheld/render-plantuml-to-wiki-action@v1.0.1
      with:
        WIKI_TOKEN: ${{ secrets.WIKI_TOKEN }}
        INPUT_DIR: 'path/to/input_directory'
        OUTPUT_DIR: 'path/to/output_directory'
        OUTPUT_FORMAT: "[PNG | SVG | PDF | EPS]"
```
##### Legend
`OUTPUT_FORMAT` - Select one of the available formats to generate images. If the selected format is not valid it will default to PNG.

You can add this step multiple times to your workflow with different input and output directories, e.g. `planning` with Gantt charts and `architecture` with UML diagrams.

NOTE: The generated files be will named after the `diagram name` specified in `@startXYZ diagram name`, not after it's original file name! If a file contains multiple diagrams, a separate output file will be generated for each diagram!

To make it easier for you to embed the image, the action will print embedding markup for all available images after rendering is completed.

## Arguments

| Variable | Expected content |
| - | - |
| WIKI_TOKEN | The token you have created above. You can use the token via `${{ secrets.WIKI_TOKEN }}`. If you have named it differently, you need to change the name accordingly.
| INPUT_DIR | Relative path from the root of your _source code repository_ to the _PlantUML_ source files |
| OUTPUT_DIR | Relative path from the root of your _wiki repo_<sup>1</sup> to the directory you want to have the generated diagrams being placed in
| OUTPUT_FORMAT | Format for the generated images, One of the formats: PNG, SVG, PDF or EPS

<sup>1</sup> although the wiki is shown as part of your repository on GitHub, it technically is a separate git repository that you can clone and push changes to. Note that this repo has limited capabilities, e.g. missing support for [Git LFS](https://git-lfs.github.com/)!

## What will be generated?

This action will recursively look for files that contain `@startXYZ` in `INPUT_DIR` of the _repo you run this action in_ and render them into `.png` files. Those generated files are then copied to `OUTPUT_DIR` in the _wiki of your repo_.

You can then embed the images into your wiki pages like this:

```md
[[/path/to/output_directory/my-image.png|alt=alt text]]
```

In the same way you can set other attributes that can be used with the HTML `<img/>` tag. Each attribute has to be separated with a pipe symbol. One attribute you might need often is `width`, as images are embedded in their full size if no size attributes given:

```md
[[/path/to/output_directory/my-image.png|width=300px|alt=alt text]]
```

## Next Steps

- [ ] improve speed of docker build by using/creating an image that comes with pre-installed dependencies (right now the preparation takes >1 minute while the rendering only takes seconds)
- [ ] split into two separate actions: render to artifact & push artifact to wiki
- [x] allow generation of different file types than PNG
- [ ] allow user to set git config user.name and user.email via env variables

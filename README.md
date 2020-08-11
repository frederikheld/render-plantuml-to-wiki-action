# plantuml-github-action

This GitHub action that renders PlantUML diagrams. It doesn't use the [public PlantUML render service](http://www.plantuml.com/plantuml/uml/) but an instance of the [PlantUML Java app](https://plantuml.com/download) that runs within your GitHub project. 

Therefore this action can be used in private GitHub projects as it doesn't leak your diagrams to the public.

## Usage

Add the following lines to your workflow script:

```sh
    - name: Render PlantUML to wiki
      uses: frederikheld/plantuml-github-action@alpha
      with:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        INPUT_DIR: '/input_directory'
        OUTPUT_DIR: '/output_directory'
```

This action will recursively look for files that contain `@startXYZ` in `INPUT_DIR` in the _repo you run this action in_ and render them into `.png` files that are pushed to `OUTPUT_DIR` in the in the _wiki of your repo_.

You can then embed the images into your wiki pages like this:

```md
[[/output_directory/my-image.png|Alt text]]
```

NOTE: The wiki must be part of the repo you run this action in!

You can also run this step multiple times with different input and output directories, e.g. `/planning` with Gantt charts and `/architecture` with UML diagrams.

NOTE: The generated files be will named after the `diagram name` specified in `@startXYZ diagram name`, not after it's original file name! If a file contains multiple diagrams, a separate output file will be generated for each diagram.

## Development

PlantUML is running in a Docker container. If you want to fundamentally change the rendering process of this action, you can build and run the container manually to debug your changes.

The Docker container can be built with

```sh
$ docker build -t render-plantuml .
```

To render PlantUML diagrams from `./input_directory` to `./output_directory`, run

```sh
$ docker run --rm --volume $(pwd)/input_directory:/input --volume $(pwd)/output_directory:/output render-plantuml
```

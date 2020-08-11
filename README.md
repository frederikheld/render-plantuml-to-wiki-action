# plantuml-github-action

This GitHub action that renders PlantUML diagrams. It doesn't use the [public PlantUML render service](http://www.plantuml.com/plantuml/uml/) but an instance of the [PlantUML Java app](https://plantuml.com/download) that runs within your GitHub project. 

Therefore this action can be used in private GitHub projects as it doesn't leak your diagrams to the public.

## How to use this Action

This action is pre-configured to render all files from `./input_directory` to `./output_directory`. You can change the names of those directories if you need.

You can also run the _Render Diagrams_ step multiple times with different input and output directories, e.g. `planning` with Gantt charts and `architecture` with UML diagrams.

The container will recursively look for files that contain `@startXYZ` in the _input directory_ and render them into `.png` files in the _output directory_. It will keep the nested directory structure.

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

# plantuml-github-action

GitHub Action that renders PlantUML diagrams. It doesn't use the [public PlantUML render service](http://www.plantuml.com/plantuml/uml/) but an instance of [PlantUML Server](https://github.com/plantuml/plantuml-server) that runs within your GitHub project. 

Therefore this action can be used in private GitHub projects as it doesn't leak your diagrams to the public.

## Usage

The Docker container can be built with

```sh
$ docker build -t render-plantuml .
```

To render PlantUML diagrams from `./input_directory` to `./output_directory`, run

```sh
$ docker run --rm --volume $(pwd)/input_directory:/input --volume $(pwd)/output_directory:/output render-plantuml
```

The container will recursively look for files that contain `@startXYZ` in `./input_directory` and render them into `.png` files in `./output_directory`. It will keep the nested directory structure.

NOTE: The generated files be will named after the `diagram name` specified in `@startXYZ diagram name`, not after it's original file name! If a file contains multiple diagrams, a separate output file will be generated for each diagram.
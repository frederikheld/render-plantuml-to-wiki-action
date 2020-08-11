# plantuml-github-action

This GitHub action that renders PlantUML diagrams. It doesn't use the [public PlantUML render service](http://www.plantuml.com/plantuml/uml/) but an instance of the [PlantUML Java app](https://plantuml.com/download) that runs within your GitHub project. 

Therefore this action can be used in private GitHub projects as it doesn't leak your diagrams to the public.

## Usage

In order to push files to the wiki, you need to create an access token that can be used by the action to do so.

Follow this documentation to create an token: https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token

Then follow this documentation to add the secret to your organization: https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets. Name the Secret `WIKI_AUTH_TOKEN`.


Now add the following lines to your workflow script:

```sh
    - name: Render PlantUML to wiki
      uses: frederikheld/plantuml-github-action@alpha
      with:
        WIKI_AUTH_TOKEN: ${{ secrets.WIKI_AUTH_TOKEN }}
        INPUT_DIR: '/input_directory'
        OUTPUT_DIR: '/output_directory'
```

This action will recursively look for files that contain `@startXYZ` in `INPUT_DIR` of the _repo you run this action in_ and render them into `.png` files. Those generated files are then copied to `OUTPUT_DIR` in the _wiki of your repo_.

You can then embed the images into your wiki pages like this:

```md
[[/output_directory/my-image.png|Alt text]]
```

You can add this step multiple times to your workflow with different input and output directories, e.g. `/planning` with Gantt charts and `/architecture` with UML diagrams.

NOTE: The generated files be will named after the `diagram name` specified in `@startXYZ diagram name`, not after it's original file name! If a file contains multiple diagrams, a separate output file will be generated for each diagram!

To make this easier for you, the action will print embed markup for all available images after rendering is completed.

## Next Steps

- [ ] improve speed of docker build by using an image that comes with pre-installed jre and git
- [ ] allow user to set git config user.name and user.email

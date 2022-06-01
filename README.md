# strapi-cms

Strapi CMS demo.

### Build and deployment overview

We build our CMS application from scratch when deploying. 
This ensures that we are always using a clean Strapi installation when building a new app, which decouples the Strapi core from any customizations we require. 
It also simplifies the upgrade process in the event of any changes to the core Strapi CMS application.  

- Build our Node.js (Alpine Linux) and Strapi base images
- Build Strapi CMS base image
  - Generate a default Strapi CMS app; this ensures we're always working with a clean, official Strapi installation
  - Install Node.js packages
  - Copy custom application files from `./strapi/app` into CMS application base image
    - Install any strapi plugins or 3rd party packages used in custom app files
- Run the Strapi CMS base image to generate a default Strapi application containing any custom mods

At this point you will be able to run the generated application using `strapi develop`. You are now ready to start deploying the application.
- Build a deployment image (optional, for staging / production deployment)
- Run deployment image (optional, for staging / production deployment)

### Building the Strapi CMS base image

You'll need to build the Strapi CMS base image before you can generate and run the actual Strapi CMS application.

<b>IMPORTANT!</b> This assumes you have an existing postgres instance, with an existing `strapi_demo` database.

To build the Strapi CMS base image locally, run the following script. 
We follow a similar process for our staging and production deployments.

```shell
docker build \
  --build-arg NODE_VERSION=16.15.0-alpine \
  --build-arg STRAPI_PKG=@strapi/strapi@4.1.12 \
  --build-arg DATABASE_CLIENT=postgres \
  --build-arg DATABASE_HOST=host.docker.internal \
  --build-arg DATABASE_PORT=5432 \
  --build-arg DATABASE_NAME=strapi_demo \
  --build-arg DATABASE_USERNAME=postgres \
  --build-arg DATABASE_PASSWORD=postgres \
  -t strapi-cms-base \
  --progress=plain \
  ./strapi
```

### Generating the CMS application

To generate the CMS application using the Strapi CMS base image we created in the previous step, run the following script.
We follow a similar process for our staging and production deployments.

IMPORTANT! We can run as a detached process locally, which improves performance. However, if you do this from within
a workflow (any build runner), the task may move on before the file generation is completed, leading to errors.
Make sure you remove the `-d` flag when executing this step in a runner!

```shell
docker run -d --rm \
  --name strapi-cms-builder \
  -v `pwd`/app:/srv/app \
  strapi-cms-base
```

Wait for the step to complete before continuing. Files will be generated in the mounted `./app` folder on the host.

### Running the CMS application (locally)

Open a terminal window and navigate to the `./app` folder. Run the app using `yarn strapi develop`.

You may run into the following error:
*Could not load js config file: node_modules/@strapi/plugin-upload/strapi-server.js*

Simply run `npm rebuild sharp` to fix the problem. <b>Because our images use Alpine Linux, 
you'll need to rebuild the sharp dependency for your local operating system.</b> 
Sharp is used by the `strapi-upload` plugin.

### Running the generated Strapi CMS application in Docker

<b>IMPORTANT!</b> Our actual staging / production deployment is a bit different than what we do here as we're using GitHub Actions. This is just an example illustrating how to run the generated application in a containerized environment using Docker.
See `./.github/workflows` for the actual staging and production workflows.

To deploy the generated Strapi CMS application, we'll have to follow a few more steps.

First, build the application image. Don't forget to supply the same NODE_VERSION used when building the Strapi CMS base image.

```shell
docker build \
  --build-arg NODE_VERSION=16.15.0-alpine \
  -t strapi-cms \
  --progress=plain \
  ./app
```

You can now run the Strapi CMS application image using `docker run`, supplying any environment variables required by the application.
The database defaults will have already been configured when we initially built our Strapi CMS base image, but you can override the values here.

To run in development mode, you can use the script below as is. Don't forget to fill in the AWS variables!

Note! You may have to set DATABASE_HOST to `host.docker.internal` when running locally or you'll get an error: 
*connect ECONNREFUSED 0.0.0.0:5432*

<b>To compile distribution files for production</b>, replace `yarn strapi develop` with `yarn strapi build`.

```shell
docker run -it \
  --rm \
  --name strapi-cms \
  -p 1337:1337 \
  -p 5432:5432 \
  -e HOST=0.0.0.0 \
  -e PORT=1337 \
  -e DATABASE_HOST=host.docker.internal \
  -e APP_KEYS=pnnOz4ItNpDQ+5vRIUP4cA==,JLxLnJiqbbM+xmfXsXAxgw==,ym53dOPwxger/RepMVaCxg==,oFZuX6GaxTwpesiMKA24OA== \
  -e API_TOKEN_SALT=GJ7EC5bDlq95mbH7u/rXDQ== \
  -e ADMIN_JWT_SECRET=bRoIMxutKJgCU4s/4Nv3WA== \
  -e JWT_SECRET=FWgNGMQOVEgLeEgnujtJXg== \
  -e AWS_ACCESS_KEY_ID='' \
  -e AWS_ACCESS_SECRET='' \
  -e AWS_REGION='' \
  -e AWS_BUCKET='' \
  strapi-cms yarn strapi develop
```

### Quick start using docker-compose

To demo the application locally without setting up an external postgres instance or creating a database,
run the following command: `docker compose up`

### Plugins and 3rd party dependencies

As this project builds the CMS application from scratch using a clean Strapi installation,
any Strapi plugins (which are NPM packages) need to be added when we create the Strapi docker image.
Plugins or 3rd party libraries should be added in `./strapi/docker-entrypoint.sh`. Do not alter the package.json in
the generated Strapi application files residing in the `./app` dir as it is automatically generated as part of the build process.

#### Notes regarding @strapi/provider-upload-aws-s3
- This project uses the @strapi/provider-upload-aws-s3 plugin to allow media uploads to AWS S3. Please see the official documentation for installation instructions.
- A custom Strapi provider configuration (see `./strapi/config/plugins.js`) and changes to Strapi security middleware (see `./strapi/config/middlewares.js`) are required.
- These are the minimum amount of AWS Policy Actions permissions needed for this provider to work.

  ```shell
  "Action": [
    "s3:PutObject",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:DeleteObject",
    "s3:PutObjectAcl"
  ],
  ```

#### Data migrations

There are two cases where we need to consider data migrations.

- The first case is when migrating major Strapi versions. This is out of scope in terms of what we can reasonably cover in this README.
  Please see the official docs at https://docs.strapi.io/developer-docs/latest/update-migration-guides/migration-guides.html for more information.

- The second case is when we make changes to our own custom data model in `./src/api`, for example.

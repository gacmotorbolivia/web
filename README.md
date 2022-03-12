## Requirements

- [Docker v19+](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- [docker-compose v1.23+](https://docs.docker.com/compose/install/)
- [docker-compose via pip](https://pypi.org/project/docker-compose/)
- make

## Set up development environment

if you want to describe the images docker of gitlab

    shell
        docker login registry.gitlab.com
        docker pull registry.gitlab.com/bjvta/gac-motor/backend:latest
        docker pull registry.gitlab.com/bjvta/gac-motor/backend:develop

### We run the development environment
In the root directory of the project.
Create a .env file, there you can custom environment variables if you need it.

     shell
        touch .env
        chmod 600 .env

create the .env file

        DJANGO_SECRET_KEY="ko8n3#^m#67+p@bvx#1xp0om+!zo@&l8-*8n(c#47n)=!3t$hd"
        DJANGO_DATABASE_HOST=database
        DJANGO_DATABASE_NAME=gac_master
        DJANGO_DATABASE_USER=postgres
        DJANGO_DATABASE_PASSWORD=postgres
        
Type in the bash

        make backend
        
Inside the container 
        
        make requirements
        make

Then we need to migrate

        python src/manage.py migrate


Before running the application we need to run the frontend, go to `src/frontend` and run

        yarn install
        yarn run server

Now we can run the project, inside the container please

        make runserver


Then you can go to http://0.0.0.0:8000


To create a super user with the following command

        python src/manage.py createsuperuser
        # Set your username
        # Email: leave the email blank
        # Password: set the first password
        # Confirma Password: repeat the password


## Test

In order to have everything right, please create test and run with the command inside de container

        make test
        # This command will run 
        # python src/manage.py test gac.apps.common --settings=gac.settings.test
        # This is for the common app

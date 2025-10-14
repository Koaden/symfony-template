# Symfony template

This template provides you to quickly start a Symfony project running with docker compose and a MySQL database.
A makefile is also ready to use for basic Symfony interractions.

## Requirements

- [Docker](https://docs.docker.com/engine/install/)
- [Docker compose](https://docs.docker.com/compose/install/)

## Quick start

1. **Clone this repository**
    ```bash
   git clone https://github.com/Koaden/symfony-template.git my-project
2. Remove `.git` folder
3. Duplicate `.env.dist` and rename it `.env`
4. Setup Symfony project
    1. Set `SYMFONY_VERSION` you want to use in `.env` 
    2. Create symfony project
        ```bash
        make install-symfony
        ```
        **or** with the webapp configuration
        
        ```bash
        make install-symfony-webapp
    3. Clear the cache
        ```bash
        make cc
    4. Remove the setup section in the `makefile`
5. Prepare your project for GitHub
    ```bash
    git init my-project
6. Update this `README.md` to match your project
7. Make your first commit on the `main` branch 
    ```bash
    git commit -m "chore: init"
    git push
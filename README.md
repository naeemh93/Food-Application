# Overview
Ruby on rails application using Contentful API to fetch Recipe list and Recipe details.

# pre-requiste
Create .env file in root directory. Add the required fields *SPACE_KEY*, *ACCESS_TOKEN*, *ENV_ID* as key-value pair in it.

```
SPACE_KEY=randomkey
ACCESS_TOKEN=randomtoken
ENV_ID=env
```
# Running application
1. clone the project
2. bundle install
3. bundle exec rails webpacker:install
4. Server would be running at localhost:3000

# Implementation details
The web application comprises  of providing endpoints using services, for fetching data from Contentful API to fetch all recipes based upon their creation and individual 
recipe details from the Contentful Api.
 - Recipe listing page (`/recipe`)
 - Recipe detail page (`/recipes/:id`)


# Running tests
The tests coverage can be seen by running `rspec` for the entire app or individual files.

# Enhancements
- Add docker to run App.
- Beautify UI layout
- Add vcr for testing Apis properly.
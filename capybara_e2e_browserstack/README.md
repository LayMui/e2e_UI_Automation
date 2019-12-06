# e2e test automation

```
Clone from github
git clone https://github.com/taigers/iconverse/tree/develop/iconverse-e2e/iconverse-qa-e2e.git

To run in local environment with dependencies setup
-Install Ruby 
-Install bundle (bundle is a library to simplify the task of installing several gems)
-Go to project root folder and run
    bundle install
-Run the test
    rake

Build the docker image, Go to the folder with the Makefile
    make docker-build

Run the docker image built
    make test

Structure:

```bash
├── Dockerfile
├── Makefile
├── Gemfile
├── Gemfile.lock
├── README.md
├── run_cucumber.sh
└── config
    ├── local.config.yml
    ├── parallel.config.yml
    ├── single.config.yml
└── features
    ├── signin.feature
    ├── roles_privileges.feature
    ├── user_management.feature
    ├── ....
    └── support
        ├── env.rb
        ├── hooks.rb
        ├── world.rb
    └── step_definitions
        ├── sign_in.rb
        ├── roles_privileges.rb
        ├── user_management.rb
        ├── ...
```

The high level feature files served as the living documentation that express scenarios
in business domain specific language using Gherkins syntax 'Given, When, Then'

Ruby code that supports step definition can go into the features/support which are loaded 
before the step definitions

The env.rb is loaded first. This is where you need to boot up your app

Cucumber read the features file and map to the step definitions
1 file per domain entities such as signin, roles_privileges, user_management, etc
Step definition execute in the context of an Object called the World.
By adding my own World module, we make the step definition code easier to read and
able to decouple the step definition from the system.
Any @instance_variable instantiated in a step definition will be assigned to the World, and can be accessed from other step definitions. Example The Actor (super_admin) @james.

Includes modules with helper method to the World

To integrate with browserstack
set the env variables
export BROWSERSTACK_USERNAME=laymui2
export BROWSERSTACK_ACCESS_KEY=vCp16gSeuYeLAGuKjDcr


Environment variables  are found at 
<project directory>/.env 

reference: 
https://github.com/browserstack/capybara-browserstack


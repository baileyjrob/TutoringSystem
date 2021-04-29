# OR Tutoring Service

This website serves as a way to manage tutoring by keeping track of tutors and students, their meetings, the number of hours spent tutoring, and allows students to easily match with tutors they desire. It also aids in the Spartan Tutoring program used by the Corps of Cadets.

## Requirements

This code has been tested on Windows, WSL, and Linux. Windows functionality requires some additional steps and effort to maintain, so if it can be avoided, it is recommended.

Ruby 2.7.2 was primarily used to develop this, although your mileage with different versions may vary. However, Ruby is required in order to download the gems used. You will also need PostgreSQL. The specific version on this end is 13beta3, but this is less important, and any moderately recent version of PostgreSQL should do the trick. Finally, you will need to have yarn.

## Installation

First, make sure you have bundler and yarn installed.

```bash
gem install bundler
yarn set version berry
```

Once this has been installed, the first step is to setup all dependencies that the code requires.

```bash
bundle install
yarn
```

This should run mostly without a hitch. These may take some time on the first execution, but eventually you should be good to go. In the event that there is some error with a missing dependency or something of that ilk, the terminal should output the error, so simply follow the instructions the terminal gives you until you get a success.

There is one final gem that must be installed, however. It cannot be placed into the gemfile, so it must be installed individually. As before, however, this is a simple matter:

```bash
gem install mailcatcher
```

Mailcatcher is a gem used for testing certain mail functions. It is not required if you do not intend to run tests, but if you do, it should be installed.

## Environment Setup

A few more steps are required before we're ready to use the code. First, create a file "/config/local_env.yml". In this file should be the following lines:

```yaml
LOCAL_POSTGRES_USERNAME: 'XXX' # Replace 'XXX' with your local postgres username
LOCAL_POSTGRES_PASSWORD: 'YYY' # Replace 'YYY' with your local postgres password
```

This will allow the environments to actually use PostgreSQL on your local machine. Don't worry: if you decide to use this repo in your own github repo, the .gitignore will ignore this file, so your credentials are completely safe.

Finally, you'll need to actually create the database. This is a single command:

```bash
bundle exec rake db:setup
```

With this, you're ready to go. If this command gives you errors, double check that your PostgreSQL credentials actually match your local machine: it can be finnicky sometimes.

## Testing

This website utilizes rspec to perform automatic testing. In order to test the entire codebase, simply execute

```bash
bundle exec rspec
```

Be aware that this can take awhile, especially on your first run, so do not be too alarmed if it seems to be going very slowly. Many of our specs, especially unit tests, use Capybara to test end-user functionality. As a result, some tests require JavaScript compatability. By default, "apparition" is used as the JS engine for Capybara. If you use Windows, go to '/spec/spec_helper.rb' and either uncomment line 26,

```ruby
Capybara.javascript_driver = :selenium_chrome_headless
```

or replace line 24,

```ruby
Capybara.javascript_driver = :apparition
```

with the former. Note, by the way, that two tests will still fail after this is done, resulting in output containing the following:

```bash
 1) TutoringSessionController SHOW is able to delete session
     Failure/Error: expect(TutoringSession.all.count).to eq(0)

       expected: 0
            got: 1

       (compared using ==)
     # ./spec/feature/tutoring_session_controller_scheduler_spec.rb:184:in `block (3 levels) in <top (required)>'

  2) TutoringSessionController SHOW is able to delete session and any repeating sessions at the same time
     Failure/Error: expect(TutoringSession.all.count).to eq(0)

       expected: 0
            got: 2

       (compared using ==)
     # ./spec/feature/tutoring_session_controller_scheduler_spec.rb:199:in `block (3 levels) in <top (required)>'
```

We have been unable to determine why this occurs, but we can assure you that it is a false negative: this error only appears on Windows machines using selenium_chrome, and nothing can appear to fix it. This is why it is recommended to avoid Windows if possible. It's a minor bug that only affects the testing side of things, not the end result.

## Heroku

Currently, the main [site](https://ortutoring.herokuapp.com/) is hosted on Heroku. If one wished to directly update the website, they would first need to connect to the Heroku repo.

First, you need permission to access the Heroku repo. Presumably, if you are reading this, this is already the case. If this is not the case, the only way to get it is by directly asking the owner to grant it to you. 

If you wish to use the command line, you must first download the Heroku CLI. This can be done via their [website](https://devcenter.heroku.com/articles/heroku-cli).

You can establish a direct connection to the website by using the following command:

```bash
heroku git:remote -a ortutoring
```

You can then push directly to production using

```bash
git push heroku <local branch>:main
```

Naturally, this is ill-advised. You could instead push to staging using

```bash
heroku git:remote -a tutoring-session-staging-2
```

Followed by a push command. If you choose to have both a staging and production remote, make sure to rename them. For example:

```bash
git remote rename heroku heroku-staging
```

An app in staging can be promoted to production either by pushing the changes to production once you're satisfied or via the Heroku dashboard. Navigate to the [tutoring-system-pipeline](https://dashboard.heroku.com/pipelines/b62c12df-a022-4cd9-9e67-7cfb963e5f0c) and test your staged build by clicking "Open app". Once satisfied, clicking "promote to production" will make the changes go live to the world.

Finally, a command of the form 

```bash
heroku open
```

Will send you to the online version of the "heroku" app (be that production, staging, whatever remote you named "heroku"). Alternatively,

```bash
heroku local
```

Will start up a local version. By default, the local version of the website can be accessed by running this command, then going to a webbrowser of your choice and searching "localhost:3000". 

## CI/CD

Rather than pushing manually to each branch, CI/CD can be implemented to make your development and maintenance far easier. As it currently is, the pipeline is set to automatically deploy from its development [repository](https://github.com/baileyjrob/TutoringSystem). If you wish, this can be changed by navigating to the [tutoring-system-pipeline](https://dashboard.heroku.com/pipelines/b62c12df-a022-4cd9-9e67-7cfb963e5f0c), clicking the settings tab, clicking the "Disconnect..." button, then linking in your repo of choice. 

If you do this, make sure you go to [tutoring-session-staging-2](https://dashboard.heroku.com/apps/tutoring-session-staging-2), make sure it's connected to the right repo, and make sure "automatic deploys" are enabled. Best practice would be to make sure it's pulling from your master or main branches.

For CI, two jobs exist. One lints the code to make sure it's held up to standard (this is performed every push), while the other runs all rspec tests to make sure the code hasn't broken (this only runs whenever master is being altered).

To set this up in your own repo, first go to the "Actions" tab of your repo and make sure you have two workflows listed: "Rubocop" and "Ruby". This should happen automatically due to them being in the workflows folder, but making sure couldn't hurt. Then, go to the settings tab. In the settings tab, choose Branches. Create two branch protection rules: make one apply to your master/main/production branch, and make the other apply to your development branch. In the master branch rule, check "require status check to pass before mergine", then check both status check boxes ("lint" and "test (2.7)"). In the dev branch rule, do the same thing, but do not check "test (2.7)").

Note that if you do not name your primary branch "master", you must go into ".github/workflows/ruby.yml" and change the first few lines from 

```yaml
on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]
```

to

```yaml
on:
  push:
    branches: [ <your production branch name> ]
  pull_request:
    branches: [ <your production branch name> ]
```

Now, any time you make a Pull Request into master/main/production, the code will be required to pass all tests before it can be merged.

## License

OR Tutoring Service was built by Bailey Robinson, Amanda Latham, Nick Isom, Savannah Yu, and Cameron Bourque, as part of the CSCE 431 Spring 2021 class project under Professor Pauline Wade and the TA Manseerat Batra, for use by the General O.R. Simpson Corps Honor Society at Texas A&M University. I'm not sure where that puts this legally but credit where it's due.

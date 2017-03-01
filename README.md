Cohorts &nbsp;|&nbsp; [ ![Codeship Status for adhocteam/cohorts](https://app.codeship.com/projects/e156b990-bb11-0134-b27f-0ac68540e3ab/status?branch=master)](https://app.codeship.com/projects/195552)
=====

Cohorts is an application to manage people that are involved Ad Hoc user research. It is heavily based on [kimball](https://github.com/smartchicago/kimball), originally developed for the Smart Chicago CUTGroup.

Features
--------

Cohorts is a tool to recruit, manage, and communicate with a large pool of people to test the products we build. Cohorts stores information about people that have signed up to participate in Ad Hoc user research. It does so by integrating with three external services:
* [Wufoo](https://www.wufoo.com/) is used to create web forms that can be sent out to participants to collect more information about them.
* [Twilio](https://www.twilio.com/) is used to communicate with participants via SMS.
* [Mailchimp](https://mailchimp.com/) is used to communicate with participants via email.

Setup
-----
Cohorts is a Ruby on Rails app. The regular rules apply:
1. Locally or in a VM, install dependencies:
    * **MySQL** - `sudo apt-get mysql-server` / `brew install mysql`
    * **Ruby 2.3.1** - Install using [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/rvm/install)
    * **Bundler** - `gem install bundler` after installing Ruby
2. Clone this repo
3. In the project directory, run `bundle install`
4. Setup the database by running `bundle exec rake db:setup` - make sure you have `MYSQL_PWD` defined as an environment variable
5. Run the app with `rails s`!

Services and Environment Variables
--------
Environment variables live here: [/config/local_env.yml](/config/local_env.yaml). The defaults are drawn from [/config/sample.local_env.yml](/config/sample.local_env.yaml).

local_env.yml, which should not be committed, and should store your API credentials, etc.

If a variable isn't defined in your local_env.yml, we use the default value from sample.local_env.yml, which is checked into the respository.

* **Organizational Defaults**

* **Wufoo**
  * Wufoo hosts all forms used for Cohorts.
  * On the Server Side there are 4 environment variables used:
    * WUFOO_ACCOUNT
    * WUFOO_API
    * WUFOO_SIGNUP_FORM
    * WUFOO_HANDSHAKE_KEY
  * For SMS signup and form fills, "SMS Campaigns" are created in the Cohorts app to associate a Wufoo form ID.
  * Webhooks are used on Wufoo to send data back to Cohorts. Currently there are 2 webhooks in use:
    * /people : This endpoint is used for new signups via the main signup/registration wufoo form.
    * /people/create_sms : This endpoint is used for new signups via the signup/registration Wufoo form that has been customized for SMS signup.
    * /submissions : This endpoint is for all other Wufoo forms (call out, availability, tests). It saves the results in the submissions model.
* **Twilio**
  * Twilio is used to
     - send and receive text messages for sign up, notifications, and surveys.
     - schedule interviews and calls
  * Three Twilio phone numbers are needed.
    - Text message signup, notifications, and surveys.
    - Text message verification.
    - Scheduling
  * On the Server Side there are several environment variables used:
    * TWILIO_ACCOUNT_SID
    * TWILIO_AUTH_TOKEN
    * TWILIO_SURVEY_NUMBER
      - /receive_text/smssignup #POST
    * TWILIO_SIGNUP_VERIFICATION_NUMBER
      - /receive_text/index #POST
    * TWILIO_SCHEDULING_NUMBER
      - /v2/sms_reservations  #POST

* **Mailchimp**
  * Mailchimp is used to send emails.
  * we also get webhooks now for unsubscribes
  * On the Server Side there are 2 environment variables used:
    * MAILCHIMP_API_KEY
    * MAILCHIMP_LIST_ID
    * MAILCHIMP_WEBHOOK_SECRET_KEY
  * Mailchimp Web hook url is:
    -?

* **SMTP**
  * we now send transactional emails!
  * Use Mandrill, which is built into Mailchimp.
  * [Credentials](https://mandrill.zendesk.com/hc/en-us/articles/205582197-Where-do-I-find-my-SMTP-credentials-)

Product Roadmap
----
* In general
- more knowledge about members, including social exhaust
- better support for UX researchers
- better admin view of the entire system

* Events
  * Invite
  * RSVP
  * Attendance tracking
  * Reminder emails
* Programs
  * Associate results
* People
  * Add arbitrary fields
  * Attach photograph
  * Attach files
  * Link with their social networks
  * Show activity streams
  * Track program status (e.g. has received Visa card)
  * Show output from Tribune boundaries service on individual person pages
* Backend
  * Terms of service/privacy policy
  * Managed access to anonymized data for research
  * Audit trails
  * Comments on all objects


Usage
--------
  1. Create a Wufoo form. Here is the [standard signup form](https://adhocteamus.wufoo.com/forms/be-a-tester-get-paid/) for example.
  2. Pick people to receive the survey and send it. This can be done either by exporting a list to Mailchimp via the search page, or by creating a "TwilioWufoo" to send the survey via SMS.
  3. Choose people and send them an availability survey:
    * ...
    * people can choose multiple slots
  4. Tell people individually what tests you've chosen for them and manually create a reservation for them.
  5. create a survey that is filled out during the test itself, either via SMS or web.


Hacking
-------

Main development occurs in the `master` branch and deployed to the [staging](https://staging.cohorts.adhocteam.us/) environment when the Codeship build passes. HEAD on `prod` is always the production release. New features are created in topic branches, and then merged to `master` via pull requests. Candidate releases are tagged from `master`  and merged into `prod`, which then deploys to the production environment.

#### Vagrant

Install Vagrant: https://vagrantup.com/
```
vagrant plugin install vagrant-cachier vagrant-hostmanager
vagrant up
open http://`whoami`.cohorts.dev
```

To access the virtual machine, run:
```
vagrant ssh
bundle exec rails c # etc. etc. etc.
```

Unit and Integration Tests
---------------------------
To run all tests:
```
bundle exec rake
```

To constantly run red-green-refactor tests:
```
bundle exec guard -g red_green_refactor
```

Contributors
------------
##### CUTGroup:
* Chris Gansen (cgansen@gmail.com)
* Dan O'Neil (doneil@cct.org)
* Bill Cromie (bill@robinhood.org)
* Josh Kalov (jkalov@cct.org)
##### Ad Hoc:
* Dan O'Neil (danx@adhocteam.us)
* Nick Clyde (nick@adhocteam.us)
* Danny Chapman (danny@adhocteam.us)

License
-------

The application code is released under the MIT License. See [LICENSE](LICENSE.md) for terms.

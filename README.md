Cohorts
=====

Cohorts is an application to manage people that are involved Ad Hoc user research. It is heavily based on [kimball](https://github.com/smartchicago/kimball) originally developed for the Smart Chicago CUTGroup.

Features
--------

Cohorts is a customer relationship management application at its heart. Cohorts tracks people that have signed up to participate in Ad Hoc user research.

Setup
-----
Cohorts is a Ruby on Rails app. It is hosted on AWS Elastic Beanstalk.

Services and Environment Variables.
--------
Environment variables live here: [/config/local_env.yml](/config/local_env.yaml). The defaults are drawn from [/config/sample.local_env.yml](/config/sample.local_env.yaml).

local_env.yml, which should not be committed, and should store your API credentials, etc.

If a variable isn't defined in your local_env.yml, we use the default value from sample.local_env.yml, which is checked into the respository.

* Organizational Defaults

* Wufoo
  * Wufoo hosts all forms used for Cohorts.
  * On the Server Side there are 3 environment variables used:
    * WUFOO_ACCOUNT
    * WUFOO_API
    * WUFOO_SIGNUP_FORM
    * WUFOO_HANDSHAKE_KEY
  * For SMS signup and form fills, "SMS Campaigns" are created in the Cohorts app to associate a Wufoo form ID.
  * Webhooks are used on Wufoo to send data back to Cohorts. Currently there are 2 webhooks in use:
    * /people : This endpoint is used for new signups via the main signup/registration wufoo form.
    * /people/create_sms : This endpoint is used for new signups via the signup/registration Wufoo form that has been customized for SMS signup.
    * /submissions : This endpoint is for all other Wufoo forms (call out, availability, tests). It saves the results in the submissions model.
* Twilio:
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

* Mailchimp:
  * Mailchimp is used to send emails.
  * we also get webhooks now for unsubscribes
  * On the Server Side there are 2 environment variables used:
    * MAILCHIMP_API_KEY
    * MAILCHIMP_LIST_ID
    * MAILCHIMP_WEBHOOK_SECRET_KEY
  * Mailchimp Web hook url is:
    -?

* SMTP
  * we now send transactional emails!
  * Use Mandrill, which is built into Mailchimp.
  * [Credentials](https://mandrill.zendesk.com/hc/en-us/articles/205582197-Where-do-I-find-my-SMTP-credentials-)

* Backups!
  * things now get backed up to AWS
    * AWS_API_TOKEN
    * AWS_API_SECRET
    * AWS_S3_BUCKET
  * provisioning script sets this up for you. runs 32 minutes after the hour, ever hour.

TODO
----
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
# Running a Test!
  1. create a survey
    * email and web link: ...
    * SMS survey: ...
  2. Pick people to receive the survey and send it to em.
  3. Choose people and send them an availability survey:
    * ...
    * people can choose multiple slots
  4. Tell people individually what tests you've chosen for them and manually create a reservation for them.
  5. create a survey that is filled out during the test itself, either via SMS or web.


Hacking
-------

Main development occurs in the development branch. HEAD on master is always the production release. New features are created in topic branches, and then merged to development via pull requests. Candidate releases are tagged from development and deployed to staging, tested, then pushed to master and production.

Development workflow:
Install Vagrant: https://vagrantup.com/
```
vagrant plugin install vagrant-cachier vagrant-hostmanager
vagrant up
open http://`whoami`.patterns.dev
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

* Chris Gansen (cgansen@gmail.com)
* Dan O'Neil (doneil@cct.org)
* Bill Cromie (bill@robinhood.org)
* Josh Kalov (jkalov@cct.org)

License
-------

The application code is released under the MIT License. See [LICENSE](LICENSE.md) for terms.

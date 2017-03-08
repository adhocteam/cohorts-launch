Gibbon::Request.api_key = ENV['MAILCHIMP_API_KEY']
Cohorts::Application.config.cohorts_mailchimp_list_id = ENV['MAILCHIMP_LIST_ID'] # the list that we will add all static segements to

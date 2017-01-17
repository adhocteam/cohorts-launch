require 'faraday_middleware'
require 'faraday_middleware/aws_signers_v4'

if Rails.env.development? || Rails.env.test?
  Elasticsearch::Model.client = Elasticsearch::Client.new
else
  Elasticsearch::Model.client = Elasticsearch::Client.new url: ENV['ELASTICSEARCH_URL'] do |f|
    f.request :aws_signers_v4,
              credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY'], ENV['AWS_SECRET_ACCESS_KEY']),
              service_name: 'es',
              region: 'us-east-1'
  end
end

$:.unshift "api"

require 'api'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*',
      headers: :any,
      methods: [:get, :put, :post]
  end
end
run Expenses::ExpensesAPI

# frozen_string_literal: true

set :active_model_serializers, {}
set :serializers_path, './serializers'
set :raise_sinatra_param_exceptions, true

configure do
  enable :cross_origin
end

helpers Sinatra::Param
register Sinatra::StrongParams
register Sinatra::CrossOrigin

configure :development, :test do
  set :show_exceptions, false
  set :raise_errors, true
end

options '*' do
  add_control_headers

  200
end

before do
  add_control_headers
  content_type :json
end

error Sinatra::Param::InvalidParameterError do
  status 400

  { error: "#{env['sinatra.error'].param} is invalid" }.to_json
end

error RequiredParamMissing do
  error_msg = { error: env['sinatra.error'].message }
  [400, error_msg.to_json]
end

error Sinatra::NotFound do
  status 400
end

error ActiveRecord::RecordNotFound do
  status 404
end

def add_control_headers
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, '\
                                                     'DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'Authorization, '\
                                                     'Content-Type, Accept, X-User-Email, X-Auth-Token, x-requester-id'
end

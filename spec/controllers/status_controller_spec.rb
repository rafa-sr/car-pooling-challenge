# frozen_string_literal: true

describe 'status' do
  it 'response ok 200' do
    get 'status'

    expect(last_response.status).to be 200
  end
end

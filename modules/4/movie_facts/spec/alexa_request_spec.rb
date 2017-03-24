require 'alexa/request'

RSpec.describe Alexa::Request do
  describe '#slot_value' do
    it 'returns the value for a specific slot' do
      stubbed_request = stub_sinatra_request({
        "request": {
          "type": "IntentRequest",
          "intent": {
            "name": "IntentName",
            "slots": {
              "SlotName": {
                "name": "SlotName",
                "value": "10"
              }
            }
          }
        }
      }.to_json)

      expect(described_class.new(stubbed_request).slot_value("SlotName")).to eq "10"
    end
  end

  describe '#new_session?' do
    it 'is true if this is a new session' do
      stubbed_request = stub_sinatra_request({
        "session": {
          "sessionId": "id_string",
          "application": {
            "applicationId": "id_string"
          },
          "new": true
        }
      }.to_json)

      expect(described_class.new(stubbed_request).new_session?).to be true
    end

    it 'is false otherwise' do
      stubbed_request = stub_sinatra_request({
        "session": {
          "sessionId": "id_string",
          "application": {
            "applicationId": "id_string"
          },
          "new": false
        }
      }.to_json)

      expect(described_class.new(stubbed_request).new_session?).to be false
    end
  end

  private

  def stub_sinatra_request(request_json)
    original_request_body = StringIO.new(request_json)
    double("Sinatra::Request", body: original_request_body)
  end
end
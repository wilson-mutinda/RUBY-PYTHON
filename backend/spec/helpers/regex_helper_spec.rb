require 'rails_helper'
RSpec.describe RegexHelper, type: :helper do
  describe "#email_regex" do
    it "returns an error if invalid email" do
      result = helper.email_regex('aa@gmailcom')
      expect(result).to eq({ errors: { email: "Invalid email format!"}})
    end

    it "returns email if valid" do
      result = helper.email_regex('aa@gmail.com')
      expect(result).to eq('aa@gmail.com')
    end
  end

  describe "#phone_regex" do
    it "returns an error if invalid format" do
      result = helper.phone_regex('254091738418')
      expect(result).to eq({ errors: { phone: "Invalid phone format!"}})
    end

    it 'returns number if valid' do
      result = helper.phone_regex('254791738418')
      expect(result).to eq('254791738418')
    end

    it "returns number in standard form" do
      result = helper.phone_regex('0112345678')
      expect(result).to eq('254112345678')
    end
  end
end

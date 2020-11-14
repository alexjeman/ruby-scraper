require 'securerandom'
require 'json'

class Accounts
  def initialize
    @file_path = './data_accounts.json'
  end

  def add_account(type, name, bank, currency, nature)
    account_data = load_file
    new_account = {
      'id' => SecureRandom.uuid,
      'type' => type,
      'bank' => bank,
      'name' => name,
      'currency' => currency,
      'balance' => 0,
      'nature' => nature
    }

    account_data['accounts'].append(new_account)
    save_file(account_data)
  end

  def save_file(account_data)
    File.write(@file_path, JSON.pretty_generate(account_data))
  end

  def load_file
    begin
      account_data = JSON.parse(File.open(@file_path).read)
    rescue StandardError
      account_data = { 'accounts' => [] }
    end
    account_data
  end
end

# account_test = Accounts.new
#
# account_test.add_account('demo', 'testacc1', 'demo', 'MDL', 'credit_card')

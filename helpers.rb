require 'json'

class Accounts
  def initialize
    @file_path = './data_accounts.json'
  end

  def add_account(**kwargs)
    account_data = load_file
    new_account = {
      'bank' => kwargs.fetch(:bank),
      'name' => kwargs.fetch(:name),
      'currency' => kwargs.fetch(:currency),
      'balance' => kwargs.fetch(:balance, 0),
      'nature' => kwargs.fetch(:nature, 'credit_card'),
      'transactions' => kwargs.fetch(:transactions, [])
    }

    account_data['accounts'].append(new_account)
    save_file(account_data)
  end


  def get_account_transactions(account_name)
    accounts = load_file['accounts']
    current_acc = accounts.select { |account| account['name'] == account_name }
    [current_acc.first['transactions']]
  end

  def update_account_val(name, key, value, method)
    accounts = load_file['accounts']
    current_acc = accounts.select { |account| account['name'] == name }.tap { |account| accounts -= account }
    case method
    when 'update'
      current_acc.first[key] = value
    when 'add'
      current_acc.first[key] += value
    else
      return 'Method update or add is required'
    end
    accounts.append(current_acc.first)
    save_file({ 'accounts' => accounts })
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
# account_test.add_account(bank:'demo_bank', name:'testacc1', currency:'MDL')
# puts account_test.get_account_transactions('testacc1')
# # account_test.update_account_val('testacc1', 'balance', 710)
# new_transac = {"date"=>"2015-01-18", "description"=>"bought food 4", "amount"=>-30, "currency"=>"MDL", "account_name"=>"account1"}
#
# account_test.update_account_val('testacc1', 'transactions', [new_transac], 'add')

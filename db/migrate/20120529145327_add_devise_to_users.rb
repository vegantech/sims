class AddDeviseToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.string :encrypted_password, null: false
      t.rename :token,:reset_password_token
      t.datetime :reset_password_sent_at

      #t.recoverable
      #t.rememberable
      #t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps
    end

    # add_index :users, :email,                :unique => true
    # add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end

  def down
    change_table(:users) do |t|
      t.remove :reset_password_sent_at, :encrypted_password
      t.rename :reset_password_token, :token
    end
  end

end

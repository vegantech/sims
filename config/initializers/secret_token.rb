# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.



secret_file = Rails.root.join("config","secret")
if File.exist?(secret_file)
  secret=File.read(secret_file)
else
  secret = '63d92d8011a5bdfe67367f34f2b588f4642f8961a0bc8fb07268234535540748b27a60fe4dfd38f1ff6c7fed71de9e6ffbb4c926d745de31fef048ba42b23587'
end
Sims::Application.config.secret_token =  secret


# README

For development, please be sure to make a file /config/local_env.yml and add the following lines:

LOCAL_POSTGRES_USERNAME: 'XXX'
LOCAL_POSTGRES_PASSWORD: 'YYY'

With your local postgres username/password properly filling in the blanks.

In that same file, be sure to add the following lines:

SECRET_KEY_BASE: 'XXX'
ENCRYPTION_SERVICE_SALT: 'YYY'

To get the value of XXX, use the following command in the rails console: 

SecureRandom.random_bytes(64)

And replace XXX with the output value. Likewise, to get YYY, use the following command in the rails console:

ActiveSupport::KeyGenerator.new('password').generate_key(XXX)

With the XXX in the command replaced by the SECRET_KEY_BASE value, and replace YYY with the output value.

Main Heroku site: https://still-meadow-96529.herokuapp.com/

Testing commit


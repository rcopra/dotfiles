# Ruby OpenSSL default store configuration
# This file is loaded via RUBYOPT to configure OpenSSL certificate paths
# See: https://github.com/rbenv/ruby-build/wiki#suggested-build-environment

begin
  require 'openssl'
  # This helps Ruby find system certificates on macOS
  OpenSSL::X509::DEFAULT_CERT_FILE
rescue LoadError
  # OpenSSL not available, skip
end

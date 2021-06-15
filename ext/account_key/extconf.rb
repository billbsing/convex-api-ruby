require 'mkmf'


if have_library("libcrypto", "CRYPTO_malloc") &&
        have_library("libssl", "SSL_new")
    return false
end

create_header
create_makefile 'account_key'


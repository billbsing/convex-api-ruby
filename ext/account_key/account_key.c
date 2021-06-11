#include "ruby.h"
#include "extconf.h"
#include "account_key.h"

/**
 * @private
 *
 * init an empty convex account structure and return it's pointer.
 *
 * @return convex_account_p Pointer to a new convex_account_t structure.
 *
 */

static convex_account_p init_empty_account() {
    convex_account_p account = (convex_account_p) malloc(sizeof(convex_account_t));
    if (!account) {
        return NULL;
    }
    memset(account, 0, sizeof(convex_account_t));
    return account;
}

/**
 * @private
 *
 * Set's the internal public key bytes to the actual key in the openssl key.
 *
 */
static void set_raw_public_key(convex_account_p account) {
    long key_length = sizeof(account->public_key);
    EVP_PKEY_get_raw_public_key(account->key, account->public_key, &key_length);
}

static void convex_account_close(void *data) {
    convex_account_p account = (convex_account_p) data;
    if (account) {
        if (account->key) {
            EVP_PKEY_free(account->key);
        }
        free(account);
    }
}

static VALUE account_init(VALUE klass) {
    VALUE obj = 0;

    convex_account_p account = init_empty_account();
    obj = Data_Wrap_Struct(klass, NULL, convex_account_close, account);
    return obj;
}

static VALUE account_create_key(VALUE module) {
    EVP_PKEY_CTX *ctx;


    VALUE key_class = rb_const_get(module, rb_intern("Key"));
    VALUE id_new = rb_intern("new");
    VALUE klass = rb_funcall(key_class, id_new, 0);
    convex_account_p account = NULL;
    Data_Get_Struct(klass, convex_account_t , account);
    if (!account) {
        return 0;
    }
    // create the openssl ctx for ED25519 keys
    ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_ED25519, NULL);
    if (!ctx) {
        return 0;
    }

    EVP_PKEY_keygen_init(ctx);

    // generate a new key
    EVP_PKEY_keygen(ctx, &account->key);
    set_raw_public_key(account);

    // now free the openssl ctx
    EVP_PKEY_CTX_free(ctx);
    return klass;
}


static VALUE account_close(VALUE self) {
    convex_account_p account = NULL;
    Data_Get_Struct(self, convex_account_t , account);
    if (!account) {
        return 0;
    }
    convex_account_close((void *) account);
    return self;
}

static VALUE account_public_key(VALUE self) {
    convex_account_p account = NULL;
    Data_Get_Struct(self, convex_account_t , account);
    VALUE result = 0;
    if(!account) {
        return 0;
    }
    char buffer[(CONVEX_ACCOUNT_PUBLIC_KEY_LENGTH * 2) + 1];
    int buffer_length = sizeof(buffer);
    convex_utils_public_key_to_hex(account->public_key, CONVEX_ACCOUNT_PUBLIC_KEY_LENGTH, buffer, &buffer_length);
    result = rb_str_new_cstr(buffer);
    return result;
}

static VALUE account_export_to_text(VALUE self, VALUE password) {

    VALUE result = 0;

    convex_account_p account = NULL;
    Data_Get_Struct(self, convex_account_t , account);
    if (!account) {
        return 0;
    }

    if (!account->key) {
      return 0;
    }

    // make sure the password is a string
    Check_Type(password, T_STRING);
    char *password_ptr = StringValueCStr(password);

    const EVP_CIPHER *cipher = EVP_aes_256_cfb();
    if (!cipher) {
        return 0;
    }

    BIO *memory = BIO_new(BIO_s_mem());

    // char *kstr = strdup(password);
    PEM_write_bio_PKCS8PrivateKey(memory, account->key, cipher, NULL, 0, 0, (void *)password_ptr);
    // free(kstr);

    BUF_MEM *bptr;
    long data_length = BIO_get_mem_data(memory, &bptr);

    result = rb_str_new((const char *)bptr, data_length);

    BIO_free_all(memory);
    return result;
}

static VALUE account_create_key_from_text(VALUE module, VALUE text, VALUE password) {

    VALUE result = 0;

    VALUE key_class = rb_const_get(module, rb_intern("Key"));
    VALUE id_new = rb_intern("new");
    VALUE klass = rb_funcall(key_class, id_new, 0);

    convex_account_p account = NULL;
    Data_Get_Struct(klass, convex_account_t , account);
    if(!account) {
        return result;
    }

    if (account->key) {
        EVP_PKEY_free(account->key);
        account->key = NULL;
    }
    char *text_ptr = StringValueCStr(text);
    char *password_ptr = StringValueCStr(password);

    BIO *memory = BIO_new(BIO_s_mem());
    BIO_puts(memory, text_ptr);
    account->key = PEM_read_bio_PrivateKey(memory, NULL, NULL, (void *)password_ptr);
    BIO_free_all(memory);
    if (!account->key) {
        return result;
    }
    set_raw_public_key(account);
    return klass;
}


void Init_account_key() {

  VALUE module = rb_define_module("AccountKey");
  VALUE key_class = rb_define_class_under(module, "Key", rb_cObject);

  rb_define_module_function(module, "create", account_create_key, 0);
  rb_define_module_function(module, "create_from_text", account_create_key_from_text, 2);

  rb_define_alloc_func(key_class, account_init);
  rb_define_method(key_class, "public_key", account_public_key, 0);
  rb_define_method(key_class, "export_to_text", account_export_to_text, 1);
  rb_define_method(key_class, "close", account_close, 0);
}

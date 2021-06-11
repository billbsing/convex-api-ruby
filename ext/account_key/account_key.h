
#ifndef CONVEX_ACCOUNT_H
#define CONVEX_ACCOUNT_H

#include <stdbool.h>
#include <openssl/evp.h>
#include <openssl/pem.h>
#include <openssl/bio.h>


#define CONVEX_ACCOUNT_PUBLIC_KEY_LENGTH            32
#define CONVEX_ACCOUNT_PUBLIC_KEY_HEX_LENGTH        (CONVEX_ACCOUNT_PUBLIC_KEY_LENGTH * 2)

typedef struct {
    EVP_PKEY *key;
    unsigned char public_key[CONVEX_ACCOUNT_PUBLIC_KEY_LENGTH];
} convex_account_t;

typedef convex_account_t* convex_account_p;


#endif          // CONVEX_ACCOUNT_H

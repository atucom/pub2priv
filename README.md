# pub2priv
Convert RSA public keys to their associated private keys

Notes:
    The usage of this script is not paralelized or optimized. I am not a cryptographer, I simply created a reliable script to factor the modulus given in the public key into it's original p & q components. I then use these components to generate the rest of the details for the private key.

Usage:
    input: file with public key
    output: text of private key (PEM encoded)
    example:
        ruby pub2priv.rb <FilenameOfPublicKey>
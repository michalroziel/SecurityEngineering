

## Aufgabe 2



```

SHA2-256(services)= f6183055fd949f9c53d49ee620f85d0150123ea691d25ed1bba0c641b4ee2f48
SHA1(services)= a0d7a229bf049f7fe17e8445226236e4024535d0
SHA2-384(services)= f5c538da3dc434041306491a3a08481fb67315e424e3becc8e7b450c1a3779e3a6f0bc49c2032f36010e4cab73bbf018
MD5(services)= 3975f0d8c4e1ecb25f035edfb1ba27ac

after editing of services   :

SHA2-256(services)= 2606c5653f252d95e22761e4093c8e95772f2f97c369730c3b10168443ce4c75

openssl dgst -whirlpool services : 

20A062DB1CF00000:error:03000086:digital envelope routines:evp_md_init_internal:initialization error:../crypto/evp/digest.c:254:

openssl dgst -SHA3 services

0505706F8FB0000:error:0308010C:digital envelope routines:inner_evp_generic_fetch:unsupported:../crypto/evp/evp_fetch.c:386:Global default library context, Algorithm (SHA3 : 0), Properties (<null>)

RIPEMD-160(services)= fd78561c8b038447e89e3bbce3c6d2f9432db1bd

```



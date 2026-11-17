---
SPDX-License-Identifier: Community-Spec-1.0
tags:
  - security
  - v3.1
---

# Selecting hash algorithms

Inclusion in the SPDX
[`HashAlgorithm`](https://spdx.github.io/spdx-spec/v3.1/model/Core/Vocabularies/HashAlgorithm/)
vocabulary does not imply that an algorithm is suitable for cryptographic
integrity verification.

When cryptographic integrity is required, producers should provide at least one
SHA-256 or stronger hash. Consumers may reject integrity verification when only
weaker algorithms are provided.

MD2, MD4, MD5, and SHA-1 are not collision resistant and should not be used for
cryptographic integrity. Adler-32 is a non-cryptographic checksum intended to
detect accidental corruption. MD6 is experimental, is not standardized, and
should not be used for new integrity information.

Dilithium and FALCON are digital-signature algorithms, and Kyber is a
key-encapsulation mechanism. They are not hash algorithms and should not be
used as the algorithm for an SPDX
[`Hash`](https://spdx.github.io/spdx-spec/v3.1/model/Core/Classes/Hash/).

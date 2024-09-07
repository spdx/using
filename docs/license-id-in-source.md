---
SPDX-License-Identifier: Community-Spec-1.0
tags:
  - license
  - compliance
---

# Using SPDX License List short identifiers in source files

TODO: update for SPDXv3

## Introduction

Identifying the license for open source software is critical for both reporting purposes and license compliance. However, determining the license can sometimes be difficult due to a lack of information or ambiguous information. Even when licensing information is present, a lack of consistent notation can make automating the task of license detection very difficult, thus requiring vast amounts of human effort.

[Short identifiers](https://spdx.org/licenses/) from the SPDX License List can be used to indicate license info at the file level. The advantages of doing this are numerous but include:

- It is precise.
- It is concise.
- It is language neutral.
- It is easy and more reliable to machine process.
- Leads to code that is easier to reuse.
- The license information travels with the file (as sometimes not entire projects are used or license files are removed).
- It is a standard and can be universal. There is no need for variation.
- An SPDX short identifier is immutable.
- Easy look-ups and cross-references to the SPDX License List website.

If using SPDX short identifiers in individual files, it is recommended to reproduce the full license in the projects LICENSE file and indicate that SPDX short identifiers are being used to refer to it. For links to projects illustrating these scenarios, see <https://spdx.dev/ids-where>.

## Format for `SPDX-License-Identifier`

The `SPDX-License-Identifier` tag declares the license the file is under and should be placed at or near the top of the file in a comment.

The SPDX License Identifier syntax may consist of a single license
(represented by a short identifier from the
[SPDX License List](https://spdx.org/licenses/)) or a compound set of licenses
(represented by joining together multiple licenses using the license expression
syntax).

The tag should appear on its own line in the source file, generally as part of a comment.

```text
SPDX-License-Identifier: <SPDX License Expression>
```

## Representing single license

A single license is represented by using the short identifier from
[SPDX License List](https://spdx.org/licenses/), optionally with a unary "+"
operator following it to indicate "or later" versions may be applicable.

Examples:

```text
SPDX-License-Identifier: CDDL-1.0+
SPDX-License-Identifier: MIT
```

## Representing multiple licenses

Multiple licenses can be represented using an SPDX *license expression* as defined in the specification Annex. A set of licenses may optionally be enclosed in parentheses, but are not required to be enclosed. As further described there:

1. When there is a choice between licenses ("disjunctive license"), they should be separated with "OR". If presented with a choice between two or more licenses, use the disjunctive binary "OR" operator to construct a new license expression.
2. Similarly when multiple licenses need to be simultaneously applied ("conjunctive license"), they should be separated with "AND". If required to simultaneously comply with two or more licenses, use the conjunctive binary "AND" operator to construct a new license expression.
3. In some cases, a set of license terms apply except under special circumstances, in this case, use the "WITH" operator followed by one of the [recognized exception identifiers](https://spdx.org/licenses/exceptions-index.html) or a custom addition.
4. The expression MUST be on a single line, and MUST NOT include a line break in the middle of the expression.

Examples:

```text
SPDX-License-Identifier: GPL-2.0-only OR MIT
SPDX-License-Identifier: LGPL-2.1-only AND BSD-2-Clause
SPDX-License-Identifier: GPL-2.0-or-later WITH Bison-exception-2.2
```

Please see the specification Annex for more examples and details of the license expression specific syntax.

If you can’t express the license(s) as an expression using identifiers from the SPDX list, it is probably best to just put the text of your license header in the file (if there is a standard header), or refer to a neutral site URL where the text can be found. To request a license be added to the SPDX License List, please follow the process described here: <https://github.com/spdx/license-list-XML/blob/master/CONTRIBUTING.md>.

Alternatively, you can use a `LicenseRef-` custom license identifier to refer to a license that is not on the SPDX License List, such as the following:

```text
SPDX-License-Identifier: LicenseRef-my-special-license
```

The `LicenseRef-` format is defined in the SPDX specification Annex defining license expressions. When using a custom `LicenseRef-` identifier, you will also need to provide a way for others to determine what license text corresponds to it. The [REUSE Software Specification](https://reuse.software/spec/) provides a standardized format that can optionally be used for providing the corresponding license text for these identifiers.

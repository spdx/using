# Creating Extensions in SPDX 3

This document will walk though how to create custom extensions in SPDX 3.

If you do would like to construct the complete example document from this
Markdown file, use the following command:

```shell
cat extensions.md | awk 'BEGIN{flag=0} /^```json/, $0=="```" { if (/^---$/){flag++} else if ($0 !~ /^```.*/ ) print $0 > "doc-" flag ".spdx.json"}'
```

This walk through assumes you understand the basics of writing SPDX 3
documents. If you are unfamilar with how to do this, please see the
[getting started](./getting-started.md) guide.

## Preparing the Document

Extensions in SPDX 3 are a powerful tool that user can use to add arbitrary
data fields to any SPDX 3 [Element][Class_Element] derived class.

First, we will start with our standard document prefix:

```json
{
    "@context": "https://spdx.org/rdf/3.0.1/spdx-context.jsonld",
    "@graph": [
        {
            "type": "CreationInfo",
            "@id": "_:creationinfo",
            "specVersion": "3.0.1",
            "createdBy": [
                "https://spdx.org/spdxdocs/Person/JoshuaWatt-0ef7e15a-5628-4bd9-8485-a3eace6dcc4f"
            ],
            "created": "2024-03-06T00:00:00Z"
        },
```

For this example, we will add an extension to the [Person][Class_Person] object
referenced by our `CreationInfo`, but be aware that any
[Element][Class_Element] derived class can have extensions added in the same
way. First, lets create our `Person` and the core fields it requires:

```json
        {
            "type": "Person",
            "spdxId": "https://spdx.org/spdxdocs/Person/JoshuaWatt-0ef7e15a-5628-4bd9-8485-a3eace6dcc4f",
            "creationInfo": "_:creationinfo",
            "name": "Joshua Watt",
```

## Adding an Extension

Extensions are created by adding objects to the [extension][Property_extension]
property of [Element][Class_Element]:

```json
            "extension": [
```

Each item in this list is an object which must derive from the
[extension_Extension][Class_Extension]. It is important to note that
[extension_Extension][Class_Extension] itself is abstract, and therefore cannot
be used as the `type` for any object; as such, you must define your own type
that derives from [extension_Extension][Class_Extension].

Since most extension classes are by definition not known by SPDX, there is no
way to validate them. Therefore the validation code assumes than any unknown
object type in the [extension][Property_extension] property _must_ be derived
from [extension_Extension][Class_Extension].

Finally, extension type and field names can't possibly be known by the SPDX
JSON-LD context, therefore they must use fully qualified IRIs.

If the above is too confusing, don't worry about the details too much. The
practical implication for this is that a new extension type can be defined by
simply using the fully qualified IRI for the `type` property, like so:

```json
                {
                    "type": "http://spdx.org/spdxdocs/ExampleExtension",
```

In practice you will want to use your own domain to define the extension, and
probably document the expected fields and schema for the extension users.

If you want to reference your extension object elsewhere in the document, an
`@id` property can be added, but is not mandatory. The value can either be a
blank node (if the extension only needs to be referenced inside this document),
or a full IRI (if it needs to be referenced outside of this document):

```json
                    "@id": "_:my-extension",
```

Extensions can have arbitrary properties attached to them. Which properties are
allowed and which values are accepted is up to the extension creator to define.
The restriction by SPDX is that the property names must be fully qualified
IRIs, since it's not possible to have a context to shorten them. These property
values can be of any scalar type (e.g. `integer`, `string`, `boolean`, `IRI`,
etc.), a list of any scalar type, an object, or a list of objects.

As an example of what this looks like in practice, we'll add a few properties
to our example extension:

```json

                    "http://spdx.org/spdxdocs/ExampleExtension/intProperty": 1,
                    "http://spdx.org/spdxdocs/ExampleExtension/boolProperty": true,
                    "http://spdx.org/spdxdocs/ExampleExtension/stringProperty": "Hello",
                    "http://spdx.org/spdxdocs/ExampleExtension/IRIProperty": "https://spdx.org/spdxdocs/Person/JoshuaWatt-0ef7e15a-5628-4bd9-8485-a3eace6dcc4f",
                    "http://spdx.org/spdxdocs/ExampleExtension/enumProperty": "http://spdx.org/spdxdocs/ExampleExtension/enumA",

                    "http://spdx.org/spdxdocs/ExampleExtension/intListProperty": [ 1, 2, 3 ],

                    "http://spdx.org/spdxdocs/ExampleExtension/ObjectProperty": {
                        "type": "http://spdx.org/spdxdoc/ExampleExtension/SubObject",
                        "http://spdx.org/spdxdoc/ExampleExtension/SubObject/name": "Foo"
                    },

                    "http://spdx.org/spdxdocs/ExampleExtension/ObjectListProperty": [
                        {
                            "type": "http://spdx.org/spdxdoc/ExampleExtension/SubObject",
                            "http://spdx.org/spdxdoc/ExampleExtension/SubObject/name": "Bar"
                        },
                        {
                            "type": "http://spdx.org/spdxdoc/ExampleExtension/SubObject",
                            "http://spdx.org/spdxdoc/ExampleExtension/SubObject/name": "Baz"
                        }
                    ]

```

Note the fully qualified IRI used for each property name. As usual, you would
want to use your own domain in practice.

Also note that while it's technically possible to create lists of mixed types
(E.g. a list where the items are not all the same type), it is highly
recommended to avoid this as it makes using your extension more complicated.

## Finishing the Document

Now that we are done, we'll close out our `Person` and finally close out the document:

```json
                }
            ]
        }
    ]
}
```

[Class_Element]: https://spdx.github.io/spdx-spec/v3.0/model/Core/Classes/Element/
[Class_Person]: https://spdx.github.io/spdx-spec/v3.0/model/Core/Classes/Person/
[Class_Extension]: https://spdx.github.io/spdx-spec/v3.0/model/Extension/Classes/Extension/
[Property_extension]: https://spdx.github.io/spdx-spec/v3.0/model/Core/Properties/extension/

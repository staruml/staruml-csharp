C# Extension for StarUML
========================

This extension for StarUML(http://staruml.io) support to generate C# code from UML model and to reverse C# code to UML model. Install this extension from Extension Manager of StarUML.

> __Note__
> This extensions do not provide perfect reverse engineering which is a test and temporal feature. If you need a complete reverse engineering feature, please check other professional reverse engineering tools.

> __Note__
>  This extension is based on C# 2.0 specification.

C# Code Generation
--------------------

1. Click the menu (`Tools > C# > Generate Code...`)
2. Select a base model (or package) that will be generated to C#.
3. Select a folder where generated C# source files will be placed.

Belows are the rules to convert from UML model elements to C# source codes.

### UMLPackage

* converted to _C# namespace_ (as a folder).

### UMLClass

* converted to _C# Class_. (as a separate `.cs` file)
* `visibility` to one of modifiers `public`, `protected`, `private` and none.
* `isAbstract` property to `abstract` modifier.
* `isFinalSpecialization` and `isLeaf` property to `sealed` modifier.
* Default constructor is generated.
* All contained types (_UMLClass_, _UMLInterface_, _UMLEnumeration_) are generated as inner type definition.
* Documentation property to C#Doc comment.
* Annotation Type is converted to C# attribute class which extends System.Attribute and postfix of class is Attribute.
  (cf. class testAttribute:System.Attribute)

### UMLAttribute

* converted to _C# Field_.
* `visibility` property to one of modifiers `public`, `protected`, `private` and none.
* `name` property to field identifier.
* `type` property to field type.
* `multiplicity` property to array type.
* `isStatic` property to `static` modifier.
* `isLeaf` property to `sealed` modifier.
* `defaultValue` property to initial value.
* Documentation property to C#Doc comment.

### UMLOperation

* converted to _C# Methods_.
* `visibility` property to one of modifiers `public`, `protected`, `private` and none.
* `name` property to method identifier.
* `isAbstract` property to `abstract` modifier.
* `isStatic` property to `static` modifier.
* _UMLParameter_ to _C# Method Parameters_.
* _UMLParameter_'s name property to parameter identifier.
* _UMLParameter_'s type property to type of parameter.
* _UMLParameter_ with `direction` = `return` to return type of method. When no return parameter, `void` is used.
* _UMLParameter_ with `isReadOnly` = `true` to `sealed` modifier of parameter.
* Documentation property to C#Doc comment.

### UMLInterface

* converted to _C# Interface_.  (as a separate `.cs` file)
* `visibility` property to one of modifiers `public`, `protected`, `private` and none.
* Documentation property to C#Doc comment.

### UMLEnumeration

* converted to _C# enum_.  (as a separate `.cs` file)
* `visibility` property to one of modifiers `public`, `protected`, `private` and none.
* _UMLEnumerationLiteral_ to literals of enum.

### UMLAssociationEnd

* converted to _C# Field_.
* `visibility` property to one of modifiers `public`, `protected`, `private` and none.
* `name` property to field identifier.
* `type` property to field type.
* If `multiplicity` is one of `0..*`, `1..*`, `*`, then collection type (`List<>` when `isOrdered` = `true` or `HashSet<>`) is used.
* `defaultValue` property to initial value.

### UMLGeneralization

* converted to _C# Extends_ (`:`).
* Allowed only for _UMLClass_ to _UMLClass_, and _UMLInterface_ to _UMLInterface_.

### UMLInterfaceRealization

* converted to _C# Implements_ (`:`).
* Allowed only for _UMLClass_ to _UMLInterface_.


C# Reverse Engineering
------------------------

1. Click the menu (`Tools > C# > Reverse Code...`)
2. Select a folder containing C# source files to be converted to UML model elements.
3. `CsharpReverse` model will be created in the Project.

Belows are the rules to convert from C# source code to UML model elements.

### C# Namespace

* converted to _UMLPackage_.

### C# Class

* converted to _UMLClass_.
* Class name to `name` property.
* Type parameters to _UMLTemplateParameter_.
* Access modifier `public`, `protected` and  `private` to `visibility` property.
* `abstract` modifier to `isAbstract` property.
* `sealed` modifier to `isLeaf` property.
* Constructors to _UMLOperation_ with stereotype `<<constructor>>`.
* All contained types (_UMLClass_, _UMLInterface_, _UMLEnumeration_) are generated as inner type definition.


### C# Field (to UMLAttribute)

* converted to _UMLAttribute_ if __"Use Association"__ is __off__ in Preferences.
* Field type to `type` property.

    * Primitive Types : `type` property has the primitive type name as string.
    * `T[]`(array) or its decendants: `type` property refers to `T` with multiplicity `*`.
    * `T` (User-Defined Types)  : `type` property refers to the `T` type.
    * Otherwise : `type` property has the type name as string.

* Access modifier `public`, `protected` and  `private` to `visibility` property.
* `static` modifier to `isStatic` property.
* `sealed` modifier to `isLeaf` and `isReadOnly` property.
* Initial value to `defaultValue` property.

### C# Field (to UMLAssociation)

* converted to (Directed) _UMLAssociation_ if __"Use Association"__ is __on__ in Preferences and there is a UML type element (_UMLClass_, _UMLInterface_, or _UMLEnumeration_) correspond to the field type.
* Field type to `end2.reference` property.

    * `T[]`(array) or its decendants: `reference` property refers to `T` with multiplicity `*`.
    * `T` (User-Defined Types)  : `reference` property refers to the `T` type.
    * Otherwise : converted to _UMLAttribute_, not _UMLAssociation_.

* Access modifier `public`, `protected` and  `private` to `visibility` property.

### C# Method

* converted to _UMLOperation_.
* Type parameters to _UMLTemplateParameter_.
* Access modifier `public`, `protected` and  `private` to `visibility` property.
* `static` modifier to `isStatic` property.
* `abstract` modifier to `isAbstract` property.
* `sealed` modifier to `isLeaf` property.

### C# Interface

* converted to _UMLInterface_.
* Class name to `name` property.
* Type parameters to _UMLTemplateParameter_.
* Access modifier `public`, `protected` and  `private` to `visibility` property.

### C# Enum

* converted to _UMLEnumeration_.
* Enum name to `name` property.
* Type parameters to _UMLTemplateParameter_.
* Access modifier `public`, `protected` and  `private` to `visibility` property.
* Enum constants are converted to _UMLEnumerationLiteral_.

### C# AnnotationType

* converted to _UMLClass_ with stereotype `<<annotationType>>`.
* Annotation type elements to _UMLOperation_. (Default value to a Tag with `name="default"`).


---

Licensed under the MIT license (see LICENSE file).

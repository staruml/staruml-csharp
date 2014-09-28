C# Extension for StarUML 2
============================

This extension for StarUML(http://staruml.io) support to generate C# code from UML model and to reverse Java code to UML model. Install this extension from Extension Manager of StarUML. It is based on C# 2.0 specification.

C# Code Generation
--------------------

1. Click the menu (`Tools > C# > Generate Code...`)
2. Select a base model (or package) that will be generated to C#.
3. Select a folder where generated C# source files will be placed.

Belows are the rules to convert from UML model elements to Java source codes.

### UMLPackage

* converted to _C# namespace_ (as a folder).

### UMLClass

* converted to _C# Class_. (as a separate `.cs` file)
* `visibility` to one of modifiers `public`, `protected`, `private` and none.
* `isAbstract` property to `abstract` modifier.
* `isFinalSpecification` and `isLeaf` property to `sealed` modifier.
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
* Documentation property to JavaDoc comment.

### UMLGeneralization

* converted to _C# Extends_ (`:`).
* Allowed only for _UMLClass_ to _UMLClass_, and _UMLInterface_ to _UMLInterface_.

### UMLInterfaceRealization

* converted to _C# Implements_ (`:`).
* Allowed only for _UMLClass_ to _UMLInterface_.

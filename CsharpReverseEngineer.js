/*
 * Copyright (c) 2014 MKLab. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 */

/*jslint vars: true, plusplus: true, devel: true, nomen: true, indent: 4, maxerr: 50, regexp: true, continue:true */
/*global define, $, _, window, app, type, document, csharp, parser */
define(function (require, exports, module) {
    "use strict";

    var Core            = app.getModule("core/Core"),
        Repository      = app.getModule("core/Repository"),
        CommandManager  = app.getModule("command/CommandManager"),
        UML             = app.getModule("uml/UML"),
        FileSystem      = app.getModule("filesystem/FileSystem"),
        FileSystemError = app.getModule("filesystem/FileSystemError"),
        FileUtils       = app.getModule("file/FileUtils"),
        Async           = app.getModule("utils/Async");

    require("grammar/csharp");
    
      
    /**
     * C# Code Analyzer
     * @constructor
     */
    function CsharpCodeAnalyzer() {

        /** @member {type.UMLModel} */
        this._root = new type.UMLModel();
        this._root.name = "CsharpReverse";

        /** @member {Array.<File>} */
        this._files = [];

        /** @member {Object} */
        this._currentCompilationUnit = null;

        /**
         * @member {{classifier:type.UMLClassifier, node: Object, kind:string}}
         */
        this._extendPendings = [];

        /**
         * @member {{classifier:type.UMLClassifier, node: Object}}
         */
        this._implementPendings = [];

        /**
         * @member {{classifier:type.UMLClassifier, association: type.UMLAssociation, node: Object}}
         */
        this._associationPendings = [];

        /**
         * @member {{operation:type.UMLOperation, node: Object}}
         */
        this._throwPendings = [];

        /**
         * @member {{namespace:type.UMLModelElement, feature:type.UMLStructuralFeature, node: Object}}
         */
        this._typedFeaturePendings = [];
    }
 
    /**
     * Add File to Reverse Engineer
     * @param {File} file
     */
    CsharpCodeAnalyzer.prototype.addFile = function (file) {
        this._files.push(file);
    };

    /**
     * Analyze all files.
     * @param {Object} options
     * @return {$.Promise}
     */
    CsharpCodeAnalyzer.prototype.analyze = function (options) {
        var self = this,
            promise;

        // Perform 1st Phase
        promise = this.performFirstPhase(options);

        // Perform 2nd Phase
//        promise.always(function () {
//            self.performSecondPhase(options);
//        });

        // Load To Project
//        promise.always(function () {
//            var writer = new Core.Writer();
//            writer.writeObj("data", self._root);
//            var json = writer.current.data;
//            Repository.importFromJson(Repository.getProject(), json);
//        });

        // Generate Diagrams
//        promise.always(function () {
//            self.generateDiagrams(options);
//            console.log("[C#] done.");
//        });

        return promise;
    };
    
    CsharpCodeAnalyzer.prototype.JSONtoString = function (object) {
        var results = [];
        for (var property in object) {
            var value = object[property];
            if (value) {
                results.push(property.toString() + ': ' + value);
            }
        }
        return '{' + results.join(', ') + '}';
    };
    
    /**
     * Perform First Phase
     *   - Create Packages, Classes, Interfaces, Enums, AnnotationTypes.
     *
     * @param {Object} options
     * @return {$.Promise}
     */
    CsharpCodeAnalyzer.prototype.performFirstPhase = function (options) {
        var self = this;
        return Async.doSequentially(this._files, function (file) {
            var result = new $.Deferred();
            file.read({}, function (err, data, stat) {
                if (!err) {
                    try {
                        var ast = parser.parse(data);
                        
                        var results = [];
                        for (var property in ast) {
                            var value = ast[property];
                            if (value) {
                                results.push(property.toString() + ': ' + value);
                            }
                        }
                        console.log( JSON.stringify(ast) ); 
                        
                        
                        self._currentCompilationUnit = ast;
                        self._currentCompilationUnit.file = file;
                        self.translateCompilationUnit(options, self._root, ast);
                          
                        
                        result.resolve();
                    } catch (ex) {
                        console.error("[C#] Failed to parse - " + file._name + "  : " + ex);
                        result.reject(ex);
                    }
                } else {
                    result.reject(err);
                }
            });
            return result.promise();
        }, false);
    };

    
    /**
     * Translate C# CompilationUnit Node.
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} compilationUnitNode
     */
    CsharpCodeAnalyzer.prototype.translateCompilationUnit = function (options, namespace, compilationUnitNode) 
    {
        var _namespace = namespace,
            i,
            len; 
        
        this.translateTypes(options, _namespace, compilationUnitNode["namespace"]);     
        
    };
    
    /**
     * Translate Type Nodes
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Array.<Object>} typeNodeArray
     */
    CsharpCodeAnalyzer.prototype.translateTypes = function (options, namespace, typeNodeArray) {
        var _namespace = namespace, i, len;
        if (typeNodeArray.length > 0) {
            for (i = 0, len = typeNodeArray.length; i < len; i++) {
                var typeNode = typeNodeArray[i];
                switch (typeNode.node) {
                case "namespace":
                    var _package = this.translatePackage(options, _namespace, typeNode);
                    if (_package !== null) {
                        _namespace = _package;
                    }
                    // Translate Types
                    this.translateTypes(options, _namespace, typeNode.body);
                    break;
                case "class":
                    this.translateClass(options, namespace, typeNode);
                    break;
                case "interface":
                    this.translateInterface(options, namespace, typeNode);
                    break;
                case "enum":
                    this.translateEnum(options, namespace, typeNode);
                    break;
                case "annotationType":
                    this.translateAnnotationType(options, namespace, typeNode);
                    break;
                }
            }
        }
    };
    
    
    /**
     * Translate C# AnnotationType Node.
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} annotationTypeNode
     */
    CsharpCodeAnalyzer.prototype.translateAnnotationType = function (options, namespace, annotationTypeNode) {
        var _annotationType;

        // Create Class <<annotationType>>
        _annotationType = new type.UMLClass();
        _annotationType._parent = namespace;
        _annotationType.name = annotationTypeNode.name;
        _annotationType.stereotype = "annotationType";
        _annotationType.visibility = this._getVisibility(annotationTypeNode.modifiers);

        // CsharpDoc
//        if (annotationTypeNode.comment) {
//            _annotationType.documentation = annotationTypeNode.comment;
//        }

        namespace.ownedElements.push(_annotationType);

        // Translate Type Parameters
        this.translateTypeParameters(options, _annotationType, annotationTypeNode.typeParameters);
        // Translate Types
        this.translateTypes(options, _annotationType, annotationTypeNode.body);
        // Translate Members
        this.translateMembers(options, _annotationType, annotationTypeNode.body);
    };
    
    
    /**
     * Translate C# Enum Node.
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} enumNode
     */
    CsharpCodeAnalyzer.prototype.translateEnum = function (options, namespace, enumNode) {
        var _enum;

        // Create Enumeration
        _enum = new type.UMLEnumeration();
        _enum._parent = namespace;
        _enum.name = enumNode.name;
        _enum.visibility = this._getVisibility(enumNode.modifiers);

        // CsharpDoc
//        if (enumNode.comment) {
//            _enum.documentation = enumNode.comment;
//        }

        namespace.ownedElements.push(_enum);

        // Translate Type Parameters
        this.translateTypeParameters(options, _enum, enumNode.typeParameters);
        // Translate Types
        this.translateTypes(options, _enum, enumNode.body);
        // Translate Members
        this.translateMembers(options, _enum, enumNode.body);
    };

    
    
     /**
     * Translate C# Interface Node.
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} interfaceNode
     */
    CsharpCodeAnalyzer.prototype.translateInterface = function (options, namespace, interfaceNode) {
        var i, len, _interface;

        // Create Interface
        _interface = new type.UMLInterface();
        _interface._parent = namespace;
        _interface.name = interfaceNode.name;
        _interface.visibility = this._getVisibility(interfaceNode.modifiers);

        // CsharpDoc
//        if (interfaceNode.comment) {
//            _interface.documentation = interfaceNode.comment;
//        }

        namespace.ownedElements.push(_interface);

        // Register Extends for 2nd Phase Translation
        if (interfaceNode["base"]) {
            for (i = 0, len = interfaceNode["base"].length; i < len; i++) {
                var _extend = interfaceNode["base"][i];
                this._extendPendings.push({
                    classifier: _interface,
                    node: _extend,
                    kind: "interface",
                    compilationUnitNode: this._currentCompilationUnit
                });
            }
        }

        // Translate Type Parameters
        this.translateTypeParameters(options, _interface, interfaceNode.typeParameters);
        // Translate Types
        this.translateTypes(options, _interface, interfaceNode.body);
        // Translate Members
        this.translateMembers(options, _interface, interfaceNode.body);
    };

    
    
    /**
     * Return visiblity from modifiers
     *
     * @param {Array.<string>} modifiers
     * @return {string} Visibility constants for UML Elements
     */
    CsharpCodeAnalyzer.prototype._getVisibility = function (modifiers) {
        if (_.contains(modifiers, "public")) {
            return UML.VK_PUBLIC;
        } else if (_.contains(modifiers, "protected")) {
            return UML.VK_PROTECTED;
        } else if (_.contains(modifiers, "private")) {
            return UML.VK_PRIVATE;
        }
        return UML.VK_PACKAGE;
    };

    
    /**
     * Translate C# Class Node.
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} compilationUnitNode
     */
    CsharpCodeAnalyzer.prototype.translateClass = function (options, namespace, classNode) {
        var i, len, _class;

        // Create Class
        _class = new type.UMLClass();
        _class._parent = namespace;
        _class.name = classNode.name;

        // Access Modifiers
        _class.visibility = this._getVisibility(classNode.modifiers);

        // Abstract Class
        if (_.contains(classNode.modifiers, "abstract")) {
            _class.isAbstract = true;
        }

        // Final Class
        if (_.contains(classNode.modifiers, "sealed")) {
            _class.isFinalSpecification = true;
            _class.isLeaf = true;
        }

        // CsharpDoc
//        if (classNode.comment) {
//            _class.documentation = classNode.comment;
//        }

        namespace.ownedElements.push(_class);

        // Register Extends for 2nd Phase Translation
        if (classNode["base"]) {
            var _extendPending = {
                classifier: _class,
                node: classNode["base"],
                kind: "class",
                compilationUnitNode: this._currentCompilationUnit
            };
            this._extendPendings.push(_extendPending);
        }
 
        
        // Translate Type Parameters
        this.translateTypeParameters(options, _class, classNode.typeParameters);
        // Translate Types
        this.translateTypes(options, _class, classNode.body);
        // Translate Members
        this.translateMembers(options, _class, classNode.body.members);
    };
    
    
    /**
     * Translate Members Nodes
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Array.<Object>} memberNodeArray
     */
    CsharpCodeAnalyzer.prototype.translateMembers = function (options, namespace, memberNodeArray) {
        var i, len;
        if (memberNodeArray.length > 0) {
            for (i = 0, len = memberNodeArray.length; i < len; i++) {
                var memberNode = memberNodeArray[i],
                    visibility = this._getVisibility(memberNode.modifiers);

                // Generate public members only if publicOnly == true
                if (options.publicOnly && visibility !== UML.VK_PUBLIC) {
                    continue;
                }

                memberNode.compilationUnitNode = this._currentCompilationUnit;
                 
                switch (memberNode.node) {
                case "field":
                case "property":
                    if (options.association) {
                        this.translateFieldAsAssociation(options, namespace, memberNode);
                    } else {
                        this.translateFieldAsAttribute(options, namespace, memberNode);
                    }
                    break;
                case "constructor":
                    this.translateMethod(options, namespace, memberNode, true);
                    break;
                case "method":
                    this.translateMethod(options, namespace, memberNode);
                    break;
                case "constant":
//                    this.translateEnumConstant(options, namespace, memberNode);
                    break;
                }
            }
        }
    };

    
    /**
     * Translate Enumeration Constant
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} enumConstantNode
     */
    CsharpCodeAnalyzer.prototype.translateEnumConstant = function (options, namespace, enumConstantNode) {
        var _literal = new type.UMLEnumerationLiteral();
        _literal._parent = namespace;
        _literal.name = enumConstantNode.name;

        // CsharpDoc
//        if (enumConstantNode.comment) {
//            _literal.documentation = enumConstantNode.comment;
//        }

//        namespace.literals.push(_literal);
    };
    
    
    /**
     * Translate Method
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} methodNode
     * @param {boolean} isConstructor
     */
    CsharpCodeAnalyzer.prototype.translateMethod = function (options, namespace, methodNode, isConstructor)
    {
        var i, len, _operation = new type.UMLOperation();
        _operation._parent = namespace;
        _operation.name = methodNode.name;
        namespace.operations.push(_operation);

        // Modifiers
        _operation.visibility = this._getVisibility(methodNode.modifiers);
        if (_.contains(methodNode.modifiers, "static")) {
            _operation.isStatic = true;
        }
        if (_.contains(methodNode.modifiers, "abstract")) {
            _operation.isAbstract = true;
        }
        if (_.contains(methodNode.modifiers, "sealed")) {
            _operation.isLeaf = true;
        }
//        if (_.contains(methodNode.modifiers, "synchronized")) {
//            _operation.concurrency = UML.CCK_CONCURRENT;
//        }
//        if (_.contains(methodNode.modifiers, "native")) {
//            this._addTag(_operation, Core.TK_BOOLEAN, "native", true);
//        }
//        if (_.contains(methodNode.modifiers, "strictfp")) {
//            this._addTag(_operation, Core.TK_BOOLEAN, "strictfp", true);
//        }

        // Constructor
        if (isConstructor) {
            _operation.stereotype = "constructor";
        }

        // Formal Parameters
        if (methodNode.parameter && methodNode.parameter.length > 0) {
            for (i = 0, len = methodNode.parameter.length; i < len; i++) {
                var parameterNode = methodNode.parameter[i];
                parameterNode.compilationUnitNode = methodNode.compilationUnitNode;
                this.translateParameter(options, _operation, parameterNode);
            }
        }

        // Return Type
        if (methodNode.type) {
            var _returnParam = new type.UMLParameter();
            _returnParam._parent = _operation;
            _returnParam.name = "";
            _returnParam.direction = UML.DK_RETURN;
            // Add to _typedFeaturePendings
            this._typedFeaturePendings.push({
                namespace: namespace,
                feature: _returnParam,
                node: methodNode
            });
            _operation.parameters.push(_returnParam);
        }

        // Throws
//        if (methodNode.throws) {
//            for (i = 0, len = methodNode.throws.length; i < len; i++) {
//                var _throwNode = methodNode.throws[i];
//                var _throwPending = {
//                    operation: _operation,
//                    node: _throwNode,
//                    compilationUnitNode: methodNode.compilationUnitNode
//                };
//                this._throwPendings.push(_throwPending);
//            }
//        }

        // CsharpDoc
//        if (methodNode.comment) {
//            _operation.documentation = methodNode.comment;
//        }

        // "default" for Annotation Type Element
//        if (methodNode.defaultValue) {
//            this._addTag(_operation, Core.TK_STRING, "default", methodNode.defaultValue);
//        }

        // Translate Type Parameters
//        this.translateTypeParameters(options, _operation, methodNode.typeParameters);
    };

    
    /**
     * Add a Tag
     * @param {type.Model} elem
     * @param {string} kind Kind of Tag
     * @param {string} name
     * @param {?} value Value of Tag
     */
    CsharpCodeAnalyzer.prototype._addTag = function (elem, kind, name, value) {
        var tag = new type.Tag();
        tag._parent = elem;
        tag.name = name;
        tag.kind = kind;
        switch (kind) {
        case Core.TK_STRING:
            tag.value = value;
            break;
        case Core.TK_BOOLEAN:
            tag.checked = value;
            break;
        case Core.TK_NUMBER:
            tag.number = value;
            break;
        case Core.TK_REFERENCE:
            tag.reference = value;
            break;
        case Core.TK_HIDDEN:
            tag.value = value;
            break;
        }
        elem.tags.push(tag);
    };
    
    
    /**
     * Translate Method Parameters
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} parameterNode
     */
    CsharpCodeAnalyzer.prototype.translateParameter = function (options, namespace, parameterNode) {
        var _parameter = new type.UMLParameter();
        _parameter._parent = namespace;
        _parameter.name = parameterNode.name;
        namespace.parameters.push(_parameter);

        // Add to _typedFeaturePendings
        this._typedFeaturePendings.push({
            namespace: namespace._parent,
            feature: _parameter,
            node: parameterNode
        });
    };

    
    /**
     * Translate C# Field Node as UMLAssociation.
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} fieldNode
     */
    CsharpCodeAnalyzer.prototype.translateFieldAsAssociation = function (options, namespace, fieldNode) {
        var i, len;
        if (fieldNode.name && fieldNode.name.length > 0) {
            // Add to _associationPendings
            var _associationPending = {
                classifier: namespace,
                node: fieldNode
            };
            this._associationPendings.push(_associationPending);
        }
    };

    /**
     * Translate C# Field Node as UMLAttribute.
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} fieldNode
     */
    CsharpCodeAnalyzer.prototype.translateFieldAsAttribute = function (options, namespace, fieldNode) {
        var i, len;
        if (fieldNode.name && fieldNode.name.length > 0) {
            for (i = 0, len = fieldNode.name.length; i < len; i++) {
                var variableNode = fieldNode.name[i];

                // Create Attribute
                var _attribute = new type.UMLAttribute();
                _attribute._parent = namespace;
                _attribute.name = variableNode.name;

                // Access Modifiers
                _attribute.visibility = this._getVisibility(fieldNode.modifiers);
                if (variableNode.initialize) {
                    _attribute.defaultValue = variableNode.initialize;
                }

                // Static Modifier
                if (_.contains(fieldNode.modifiers, "static")) {
                    _attribute.isStatic = true;
                }

                // Final Modifier
                if (_.contains(fieldNode.modifiers, "sealed")) {
                    _attribute.isLeaf = true;
                    _attribute.isReadOnly = true;
                }

                // Volatile Modifier
                if (_.contains(fieldNode.modifiers, "volatile")) {
                    this._addTag(_attribute, Core.TK_BOOLEAN, "volatile", true);
                }
 
                // CsharpDoc
//                if (fieldNode.comment) {
//                    _attribute.documentation = fieldNode.comment;
//                }

                namespace.attributes.push(_attribute);

                // Add to _typedFeaturePendings
                var _typedFeature = {
                    namespace: namespace,
                    feature: _attribute,
                    node: fieldNode
                };
                this._typedFeaturePendings.push(_typedFeature);

            }
        }
    };

    
    
    /**
     * Translate C# Type Parameter Nodes.
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} typeParameterNodeArray
     */
    CsharpCodeAnalyzer.prototype.translateTypeParameters = function (options, namespace, typeParameterNodeArray) {
        if (typeParameterNodeArray) {
            var i, len, _typeParam;
            for (i = 0, len = typeParameterNodeArray.length; i < len; i++) {
                _typeParam = typeParameterNodeArray[i];
                if (_typeParam.node === "TypeParameter") {
                    var _templateParameter = new type.UMLTemplateParameter();
                    _templateParameter._parent = namespace;
                    _templateParameter.name = _typeParam.name; 
                    if (_typeParam.type) {
                        _templateParameter.parameterType = _typeParam.type;
                    }
                    namespace.templateParameters.push(_templateParameter);
                }
            }
        }
    };
    
    /**
     * Translate C# Package Node.
     * @param {Object} options
     * @param {type.Model} namespace
     * @param {Object} compilationUnitNode
     */
    CsharpCodeAnalyzer.prototype.translatePackage = function (options, namespace, packageNode) {
        if (packageNode && packageNode.qualifiedName ) {
            
            var pathNames = packageNode.qualifiedName.split("."); 
            return this._ensurePackage(namespace, pathNames);
        }
        return null;
    };
    
    
    /**
     * Return the package of a given pathNames. If not exists, create the package.
     * @param {type.Model} namespace
     * @param {Array.<string>} pathNames
     * @return {type.Model} Package element corresponding to the pathNames
     */
    CsharpCodeAnalyzer.prototype._ensurePackage = function (namespace, pathNames) {
        if (pathNames.length > 0) {
            var name = pathNames.shift();
            if (name && name.length > 0) {
                var elem = namespace.findByName(name);
                if (elem !== null) {
                    // Package exists
                    if (pathNames.length > 0) {
                        return this._ensurePackage(elem, pathNames);
                    } else {
                        return elem;
                    }
                } else {
                    // Package not exists, then create one.
                    var _package = new type.UMLPackage();
                    namespace.ownedElements.push(_package);
                    _package._parent = namespace;
                    _package.name = name;
                    if (pathNames.length > 0) {
                        return this._ensurePackage(_package, pathNames);
                    } else {
                        return _package;
                    }
                }
            }
        } else {
            return namespace;
        }
    };
    
    /**
     * Analyze all C# files in basePath
     * @param {string} basePath
     * @param {Object} options
     * @return {$.Promise}
     */
    function analyze(basePath, options) {
        var result = new $.Deferred(),
            csharpAnalyzer = new CsharpCodeAnalyzer();

        function visitEntry(entry) {
            if (entry._isFile === true) {
                var ext = FileUtils.getFileExtension(entry._path);
                if (ext && ext.toLowerCase() === "cs") {
                    csharpAnalyzer.addFile(entry);
                }
            }
            return true;
        }

        // Traverse all file entries
        var dir = FileSystem.getDirectoryForPath(basePath);
        dir.visit(visitEntry, {}, function (err) {
            if (!err) {
                csharpAnalyzer.analyze(options).then(result.resolve, result.reject);
            } else {
                result.reject(err);
            }
        });

        return result.promise();
    }

    exports.analyze = analyze;

});
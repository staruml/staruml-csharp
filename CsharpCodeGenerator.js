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

/*jslint vars: true, plusplus: true, devel: true, nomen: true, indent: 4, maxerr: 50, regexp: true */
/*global define, $, _, window, staruml, type, document, csharp */

define(function (require, exports, module) {
    "use strict";

    var Repository = staruml.getModule("engine/Repository"),
        Engine     = staruml.getModule("engine/Engine"),
        FileSystem = staruml.getModule("filesystem/FileSystem"),
        FileUtils  = staruml.getModule("file/FileUtils"),
        Async      = staruml.getModule("utils/Async"),
        UML        = staruml.getModule("uml/UML");

    var CodeGenUtils = require("CodeGenUtils");
    
    /**
     * C# Code Generator
     * @constructor
     *
     * @param {type.UMLPackage} baseModel
     * @param {string} basePath generated files and directories to be placed
     */
    function CsharpCodeGenerator(baseModel, basePath) {
    
        /** @member {type.Model} */
        this.baseModel = baseModel;
        
        /** @member {string} */
        this.basePath = basePath;
        
    }

    /**
     * Return Indent String based on options
     * @param {Object} options
     * @return {string}
     */
    CsharpCodeGenerator.prototype.getIndentString = function (options) {
        if (options.useTab) {
            return "\t";
        } else {
            var i, len, indent = [];
            for (i = 0, len = options.indentSpaces; i < len; i++) {
                indent.push(" ");
            }
            return indent.join("");
        }
    };
    
    /**
     * Generate codes from a given element
     * @param {type.Model} elem
     * @param {string} path
     * @param {Object} options
     * @return {$.Promise}
     */
    CsharpCodeGenerator.prototype.generate = function (elem, path, options) {
        var result = new $.Deferred(),
            self = this,
            fullPath,
            directory,
            codeWriter,
            file;
        
        // Package
        if (elem instanceof type.UMLPackage) {
            fullPath = path + "/" + elem.name;
            directory = FileSystem.getDirectoryForPath(fullPath);
            directory.create(function (err, stat) {
                if (!err) {
                    Async.doSequentially(
                        elem.ownedElements,
                        function (child) {
                            console.log('package generate');
                            return self.generate(child, fullPath, options);
                        },
                        false
                    ).then(result.resolve, result.reject);
                } else {
                    result.reject(err);
                }
            });
        } 
        
        else if (elem instanceof type.UMLClass) {
           
            var isAnnotationType = elem.stereotype === "annotationType";
            
            // AnnotationType
            if (isAnnotationType) {
                console.log('annotationType generate');
                
            } 
            // Class
            else { 
                fullPath = path + "/" + elem.name + ".cs"; 
                console.log('Class generate' + fullPath);
                
                codeWriter = new CodeGenUtils.CodeWriter(this.getIndentString(options)); 
                codeWriter.writeLine();
                codeWriter.writeLine("using System;");
//                codeWriter.writeLine("using System.Collections.Generic;");
//                codeWriter.writeLine("using System.Linq;");
//                codeWriter.writeLine("using System.Text;");
                codeWriter.writeLine();
                this.writeNamespace(codeWriter, elem, options, isAnnotationType);
                file = FileSystem.getFileForPath(fullPath);
                FileUtils.writeText(file, codeWriter.getData(), true).then(result.resolve, result.reject);
            }
        }
            
        // Others (Nothing generated.)
        else {
            console.log('nothing generate');
            result.resolve();
        }
        return result.promise();
    };
    
    
    /**
     * Write namespace 
     * @param {StringWriter} codeWriter
     * @param {type.Model} elem
     * @param {Object} options     
     */
    CsharpCodeGenerator.prototype.writeNamespace = function (codeWriter, elem, options, isAnnotationType) {
        var path = null;
        if (elem._parent) {
            path = _.map(elem._parent.getPath(this.baseModel), function (e) { return e.name; }).join(".");
        }
        if (path) {
            codeWriter.writeLine("namespace " + path + "{"); 
            codeWriter.indent();
            if(isAnnotationType){
                
            } else { 
                this.writeClass(codeWriter, elem, options);
            }
            codeWriter.outdent();
            codeWriter.writeLine("}");
        }
        else{
            if(isAnnotationType){
                
            } else { 
                this.writeClass(codeWriter, elem, options);
            }
        }
    };

    
    /**
     * Write Class
     * @param {StringWriter} codeWriter
     * @param {type.Model} elem
     * @param {Object} options     
     */
    CsharpCodeGenerator.prototype.writeClass = function (codeWriter, elem, options) {
        var i, len, terms = [];
        // Doc
        var doc = elem.documentation.trim();
        if (Repository.getProject().author && Repository.getProject().author.length > 0) {
            doc += "\n@author " + Repository.getProject().author;
        }
        this.writeDoc(codeWriter, doc, options);
           
         // Modifiers
        var _modifiers = this.getModifiers(elem);
        if (_.some(elem.operations, function (op) { return op.isAbstract === true; })) {
            _modifiers.push("abstract");
        }
        if (_modifiers.length > 0) {
            terms.push(_modifiers.join(" "));
        }
        
        // Class
        terms.push("class");
        terms.push(elem.name);
        
        // Extends
        var _extends = this.getSuperClasses(elem);
        if (_extends.length > 0) {
            terms.push(": " + _extends[0].name);
        }
        
        // Implements
        var _implements = this.getSuperInterfaces(elem);
        if (_implements.length > 0) {
            if (_extends.length > 0) {
                terms.push(", " + _.map(_implements, function (e) { return e.name; }).join(", "));
            } else { 
                terms.push(": " + _.map(_implements, function (e) { return e.name; }).join(", "));
            }
        }
        
        codeWriter.writeLine(terms.join(" ") + " {");
        codeWriter.writeLine();
        codeWriter.indent();
        
        codeWriter.outdent();
        codeWriter.writeLine("}");
        
    };
    
    /**
     * Write Doc
     * @param {StringWriter} codeWriter
     * @param {string} text
     * @param {Object} options
     */
    CsharpCodeGenerator.prototype.writeDoc = function (codeWriter, text, options) {
        
        var i, len, lines;
        if (options.csharpDoc && _.isString(text)) {
            console.log("write Doc");
            lines = text.trim().split("\n");
            codeWriter.writeLine("/**");
            for (i = 0, len = lines.length; i < len; i++) {
                codeWriter.writeLine(" * " + lines[i]);
            }
            codeWriter.writeLine(" */");
        }
    };

    /**
     * Return visibility
     * @param {type.Model} elem
     * @return {string}
     */
    CsharpCodeGenerator.prototype.getVisibility = function (elem) {
        switch (elem.visibility) {
        case UML.VK_PUBLIC:
            return "public";
        case UML.VK_PROTECTED:
            return "protected";
        case UML.VK_PRIVATE:
            return "private";
        }
        return null;
    };

    /**
     * Collect modifiers of a given element.
     * @param {type.Model} elem
     * @return {Array.<string>}
     */
    CsharpCodeGenerator.prototype.getModifiers = function (elem) {
        var modifiers = [];
        var visibility = this.getVisibility(elem);
        if (visibility) {
            modifiers.push(visibility);
        }
        if (elem.isStatic === true) {
            modifiers.push("static");
        }
        if (elem.isAbstract === true) {
            modifiers.push("abstract");
        }
        if (elem.isFinalSpecification === true || elem.isLeaf === true) {
            modifiers.push("sealed");
        }
        if (elem.concurrency === UML.CCK_CONCURRENT) {
            //http://msdn.microsoft.com/ko-kr/library/c5kehkcz.aspx
            //modifiers.push("synchronized");
        }
        // transient
        // volatile
        // strictfp
        // const
        // native
        return modifiers;
    };

    /**
     * Collect super classes of a given element
     * @param {type.Model} elem
     * @return {Array.<type.Model>}
     */
    CsharpCodeGenerator.prototype.getSuperClasses = function (elem) {
        var generalizations = Repository.getRelationshipsOf(elem, function (rel) {
            return (rel instanceof type.UMLGeneralization && rel.source === elem);
        });
        return _.map(generalizations, function (gen) { return gen.target; });
    };

    /**
     * Collect super interfaces of a given element
     * @param {type.Model} elem
     * @return {Array.<type.Model>}
     */
    CsharpCodeGenerator.prototype.getSuperInterfaces = function (elem) {
        var realizations = Repository.getRelationshipsOf(elem, function (rel) {
            return (rel instanceof type.UMLInterfaceRealization && rel.source === elem);
        });
        return _.map(realizations, function (gen) { return gen.target; });
    };
    
  
    /**
     * Generate
     * @param {type.Model} baseModel
     * @param {string} basePath
     * @param {Object} options
     */
    function generate(baseModel, basePath, options) {
        var result = new $.Deferred();
        var csharpCodeGenerator = new CsharpCodeGenerator(baseModel, basePath);
        return csharpCodeGenerator.generate(baseModel, basePath, options);
    }
    
    exports.generate = generate;

});
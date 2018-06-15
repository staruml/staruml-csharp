/*
 * Copyright (c) 2014-2018 MKLab. All rights reserved.
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

const fs = require('fs')
const path = require('path')
const codegen = require('./codegen-utils')

/**
 * C# Code Generator
 */
class CSharpCodeGenerator {
  /**
   * @constructor
   *
   * @param {type.UMLPackage} baseModel
   * @param {string} basePath generated files and directories to be placed
   */
  constructor (baseModel, basePath) {
    /** @member {type.Model} */
    this.baseModel = baseModel

    /** @member {string} */
    this.basePath = basePath
  }

  /**
   * Return Indent String based on options
   * @param {Object} options
   * @return {string}
   */
  getIndentString (options) {
    if (options.useTab) {
      return '\t'
    } else {
      var i, len
      var indent = []
      for (i = 0, len = options.indentSpaces; i < len; i++) {
        indent.push(' ')
      }
      return indent.join('')
    }
  }

  /**
   * Generate codes from a given element
   * @param {type.Model} elem
   * @param {string} path
   * @param {Object} options
   * @return {$.Promise}
   */
  generate (elem, basePath, options) {
    var fullPath, codeWriter
    var isAnnotationType = elem.stereotype === 'annotationType'
    // Package
    if (elem instanceof type.UMLPackage) {
      fullPath = path.join(basePath, elem.name)
      fs.mkdirSync(fullPath)
      if (Array.isArray(elem.ownedElements)) {
        elem.ownedElements.forEach(child => {
          return this.generate(child, fullPath, options)
        })
      }
    } else if (elem instanceof type.UMLClass) {
      // AnnotationType
      if (isAnnotationType) {
        if (elem.name.length < 9) {
          elem.name = elem.name + 'Attribute'
        } else if (elem.name.substring(elem.name.length - 9, elem.name.length) !== 'Attribute') {
          elem.name = elem.name + 'Attribute'
        }
        fullPath = basePath + '/' + elem.name + '.cs'
        codeWriter = new codegen.CodeWriter(this.getIndentString(options))
        codeWriter.writeLine()
        codeWriter.writeLine('using System;')
        codeWriter.writeLine('using System.Collections.Generic;')
        codeWriter.writeLine('using System.Linq;')
        codeWriter.writeLine('using System.Text;')
        codeWriter.writeLine()
        // this.writeAnnotationType(codeWriter, elem, options, isAnnotationType);
        this.writeNamespace('writeAnnotationType', codeWriter, elem, options, isAnnotationType)
        fs.writeFileSync(fullPath, codeWriter.getData())
      } else {
        // Class
        fullPath = path.join(basePath, elem.name + '.cs')
        codeWriter = new codegen.CodeWriter(this.getIndentString(options))
        codeWriter.writeLine()
        codeWriter.writeLine('using System;')
        codeWriter.writeLine('using System.Collections.Generic;')
        codeWriter.writeLine('using System.Linq;')
        codeWriter.writeLine('using System.Text;')
        codeWriter.writeLine()
        // this.writeClass(codeWriter, elem, options, isAnnotationType);
        this.writeNamespace('writeClass', codeWriter, elem, options, isAnnotationType)
        fs.writeFileSync(fullPath, codeWriter.getData())
      }
    } else if (elem instanceof type.UMLInterface) {
      // Interface
      fullPath = basePath + '/' + elem.name + '.cs'
      codeWriter = new codegen.CodeWriter(this.getIndentString(options))
      codeWriter.writeLine()
      codeWriter.writeLine('using System;')
      codeWriter.writeLine('using System.Collections.Generic;')
      codeWriter.writeLine('using System.Linq;')
      codeWriter.writeLine('using System.Text;')
      codeWriter.writeLine()
      // this.writeInterface(codeWriter, elem, options);
      this.writeNamespace('writeInterface', codeWriter, elem, options, isAnnotationType)
      fs.writeFileSync(fullPath, codeWriter.getData())
    } else if (elem instanceof type.UMLEnumeration) {
      // Enum
      fullPath = basePath + '/' + elem.name + '.cs'
      codeWriter = new codegen.CodeWriter(this.getIndentString(options))
      codeWriter.writeLine()
      // this.writeEnum(codeWriter, elem, options);
      this.writeNamespace('writeEnum', codeWriter, elem, options, isAnnotationType)
      fs.writeFileSync(fullPath, codeWriter.getData())
    }
  }

  /**
   * Write Namespace
   * @param {functionName} writeFunction
   * @param {StringWriter} codeWriter
   * @param {type.Model} elem
   * @param {Object} options
   */
  writeNamespace (writeFunction, codeWriter, elem, options) {
    var path = null
    if (elem._parent) {
      path = elem._parent.getPath(this.baseModel).map(function (e) { return e.name }).join('.')
    }
    if (path) {
      codeWriter.writeLine('namespace ' + path + '{')
      codeWriter.indent()
    }
    if (writeFunction === 'writeAnnotationType') {
      this.writeAnnotationType(codeWriter, elem, options)
    } else if (writeFunction === 'writeClass') {
      this.writeClass(codeWriter, elem, options)
    } else if (writeFunction === 'writeInterface') {
      this.writeInterface(codeWriter, elem, options)
    } else if (writeFunction === 'writeEnum') {
      this.writeEnum(codeWriter, elem, options)
    }
    if (path) {
      codeWriter.outdent()
      codeWriter.writeLine('}')
    }
  }

  /**
   * Write Enum
   * @param {StringWriter} codeWriter
   * @param {type.Model} elem
   * @param {Object} options
   */
  writeEnum (codeWriter, elem, options) {
    var i, len
    var terms = []
    // Doc
    this.writeDoc(codeWriter, elem.documentation, options)

    // Modifiers
    var visibility = this.getVisibility(elem)
    if (visibility) {
      terms.push(visibility)
    }
    // Enum
    terms.push('enum')
    terms.push(elem.name)

    codeWriter.writeLine(terms.join(' ') + ' {')
    codeWriter.indent()

    // Literals
    for (i = 0, len = elem.literals.length; i < len; i++) {
      codeWriter.writeLine(elem.literals[i].name + (i < elem.literals.length - 1 ? ',' : ''))
    }

    codeWriter.outdent()
    codeWriter.writeLine('}')
  }

  /**
   * Write Interface
   * @param {StringWriter} codeWriter
   * @param {type.Model} elem
   * @param {Object} options
   */
  writeInterface (codeWriter, elem, options) {
    var i, len
    var terms = []

    // Doc
    this.writeDoc(codeWriter, elem.documentation, options)

    // Modifiers
    var visibility = this.getVisibility(elem)
    if (visibility) {
      terms.push(visibility)
    }

    // Interface
    terms.push('interface')
    terms.push(elem.name)

    // Extends
    var _extends = this.getSuperClasses(elem)
    if (_extends.length > 0) {
      terms.push(': ' + _extends.map(function (e) { return e.name }).join(', '))
    }
    codeWriter.writeLine(terms.join(' ') + ' {')
    codeWriter.writeLine()
    codeWriter.indent()

    // Member Variables
    // (from attributes)
    for (i = 0, len = elem.attributes.length; i < len; i++) {
      this.writeMemberVariable(codeWriter, elem.attributes[i], options)
      codeWriter.writeLine()
    }
    // (from associations)
    var associations = app.repository.getRelationshipsOf(elem, function (rel) {
      return (rel instanceof type.UMLAssociation)
    })
    for (i = 0, len = associations.length; i < len; i++) {
      var asso = associations[i]
      if (asso.end1.reference === elem && asso.end2.navigable === true) {
        this.writeMemberVariable(codeWriter, asso.end2, options)
        codeWriter.writeLine()
      } else if (asso.end2.reference === elem && asso.end1.navigable === true) {
        this.writeMemberVariable(codeWriter, asso.end1, options)
        codeWriter.writeLine()
      }
    }

    // Methods
    for (i = 0, len = elem.operations.length; i < len; i++) {
      this.writeMethod(codeWriter, elem.operations[i], options, true, false)
      codeWriter.writeLine()
    }

    // Inner Definitions
    for (i = 0, len = elem.ownedElements.length; i < len; i++) {
      var def = elem.ownedElements[i]
      if (def instanceof type.UMLClass) {
        if (def.stereotype === 'annotationType') {
          this.writeAnnotationType(codeWriter, def, options)
        } else {
          this.writeClass(codeWriter, def, options)
        }
        codeWriter.writeLine()
      } else if (def instanceof type.UMLInterface) {
        this.writeInterface(codeWriter, def, options)
        codeWriter.writeLine()
      } else if (def instanceof type.UMLEnumeration) {
        this.writeEnum(codeWriter, def, options)
        codeWriter.writeLine()
      }
    }

    codeWriter.outdent()
    codeWriter.writeLine('}')
  }

  /**
   * Write AnnotationType
   * @param {StringWriter} codeWriter
   * @param {type.Model} elem
   * @param {Object} options
   */
  writeAnnotationType (codeWriter, elem, options) {
    var i, len
    var terms = []
    // Doc
    var doc = elem.documentation.trim()
    if (app.project.getProject().author && app.project.getProject().author.length > 0) {
      doc += '\n@author ' + app.project.getProject().author
    }
    this.writeDoc(codeWriter, doc, options)

    // Modifiers
    var _modifiers = this.getModifiers(elem)
    if (elem.operations.some(function (op) { return op.isAbstract === true })) {
      _modifiers.push('abstract')
    }
    if (_modifiers.length > 0) {
      terms.push(_modifiers.join(' '))
    }

    // Class
    terms.push('class')
    terms.push(elem.name)

    // AnnotationType => Attribute in C#
    terms.push(':System.Attribute')
    codeWriter.writeLine(terms.join(' ') + ' {')
    codeWriter.writeLine()
    codeWriter.indent()

    // Constructor
    this.writeConstructor(codeWriter, elem, options)
    codeWriter.writeLine()

    // Member Variables
    // (from attributes)
    for (i = 0, len = elem.attributes.length; i < len; i++) {
      this.writeMemberVariable(codeWriter, elem.attributes[i], options)
      codeWriter.writeLine()
    }
    // (from associations)
    var associations = app.repository.getRelationshipsOf(elem, function (rel) {
      return (rel instanceof type.UMLAssociation)
    })

    for (i = 0, len = associations.length; i < len; i++) {
      var asso = associations[i]
      if (asso.end1.reference === elem && asso.end2.navigable === true) {
        this.writeMemberVariable(codeWriter, asso.end2, options)
        codeWriter.writeLine()
      } else if (asso.end2.reference === elem && asso.end1.navigable === true) {
        this.writeMemberVariable(codeWriter, asso.end1, options)
        codeWriter.writeLine()
      }
    }

    // Methods
    for (i = 0, len = elem.operations.length; i < len; i++) {
      this.writeMethod(codeWriter, elem.operations[i], options, false, false)
      codeWriter.writeLine()
    }

    // Inner Definitions
    for (i = 0, len = elem.ownedElements.length; i < len; i++) {
      var def = elem.ownedElements[i]
      if (def instanceof type.UMLClass) {
        if (def.stereotype === 'annotationType') {
          this.writeAnnotationType(codeWriter, def, options)
        } else {
          this.writeClass(codeWriter, def, options)
        }
        codeWriter.writeLine()
      } else if (def instanceof type.UMLInterface) {
        this.writeInterface(codeWriter, def, options)
        codeWriter.writeLine()
      } else if (def instanceof type.UMLEnumeration) {
        this.writeEnum(codeWriter, def, options)
        codeWriter.writeLine()
      }
    }
    codeWriter.outdent()
    codeWriter.writeLine('}')
  }

  /**
   * Write Class
   * @param {StringWriter} codeWriter
   * @param {type.Model} elem
   * @param {Object} options
   */
  writeClass (codeWriter, elem, options) {
    var i, len
    var terms = []

    // Doc
    var doc = elem.documentation.trim()
    if (app.project.getProject().author && app.project.getProject().author.length > 0) {
      doc += '\n@author ' + app.project.getProject().author
    }
    this.writeDoc(codeWriter, doc, options)

    // Modifiers
    var _modifiers = this.getModifiers(elem)
    if (elem.operations.some(function (op) { return op.isAbstract === true }) && !_modifiers.includes('abstract')) {
      _modifiers.push('abstract')
    }
    if (_modifiers.length > 0) {
      terms.push(_modifiers.join(' '))
    }

    // Class
    terms.push('class')
    terms.push(elem.name)

    // Extends
    var _extends = this.getSuperClasses(elem)
    if (_extends.length > 0) {
      terms.push(': ' + _extends[0].name)
    }

    // Implements
    var _implements = this.getSuperInterfaces(elem)
    if (_implements.length > 0) {
      if (_extends.length > 0) {
        terms.push(', ' + _implements.map(function (e) { return e.name }).join(', '))
      } else {
        terms.push(': ' + _implements.map(function (e) { return e.name }).join(', '))
      }
    }

    codeWriter.writeLine(terms.join(' ') + ' {')
    codeWriter.writeLine()
    codeWriter.indent()

    // Constructor
    this.writeConstructor(codeWriter, elem, options)
    codeWriter.writeLine()

    // Member Variables
    // (from attributes)
    for (i = 0, len = elem.attributes.length; i < len; i++) {
      this.writeMemberVariable(codeWriter, elem.attributes[i], options)
      codeWriter.writeLine()
    }
    // (from associations)
    var associations = app.repository.getRelationshipsOf(elem, function (rel) {
      return (rel instanceof type.UMLAssociation)
    })

    for (i = 0, len = associations.length; i < len; i++) {
      var asso = associations[i]
      if (asso.end1.reference === elem && asso.end2.navigable === true) {
        this.writeMemberVariable(codeWriter, asso.end2, options)
        codeWriter.writeLine()
      } else if (asso.end2.reference === elem && asso.end1.navigable === true) {
        this.writeMemberVariable(codeWriter, asso.end1, options)
        codeWriter.writeLine()
      }
    }

    // Methods
    for (i = 0, len = elem.operations.length; i < len; i++) {
      this.writeMethod(codeWriter, elem.operations[i], options, false, false)
      codeWriter.writeLine()
    }

    // Inner Definitions
    for (i = 0, len = elem.ownedElements.length; i < len; i++) {
      var def = elem.ownedElements[i]
      if (def instanceof type.UMLClass) {
        if (def.stereotype === 'annotationType') {
          this.writeAnnotationType(codeWriter, def, options)
        } else {
          this.writeClass(codeWriter, def, options)
        }
        codeWriter.writeLine()
      } else if (def instanceof type.UMLInterface) {
        this.writeInterface(codeWriter, def, options)
        codeWriter.writeLine()
      } else if (def instanceof type.UMLEnumeration) {
        this.writeEnum(codeWriter, def, options)
        codeWriter.writeLine()
      }
    }

    codeWriter.outdent()
    codeWriter.writeLine('}')
  }

  /**
   * Write Method
   * @param {StringWriter} codeWriter
   * @param {type.Model} elem
   * @param {Object} options
   * @param {boolean} skipBody
   * @param {boolean} skipParams
   */
  writeMethod (codeWriter, elem, options, skipBody, skipParams) {
    if (elem.name.length > 0) {
      var terms = []
      var params = elem.getNonReturnParameters()
      var returnParam = elem.getReturnParameter()

      // doc
      var doc = elem.documentation.trim()
      params.forEach(function (param) {
        doc += '\n@param ' + param.name + ' ' + param.documentation
      })
      if (returnParam) {
        doc += '\n@return ' + returnParam.documentation
      }
      this.writeDoc(codeWriter, doc, options)

      // modifiers
      var _modifiers = this.getModifiers(elem)
      if (_modifiers.length > 0) {
        terms.push(_modifiers.join(' '))
      }

      // type
      if (returnParam) {
        terms.push(this.getType(returnParam))
      } else {
        terms.push('void')
      }

      // name + parameters
      var paramTerms = []
      if (!skipParams) {
        var i, len
        for (i = 0, len = params.length; i < len; i++) {
          var p = params[i]
          var s = this.getType(p) + ' ' + p.name
          if (p.isReadOnly === true) {
            s = 'sealed ' + s
          }
          paramTerms.push(s)
        }
      }
      terms.push(elem.name + '(' + paramTerms.join(', ') + ')')

      // body
      if (skipBody === true || _modifiers.includes('abstract')) {
        codeWriter.writeLine(terms.join(' ') + ';')
      } else {
        codeWriter.writeLine(terms.join(' ') + ' {')
        codeWriter.indent()
        codeWriter.writeLine('// TODO implement here')

        // return statement
        if (returnParam) {
          var returnType = this.getType(returnParam)
          if (returnType === 'bool') {
            codeWriter.writeLine('return False;')
          } else if (returnType === 'byte' || returnType === 'int' || returnType === 'sbyte' || returnType === 'short' || returnType === 'uint' || returnType === 'ulong' || returnType === 'ushort') {
            codeWriter.writeLine('return 0;')
          } else if (returnType === 'float') {
            codeWriter.writeLine('return 0.0F;')
          } else if (returnType === 'double') {
            codeWriter.writeLine('return 0.0D;')
          } else if (returnType === 'long') {
            codeWriter.writeLine('return 0.0L;')
          } else if (returnType === 'decimal') {
            codeWriter.writeLine('return 0.0M;')
          } else if (returnType === 'char') {
            codeWriter.writeLine('return "\\0";')
          } else if (returnType === 'string') {
            codeWriter.writeLine('return "";')
          } else {
            codeWriter.writeLine('return null;')
          }
        }

        codeWriter.outdent()
        codeWriter.writeLine('}')
      }
    }
  };

  /**
   * Return type expression
   * @param {type.Model} elem
   * @return {string}
   */
  getType (elem) {
    var _type = 'void'
    // type name
    if (elem instanceof type.UMLAssociationEnd) {
      if (elem.reference instanceof type.UMLModelElement && elem.reference.name.length > 0) {
        _type = elem.reference.name
      }
    } else {
      if (elem.type instanceof type.UMLModelElement && elem.type.name.length > 0) {
        _type = elem.type.name
      } else if ((typeof elem.type === 'string') && elem.type.length > 0) {
        _type = elem.type
      }
    }

    // multiplicity
    if (elem.multiplicity) {
      if (['0..*', '1..*', '*'].includes(elem.multiplicity.trim())) {
        if (elem.isOrdered === true) {
          _type = 'List<' + _type + '>'
        } else {
          _type = 'HashSet<' + _type + '>'
        }
      } else if (elem.multiplicity !== '1' && elem.multiplicity.match(/^\d+$/)) { // number
        _type += '[]'
      }
    }
    return _type
  }

  /**
   * Write Member Variable
   * @param {StringWriter} codeWriter
   * @param {type.Model} elem
   * @param {Object} options
   */
  writeMemberVariable (codeWriter, elem, options) {
    if (elem.name.length > 0) {
      var terms = []
      // doc
      this.writeDoc(codeWriter, elem.documentation, options)
      // modifiers
      var _modifiers = this.getModifiers(elem)
      if (_modifiers.length > 0) {
        terms.push(_modifiers.join(' '))
      }
      // type
      terms.push(this.getType(elem))
      // name
      terms.push(elem.name)
      // initial value
      if (elem.defaultValue && elem.defaultValue.length > 0) {
        terms.push('= ' + elem.defaultValue)
      }

      // property
      if (elem.stereotype === 'property') {
        codeWriter.writeLine(terms.join(' ') + ' {')
        codeWriter.indent()
        if (elem.isReadOnly) {
          codeWriter.writeLine('get {')
          codeWriter.writeLine('}')
        } else {
          codeWriter.writeLine('get; set;')
        }
        codeWriter.outdent()
        codeWriter.writeLine('}')
      } else {
        codeWriter.writeLine(terms.join(' ') + ';')
      }
    }
  }

  /**
   * Write Constructor
   * @param {StringWriter} codeWriter
   * @param {type.Model} elem
   * @param {Object} options
   */
  writeConstructor (codeWriter, elem, options) {
    if (elem.name.length > 0) {
      var terms = []
      // Doc
      this.writeDoc(codeWriter, elem.documentation, options)
      // Visibility
      var visibility = this.getVisibility(elem)
      if (visibility) {
        terms.push(visibility)
      }
      terms.push(elem.name + '()')
      codeWriter.writeLine(terms.join(' ') + ' {')
      codeWriter.writeLine('}')
    }
  }

  /**
   * Write Doc
   * @param {StringWriter} codeWriter
   * @param {string} text
   * @param {Object} options
   */
  writeDoc (codeWriter, text, options) {
    var i, len, lines
    if (options.csharpDoc && (typeof text === 'string') && text.trim().length > 0) {
      lines = text.trim().split('\n')
      codeWriter.writeLine('/// <summary>')
      for (i = 0, len = lines.length; i < len; i++) {
        codeWriter.writeLine('/// ' + lines[i])
      }
      codeWriter.writeLine('/// </summary>')
    }
  }

  /**
   * Return visibility
   * @param {type.Model} elem
   * @return {string}
   */
  getVisibility (elem) {
    switch (elem.visibility) {
    case type.UMLModelElement.VK_PUBLIC:
      return 'public'
    case type.UMLModelElement.VK_PROTECTED:
      return 'protected'
    case type.UMLModelElement.VK_PRIVATE:
      return 'private'
    case type.UMLModelElement.VK_PACKAGE:
      return 'internal'
    }
    return null
  }

  /**
   * Collect modifiers of a given element.
   * @param {type.Model} elem
   * @return {Array.<string>}
   */
  getModifiers (elem) {
    var modifiers = []
    var visibility = this.getVisibility(elem)
    if (visibility) {
      modifiers.push(visibility)
    }
    if (elem.isStatic === true) {
      modifiers.push('static')
    }
    if (elem.isAbstract === true) {
      modifiers.push('abstract')
    }
    if (elem.isFinalSpecialization === true || elem.isLeaf === true) {
      modifiers.push('sealed')
    }
    // if (elem.concurrency === UML.CCK_CONCURRENT) {
    // http://msdn.microsoft.com/ko-kr/library/c5kehkcz.aspx
    // modifiers.push("synchronized");
    // }
    // transient
    // volatile
    // strictfp
    // const
    // native
    return modifiers
  }

  /**
   * Collect super classes of a given element
   * @param {type.Model} elem
   * @return {Array.<type.Model>}
   */
  getSuperClasses (elem) {
    var generalizations = app.repository.getRelationshipsOf(elem, function (rel) {
      return (rel instanceof type.UMLGeneralization && rel.source === elem)
    })
    return generalizations.map(function (gen) { return gen.target })
  };

  /**
   * Collect super interfaces of a given element
   * @param {type.Model} elem
   * @return {Array.<type.Model>}
   */
  getSuperInterfaces (elem) {
    var realizations = app.repository.getRelationshipsOf(elem, function (rel) {
      return (rel instanceof type.UMLInterfaceRealization && rel.source === elem)
    })
    return realizations.map(function (gen) { return gen.target })
  }

}

/**
 * Generate
 * @param {type.Model} baseModel
 * @param {string} basePath
 * @param {Object} options
 */
function generate (baseModel, basePath, options) {
  var csharpCodeGenerator = new CSharpCodeGenerator(baseModel, basePath)
  csharpCodeGenerator.generate(baseModel, basePath, options)
}

exports.generate = generate

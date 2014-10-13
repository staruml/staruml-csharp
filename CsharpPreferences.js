/*
 * Copyright (c) 2013-2014 Minkyu Lee. All rights reserved.
 *
 * NOTICE:  All information contained herein is, and remains the
 * property of Minkyu Lee. The intellectual and technical concepts
 * contained herein are proprietary to Minkyu Lee and may be covered
 * by Republic of Korea and Foreign Patents, patents in process,
 * and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Minkyu Lee (niklaus.lee@gmail.com).
 *
 */

/*jslint vars: true, plusplus: true, devel: true, nomen: true, indent: 4, maxerr: 50, regexp: true */
/*global define, $, _, window, appshell, staruml */

define(function (require, exports, module) {
    "use strict";

    var AppInit           = staruml.getModule("utils/AppInit"),
        Core              = staruml.getModule("core/Core"),
        PreferenceManager = staruml.getModule("preference/PreferenceManager");

    var preferenceId = "csharp";
    
    var csharpPreferences = {
        "csharp.gen": {
            text: "C# Code Generation",
            type: "Section"
        },
        "csharp.gen.csharpDoc": {
            text: "CsharpDoc",
            description: "Generate CsharpDoc comments.",
            type: "Check",
            default: true
        },
        "csharp.gen.useTab": {
            text: "Use Tab",
            description: "Use Tab for indentation instead of spaces.",
            type: "Check",
            default: false
        },
        "csharp.gen.indentSpaces": {
            text: "Indent Spaces",
            description: "Number of spaces for indentation.",
            type: "Number",
            default: 4
        },
        "csharp.rev": {
            text: "C# Reverse Engineering",
            type: "Section"
        },
        "csharp.rev.association": {
            text: "Use Association",
            description: "Reverse C# Fields as UML Associations.",
            type: "Check",
            default: true
        },
        "csharp.rev.publicOnly": {
            text: "Public Only",
            description: "Reverse public members only.",
            type: "Check",
            default: false
        },
        "csharp.rev.typeHierarchy": {
            text: "Type Hierarchy Diagram",
            description: "Create a type hierarchy diagram for all classes and interfaces",
            type: "Check",
            default: true
        },
        "csharp.rev.packageOverview": {
            text: "Package Overview Diagram",
            description: "Create overview diagram for each package",
            type: "Check",
            default: true
        },
        "csharp.rev.packageStructure": {
            text: "Package Structure Diagram",
            description: "Create a package structure diagram for all packages",
            type: "Check",
            default: true
        }
    };
    
    function getId() {
        return preferenceId;
    }

    function getGenOptions() {
        return {
            csharpDoc     : PreferenceManager.get("csharp.gen.csharpDoc"),
            useTab        : PreferenceManager.get("csharp.gen.useTab"),
            indentSpaces  : PreferenceManager.get("csharp.gen.indentSpaces")
        };
    }
 
    function getRevOptions() {
        return {
            association      : PreferenceManager.get("csharp.rev.association"),
            publicOnly       : PreferenceManager.get("csharp.rev.publicOnly"),
            typeHierarchy    : PreferenceManager.get("csharp.rev.typeHierarchy"),
            packageOverview  : PreferenceManager.get("csharp.rev.packageOverview"),
            packageStructure : PreferenceManager.get("csharp.rev.packageStructure")
        };
    }

    AppInit.htmlReady(function () {
        PreferenceManager.register(preferenceId, "CSharp", csharpPreferences);
    });

    exports.getId         = getId;
    exports.getGenOptions = getGenOptions;
    exports.getRevOptions = getRevOptions;
    
});

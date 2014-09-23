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
/*global define, $, _, window, staruml, type, appshell, document */

define(function (require, exports, module) {
    "use strict";
    var CommandManager      = staruml.getModule("command/CommandManager"),
        Commands            = staruml.getModule("command/Commands"),
        MenuManager         = staruml.getModule("menu/MenuManager");
    
    var CMD_CSHARP              = "csharp",
        CMD_CSHARP_GENERATE     = "csharp.generate",
        CMD_CSHARP_REVERSE      = "csharp.reverse",
        CMD_CSHARP_CONFIGURE    = "csharp.configure";
     
    function _handleGenerate() {
        console.log("handle generate");
    }

    function _handleReverse() {
        console.log("handle reverse");
    }

    function _handleConfigure() {
        console.log("handle configure");
    }

    // Register Commands
    CommandManager.register("C#",               CMD_CSHARP,           CommandManager.doNothing);
    CommandManager.register("Generate Code...", CMD_CSHARP_GENERATE,  _handleGenerate);
    CommandManager.register("Reverse Code...",  CMD_CSHARP_REVERSE,   _handleReverse);
    CommandManager.register("Configure...",     CMD_CSHARP_CONFIGURE, _handleConfigure);

    var menu, menuItem;
    menu = MenuManager.getMenu(Commands.TOOLS);
    menuItem = menu.addMenuItem(CMD_CSHARP);
    menuItem.addMenuItem(CMD_CSHARP_GENERATE);
    menuItem.addMenuItem(CMD_CSHARP_REVERSE);
    menuItem.addMenuDivider();
    menuItem.addMenuItem(CMD_CSHARP_CONFIGURE);
});
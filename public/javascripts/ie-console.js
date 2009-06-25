/**
 * Simple Javascript console for IE
 *
 * Inspired by Firebug for Firefox
 *
 * Instructions:
 *     1. Include this script file in your page's HTML head
 *     2. Press F12, or from some Javascript on the page, call console.log()
 *
 * Author:                              Moxley Stratton (www.moxleystratton.com)
 * License:                             MIT License
 * Original Release Date: 2006-12-04
 * @version 0.4
 *
 * The MIT License
 *
 * Copyright (c) 2008 Moxley Stratton
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */
 
var IEConsole = {
    HEIGHT: 120,
    INPUT_HEIGHT: 25,
    block: false,
    open: false,
    show: function() {
        if (!IEConsole.block) {
            IEConsole.block = IEConsole.createContainer();
            document.body.insertBefore(IEConsole.block, document.body.childNodes[0]);
            //IEConsole.inputElement.focus();
        }
        container.style.display = 'block';
        if (IEConsole.inputElement) IEConsole.inputElement.focus();
        IEConsole.open = true;
    },
    isOpen: function() {
        return IEConsole.open;
    },
    hide: function() {
        container.style.display = 'none';
        IEConsole.open = false;
    },
    createContainer: function() {
        container = document.createElement('div');
        //div.setAttribute('id', 'IEConsole');
        container.style.display = 'none';
        container.style.height = IEConsole.HEIGHT + 'px';
        container.style.border = "1px solid #0a0";
        //container.style.position = "fixed";
        container.style.backgroundColor = "#FFFFFF";
        container.style.left = "0";
        //container.style.marginBottom = IEConsole.HEIGHT + 'px';
        container.appendChild(IEConsole.createOutputArea());
        container.appendChild(IEConsole.createInputBar());
        return container;
    },
    createOutputArea: function() {
        var output = document.createElement('div');
        output.style.height = (IEConsole.HEIGHT - IEConsole.INPUT_HEIGHT) + "px";
        output.style.overflow = 'auto';
        output.style.textAlign = "left";
        output.style.width = '100%';
        IEConsole.outputElement = output;
        return output;
    },
    createInputBar: function() {
        var form = document.createElement('form');
        form.style.borderTop = "1px solid #aaa";
        form.style.height = IEConsole.INPUT_HEIGHT + "px";
        form.style.margin = 0;
        form.action = "javascript:;";
        form.onsubmit = IEConsole.evaluate;
        form.appendChild(IEConsole.createPromptAndInput());
        return form;
    },
    createPromptAndInput: function() {
        var container = document.createElement("div");
        container.innerHTML = "<table style=\"width: 100%\" cellspacing=\"0\" cellpadding=\"0\"><tr>" +
            "<td width=\"25\" style=\"padding-top: 10px;\">&gt;&gt;&gt;</td>" +
            "<td><input type=\"text\" /></td>" +
            "</tr></table><div style=\"height: 15px\"><a href=\"#\" onclick=\"IEConsole.hide();return false;\">hide</a></div>";
        IEConsole.inputElement = container.getElementsByTagName('input')[0];
        IEConsole.inputElement.style.width = "100%";
        IEConsole.inputElement.style.border = "0";
        IEConsole.inputElement.onkeydown = function(e) {
            if (typeof(event) != "undefined") {
                if (event.keyCode == 38) IEConsole.historyUp();
                else if (event.keyCode == 40) IEConsole.historyDown();
            }
        }
        return container;
    },
    history: [],
    historyPointer: 0,
    historyUp: function() {
        IEConsole.historyPointer--;
        if (IEConsole.historyPointer < 0) return;
        IEConsole.inputElement.value = IEConsole.history[IEConsole.historyPointer];
    },
    historyDown: function() {
        if (IEConsole.historyPointer >= IEConsole.history.length) return;
        IEConsole.historyPointer++;
        if (IEConsole.historyPointer >= IEConsole.history.length) {
            IEConsole.inputElement.value = '';
        }
        else {
            IEConsole.inputElement.value = IEConsole.history[IEConsole.historyPointer];
        }
    },
    evaluate: function() {
        IEConsole.history.push(IEConsole.inputElement.value);
        IEConsole.historyPointer = IEConsole.history.length;
        var result;
        try {
            result = eval(IEConsole.inputElement.value);
            IEConsole.log(IEConsole.formatResult(result));
        }
        catch (e) {
            IEConsole.logError(result);
        }
        IEConsole.inputElement.value = '';
    },
    formatResult: function(result) {
        var type = IEConsole.getType(result);
        try {
            // DOM Element
            if (type == 'DOMElement') {
                if (result.nodeType == Node.ELEMENT_NODE) {
                    return IEConsole.formatElement(result);
                }
                else if (result.nodeType == Node.TEXT_NODE) {
                    return "DOMText: " + IEConsole.formatResult(result.nodeValue);
                }
                else {
                    return "HTML non-element: " + result.nodeName;
                }
            }
            // DOM NodeList
            else if (type == 'DOMNodeList') {
                var out = "";
                if (result.length > 0 && result[0].nodeType == Node.ATTRIBUTE_NODE) {
                    for (var i=0; i < result.length; i++) {
                        if (i > 0) out += ', ';
                        out += result[i].nodeName + ': '
                            + IEConsole.formatResult(result[i].nodeValue);
                    }
                    return "DOMElement.attributes: [" + out + ']';
                }
                else {
                    for (var i=0; i < result.length; i++) {
                        if (i > 0) out += ', ';
                        out += IEConsole.formatResult(result[i]);
                    }
                    return "DOMNodeList: [" + out + ']';
                }
            }
            // Array
            else if (type == 'Array') {
                return "Array(length: " + result.length + ")";
            }
            else if (type == 'string') {
                return '"' + result.replace('"', '\\"')
                                   .replace("\n", '\\n')
                                   .replace("\r", '\\r')
                       + '"';
            }
            else if (type == 'function') {
                return 'function() {}';
            }
            else if (type == 'undefined') {
                return 'undefined';
            }
            else {
                return "" + result;
            }
        }
        catch (e) {
            return "Failed to format result: " + e.message;
        }
    },
    getType: function(value) {
        var self = IEConsole;
        var type = typeof value;
        try {
            if (type == "undefined") {
                return "undefined";
            }
            else if (type == 'boolean') {
                return 'boolean';
            }
            else if (type == 'number') {
                return 'number';
            }
            else if (type == 'string') {
                return 'string';
            }
            else if (type == "object") {
                // DOM Element
                if (value.nodeName) {
                    return "DOMElement";
                }
                // DOM NodeList
                else if (typeof(value.length) == 'number'
                         && typeof(value.item) != 'undefined') {
                    return "DOMNodeList";
                }
                // Array
                else if (typeof(value.push) == 'function'
                         && typeof(value.pop) == 'function'
                         && typeof(value.length) == "number") {
                    return "Array";
                }
                else {
                    return "object";
                }
            }
            else {
                return "unknown";
            }
        }
        catch (e) {
            return "unknown";
        }
    },
    formatElement: function(element) {
        var out = "&lt;" + element.tagName.toLowerCase();
        if (element.id) out += '#' + element.id;
        out += (element.childNodes.length > 0 ? "&gt;" : "/&gt;");
        return out;
    },
    escapeHTML: function(str) {
        str = str.replace("<", "&lt;");
        str = str.replace(">", "&gt;");
        return str;
    },
    log: function(msg) {
        IEConsole.logRaw(IEConsole.escapeHTML(msg));
    },
    logError: function(msg) {
        IEConsole.logRawError(IEConsole.escapeHTML(msg));
    },
    launch: function() {
        if (!IEConsole.block) {
            IEConsole.block = IEConsole.createContainer();
            document.body.insertBefore(IEConsole.block, document.body.childNodes[0]);
            //IEConsole.inputElement.focus();
        }
    },
    logRaw: function(msg) {
        msg = "<div style=\"border-bottom: 1px solid #aaa; padding-left: 5px\">" + 
            IEConsole.formatMessageText(msg) + "</div>\n";                                                                                      
        IEConsole.logLine(msg);
    },
    logRawError: function(msg) {
        msg = "<div style=\"border-bottom: 1px solid #aaa; padding-left: 5px" +
            "background-color: #ffc\"><span style=\"color: red\">" +
            IEConsole.formatMessageText(msg) + "</span></div>\n";
        IEConsole.logLine(msg);
    },
    formatMessageText: function(msg) {
        if (!msg) msg = "&nbsp;"
        return msg;
    },
    logLine: function(msg) {
        IEConsole.show();
        IEConsole.outputElement.innerHTML += msg;
        var out = IEConsole.outputElement;
        out.scrollTop = out.scrollHeight - out.clientHeight;
    }
}

if (typeof(window.Node) == 'undefined') var Node = {
    ELEMENT_NODE                :  1,
    ATTRIBUTE_NODE              :  2,
    TEXT_NODE                   :  3,
    CDATA_SECTION_NODE          :  4,
    ENTITY_REFERENCE_NODE       :  5,
    ENTITY_NODE                 :  6,
    PROCESSING_INSTRUCTION_NODE :  7,
    COMMENT_NODE                :  8,
    DOCUMENT_NODE               :  9,
    DOCUMENT_TYPE_NODE          : 10,
    DOCUMENT_FRAGMENT_NODE      : 11,
    NOTATION_NODE               : 12
}

var ieConsoleSavedOnLoad = window.onload;
window.onload = function(evt) {
    if (ieConsoleSavedOnLoad) ieConsoleSavedOnLoad(evt);
    if (typeof console == "undefined") console = {};
    if (typeof console.log == "undefined") {
        console.log = function(msg) {
            IEConsole.log(msg);
        }
    }
    var ieConsoleSavedOnKeyDown = document.onkeydown;
    document.onkeydown = function(e) {
        var e = window.event || e;
        var keyunicode = e.charCode || e.keyCode;
        // '123' is the F12 key
        if (keyunicode == 123) {
            if (IEConsole.isOpen()) {
                IEConsole.hide();
            } else {
                IEConsole.show();
            }
        } else {
            if (ieConsoleSavedOnKeyDown) {
                ieConsoleSavedOnKeyDown(e);
            }
        }
    }
}

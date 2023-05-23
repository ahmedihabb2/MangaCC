// node_modules/prismjs/plugins/show-invisibles/prism-show-invisibles.js
(function() {
  if (typeof Prism === "undefined") {
    return;
  }
  var invisibles = {
    "tab": /\t/,
    "crlf": /\r\n/,
    "lf": /\n/,
    "cr": /\r/,
    "space": / /
  };
  function handleToken(tokens, name) {
    var value = tokens[name];
    var type = Prism.util.type(value);
    switch (type) {
      case "RegExp":
        var inside = {};
        tokens[name] = {
          pattern: value,
          inside
        };
        addInvisibles(inside);
        break;
      case "Array":
        for (var i = 0, l = value.length; i < l; i++) {
          handleToken(value, i);
        }
        break;
      default:
        var inside = value.inside || (value.inside = {});
        addInvisibles(inside);
        break;
    }
  }
  function addInvisibles(grammar) {
    if (!grammar || grammar["tab"]) {
      return;
    }
    for (var name in invisibles) {
      if (invisibles.hasOwnProperty(name)) {
        grammar[name] = invisibles[name];
      }
    }
    for (var name in grammar) {
      if (grammar.hasOwnProperty(name) && !invisibles[name]) {
        if (name === "rest") {
          addInvisibles(grammar["rest"]);
        } else {
          handleToken(grammar, name);
        }
      }
    }
  }
  Prism.hooks.add("before-highlight", function(env) {
    addInvisibles(env.grammar);
  });
})();
//# sourceMappingURL=prismjs_plugins_show-invisibles_prism-show-invisibles.js.map

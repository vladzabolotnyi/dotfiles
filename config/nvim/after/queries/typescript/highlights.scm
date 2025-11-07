; extends

((variable_declarator
   name: (identifier) @hook.variable
   value: (call_expression
      function: (identifier) @_function))
   (#eq? @_function "useCallback"))

((variable_declarator
   name: (identifier) @hook.variable
   value: (call_expression
      function: (identifier) @_function))
   (#eq? @_function "useMemo"))

((call_expression
   function: (identifier) @effect.call)
 (#eq? @effect.call "useEffect"))



exception TodoConstruct of string * Parse_info.t
exception UnhandledConstruct of string * Parse_info.t

(* set to false for Sgrep, set to true for Abstract Interpreter *)
val transpile_xml: bool ref
val transpile_pattern: bool ref

val program: Cst_js.program -> Ast_js.program

val any: Cst_js.any -> Ast_js.any

(* for lang_json/ *)
val expr: Cst_js.expr -> Ast_js.expr
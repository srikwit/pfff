(* generated by ocamltarzan with: camlp4o -o /tmp/yyy.ml -I pa/ pa_type_conv.cmo pa_vof.cmo  pr_o.cmo /tmp/xxx.ml  *)

open Ast_python

let vof_tok v = Meta_parse_info.vof_info_adjustable_precision v
  
let vof_wrap _of_a (v1, v2) =
  let v1 = _of_a v1 and v2 = vof_tok v2 in Ocaml.VTuple [ v1; v2 ]

let vof_bracket of_a (_t1, x, _t2) =
  of_a x
  
let vof_name v = vof_wrap Ocaml.vof_string v
  
let vof_dotted_name v = Ocaml.vof_list vof_name v

let vof_module_name (v1, v2) = 
  let v1 = vof_dotted_name v1
  and v2 = Ocaml.vof_option (Ocaml.vof_list vof_tok) v2 in
  Ocaml.VTuple [v1; v2]

let vof_resolved_name =
  function
  | LocalVar -> Ocaml.VSum (("LocalVar", []))
  | Parameter -> Ocaml.VSum (("Parameter", []))
  | GlobalVar -> Ocaml.VSum (("GlobalVar", []))
  | ClassField -> Ocaml.VSum (("ClassField", []))
  | ImportedModule v1 ->
      let v1 = vof_dotted_name v1 in Ocaml.VSum (("ImportedModule", [ v1 ]))
  | ImportedEntity v1 ->
      let v1 = vof_dotted_name v1 in Ocaml.VSum (("ImportedEntity", [ v1 ]))
  | NotResolved -> Ocaml.VSum (("NotResolved", []))
  
let rec vof_expr =
  function
  | Num v1 -> let v1 = vof_number v1 in Ocaml.VSum (("Num", [ v1 ]))
  | Str v1 ->
      let v1 = (vof_wrap Ocaml.vof_string) v1
      in Ocaml.VSum (("Str", [ v1 ]))
  | EncodedStr ((v1, v2)) ->
      let v1 = (vof_wrap Ocaml.vof_string) v1
      and v2 = Ocaml.vof_string v2
      in Ocaml.VSum (("EncodedStr", [ v1; v2 ]))
  | InterpolatedString v1 ->
      let v1 = Ocaml.vof_list vof_expr v1 in
      Ocaml.VSum (("InterpolatedString", [v1]))
  | Bool v1 ->
      let v1 = vof_wrap Ocaml.vof_bool v1 in Ocaml.VSum (("Bool", [ v1 ]))
  | None_ v1 -> let v1 = vof_tok v1 in Ocaml.VSum (("None_", [ v1 ]))
  | Name ((v1, v2, v3)) ->
      let v1 = vof_name v1
      and v2 = vof_expr_context v2
      and v3 = Ocaml.vof_ref vof_resolved_name v3
      in Ocaml.VSum (("Name", [ v1; v2; v3 ]))
  | Tuple ((v1, v2)) ->
      let v1 = vof_list_or_comprehension vof_expr v1
      and v2 = vof_expr_context v2
      in Ocaml.VSum (("Tuple", [ v1; v2 ]))
  | List ((v1, v2)) ->
      let v1 = vof_list_or_comprehension vof_expr v1
      and v2 = vof_expr_context v2
      in Ocaml.VSum (("List", [ v1; v2 ]))
  | DictOrSet v1 ->
      let v1 = vof_list_or_comprehension2 vof_dictorset_elt v1
      in Ocaml.VSum (("DictOrSet", [ v1 ]))
  | ExprStar v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("ExprStar", [ v1 ]))
  | TypedExpr ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_type_ v2
      in Ocaml.VSum (("TypedExpr", [ v1; v2 ]))
  | Ellipsis v1 -> let v1 = vof_tok v1 in Ocaml.VSum (("Ellipsis", [ v1 ]))
  | DeepEllipsis v1 -> let v1 = vof_bracket vof_expr v1 in 
      Ocaml.VSum (("DeepEllipsis", [ v1 ]))
  | TypedMetavar ((v1, v2, v3)) ->
      let v1 = vof_name v1
      and v2 = vof_tok v2
      and v3 = vof_type_ v3
      in Ocaml.VSum (("TypedMetavar", [ v1; v2; v3 ]))
  | BoolOp ((v1, v2)) ->
      let v1 = vof_wrap vof_boolop v1
      and v2 = Ocaml.vof_list vof_expr v2
      in Ocaml.VSum (("BoolOp", [ v1; v2 ]))
  | BinOp ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_wrap vof_operator v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("BinOp", [ v1; v2; v3 ]))
  | UnaryOp ((v1, v2)) ->
      let v1 = vof_wrap vof_unaryop v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("UnaryOp", [ v1; v2 ]))
  | Compare ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_list (vof_wrap vof_cmpop) v2
      and v3 = Ocaml.vof_list vof_expr v3
      in Ocaml.VSum (("Compare", [ v1; v2; v3 ]))
  | Call ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_list vof_argument v2
      in Ocaml.VSum (("Call", [ v1; v2 ]))
  | Subscript ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_list vof_slice v2
      and v3 = vof_expr_context v3
      in Ocaml.VSum (("Subscript", [ v1; v2; v3 ]))
  | Lambda ((v1, v2)) ->
      let v1 = vof_parameters v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("Lambda", [ v1; v2 ]))
  | IfExp ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_expr v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("IfExp", [ v1; v2; v3 ]))
  | Yield ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 = Ocaml.vof_option vof_expr v1
      and v2 = Ocaml.vof_bool v2
      in Ocaml.VSum (("Yield", [ t; v1; v2 ]))
  | Await (t, v1) -> 
      let t = vof_tok t in
      let v1 = vof_expr v1 in Ocaml.VSum (("Await", [ t; v1 ]))
  | Repr (v1) -> 
      let v1 = vof_bracket vof_expr v1 in Ocaml.VSum (("Repr", [ v1 ]))
  | Attribute ((v1, t, v2, v3)) ->
      let v1 = vof_expr v1
      and t = vof_tok t
      and v2 = vof_name v2
      and v3 = vof_expr_context v3
      in Ocaml.VSum (("Attribute", [ v1; t; v2; v3 ]))
and vof_number =
  function
  | Int v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Int", [ v1 ]))
  | LongInt v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1
      in Ocaml.VSum (("LongInt", [ v1 ]))
  | Float v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Float", [ v1 ]))
  | Imag v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Imag", [ v1 ]))
and vof_boolop =
  function | And -> Ocaml.VSum (("And", [])) | Or -> Ocaml.VSum (("Or", []))
and vof_operator =
  function
  | Add -> Ocaml.VSum (("Add", []))
  | Sub -> Ocaml.VSum (("Sub", []))
  | Mult -> Ocaml.VSum (("Mult", []))
  | Div -> Ocaml.VSum (("Div", []))
  | Mod -> Ocaml.VSum (("Mod", []))
  | Pow -> Ocaml.VSum (("Pow", []))
  | MatMult -> Ocaml.VSum (("MatMult", []))
  | FloorDiv -> Ocaml.VSum (("FloorDiv", []))
  | LShift -> Ocaml.VSum (("LShift", []))
  | RShift -> Ocaml.VSum (("RShift", []))
  | BitOr -> Ocaml.VSum (("BitOr", []))
  | BitXor -> Ocaml.VSum (("BitXor", []))
  | BitAnd -> Ocaml.VSum (("BitAnd", []))
and vof_unaryop =
  function
  | Invert -> Ocaml.VSum (("Invert", []))
  | Not -> Ocaml.VSum (("Not", []))
  | UAdd -> Ocaml.VSum (("UAdd", []))
  | USub -> Ocaml.VSum (("USub", []))
and vof_cmpop =
  function
  | Eq -> Ocaml.VSum (("Eq", []))
  | NotEq -> Ocaml.VSum (("NotEq", []))
  | Lt -> Ocaml.VSum (("Lt", []))
  | LtE -> Ocaml.VSum (("LtE", []))
  | Gt -> Ocaml.VSum (("Gt", []))
  | GtE -> Ocaml.VSum (("GtE", []))
  | Is -> Ocaml.VSum (("Is", []))
  | IsNot -> Ocaml.VSum (("IsNot", []))
  | In -> Ocaml.VSum (("In", []))
  | NotIn -> Ocaml.VSum (("NotIn", []))

and vof_list_or_comprehension _of_a =
  function
  | CompList v1 ->
      let v1 = vof_bracket (Ocaml.vof_list _of_a) v1 in 
      Ocaml.VSum (("CompList", [ v1 ]))
  | CompForIf v1 ->
      let v1 = vof_comprehension _of_a v1
      in Ocaml.VSum (("CompForIf", [ v1 ]))
and vof_list_or_comprehension2 _of_a =
  function
  | CompList v1 ->
      let v1 = vof_bracket (Ocaml.vof_list _of_a) v1 in 
      Ocaml.VSum (("CompList", [ v1 ]))
  | CompForIf v1 ->
      let v1 = vof_comprehension2 _of_a v1
      in Ocaml.VSum (("CompForIf", [ v1 ]))
and vof_comprehension2 _of_a (v1, v2) =
  let v1 = _of_a v1
  and v2 = Ocaml.vof_list vof_for_if v2
  in Ocaml.VTuple [ v1; v2 ]
and vof_comprehension _of_a (v1, v2) =
  let v1 = _of_a v1
  and v2 = Ocaml.vof_list vof_for_if v2
  in Ocaml.VTuple [ v1; v2 ]
and vof_for_if =
  function
  | CompFor ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("CompFor", [ v1; v2 ]))
  | CompIf v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("CompIf", [ v1 ]))
and vof_dictorset_elt =
  function
  | KeyVal ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("KeyVal", [ v1; v2 ]))
  | Key v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("Key", [ v1 ]))
  | PowInline v1 ->
      let v1 = vof_expr v1 in Ocaml.VSum (("PowInline", [ v1 ]))
and vof_expr_context =
  function
  | Load -> Ocaml.VSum (("Load", []))
  | Store -> Ocaml.VSum (("Store", []))
  | Del -> Ocaml.VSum (("Del", []))
  | AugLoad -> Ocaml.VSum (("AugLoad", []))
  | AugStore -> Ocaml.VSum (("AugStore", []))
  | Param -> Ocaml.VSum (("Param", []))
and vof_slice =
  function
  | Slice ((v1, v2, v3)) ->
      let v1 = Ocaml.vof_option vof_expr v1
      and v2 = Ocaml.vof_option vof_expr v2
      and v3 = Ocaml.vof_option vof_expr v3
      in Ocaml.VSum (("Slice", [ v1; v2; v3 ]))
  | Index v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("Index", [ v1 ]))
and vof_parameters v = Ocaml.vof_list vof_parameter v
and vof_parameter =
  function
  | ParamSingleStar v1 -> let v1 = vof_tok v1 
    in Ocaml.VSum (("ParamSingleStar", [ v1 ]))
  | ParamEllipsis v1 -> let v1 = vof_tok v1 
    in Ocaml.VSum (("ParamEllipsis", [ v1 ]))
  | ParamClassic ((v1, v2)) ->
      let v1 =
        (match v1 with
         | (v1, v2) ->
             let v1 = vof_name v1
             and v2 = Ocaml.vof_option vof_type_ v2
             in Ocaml.VTuple [ v1; v2 ])
      and v2 = Ocaml.vof_option vof_expr v2
      in Ocaml.VSum (("ParamClassic", [ v1; v2 ]))
  | ParamStar v1 ->
      let v1 =
        (match v1 with
         | (v1, v2) ->
             let v1 = vof_name v1
             and v2 = Ocaml.vof_option vof_type_ v2
             in Ocaml.VTuple [ v1; v2 ])
      in Ocaml.VSum (("ParamStar", [ v1 ]))
  | ParamPow v1 ->
      let v1 =
        (match v1 with
         | (v1, v2) ->
             let v1 = vof_name v1
             and v2 = Ocaml.vof_option vof_type_ v2
             in Ocaml.VTuple [ v1; v2 ])
      in Ocaml.VSum (("ParamPow", [ v1 ]))
and vof_argument =
  function
  | Arg v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("Arg", [ v1 ]))
  | ArgKwd ((v1, v2)) ->
      let v1 = vof_name v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("ArgKwd", [ v1; v2 ]))
  | ArgStar v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("ArgStar", [ v1 ]))
  | ArgPow v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("ArgPow", [ v1 ]))
  | ArgComp ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_list vof_for_if v2
      in Ocaml.VSum (("ArgComp", [ v1; v2 ]))
and vof_type_ v = vof_expr v
and vof_type_parent v = vof_argument v
  
let vof_pattern v = vof_expr v
  
let rec vof_stmt =
  function
  | ExprStmt v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("ExprStmt", [ v1 ]))
  | Assign ((v1, v2, v3)) ->
      let v1 = Ocaml.vof_list vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("Assign", [ v1; v2; v3 ]))
  | AugAssign ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_wrap vof_operator v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("AugAssign", [ v1; v2; v3 ]))
  | For ((t, v1, t2, v2, v3, v4)) ->
      let t = vof_tok t in
      let v1 = vof_pattern v1 in
      let t2 = vof_tok t2
      and v2 = vof_expr v2
      and v3 = Ocaml.vof_list vof_stmt v3
      and v4 = Ocaml.vof_list vof_stmt v4
      in Ocaml.VSum (("For", [ t; v1; t2; v2; v3; v4 ]))
  | While ((t, v1, v2, v3)) ->
      let t = vof_tok t in
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_list vof_stmt v2
      and v3 = Ocaml.vof_list vof_stmt v3
      in Ocaml.VSum (("While", [ t; v1; v2; v3 ]))
  | If ((t, v1, v2, v3)) ->
      let t = vof_tok t in
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_list vof_stmt v2
      and v3 = Ocaml.vof_list vof_stmt v3
      in Ocaml.VSum (("If", [ t; v1; v2; v3 ]))
  | With ((t, v1, v2, v3)) ->
      let t = vof_tok t in
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_option vof_expr v2
      and v3 = Ocaml.vof_list vof_stmt v3
      in Ocaml.VSum (("With", [ t; v1; v2; v3 ]))
  | Return (t, v1) ->
      let t = vof_tok t in
      let v1 = Ocaml.vof_option vof_expr v1
      in Ocaml.VSum (("Return", [ t; v1 ]))
  | Break t -> 
      let t = vof_tok t in
      Ocaml.VSum (("Break", [t]))
  | Continue t -> 
      let t = vof_tok t in
      Ocaml.VSum (("Continue", [t]))
  | Pass t -> 
      let t = vof_tok t in
      Ocaml.VSum (("Pass", [t]))
  | Raise (t, v1) ->
      let t = vof_tok t in
      let v1 =
        Ocaml.vof_option
          (fun (v1, v2) ->
             let v1 = vof_expr v1
             and v2 = Ocaml.vof_option vof_expr v2
             in Ocaml.VTuple [ v1; v2 ])
          v1
      in Ocaml.VSum (("Raise", [ t; v1 ]))
  | TryExcept ((t, v1, v2, v3)) ->
      let t = vof_tok t in
      let v1 = Ocaml.vof_list vof_stmt v1
      and v2 = Ocaml.vof_list vof_excepthandler v2
      and v3 = Ocaml.vof_list vof_stmt v3
      in Ocaml.VSum (("TryExcept", [ t; v1; v2; v3 ]))
  | TryFinally ((t, v1, t2, v2)) ->
      let t = vof_tok t in
      let v1 = Ocaml.vof_list vof_stmt v1 in
      let t2 = vof_tok t2 in
      let v2 = Ocaml.vof_list vof_stmt v2 in
      Ocaml.VSum (("TryFinally", [ t; v1; t2; v2 ]))
  | Assert ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_option vof_expr v2
      in Ocaml.VSum (("Assert", [ t; v1; v2 ]))
  | Global (t, v1) ->
      let t = vof_tok t in
      let v1 = Ocaml.vof_list vof_name v1 in Ocaml.VSum (("Global", [ t; v1 ]))
  | Delete (t, v1) ->
      let t = vof_tok t in
      let v1 = Ocaml.vof_list vof_expr v1 in Ocaml.VSum (("Delete", [ t; v1 ]))
  | NonLocal (t, v1) ->
      let t = vof_tok t in
      let v1 = Ocaml.vof_list vof_name v1
      in Ocaml.VSum (("NonLocal", [ t; v1 ]))
  | Async (t, v1) -> 
      let t = vof_tok t in
      let v1 = vof_stmt v1 in Ocaml.VSum (("Async", [ t; v1 ]))
  | ImportAs (t, v1, v2) ->
      let t = vof_tok t in
      let v1 = vof_alias_dotted (v1, v2)
      in Ocaml.VSum (("ImportAs", [ t; v1 ]))
  | ImportAll (t, v1, v2) ->
      let t = vof_tok t in
      let v1 = vof_module_name v1
      and v2 = vof_tok v2
      in Ocaml.VSum (("ImportAll", [t; v1; v2]))
  | ImportFrom ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 = vof_module_name v1
      and v2 = Ocaml.vof_list vof_alias v2
      in Ocaml.VSum (("ImportFrom", [ t; v1; v2 ]))

  | FunctionDef ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_name v1
      and v2 = vof_parameters v2
      and v3 = Ocaml.vof_option vof_type_ v3
      and v4 = Ocaml.vof_list vof_stmt v4
      and v5 = Ocaml.vof_list vof_decorator v5
      in Ocaml.VSum (("FunctionDef", [ v1; v2; v3; v4; v5 ]))
  | ClassDef ((v1, v2, v3, v4)) ->
      let v1 = vof_name v1
      and v2 = Ocaml.vof_list vof_type_parent v2
      and v3 = Ocaml.vof_list vof_stmt v3
      and v4 = Ocaml.vof_list vof_decorator v4
      in Ocaml.VSum (("ClassDef", [ v1; v2; v3; v4 ]))
  | Exec ((v0, v1, v2, v3)) ->
      let v0 = vof_tok v0 in
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_option vof_expr v2
      and v3 = Ocaml.vof_option vof_expr v3
      in Ocaml.VSum (("Exec", [ v0; v1; v2; v3 ]))
 | Print ((v0, v1, v2, v3)) ->
      let v0 = vof_tok v0 in
      let v1 = Ocaml.vof_option vof_expr v1
      and v2 = Ocaml.vof_list vof_expr v2
      and v3 = Ocaml.vof_bool v3
      in Ocaml.VSum (("Print", [ v0; v1; v2; v3 ]))

and vof_excepthandler =
  function
  | ExceptHandler ((t, v1, v2, v3)) ->
      let t = vof_tok t in
      let v1 = Ocaml.vof_option vof_type_ v1
      and v2 = Ocaml.vof_option vof_name v2
      and v3 = Ocaml.vof_list vof_stmt v3
      in Ocaml.VSum (("ExceptHandler", [ t; v1; v2; v3 ]))
and vof_decorator v = vof_expr v
and vof_alias (v1, v2) =
  let v1 = vof_name v1
  and v2 = Ocaml.vof_option vof_name v2
  in Ocaml.VTuple [ v1; v2 ]
and vof_alias_dotted (v1, v2) =
  let v1 = vof_module_name v1
  and v2 = Ocaml.vof_option vof_name v2
  in Ocaml.VTuple [ v1; v2 ]
  
let vof_program v = Ocaml.vof_list vof_stmt v
  
let vof_any =
  function
  | Expr v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("Expr", [ v1 ]))
  | Stmt v1 -> let v1 = vof_stmt v1 in Ocaml.VSum (("Stmt", [ v1 ]))
  | Stmts v1 ->
      let v1 = Ocaml.vof_list vof_stmt v1 in Ocaml.VSum (("Stmts", [ v1 ]))
  | Program v1 -> let v1 = vof_program v1 in Ocaml.VSum (("Program", [ v1 ]))
  | DictElem v1 ->
      let v1 = vof_dictorset_elt v1 in Ocaml.VSum (("DictElem", [ v1 ]))
  

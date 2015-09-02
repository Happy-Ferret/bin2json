exception Escape of ((int * int) * (int * int)) * Jsonm.error

type t = 
  [ `Null | `Bool of bool | `Float of float| `String of string
  | `A of t list | `O of (string * t) list ]

let to_hex i = 
  let hex = Printf.sprintf "0x%x" i in
  `String hex

let to_number i = `Float (float_of_int i)

let to_byte_array l = `A (List.map to_number l)

let add_key key value o :t =
  match o with
  | `O os ->
    `O ((key,value)::os)
  | _ ->
    invalid_arg "Cannot add key to non Object"

(* from JS Number.MAX_SAFE_INTEGER *)
let kMAX_SAFE_INTEGER = 9007199254740991

let print ~minify json =
  let enc e l = ignore (Jsonm.encode e (`Lexeme l)) in
  let rec value v k e = match v with 
  | `A vs -> arr vs k e 
  | `O ms -> obj ms k e 
  | `Null | `Bool _ | `Float _ | `String _ as v -> enc e v; k e
  and arr vs k e = enc e `As; arr_vs vs k e
  and arr_vs vs k e = match vs with 
  | v :: vs' -> value v (arr_vs vs' k) e 
  | [] -> enc e `Ae; k e
  and obj ms k e = enc e `Os; obj_ms ms k e
  and obj_ms ms k e = match ms with 
  | (n, v) :: ms -> enc e (`Name n); value v (obj_ms ms k) e
  | [] -> enc e `Oe; k e
  in
  let e = Jsonm.encoder ~minify (`Channel stdout) in
  let finish e = ignore (Jsonm.encode e `End) ; print_newline () in
  match json with `A _ | `O _ as json -> value json finish e
  | _ -> invalid_arg "invalid json text"

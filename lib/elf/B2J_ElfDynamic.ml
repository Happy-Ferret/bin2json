open Elf.Dynamic
open B2J_ElfSymbolTable
open B2J_Json

let dyn2json dyn = 
  `O [
    "d_tag" , (to_hex @@ from_tag dyn.d_tag);
    "d_un", (to_hex dyn.d_un);
    "name", `String (tag_to_string dyn.d_tag);
  ]

let dynamic_symbols2json syms = 
  let json = List.map sym2json syms in
  let meta = 
    [
      "bytes", to_byte_array [4; 1; 1; 2; 8; 8;];
      "prefix", `String "st_";
    ] in
  `O [
    "value",`A json;
    "meta", `O meta;
  ]

let to_json dyns = 
  let json = List.map dyn2json dyns in
  let meta = 
    [
      "bytes", to_byte_array [8; 8];
      "prefix", `String "d_";
    ] in
  `O [
    "value",`A json;
    "meta", `O meta;
  ]


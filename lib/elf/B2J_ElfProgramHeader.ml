open Elf.ProgramHeader
open B2J_Json

let program_header2json ph =
  `O [
    "p_type" , to_hex ph.p_type;
    "p_flags", to_hex ph.p_flags;
    "p_offset", to_hex ph.p_offset;
    "p_vaddr", to_hex ph.p_vaddr;
    "p_paddr", to_hex ph.p_paddr;
    "p_filesz", to_hex ph.p_filesz;
    "p_memsz", to_hex ph.p_memsz;
    "p_align", to_hex ph.p_align;
    "type", `String (ptype_to_string ph.p_type);
    "flags", `String (flags_to_string ph.p_flags);
  ]

let to_json phs = 
  let json = List.map program_header2json phs in
  let meta = 
    [   
      "bytes", to_byte_array [4; 4; 8; 8; 8; 8; 8; 8;];
      "prefix", `String "p_";
    ] in
  `O [
    "value",`A json;
    "meta", `O meta;
  ]


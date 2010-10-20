{
(* Yoann Padioleau
 *
 * Copyright (C) 2010 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)

open Common 

open Archi_code

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)

(* This code assumes we are called with a string enclosed by "/"
 * as in /foo.php/ so it's easy to specify the beginning or
 * end of a string (ocamllex does not handle ^ or $).
 * 
 * It also assumes the string has been lowercased. Note also that
 * the filenames has been reversed, for instance a/b/foo.php become
 * /foo.php/b/a/ because we want to return the most specialized category.
 * 
 * Note that ocamllex will try the longest match and we will return
 * the leftmost match so on "common.mli" for instance the
 * "common" rule will be applied before the .mli rule.
 *)

}

(*****************************************************************************)

rule category = parse
  | ".vcproj/" { Building }
  | ".thrift/" { Ffi }

  (* pad specific, noweb *)
  | ".nw/" 
      { Doc }

  | ".texi/" 
      { Doc }

  | ".pdf/" 
  | ".rtf/"
      { Doc }

  | ".sql/"
      { Storage }

  | ".mli/"
  | ".h/"
      { Interface }

  (* ml specific ? *)
  | ".depend" { Building }
  | "ocamlmakefile" { BoilerPlate }

  | "makefile" 
  | "/configure" 
      { Building }

  (* linux specific ? *)
  | "kconfig" { Building }

  | "/changes" 
      { Doc }

  | "/license" 
  | "/copyright" 
      { BoilerPlate }

  (* gnu software boilerplate *)
  | "/copying/" 
  | "/about-nls/" 
  | "/shtool/"
  | "/texinfo.tex/"
  | "/ltmain.sh/"
      { BoilerPlate }



  (* pad specific ? *)
  | "/main_" { Main }
  | "flag_" { Configuration }
  | "test_" { Test }


  | "/main." { Main }
  | "/init." { Init }

  (* facebook specific *)
  | "/home.php" { Main }
  | "/profile.php" { Main }


  | "core" { Core }
(*  | "/base" { Core } *)

  | "mysql" 
  | "sqlite" 
      { Storage }

  | "database" { Storage }

  | "security" { Security }

  | "lite" { MiniLite }
(* too many false positives, like mini in mono
   | "mini" { MiniLite } 
*)

  | "/tests/" 
  | "/test/" 
  | "/t/" 
  | "/testsuite/" 
      { Test }

  (* facebook specific a little *)
  | "/__tests__/" { Test }

  (* pad specific *)
  | "pleac" { Test }

  | "/docs/"
  | "/doc/" 
      { Doc }

  | "unittest" { Unittester }
  (* can not just say "profil" because at facebook profile means
   * something else
   *)
  | "profiling" { Profiler }

  | "stdlib" { Core }
  | "util" { Utils }
(*  | "/base" { Utils } *)
  | "common" { Utils }
  (* Exact "lib", Utils; *)

  (* Can not say just thrift here because we could also want
   * to look at the thrift source itself. So really just
   * want to hide all generated code.
   * 
   * The code is actually in thrift/packages but because the filename
   * is reverse, it's /packages/thrift/ here
   *)
 | "/packages/thrift/" { AutoGenerated }

 | "/thriftdoc/" { AutoGenerated }

  (* thrift auto generated files *)
 | "/gen-" { AutoGenerated }
  (* for some projects I don't remember *)
 | "/gen/" { AutoGenerated }


  | "storage" 
  | "/db/"
  | "/fs/"
  | "/database/"

  (* pad specific ... *)
  | "bdb/"
      { Storage }

  (* Exact "data", Storage; *)
  | "constants" { Constants }
  | "mutators"
  | "accessors"
      { GetSet }

  | "logging" { Logging }

  | "third-party"
  | "third_party" 
      { ThirdParty }

  | "external" { ThirdParty }
  | "legacy" { ThirdParty }
  | "deprecated" { Legacy }

  (* pad specfic *)
  | "ocamlextra" { ThirdParty }
  | "/score_parsing" { Data }
  | "/score_tests" { Data }


(* in haskell this is a valid dir
   | "/data/" { Data } 
*)

  (* facebook specific ? *)
  | "/si/"
  | "site_integrity" 
      { Security }

  (* as in OCaml asmcomp/ directory *)
  | "x86"
  | "i386"
  | "i686"
  | "/386/"
  | "ia64"
  | "mips"
  | "m68k"
  | "sparc"
  | "amd64"
  | "/arm/"
  | "hppa"
  (* linux source *)
  | "parisc"
  | "s390"
  | "blackfin"
  | "/ppc/"
  | "ppc64"
  | "/power/"
  | "/powerpc/"
  | "/alpha/" 
  (* gcc source *)
  | "rs6000"
  | "h8300"
  | "/vax/"
  | "sh64"
  | "/cris/"
  | "/frv/"
      { Architecture }

  (* plan9 source *)
  | "/pc/" 
  | "/alphapc/" 
      { Architecture }

  | "/arch/" 
      { Architecture }

  | "win32"
  | "macos"
  | "unix"
  | "linux"

  | "msdos"
  | "/vms"
  | "minix"
  | "/dos/"
  | "mswin"
      { OS }

  | "dns" 
  | "ftp"
  | "ssh" 
  | "http" 
  | "smtp" 
  | "ldap" 
  | "/imap"  (* / because can have files like guimap *)
  | "krb4" 
  | "pop3" 
  | "socks" 
  | "ssl" 
  | "socket" 
  | "mime" 
  | "url." 
  | "uri." 
  | "ipv4"
  | "ipv6"
  | "icmp."
  | "tcp."
      { Network }

  (* scan and gram ? too short ? *)
  | "scanne"
  | "parse"
  | "lexer"
  | "token" (* false positive with security stuff ? *)
  | "/gram."
  | "/scan."
  | "grammar"

  (* invent UnParsing category ? do also print ? *)
  | "pretty_print"
      { Parsing }

  | "/ui/"
  | "/gui/" 
  | "display"
  | "render"
  | "/video/"
  | "/media/"
  | "screen"
  | "visual"
  | "image"
  | "jpeg"
  | "/ui."
  | "window"
      { Ui }

  | "/gtk/"
  | "/qt/"
  | "/tcltk/"
  | "x11"
  | "/wx"
      { Ui }

  | "/intern/" { Intern }
  (* as in Linux *)
  | "documentation" { Doc }
  (* todo also  memory ?  so mm/ is colored too  *)
  | "/net/" { Network }

  | "/old/"
  | "/backup/"
      { Legacy }

  | "/tmp/"
      { Legacy }

  (* i18n *)

  | "/af/"
  | "/ar/"
  | "/az/"
  | "/bg/"
  | "/ca/"
  | "/ca-valencia/"
  | "/cs/"
  | "/da/"
  | "/de/"
  | "/de-informal/"
  | "/el/"
  (* I keep this one so at least I can see one | "/en/" *)
  | "/eo/"
  | "/es/"
  | "/et/"
  | "/eu/"
  | "/fa/"
  | "/fi/"
  | "/fo/"
  | "/fr/"
  | "/gl/"
  | "/he/"
  | "/hi/"
  | "/hr/"
  | "/hu/"
  | "/ia/"
  | "/id/"
  | "/id-ni/"
  | "/is/"
  | "/it/"
  | "/ja/"
  | "/km/"
  | "/ko/"
  | "/ku/"
  | "/lb/"
  | "/lt/"
  | "/lv/"
  | "/mg/"
  | "/mk/"
  | "/mr/"
  | "/ne/"
  | "/nl/"
  | "/no/"
  | "/pl/"
  | "/pt/"
  | "/pt-br/"
  | "/ro/"
  | "/ru/"
  | "/sk/"
  | "/sl/"
  | "/sq/"
  | "/sr/"
  | "/sv/"
  | "/th/"
  | "/tr/"
  | "/uk/"
  | "/vi/"
  | "/zh/"
  | "/zh-tw/"
      { I18n }

  | "i18n" 
  | "unicode"
  | "gettext"
  | "/intl/"
      { I18n }
      

  | _ { 
      category lexbuf
    }
  | eof { Regular }

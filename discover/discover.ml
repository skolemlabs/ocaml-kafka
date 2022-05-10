module C = Configurator.V1

let join x y =
  C.Pkg_config.{
    libs = x.libs @ y.libs;
    cflags = x.cflags @ y.cflags;
  }

let () = C.main ~name:"kafka" (fun c ->
  let default : C.Pkg_config.package_conf = {
          libs = [ "-I/usr/local/include" ];
          cflags = [ "-L/usr/local/lib"; "-lrdkafka"; "-lpthread"; "-lz" ]
  } in
  let conf = 
    match C.Pkg_config.get c with
    | None -> default
    | Some pc -> (
      match (C.Pkg_config.query pc ~package:"rdkafka") with
        | None -> default
        | Some deps -> join default deps
    )
  in
  C.Flags.write_sexp "c_flags.sexp" conf.cflags;
  C.Flags.write_sexp "c_library_flags.sexp" conf.libs
)

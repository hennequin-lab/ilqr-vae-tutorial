open Owl
open Ilqr_vae
open Base
open Gp

(* animation example *)
let plot_us ?(range = 0.1) u i (module P : Plot) =
  let it_title = Printf.sprintf "Iteration %i" i in
  let u = AD.unpack_arr u |> fun z -> Arr.reshape z [| -1; 15 |] in
  P.plots
    (List.init 10 ~f:(fun i ->
         let st = Printf.sprintf "l lw 2 lc %i" i in
         item (A (Arr.get_slice [ []; [ i ] ] u)) ~using:"(($0)*5):1" ~style:st))
    (default_props
    @ [ xlabel "time [ms]"; ylabel "inputs"; title it_title; yrange (-.range, range) ]
    @ [ set
          "object rect from 0, graph 0 to first 30, graph 1 fc lt 2 fs transparent solid \
           0.5 front"
      ])

let print_msg ?ph s =
  Jupyter_notebook.printf "%s%!" s;
  Jupyter_notebook.display_formatter ?display_id:ph "text/html" |> ignore


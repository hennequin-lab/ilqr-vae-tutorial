open Owl
open Ilqr_vae
open Owl_parameters
open Base
open Vae
open Gp
open Juplot

(* animation example *)
let plot_us_init all_us i (module P : Plot) =
  let it_title = Printf.sprintf "Iteration %i" i in
  let u = List.nth_exn all_us i in 
  let u =
    AD.unpack_arr u
    |> fun z -> Arr.reshape z [| -1; 15 |]
  in
P.plots
      (List.init 10 (fun i ->
           let st = Printf.sprintf "l lw 2 lc %i" i in
           item (A (Arr.get_slice [ []; [ i ] ] u)) ~style:st))
      (default_props @ [ xlabel "time /ms"; ylabel "" ; title it_title; yrange (-0.03,0.03)] @[ set "object rect from 0,-0.05 to 3,0.05 fc lt 2 fs transparent solid 0.5 front" ])

let plot_us_fin all_us i (module P : Plot) =
  let it_title = Printf.sprintf "Iteration %i" i in
  let u = List.nth_exn all_us i in 
  let u =
    AD.unpack_arr u
    |> fun z -> Arr.reshape z [| -1; 15 |]
  in
P.plots
      (List.init 10 (fun i ->
           let st = Printf.sprintf "l lw 2 lc %i" i in
           item (A (Arr.get_slice [ []; [ i ] ] u)) ~style:st))
      (default_props @ [ xlabel "time /ms"; ylabel "" ; title it_title; yrange (-0.1,0.1)] @[ set "object rect from 0,-0.1 to 3,0.1 fc lt 2 fs transparent solid 0.5 front" ])



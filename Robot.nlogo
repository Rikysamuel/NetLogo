extensions [ array ]

breed [ robots robot ]
breed [ robots2 robotB ]
breed [ robots3 robotC ]
breed [ robots4 robotD ]

globals [
  list-goal
  goal_x
  goal_y
  draw?
  num-of-parts
  map-mx
  is-computed?
  is-init?
]

turtles-own [
  x y finish dist
]

;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup Procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;
to Initiate
  clear-all
  set-default-shape turtles "square"
  set draw? false
  set num-of-parts 4
  set is-computed? false
  set is-init? false
  set list-goal []

  ;; draw the board
  ask patches
  [ if (pxcor = min-pxcor) or (pxcor > 21) or (pycor = min-pycor) or (pycor = max-pycor)
    [ set pcolor gray ]
  ]

  reset-ticks
end

;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Interface Buttons ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;
to rotate-right [n] ;; n indicates which robot (1,2,3,4)
  if rotate-right-clear? n
    [ ask robots [ rotate-me-right ] ]
end

to rotate-me-right  ;; Piece Procedure
  let oldx x
  let oldy y
  set x oldy
  set y (- oldx)
  set xcor ([xcor] of turtle 0) + x
  set ycor ([ycor] of turtle 0) + y
end

to rotate-left [n] ;; n indicates which robot (1,2,3,4)
  if rotate-left-clear? n
    [ ask robots [ rotate-me-left ] ]
end

to rotate-me-left  ;; Piece Procedure
  let oldx x
  let oldy y
  set x (- oldy)
  set y oldx
  set xcor ([xcor] of turtle 0) + x
  set ycor ([ycor] of turtle 0) + y
end

to-report shift-right-clear? [n]
  report clear-at? n 1 0
end

to shift-right [n]
  if shift-right-clear? n
  [
    if n = 1 [ ask robots [ set xcor xcor + 1 ] ]
    if n = 2 [ ask robots2 [ set xcor xcor + 1 ] ]
    if n = 3 [ ask robots3 [ set xcor xcor + 1 ] ]
    if n = 4 [ ask robots4 [ set xcor xcor + 1 ] ]
  ]

end

to-report shift-left-clear? [n]
  report clear-at? n -1 0
end

to shift-left [n]
  if shift-left-clear? n [
    if (n = 1) [ ask robots [ set xcor xcor - 1 ] ]
    if (n = 2) [ ask robots2 [ set xcor xcor - 1 ] ]
    if (n = 3) [ ask robots3 [ set xcor xcor - 1 ] ]
    if (n = 4) [ ask robots4 [ set xcor xcor - 1 ] ]
  ]
end

to-report shift-down-clear? [n]
  report clear-at? n 0 -1
end

to shift-down [n]
  if shift-down-clear? n [
    if (n = 1) [ ask robots [ set ycor ycor - 1 ] ]
    if (n = 2) [ ask robots2 [ set ycor ycor - 1 ] ]
    if (n = 3) [ ask robots3 [ set ycor ycor - 1 ] ]
    if (n = 4) [ ask robots4 [ set ycor ycor - 1 ] ]
  ]
end

to-report shift-up-clear? [n]
  report clear-at? n 0 1
end

to shift-up [n]
  if shift-up-clear? n [
    if (n = 1) [ ask robots [ set ycor ycor + 1 ] ]
    if (n = 2) [ ask robots2 [ set ycor ycor + 1 ] ]
    if (n = 3) [ ask robots3 [ set ycor ycor + 1 ] ]
    if (n = 4) [ ask robots4 [ set ycor ycor + 1 ] ]
  ]
end

to-report shift-upright-clear? [n]
  report (clear-at? n 1 1)
  ;(clear-at? n 0 1) and (clear-at? n 1 0) and
end

to shift-upright [n]
  if shift-upright-clear? n [
    if (n = 1) [ ask robots [ set ycor ycor + 1  set xcor xcor + 1 ] ]
    if (n = 2) [ ask robots2 [ set ycor ycor + 1  set xcor xcor + 1 ] ]
    if (n = 3) [ ask robots3 [ set ycor ycor + 1 set xcor xcor + 1 ] ]
    if (n = 4) [ ask robots4 [ set ycor ycor + 1 set xcor xcor + 1 ] ]
  ]
end

to-report shift-upleft-clear? [n]
  report (clear-at? n -1 1)
  ;(clear-at? n 0 1) and (clear-at? n -1 0)
end

to shift-upleft [n]
  if shift-upleft-clear? n [
    if (n = 1) [ ask robots [ set ycor ycor + 1  set xcor xcor - 1 ] ]
    if (n = 2) [ ask robots2 [ set ycor ycor + 1  set xcor xcor - 1 ] ]
    if (n = 3) [ ask robots3 [ set ycor ycor + 1 set xcor xcor - 1 ] ]
    if (n = 4) [ ask robots4 [ set ycor ycor + 1 set xcor xcor - 1 ] ]
  ]
end

to-report shift-downright-clear? [n]
  report (clear-at? n 1 -1)
  ;(clear-at? n 0 -1) and (clear-at? n 1 0) and
end

to shift-downright [n]
  if shift-downright-clear? n [
  if (n = 1) [ ask robots [ set ycor ycor - 1  set xcor xcor + 1 ] ]
  if (n = 2) [ ask robots2 [ set ycor ycor - 1  set xcor xcor + 1 ] ]
  if (n = 3) [ ask robots3 [ set ycor ycor - 1 set xcor xcor + 1 ] ]
  if (n = 4) [ ask robots4 [ set ycor ycor - 1 set xcor xcor + 1 ] ]
  ]
end

to-report shift-downleft-clear? [n]
  report (clear-at? n -1 -1)
  ;(clear-at? n 0 -1) and (clear-at? n -1 0) and
end

to shift-downleft [n]
  if shift-downleft-clear? n [
    if (n = 1) [ ask robots [ set ycor ycor - 1  set xcor xcor - 1 ] ]
    if (n = 2) [ ask robots2 [ set ycor ycor - 1  set xcor xcor - 1 ] ]
    if (n = 3) [ ask robots3 [ set ycor ycor - 1 set xcor xcor - 1 ] ]
    if (n = 4) [ ask robots4 [ set ycor ycor - 1 set xcor xcor - 1 ] ]
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Runtime Procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
to draw
  if mouse-down?
    [
      ask patch mouse-xcor mouse-ycor [set pcolor white]
      ;ask patches
      ;matrix:set map-mx (center-to-edge-y mouse-ycor) (center-to-edge-x mouse-xcor) 999
    ]
  display
end

to delete
  if mouse-down?
    [ask patch mouse-xcor mouse-ycor [set pcolor black]]
  display
end

to draw-goal
  if mouse-down?
    [ ask patch mouse-xcor mouse-ycor [set pcolor red] display ]
end

to go
  set-obstacle-and-goal
  create-virtual-obs
  do-flood-fill
  ask turtles [ find-goal ]
  display
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;          Reporters           ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to-report clear? [p n]  ;; p is a patch, n indicates which robot (1,2,3,4)
  if p = nobody [ report false ]

  ifelse (n = 1) and ( [ pcolor ] of p = black or is-finish? p) [      ; -------------------------- robot 1
    ifelse (is-robot-finish? 2) [
      ifelse (is-robot-finish? 4)
        [ report (not any? robots3-on p) ]
        [
          ifelse (is-robot-finish? 3)
          [ report (not any? robots4-on p) ]
          [ report (not any? robots3-on p) and (not any? robots4-on p) ]
        ]
    ] [
      ifelse (is-robot-finish? 3) [
        ifelse (is-robot-finish? 4)
        [ report (not any? robots2-on p) ]
        [ report (not any? robots2-on p) and (not any? robots4-on p) ]
      ] [
      ifelse (is-robot-finish? 4) [
        report (not any? robots2-on p) and (not any? robots3-on p)
      ] [
          report (not any? robots2-on p) and (not any? robots3-on p) and (not any? robots4-on p)
      ]
    ]
   ]

   ] [
    ifelse (n = 2) and ( [ pcolor ] of p = black or is-finish? p) [      ; -------------------------- robot 2
      ifelse (is-robot-finish? 1) [
        ifelse (is-robot-finish? 3)
        [ report (not any? robots4-on p) ]
        [
          ifelse (is-robot-finish? 4)
          [ report (not any? robots3-on p) ]
          [ report (not any? robots3-on p) and (not any? robots4-on p) ]
        ]

      ] [
        ifelse (is-robot-finish? 3) [
          ifelse (is-robot-finish? 4)
          [ report (not any? robots-on p) ]
          [ report (not any? robots-on p) and (not any? robots4-on p) ]
        ] [
          ifelse (is-robot-finish? 4) [
            report (not any? robots-on p) and (not any? robots3-on p)
          ] [
             report (not any? robots-on p) and (not any? robots3-on p) and (not any? robots4-on p)
          ]
              ]
            ]
          ]
     [
       ifelse (n = 3) and ( [ pcolor ] of p = black or is-finish? p) [      ; -------------------------- robot 3
        ifelse (is-robot-finish? 1) [
          ifelse (is-robot-finish? 2)
          [ report (not any? robots4-on p) ]
          [
             ifelse (is-robot-finish? 4)
             [ report (not any? robots2-on p) ]
             [ report (not any? robots2-on p) and (not any? robots4-on p) ]
          ]
        ] [
          ifelse (is-robot-finish? 2) [
            ifelse (is-robot-finish? 4)
            [ report (not any? robots-on p) ]
            [ report (not any? robots-on p) and (not any? robots4-on p) ]
          ] [
            ifelse (is-robot-finish? 4) [
              report (not any? robots-on p) and (not any? robots2-on p)
            ] [
                    report (not any? robots-on p) and (not any? robots2-on p) and (not any? robots4-on p)
                  ]
                ]
              ]
            ]
     [
       ifelse (n = 4) and ( [ pcolor ] of p = black or is-finish? p) [      ; -------------------------- robot 4
        ifelse (is-robot-finish? 1) [
          ifelse (is-robot-finish? 2)
          [ report (not any? robots3-on p) ]
          [
             ifelse (is-robot-finish? 3)
             [ report (not any? robots2-on p) ]
             [ report (not any? robots2-on p) and (not any? robots3-on p) ]
          ]
        ] [
          ifelse (is-robot-finish? 2) [
            ifelse (is-robot-finish? 3)
            [ report (not any? robots-on p) ]
            [ report (not any? robots-on p) and (not any? robots3-on p) ]
          ] [
            ifelse (is-robot-finish? 3) [
              report (not any? robots-on p) and (not any? robots2-on p)
            ] [
                    report (not any? robots-on p) and (not any? robots2-on p) and (not any? robots3-on p)
                  ]
                ]
              ]
            ] [
              report ([pcolor] of p = black) or ([pcolor] of p = red)  and (not any? robots-on p) and (not any? robots2-on p) and (not any? robots3-on p) and (not any? robots4-on p)
           ]
     ]
    ]
  ]
end

to-report is-finish? [p]
  report ([pcolor] of p = red)
end

to-report clear-at? [n xoff yoff]
  if n = 1 [report all? robots [clear? patch-at xoff yoff n]]
  if n = 2 [report all? robots2 [clear? patch-at xoff yoff n]]
  if n = 3 [report all? robots3 [clear? patch-at xoff yoff n]]
  if n = 4 [report all? robots4 [clear? patch-at xoff yoff n]]
end

to-report rotate-left-clear? [n] ;; n indicates which robot (1,2,3,4)
  report all? robots [clear? patch-at (- y) x n]
end

to-report rotate-right-clear? [n] ;; n indicates which robot (1,2,3,4)
  report all? robots [clear? patch-at y (- x) n]
end

to-report random-pos-x
  report (random ((max-pxcor - 3) - (min-pxcor + 4)) + (min-pxcor + 3))
end

to-report random-pos-y
  report (random ((max-pycor - 3) - (min-pycor + 3)) + (min-pycor + 3))
end

to-report center-to-edge-x [val]
  report (val + max-pxcor - 1)
end

to-report center-to-edge-y [val]
  report (max-pycor - val - 1)
end

to-report get-neighbor [p d] ;; p for patch, d for direction
  let px [pxcor] of p
  let py [pycor] of p

  if (d = 0) [ report (patch (px - 1) (py + 1) ) ] ; north-west
  if (d = 1) [ report (patch px (py + 1) ) ]       ; north
  if (d = 2) [ report (patch (px + 1) (py + 1) ) ] ; north-east
  if (d = 3) [ report (patch (px + 1) py ) ]       ; east
  if (d = 4) [ report (patch (px + 1) (py - 1)) ]  ; south-east
  if (d = 5) [ report (patch (px) (py - 1)) ]      ; south
  if (d = 6) [ report (patch (px - 1) (py - 1)) ]  ; south-west
  if (d = 7) [ report (patch (px - 1) (py)) ]      ; west
end

to-report is-clear? [p]
  let str [ plabel ] of p
  ;ifelse ( str = "" ) and ( [ pcolor ] of p != gray ) and ( [ pcolor ] of p != white )
  ifelse ( str = "" ) and ( [ plabel ] of p != 999 )
    [ report true ] [ report false ]
end

to-report is-move-clear? [p]
  let str [ plabel ] of p
  ifelse ( [ pcolor ] of p != gray ) and ( [ pcolor ] of p != white )
    [ report true ] [ report false ]
end

to-report is-ok-place? [a b]
  ifelse (not any? turtles-on patch a b) and (not any? turtles-on patch (a + 1) b) and (not any? turtles-on patch (a - 1) b) and (not any? turtles-on patch (a - 1) (b - 1)) and ( [ pcolor ] of patch a b != grey )
    [ report true ] [ report false ]
end

to-report is-robot-finish? [n] ; n indicates which robot (1,2,3 4)
  if (n = 1) [ report member? 15 [ pcolor ] of robots ]
  if (n = 2) [ report member? 15 [ pcolor ] of robots2 ]
  if (n = 3) [ report member? 15 [ pcolor ] of robots3 ]
  if (n = 4) [ report member? 15 [ pcolor ] of robots4 ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;
;;; robots Procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

to setup-robot
  create-robots num-of-parts
  let pos-x random-pos-x
  let pos-y random-pos-y
  ask robot 0 [ setxy pos-x pos-y]
  let robot-color 0 ;+ random 2
  ask robots [ setup-part 1 robot-color ]

  create-robots2 num-of-parts
  set pos-x random-pos-x
  set pos-y random-pos-y
  ask patches [
    while [not is-ok-place? pos-x pos-y]
      [ set pos-x random-pos-x
        set pos-y random-pos-y]
  ]
  ask robotB 4 [ setxy pos-x pos-y ]
  set robot-color 2 ;+ random 2
  ask robots2 [ setup-part 2 robot-color ]

  create-robots3 num-of-parts
  set pos-x random-pos-x
  set pos-y random-pos-y
  ask patches [
    while [not is-ok-place? pos-x pos-y]
      [ set pos-x random-pos-x
        set pos-y random-pos-y]
  ]
  ask robotC 8 [ setxy pos-x pos-y ]
  set robot-color 4 ;+ random 2
  ask robots3 [ setup-part 3 robot-color ]

  create-robots4 num-of-parts
  set pos-x random-pos-x
  set pos-y random-pos-y
  ask patches [
    while [not is-ok-place? pos-x pos-y]
      [ set pos-x random-pos-x
        set pos-y random-pos-y]
  ]
  ask robotD 12 [ setxy pos-x pos-y ]
  set robot-color 6 ;+ random 2
  ask robots4 [ setup-part 4 robot-color ]
end

to setup-part [n s]  ; n indicates which robot (1,2,3 4), s is a shape
  if (s = 0) [ setup-l n set color blue   ]
  if (s = 1) [ setup-l n set color red    ]
  if (s = 2) [ setup-l n set color yellow ]
  if (s = 3) [ setup-l n set color green  ]
  if (s = 4) [ setup-l n set color orange ]
  if (s = 5) [ setup-l n set color brown    ]
  if (s = 6) [ setup-l n set color violet ]
  if (s = 7) [ setup-l n set color magenta ]

  if (n = 1) [ setxy [xcor] of robot 0 + x [ycor] of robot 0 + y ]
  if (n = 2) [ setxy [xcor] of robotB 4 + x [ycor] of robotB 4 + y ]
  if (n = 3) [ setxy [xcor] of robotC 8 + x [ycor] of robotC 8 + y ]
  if (n = 4) [ setxy [xcor] of robotD 12 + x [ycor] of robotD 12 + y ]
end

to find-goal
  if (not is-robot-finish? 1) [
    move 1
  ]

  if (not is-robot-finish? 2) [
    move 2
  ]

  if (not is-robot-finish? 3) [
    move 3
  ]

  if (not is-robot-finish? 4) [
    move 4
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; robots Setup Procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The numbers 0123 show the relative positions of turtles
;; 0, 1, 2, and 3 within the overall shape.

;; L-Block
;; 201
;; 3
to setup-l [n]  ;;Piece Procedure, n inidicates which robots (1, 2, 3, 4)
  if (who = 0 + (n * num-of-parts - num-of-parts)) [ set finish false ]
  if (who = 1 + (n * num-of-parts - num-of-parts)) [ set x  1 set y  0 set finish false ]
  if (who = 2 + (n * num-of-parts - num-of-parts)) [ set x -1 set y  0 set finish false ]
  if (who = 3 + (n * num-of-parts - num-of-parts)) [ set x -1 set y -1 set finish false ]
end

to do-flood-fill
  if (not is-computed?) [
    while [not empty? list-goal] [
      add-possible-neighbor
    ]

    ask turtle 0 [ set dist [plabel] of patch-here]
    ask turtle 4 [ set dist [plabel] of patch-here]
    ask turtle 8 [ set dist [plabel] of patch-here]
    ask turtle 12 [ set dist [plabel] of patch-here]

    set is-computed? true
;    output-print "Total distance :"
;    ask turtle 0 [ output-print dist]
;    ask turtle 4 [ output-print dist]
;    ask turtle 8 [ output-print dist]
;    ask turtle 12 [ output-print dist]
  ]
end

to add-possible-neighbor
  let f-elem ( first list-goal )
  let i 0
  let tmp-elem 0

  while [ i < 8 ] [
    set tmp-elem ( get-neighbor f-elem i )
    if (is-clear? (tmp-elem)) [
      set list-goal lput tmp-elem list-goal ; add neighbor element

      ask tmp-elem [
        set plabel ( [plabel] of f-elem) + 1
        set plabel-color white
      ]
    ]
    set i ( i + 1 )
  ]

  set list-goal remove f-elem list-goal


end

to set-obstacle-and-goal
  if (is-init? = false) [
    let set-goal (patches with [pcolor = red])
    let set-obs (patches with [pcolor = white])
    let set-border (patches with [pcolor = gray])

    ask set-obs [
      set plabel 999
      set plabel-color red
    ]

    ask set-border [
      set plabel 999
      set plabel-color red
    ]

    ask set-goal [
      set list-goal lput self list-goal
      set plabel 0
      set plabel-color white
    ]

    set is-init? true
  ]
end

to set-robot-finish [n] ; n indicates which robot (1, 2, 3,4)
  if (who = 0 + (n * num-of-parts - num-of-parts)) [ set finish true ]
  if (who = 1 + (n * num-of-parts - num-of-parts)) [ set finish true ]
  if (who = 2 + (n * num-of-parts - num-of-parts)) [ set finish true ]
  if (who = 3 + (n * num-of-parts - num-of-parts)) [ set finish true ]
end

to move [n] ; n indicates which robot (1 2 3 4)
  let cur-plabel [ plabel ] of turtle ((n - 1) * 4)
  let cur-x [ xcor ] of turtle ((n - 1) * 4)
  let cur-y [ ycor ] of turtle ((n - 1) * 4)
  let is-moved? false

  if ((shift-upleft-clear? n) and (([plabel] of patch (cur-x - 1) (cur-y + 1)) = (cur-plabel - 1)) and is-move-clear? patch (cur-x - 1) (cur-y + 1) and not is-moved?) [
    shift-upleft n
    set is-moved? true
  ]
  if shift-up-clear? n and (([plabel] of patch (cur-x) (cur-y + 1)) = (cur-plabel - 1)) and is-move-clear? patch (cur-x) (cur-y + 1) and not is-moved? [
    shift-up n
    set is-moved? true
  ]
  if shift-upright-clear? n and (([plabel] of patch (cur-x + 1) (cur-y + 1)) = (cur-plabel - 1)) and is-move-clear? patch (cur-x + 1) (cur-y + 1) and not is-moved? [
    shift-upright n
    set is-moved? true
  ]
  if shift-right-clear? n and (([plabel] of patch (cur-x + 1) (cur-y)) = (cur-plabel - 1)) and is-move-clear? patch (cur-x + 1) (cur-y) and not is-moved? [
    shift-right n
    set is-moved? true
  ]
  if shift-downright-clear? n and (([plabel] of patch (cur-x + 1) (cur-y - 1)) = (cur-plabel - 1)) and is-move-clear? patch (cur-x + 1) (cur-y - 1) and not is-moved? [
    shift-downright n
    set is-moved? true
  ]
  if shift-down-clear? n and (([plabel] of patch (cur-x) (cur-y - 1)) = (cur-plabel - 1)) and is-move-clear? patch (cur-x) (cur-y - 1) and not is-moved? [
    shift-down n
    set is-moved? true
  ]
  if shift-downleft-clear? n and (([plabel] of patch (cur-x - 1) (cur-y - 1)) = (cur-plabel - 1)) and is-move-clear? patch (cur-x - 1) (cur-y - 1) and not is-moved? [
    shift-downleft n
    set is-moved? true
  ]
  if shift-left-clear? n and (([plabel] of patch (cur-x - 1) (cur-y)) = (cur-plabel - 1)) and is-move-clear? patch (cur-x - 1) (cur-y) and not is-moved? [
    shift-left n
    set is-moved? true
  ]
end

to create-virtual-obs
  let set-obs (patches with [pcolor = white])
  ask set-obs [
    let x-tmp [pxcor] of self
    let y-tmp [pycor] of self

    if (patch (x-tmp + 2) (y-tmp + 1) != nobody) [
      if ([plabel] of patch (x-tmp + 2) (y-tmp + 1) = 999) and [pcolor] of patch (x-tmp + 2) (y-tmp + 1) != black [ ;east top
        ask patch (x-tmp + 1) y-tmp [ if [pcolor] of self != red [set plabel 999 ]]
        ask patch (x-tmp + 1) (y-tmp + 1) [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
    if (patch (x-tmp + 2) y-tmp != nobody) [
      if ([plabel] of patch (x-tmp + 2) y-tmp = 999) and [pcolor] of patch (x-tmp + 2) y-tmp != black [ ;east center
        ask patch (x-tmp + 1) y-tmp [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
    if (patch (x-tmp + 2) (y-tmp - 1) != nobody) [
      if ([plabel] of patch (x-tmp + 2) (y-tmp - 1) = 999) and [pcolor] of patch (x-tmp + 2) (y-tmp - 1) != black [ ;east bottom
        ask patch (x-tmp + 1) y-tmp [ if [pcolor] of self != red [set plabel 999 ]]
        ask patch (x-tmp + 1) (y-tmp - 1) [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
    if (patch (x-tmp + 1) (y-tmp - 2) != nobody) [
      if ([plabel] of patch (x-tmp + 1) (y-tmp - 2) = 999) and [pcolor] of patch (x-tmp + 1) (y-tmp - 2) != black [ ;south right
        ask patch (x-tmp + 1) (y-tmp - 1) [ if [pcolor] of self != red [set plabel 999 ]]
        ask patch (x-tmp + 1) (y-tmp) [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
    if (patch x-tmp (y-tmp - 2) != nobody) [
      if ([plabel] of patch x-tmp (y-tmp - 2) = 999) and [pcolor] of patch x-tmp (y-tmp - 2) != black [;south center
        ask patch (x-tmp) (y-tmp - 1) [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
    if (patch (x-tmp - 1) (y-tmp - 2) != nobody) [
      if ([plabel] of patch (x-tmp - 1) (y-tmp - 2) = 999) and [pcolor] of patch (x-tmp - 1) (y-tmp - 2) != black [ ;south left
        ask patch (x-tmp - 1) (y-tmp - 1) [ if [pcolor] of self != red [set plabel 999 ]]
        ask patch (x-tmp - 1) (y-tmp) [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
    if (patch (x-tmp - 2) (y-tmp - 1) != nobody) [
      if ([plabel] of patch (x-tmp - 2) (y-tmp - 1) = 999) and [pcolor] of patch (x-tmp - 2) (y-tmp - 1) != black [ ;west bottom
        ask patch (x-tmp - 1) (y-tmp - 1) [ if [pcolor] of self != red [set plabel 999 ]]
        ask patch (x-tmp) (y-tmp - 1) [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
    if (patch (x-tmp - 2) (y-tmp) != nobody) [
      if ([plabel] of patch (x-tmp - 2) (y-tmp) = 999) and [pcolor] of patch (x-tmp - 2) (y-tmp) != black [ ;west center
        ask patch (x-tmp - 1) (y-tmp) [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
    if (patch (x-tmp - 2) (y-tmp + 1) != nobody) [
      if ([plabel] of patch (x-tmp - 2) (y-tmp + 1) = 999) and [pcolor] of patch (x-tmp - 2) (y-tmp + 1) != black [ ;west top
        ask patch (x-tmp - 1) (y-tmp) [ if [pcolor] of self != red [set plabel 999 ]]
        ask patch (x-tmp - 1) (y-tmp + 1) [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
    if (patch (x-tmp - 1) (y-tmp + 2) != nobody) [
      if ([plabel] of patch (x-tmp - 1) (y-tmp + 2) = 999) and [pcolor] of patch (x-tmp - 1) (y-tmp + 2) != black [ ;north left
        ask patch (x-tmp - 1) (y-tmp) [ if [pcolor] of self != red [set plabel 999 ]]
        ask patch (x-tmp - 1) (y-tmp + 1) [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
    if (patch (x-tmp) (y-tmp + 2) != nobody) [
      if ([plabel] of patch (x-tmp) (y-tmp + 2) = 999) and [pcolor] of patch (x-tmp) (y-tmp + 2) != black [ ;north center
        ask patch (x-tmp) (y-tmp + 1) [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
    if (patch (x-tmp + 1) (y-tmp + 2) != nobody) [
      if ([plabel] of patch (x-tmp + 1) (y-tmp + 2) = 999) and [pcolor] of patch (x-tmp + 1) (y-tmp + 2) != black [ ;north right
        ask patch (x-tmp + 1) (y-tmp) [ if [pcolor] of self != red [set plabel 999 ]]
        ask patch (x-tmp + 1) (y-tmp + 1) [ if [pcolor] of self != red [set plabel 999 ]]
      ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
368
23
1053
429
22
12
15.0
1
10
1
1
1
0
0
0
1
-22
22
-12
12
0
0
0
ticks
30.0

BUTTON
28
32
161
65
Initiate
Initiate
NIL
1
T
OBSERVER
NIL
I
NIL
NIL
1

BUTTON
1217
220
1272
253
Right
shift-right 3
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
0

BUTTON
1099
220
1154
253
Left
shift-left 3
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
0

BUTTON
1115
282
1182
315
RotLeft
rotate-left
NIL
1
T
OBSERVER
NIL
Q
NIL
NIL
0

BUTTON
1184
282
1251
315
RotRight
rotate-right
NIL
1
T
OBSERVER
NIL
E
NIL
NIL
0

BUTTON
27
80
162
113
Draw Obstacle
draw
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
1154
220
1217
253
Down
shift-down 3
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
1154
188
1217
221
Up
shift-up 3
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
185
130
322
163
Go!
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
184
81
319
114
Delete Obstacle
delete
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
185
32
320
65
Call Robots
setup-robot
NIL
1
T
OBSERVER
NIL
F
NIL
NIL
1

BUTTON
26
127
162
160
Set Goal
draw-goal
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
25
188
322
338
Distance
time
distance
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"

OUTPUT
24
356
326
440
11

@#$#@#$#@
## WHAT IS IT?

This is the classic puzzle game, Tetris.  The game involves falling pieces composed of four blocks in different configurations.  The object of the game is to complete horizontal rows of blocks in the well.

Any time a row is completed it disappears and the blocks above it fall down.  The more rows you clear with the placement of a single piece, the more points you receive.  If you clear enough rows, you move on to the next level.  The higher the level, the more points you receive for everything, but the pieces fall faster as well, increasing the challenge.

## HOW TO USE IT

Monitors:
-- SCORE shows your current score.
-- LINES shows the number of lines you have cleared.
-- LEVEL shows your current level.

Sliders:
-- STARTING-LEVEL selects the beginning level for the game.  Choosing a higher level to begin allows you to get more points faster and increase the initial falling speed.  Your level will not increase until your number of lines is 10*(level+1). (i.e. starting-level=3, level will stay 3 until 40 lines are cleared.)
-- DEBRIS-LEVEL sets how many lines of random blocks will be created at the bottom of the well at the beginning of the game.

Buttons:
-- NEW sets up a new game with the initial settings.
-- PLAY begins the game.

Controls:
-- ROTLEFT rotates the current piece 90 degrees to the left.
-- ROTRIGHT rotates the current piece 90 degrees the right.
-- LEFT moves the current piece one space left.
-- DROP causes the current piece to drop to the bottom of the well immediately.
-- RIGHT moves the current piece one space right.
-- DOWN moves the current piece one space down.

Options (Switches)
-- SHOW-NEXT-PIECE? toggles the option which causes the piece which will appear in the well after you place the current one to be shown in a small box to the right of the well.

## THINGS TO NOTICE

There are seven types of pieces.  These are all the shapes that can be made by four blocks stuck together.

       [][]      Square-Block - good filler in flat areas,
       [][]         hard to place in jagged areas

       [][][]    L-Block - fits well into deep holes
       []

         [][]    S-Block - good filler in jagged areas,
       [][]         hard to place in flat areas

       [][][]    T-Block - good average piece, can fit
         []         almost anywhere well

       [][]      Reverse S-Block (Or Z-Block) - good
         [][]       filler in jagged areas, hard to
                    place in flat areas

       [][][]    Reverse L-Block - fits well into
           []       deep holes

       [][][][]  I-Bar - Only piece that allows you to
                    clear 4 lines at once (aka a Tetris)

Scoring System:
Note: Points are scored using level + 1 so that points are still scored at level 0.
-- 1 Line  = 50*(level + 1) points
-- 2 Lines = 150*(level + 1) points
-- 3 Lines = 350*(level + 1) points
-- 4 Lines = 1000*(level + 1) points (aka a Tetris)
-- Clear the board = 2000*(level + 1)
-- Every piece = 10*(level + 1) points

## THINGS TO TRY

Beat your highest score.

## EXTENDING THE MODEL

Add options for changing the width and depth of the well.

Add the option of including pieces composed of more than four blocks, or fewer.

## NETLOGO FEATURES

This model makes use of turtle breeds.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (2001).  NetLogo Tetris model.  http://ccl.northwestern.edu/netlogo/models/Tetris.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2001 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

This model was created as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227.

<!-- 2001 -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

square big
false
0
Rectangle -7500403 true true 0 -15 300 300

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
random-seed 1
set starting-level 9
new
repeat 250 [ play ]
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@

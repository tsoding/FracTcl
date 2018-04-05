#!/usr/bin/env tclsh

package require Tk

proc snowflake {can x1 y1 n len level} {
    if {$level <= 0} {
        return
    }

    set pi 3.1415926535897931
    set angle [expr {2 * $pi / $n}]

    for {set i 0} {$i < $n} {incr i} {
        set x2 [expr {$x1 + cos($angle * $i) * $len}]
        set y2 [expr {$y1 + sin($angle * $i) * $len}]
        $can create line $x1 $y1 $x2 $y2 -width $level
        snowflake $can $x2 $y2 $n [expr {$len * 0.40}] [expr {$level - 1}]
    }
}

proc middlePoint {p1 p2} {
    set x1 [lindex $p1 0]
    set y1 [lindex $p1 1]

    set x2 [lindex $p2 0]
    set y2 [lindex $p2 1]

    return [list [expr {($x2 + $x1) / 2}] [expr {($y2 + $y1) / 2}]]
}

proc sierpinski {can p1 p2 p3 level} {
    if {$level <= 1} {
        eval [concat {$can create polygon} $p1 $p2 $p3]
        return
    }

    set p12 [middlePoint $p1 $p2]
    set p23 [middlePoint $p2 $p3]
    set p31 [middlePoint $p3 $p1]

    sierpinski $can $p1 $p12 $p31 [expr {$level - 1}]
    sierpinski $can $p12 $p2 $p23 [expr {$level - 1}]
    sierpinski $can $p31 $p23 $p3 [expr {$level - 1}]
}

proc triangle {pos size} {
    set x [lindex $pos 0]
    set y [lindex $pos 1]

    return [list \
                [list $x [expr {$y - $size}]] \
                [list [expr {$x + $size}] [expr {$y + $size}]] \
                [list [expr {$x - $size}] [expr {$y + $size}]]]
}

proc norm {x} {
    if {$x == 0} {
        return $x;
    } else {
        return [expr {$x / abs($x)}]
    }
}

proc direction {p1 p2} {
    set x1 [lindex $p1 0]
    set y1 [lindex $p1 1]
    set x2 [lindex $p2 0]
    set y2 [lindex $p2 1]
    set dx [expr {$x2 - $x1}]
    set dy [expr {$y2 - $y1}]
    return [list [norm $dx] [norm $dy]]
}

proc rotate90 {v} {
}

proc scale {s v} {
}

proc move {p v} {
}

proc drawSquare {can p s} {
    set x [lindex $p 0]
    set y [lindex $p 1]
    $can create rectangle $x $y [expr {$x + $s}] [expr {$y + $s}]
}

proc fibonacciSpiral {can p1 s1 p2 s2} {
    set s3 [expr {$s1 + $s2}]
    set p3 [move $p1 [scale $s3 [rotate90 [direction $p1 $p2]]]]

    drawSquare $can $p1 $s1
    fibonacciSpiral $can $p2 $s2 $p3 $s3
}

canvas .c -width 800 -height 600 -bg pink
pack .c
# snowflake .c 400 300 7 200 4
# eval [concat {sierpinski .c} [triangle {400 300} 200] {6}]

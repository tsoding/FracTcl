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

proc rotate90 {v} {
    set x [lindex $v 0]
    set y [lindex $v 1]
    return [list $y [expr {-$x}]]
}

proc rotateM90 {v} {
    set x [lindex $v 0]
    set y [lindex $v 1]
    return [list [expr {-$y}] $x]
}

proc invert {v} {
    set x [lindex $v 0]
    set y [lindex $v 1]
    return [list [expr {-$x}] [expr {-$y}]]
}

proc scale {s v} {
    set x [lindex $v 0]
    set y [lindex $v 1]
    return [list [expr {$x * $s}] [expr {$y * $s}]]
}

proc move {p v} {
    set vx [lindex $v 0]
    set vy [lindex $v 1]
    set px [lindex $p 0]
    set py [lindex $p 1]
    return [list [expr {$vx + $px}] [expr {$vy + $py}]]
}

proc drawArc {can p1 p2 a} {
    set x1 [lindex $p1 0]
    set y1 [lindex $p1 1]
    set x2 [lindex $p2 0]
    set y2 [lindex $p2 1]

    $can create arc [list $x1 $y1 $x2 $y2] -start $a -style arc -extent 90
}

proc fibonacciSpiral {can s1 s2 p1 v1 a level} {
    if {$level <= 0} {
        return
    }

    set p2 [move $p1 [scale $s2 $v1]]
    set p3 [move $p2 [scale $s2 [rotate90 $v1]]]
    set op [move [move $p1 [scale $s2 [invert $v1]]] [scale [expr {2 * $s2}] [rotateM90 [invert $v1]]]]

    drawArc $can $p2 $op $a

    fibonacciSpiral $can $s2 [expr {$s1 + $s2}] $p3 [rotate90 $v1] [expr {$a + 90}] [expr {$level - 1}]
}

canvas .c -width 800 -height 600 -bg pink
pack .c
# snowflake .c 400 300 7 200 4
# eval [concat {sierpinski .c} [triangle {400 300} 200] {6}]
fibonacciSpiral .c 0 10 {400 300} {1 0} 270 10


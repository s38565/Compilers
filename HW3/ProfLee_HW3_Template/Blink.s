    .file   "Blink.cpp"
    .abi_2
    .flag   verbatim
    .vec_size 16
    .text
    .align  1
    .global _Z5setupv
    .type   _Z5setupv, @function
_Z5setupv:
    push.s  { $lp }
    addi    $sp, $sp, -8
    swi     $fp, [$sp + (4)]
    addi    $fp, $sp, 0
    addi    $sp, $sp, -4
    movi    $r0, 13
    swi     $r0, [$fp + (-4)]
    addi    $sp, $sp, -4
    movi    $r0, 1
    swi     $r0, [$fp + (-8)]
    lwi     $r1, [$fp + (-8)]
    addi    $sp, $sp, 4
    lwi     $r0, [$fp + (-4)]
    addi    $sp, $sp, 4
    bal     pinMode
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-4)]
    addi    $sp, $sp, 4
._Z5setupv_END:
    addi    $sp, $fp, 0
    lwi     $fp, [$sp + (4)]
    addi    $sp, $sp, 8
    pop.s   { $lp }
    ret
    .size   _Z5setupv, .-_Z5setupv
    .text
    .align  1
    .global _Z4loopv
    .type   _Z4loopv, @function
_Z4loopv:
    push.s  { $lp }
    addi    $sp, $sp, -8
    swi     $fp, [$sp + (4)]
    addi    $fp, $sp, 0
    addi    $sp, $sp, -4
    movi    $r0, 3000
    swi     $r0, [$fp + (-4)]
    lwi     $r0, [$fp + (-4)]
    addi    $sp, $sp, 4
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-4)]
    addi    $sp, $sp, -4
    movi    $r0, 3000
    swi     $r0, [$fp + (-8)]
    lwi     $r0, [$fp + (-8)]
    addi    $sp, $sp, 4
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-8)]
    lwi     $r0, [$fp + (-8)]
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-12)]
    lwi     $r0, [$fp + (-4)]
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-16)]
    lwi     $r0, [$fp + (-8)]
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-20)]
    addi    $sp, $sp, -4
    movi    $r0, 3
    swi     $r0, [$fp + (-24)]
    lwi     $r1, [$fp + (-24)]
    addi    $sp, $sp, 4
    lwi     $r0, [$fp + (-20)]
    addi    $sp, $sp, 4
    mul     $r0, $r0, $r1
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-20)]
    lwi     $r1, [$fp + (-20)]
    addi    $sp, $sp, 4
    lwi     $r0, [$fp + (-16)]
    addi    $sp, $sp, 4
    add     $r0, $r0, $r1
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-16)]
    lwi     $r0, [$fp + (-16)]
    addi    $sp, $sp, 4
    swi     $r0, [$fp + (-8)]
    addi    $sp, $sp, -4
    movi    $r0, 13
    swi     $r0, [$fp + (-16)]
    addi    $sp, $sp, -4
    movi    $r0, 1
    swi     $r0, [$fp + (-20)]
    lwi     $r1, [$fp + (-20)]
    addi    $sp, $sp, 4
    lwi     $r0, [$fp + (-16)]
    addi    $sp, $sp, 4
    bal     digitalWrite
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-16)]
    addi    $sp, $sp, 4
    lwi     $r0, [$fp + (-4)]
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-16)]
    lwi     $r0, [$fp + (-16)]
    addi    $sp, $sp, 4
    bal     delay
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-16)]
    addi    $sp, $sp, 4
    addi    $sp, $sp, -4
    movi    $r0, 13
    swi     $r0, [$fp + (-16)]
    addi    $sp, $sp, -4
    movi    $r0, 0
    swi     $r0, [$fp + (-20)]
    lwi     $r1, [$fp + (-20)]
    addi    $sp, $sp, 4
    lwi     $r0, [$fp + (-16)]
    addi    $sp, $sp, 4
    bal     digitalWrite
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-16)]
    addi    $sp, $sp, 4
    lwi     $r0, [$fp + (-8)]
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-16)]
    lwi     $r0, [$fp + (-16)]
    addi    $sp, $sp, 4
    bal     delay
    addi    $sp, $sp, -4
    swi     $r0, [$fp + (-16)]
    addi    $sp, $sp, 4
._Z4loopv_END:
    addi    $sp, $fp, 0
    lwi     $fp, [$sp + (4)]
    addi    $sp, $sp, 8
    pop.s   { $lp }
    ret
    .size   _Z4loopv, .-_Z4loopv

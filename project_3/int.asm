lw $8, 0($2)                 
beq $4, $8, not_update
update:sw $8, 0($3)
ori $9, $8, 0x0000
ori $4, $8, 0x0000
beq $0, $0, reset
not_update:addiu $9, $9, 1
sw $9, 0($3)
reset:sw $6, 4($1)
eret

ori $3,$0,0x93
ori $6, $0, 0x1000
addu $8,$3,$6
subu $9,$3,$6
slt $1, $3, $2
slt $1, $3 $3
jal funct1
ori $3, $0, 0x6666
j end1
funct1:ori $3, $0, 0x1234
jr $31
ori $3, $0, 0x5678
jal funct1
ori $3, $0, 0x9999
end1:

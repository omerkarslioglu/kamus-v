`define opext  [1 : 0]
`define opcode [6 : 2] // <io/wire_name>`opcode -> selects just [6:2] bits
`define rd     [11: 7]
`define funct3 [14:12]
`define rs1    [19:15]
`define rs2    [24:20]
`define funct7 [31:25]
`define funct12 [31:20]
`timescale 1ns/1ps

module ROM (addr,data);
input [31:0] addr;
output [31:0] data;
reg [31:0] data;
localparam ROM_size = 32;
reg [31:0] ROM_data[ROM_size-1:0];

always@(*)
	case(addr[7:2])	//Address Must Be Word Aligned.
		//  j INIT
		0: data <= 32'b00001000000000000000000000000011;
		//  j INTER
		1: data <= 32'b00001000000000000000000000101000;
		//  j EXCEPT
		2: data <= 32'b00001000000000000000000000101001;
		//INIT:
		//  addi $t0, $zero, 0x0014
		3: data <= 32'b00100000000010000000000000010100;
		//  jr $t0
		4: data <= 32'b00000001000000000000000000001000;
		//  lui $s0, 0x4000
		5: data <= 32'b00111100000100000100000000000000;
		//  sw $t0, 32($s0)
		6: data <= 32'b10101110000010000000000000100000;
		//UART_START:
		//  addi $s1, $zero, -1
		7: data <= 32'b00100000000100011111111111111111;
		//UART_LOOP:
		//  lw $t0, 32($s0)
		8: data <= 32'b10001110000010000000000000100000;
		//  andi $t0, $t0, 0x08
		9: data <= 32'b00110001000010000000000000001000;
		//  beq $t0, $zero, UART_LOOP
		10: data <= 32'b00010001000000001111111111111101;
		//  lw $v1, 28($s0)
		11: data <= 32'b10001110000000110000000000011100;
		//  beq $v1, $zero, UART_LOOP
		12: data <= 32'b00010000011000001111111111111011;
		//  beq $s1, $zero, LOAD_2
		13: data <= 32'b00010010001000000000000000000011;
		//  addi $s4, $v1, 0
		14: data <= 32'b00100000011101000000000000000000;
		//  addi $s1, $s1, 1
		15: data <= 32'b00100010001100010000000000000001;
		//  j UART_LOOP
		16: data <= 32'b00001000000000000000000000001000;
		//LOAD_2:
		//  addi $s3, $v1, 0
		17: data <= 32'b00100000011100110000000000000000;
		//  addi $v0, $s4, 0
		18: data <= 32'b00100010100000100000000000000000;
		//GCD:
		//  beq $v0, $zero, ANS1
		19: data <= 32'b00010000010000000000000000001000;
		//  beq $v1, $zero, ANS2
		20: data <= 32'b00010000011000000000000000001001;
		//  sub $t3, $v0, $v1
		21: data <= 32'b00000000010000110101100000100010;
		//  bgtz $t3, LOOP1
		22: data <= 32'b00011101011000000000000000000001;
		//  bltz $t3, LOOP2
		23: data <= 32'b00000101011000000000000000000010;
		//LOOP1:
		//  sub $v0, $v0, $v1
		24: data <= 32'b00000000010000110001000000100010;
		//  j GCD
		25: data <= 32'b00001000000000000000000000010011;
		//LOOP2:
		//  sub $v1, $v1, $v0
		26: data <= 32'b00000000011000100001100000100010;
		//  j GCD
		27: data <= 32'b00001000000000000000000000010011;
		//ANS1:
		//  add $a0, $v1, $zero
		28: data <= 32'b00000000011000000010000000100000;
		//  j RESULT_DISPLAY
		29: data <= 32'b00001000000000000000000000011111;
		//ANS2:
		//  add $a0, $v0, $zero
		30: data <= 32'b00000000010000000010000000100000;
		//RESULT_DISPLAY:
		//  sw $a0, 12($s0)
		31: data <= 32'b10101110000001000000000000001100;
		//UART_SEND_BACK:
		//  lw $t0, 32($s0)
		32: data <= 32'b10001110000010000000000000100000;
		//  andi $t0, $t0, 0x10
		33: data <= 32'b00110001000010000000000000010000;
		//  bne $t0, $zero, UART_SEND_BACK
		34: data <= 32'b00010101000000001111111111111101;
		//  sw $a0, 24($s0)
		35: data <= 32'b10101110000001000000000000011000;
		//AA:
		//  lw $t0, 32($s0)
		36: data <= 32'b10001110000010000000000000100000;
		//  andi $t0, $t0, 0x04
		37: data <= 32'b00110001000010000000000000000100;
		//  beq $t0, $zero, AA
		38: data <= 32'b00010001000000001111111111111101;
		//  j UART_START
		39: data <= 32'b00001000000000000000000000000111;
		//INTER:
		//  nop
		40: data <= 32'b00000000000000000000000000000000;
		//EXCEPT:
		//  nop
		41: data <= 32'b00000000000000000000000000000000;
	   default:	data <= 32'h8000_0000;
	endcase
endmodule

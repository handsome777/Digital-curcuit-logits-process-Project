
module InstructionMemory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;
	
	always @(*)
		case (Address[9:2])
			// addi $a0, $zero, 3
			8'd0:    Instruction <= {6'h08, 5'd0 , 5'd4 , 16'h03};
			// jal sum
			8'd1:    Instruction <= {6'h03, 26'h03};
			//Loop:
			// beq $zero, $zero, Loop
			8'd2:    Instruction <= {6'h04, 5'd0 , 5'd0 , 16'b1111111111111111};
			//sum:
			// addi $sp, $sp, -8
			8'd3:    Instruction <= {6'h08, 5'd29 , 5'd29 ,16'b1111111111111000};
			// sw $ra, 4($sp)
			8'd4:    Instruction <= {6'h2b, 5'd29 , 5'd31 , 16'h04};
			// sw $a0, 0($sp)	
			8'd5:    Instruction <= {6'h2b, 5'd29 , 5'd4  , 16'h0};
			// slti $t0, $a0, 1
			8'd6:    Instruction <= {6'h0a, 5'd4 , 5'd8 , 16'h01};
			// beq $t0, $zero, L1
			8'd7:    Instruction <= {6'h04, 5'd8 , 5'd0 , 16'b0000000000000011};
			// xor $v0, $zero, $zero	
			8'd8:    Instruction <= {6'h00, 5'd0 , 5'd0, 5'd2, 5'd0, 6'h26};
			// addi $sp, $sp, 8
			8'd9:    Instruction <= {6'h08, 5'd29 , 5'd29 , 16'h0008};
			// jr $ra	
			8'd10:   Instruction <= {6'h00, 5'd31 , 15'h0 , 6'h08};
			// L1:
			// addi $a0, $a0, -1
			8'd11:   Instruction <= {6'h08, 5'd4, 5'd4, 16'hffff};
			//jal sum	
			8'd12:   Instruction <= {6'h03, 26'h3};
			//lw $a0, 0($sp)
			8'd13:   Instruction <= {6'h23, 5'd29, 5'd4, 16'h0};
			//lw $ra, 4($sp)	
			8'd14:   Instruction <= {6'h23, 5'd29, 5'd31, 16'h04};
			//addi $sp, $sp, 8
			8'd15:   Instruction <= {6'h08, 5'd29, 5'd29, 16'h08};
			//add $v0,$a0,$v0
			8'd16:   Instruction <= {6'h0, 5'd4, 5'd2, 5'd2,5'h0,6'h20};
			//jr $ra
			8'd17:   Instruction <= {6'h0, 5'd31 , 15'h0 , 6'h08};
			
			default: Instruction <= 32'h00000000;
		endcase
		
endmodule

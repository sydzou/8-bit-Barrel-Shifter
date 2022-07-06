`timescale 1ns / 1ps



module barrel_shifter_tb;
  reg [7:0] in;
  reg [2:0] ctrl, opcode;
  wire [7:0] out; 
  wire flag;
  
barrel_shifter uut(.a(in),.s(ctrl),.opcode(opcode),.y(out),.overflow(flag));
  
initial 
 begin
    $display($time, " << Starting the Simulation >>");
        in= 8'd0;  ctrl=3'd0; //no shift
    #10 in=8'ha6; ctrl= 3'd4; opcode= 3'b000;//arithmetic left shift 4 bit
    #10 in=8'ha6; ctrl= 3'd3; opcode= 3'b001;//logical left shift 3 bit
    #10 in=8'ha6; ctrl= 3'd1; opcode= 3'b010;//circular left shift by 1 bit
    #10 in=8'ha6; ctrl= 3'd3; opcode= 3'b100;//arithmetic right shift by 3 bit
    #10 in=8'ha6; ctrl= 3'd5; opcode= 3'b101;//logical right shift by 5 bit
    #10 in=8'ha6; ctrl= 3'd2; opcode= 3'b110;//circular right shift by 2 bit
    #10 $finish;
  end
    initial begin
      $monitor("Input=%b, Bit Shift=%d, Output=%b, Opcode=%b",in,ctrl,out,opcode);
    end
endmodule

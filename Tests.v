module PCI_CLK(clk);
output clk;
reg clk;
initial
clk=0;
always
#5 clk=~clk;
endmodule
module PCI_TEST();
reg TIRDY,TFRAME;
reg [3:0]TCBE;
wire[31:0] TAD;
wire TDEVSEL,TTRDY,TSTOP;
reg TRESET;
///////////////////
reg[31:0] AD_Line_reg;
reg [3:0] BE;
wire [3:0] index_wire;
assign TAD =((TFRAME==1'b0 && TDEVSEL==1'b1 && TTRDY == 1'b1 && TIRDY===1'b1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==0))? AD_Line_reg: 32'bz ;
				//sending ADDRESS                            //sendind DATA


initial
begin
AD_Line_reg = 32'bx;
TFRAME = 1;
TIRDY = 1;

//write
#0 TRESET=1'b0;
//#5 TRESET=1'b0;
#10 TRESET=1'b1;
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b11111111111111110000000000001111;
TCBE = 4'b1111;
#20
AD_Line_reg = 32'b1000000000011000000000;
TCBE = 4'b1111;  
#10
TFRAME=1;
AD_Line_reg = 32'b1010100101111011111111111000111;
TCBE = 4'b1111;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0010;
#20
TCBE = 4'b1110;
#10 
TCBE = 4'b0101;
TFRAME=1;

#10 TIRDY = 1;
TCBE = 4'bz;


#20 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b00000000000000001000000000001111;
TCBE = 4'b1011;
#20
AD_Line_reg = 32'b1000011000011000000000;
TCBE = 4'b1110;  
#10
TFRAME=1;
AD_Line_reg = 32'b0000011101111011111111111000111;
TCBE = 4'b1111;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0010;
#20
TCBE = 4'b1110;
#10 
TCBE = 4'b0101;
TFRAME=1;

#10 TIRDY = 1;
TCBE = 4'bz;
end
PCI_CLK C1(TCLK);
slave I(.FRAME(TFRAME),.IRDY(TIRDY),.CLK(TCLK),.CBE(TCBE),.TRDY(TTRDY),.DEVSEL(TDEVSEL),.AD(TAD),.reset(TRESET), .STOP(TSTOP));

endmodule


module RESET_TEST();
reg TIRDY,TFRAME;
wire[2:0] TSTATE;
reg [3:0]TCBE;
wire[31:0] TAD;
wire TDEVSEL,TTRDY,TSTOP;
reg TRESET;
/////////////////// 
reg[31:0] AD_Line_reg;
reg [3:0] BE;
wire [3:0] index_wire;
assign TAD =((TFRAME==1'b0 && TDEVSEL==1'b1 && TTRDY == 1'b1 && TIRDY===1'b1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==0))? AD_Line_reg: 32'bz ;
				//sending ADDRESS                            //sendind DATA


initial
begin
AD_Line_reg = 32'bx;
TFRAME = 1;
TIRDY = 1;

//write
#0 TRESET=1'b0;
//#5 TRESET=1'b0;
#10 TRESET=1'b1;
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0; 
AD_Line_reg = 32'b1;
TCBE = 4'b1111;
#20
AD_Line_reg = 32'b100000000;
TCBE = 4'b1111;  
#10
TFRAME=1;
AD_Line_reg = 32'b0000011111;
TCBE = 4'b1111;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
#5 TRESET=1'b0;
#10 TRESET=1'b1; 

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0010;
#25 TFRAME=1;

#10 TIRDY = 1;
TCBE = 4'bz;
end
PCI_CLK C1(TCLK);
slave I(.FRAME(TFRAME),.IRDY(TIRDY),.CLK(TCLK),.CBE(TCBE),.TRDY(TTRDY),.DEVSEL(TDEVSEL),.AD(TAD), .STOP(TSTOP),.reset(TRESET));

endmodule


module TRDY_TEST();
reg TIRDY,TFRAME;
wire[2:0] TSTATE;
reg [3:0]TCBE;
wire[31:0] TAD;
wire TDEVSEL,TTRDY,TSTOP;
reg TRESET;
///////////////////
reg[31:0] AD_Line_reg;
reg [3:0] BE;
wire [3:0] index_wire;

assign TAD =((TFRAME==1'b0 && TDEVSEL==1'b1 && TTRDY == 1'b1 && TIRDY===1'b1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==0))? AD_Line_reg: 32'bz ;
				//sending ADDRESS                            //sendind DATA


initial
begin
AD_Line_reg = 32'bz;
TFRAME = 1;
TIRDY = 1;

//write
#0 TRESET=1'b0;
//#5 TRESET=1'b0;
#10 TRESET=1'b1;
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b1;
TCBE = 4'b1111;
#20
AD_Line_reg = 32'b100000000;
TCBE = 4'b1111;  
#10
AD_Line_reg = 32'b110000000;
TCBE = 4'b1111;  
#10
AD_Line_reg = 32'b11111111111111111100000001;
TCBE = 4'b1111;  
#20
TFRAME=1;
AD_Line_reg = 32'b111111111111111111110000011111;
TCBE = 4'b1111;
#10
TIRDY = 1;
AD_Line_reg = 32'bz;
TCBE = 4'bz;

//#30 TFRAME=1;
//#10 TIRDY = 1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#20 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0000;
#20
TCBE = 4'b1101;
#10
TCBE = 4'b0101;
#10
TCBE = 4'b0001;
#10 TFRAME=1;
TCBE = 4'b1111;
#10 TIRDY =1;
TCBE = 4'bz;
////////////////////////////
#30 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b01010101010101;
TCBE = 4'b0001;
#20
AD_Line_reg = 32'b1000011111110001;
TCBE = 4'b1110;  
#10
AD_Line_reg = 32'b1111111110111111111110000000;
TCBE = 4'b1111;  
#10
AD_Line_reg = 32'b11111111000000000000000000000001;
TCBE = 4'b0111;  
#20
TFRAME=1;
AD_Line_reg = 32'b100000011111111111110000011111;
TCBE = 4'b1110;
#10
TIRDY = 1;
AD_Line_reg = 32'bz;
TCBE = 4'bz;

//#30 TFRAME=1;
//#10 TIRDY = 1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#20 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0000;
#20
TCBE = 4'b1101;
#10
TCBE = 4'b0101;
#10
TCBE = 4'b0001;
#10 TFRAME=1;
TCBE = 4'b1111;
#10 TIRDY =1;
TCBE = 4'bz;
end
PCI_CLK C1(TCLK);
slave I(.FRAME(TFRAME),.IRDY(TIRDY),.CLK(TCLK),.CBE(TCBE),.TRDY(TTRDY),.DEVSEL(TDEVSEL),.AD(TAD), .STOP(TSTOP),.reset(TRESET));

endmodule

module IRDY_READ_TEST();
reg TIRDY,TFRAME;
wire[2:0] TSTATE;
reg [3:0]TCBE;
wire[31:0] TAD;
wire TDEVSEL,TTRDY,TSTOP;
reg TRESET;
///////////////////
reg[31:0] AD_Line_reg;
reg [3:0] BE;
wire [3:0] index_wire;
assign TAD =((TFRAME==1'b0 && TDEVSEL==1'b1 && TTRDY == 1'b1 && TIRDY===1'b1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==0))? AD_Line_reg: 32'bz ;
				//sending ADDRESS                            //sendind DATA


initial
begin
AD_Line_reg = 32'bz;
TFRAME = 1;
TIRDY = 1;

//write
#0 TRESET=1'b0;
//#5 TRESET=1'b0;
#10 TRESET=1'b1;
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b1;
TCBE = 4'b1111;
#20 
AD_Line_reg = 32'b111111111111100000000111111110;
TCBE = 4'b1111;
#10
TFRAME=1;
AD_Line_reg = 32'b0000011111;
TCBE = 4'b1111;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0001;
#10 TIRDY = 1;
#10 TIRDY =0;
TCBE = 4'b1110;
#20 TFRAME=1;
#10 TIRDY = 1;
TCBE = 4'bz;

///////////////////
#20 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b11111111111111111111111111111111;
TCBE = 4'b1000;
#20 
AD_Line_reg = 32'b00000000111110000000000000000000;
TCBE = 4'b0111;
#10
TFRAME=1;
AD_Line_reg = 32'b00000111110000011111;
TCBE = 4'b1011;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0001;
#10 TIRDY = 1;
#10 TIRDY =0;
TCBE = 4'b1110;
#20 TFRAME=1;
#10 TIRDY = 1;
TCBE = 4'bz;
end
PCI_CLK C1(TCLK);
slave I(.FRAME(TFRAME),.IRDY(TIRDY),.CLK(TCLK),.CBE(TCBE),.TRDY(TTRDY),.DEVSEL(TDEVSEL),.AD(TAD), .STOP(TSTOP),.reset(TRESET));
endmodule

module CBE_TEST();
reg TIRDY,TFRAME;
wire[2:0] TSTATE;
reg [3:0]TCBE;
wire[31:0] TAD;
wire TDEVSEL,TTRDY,TSTOP;
reg TRESET;
///////////////////
reg[31:0] AD_Line_reg;
reg [3:0] BE;
wire [3:0] index_wire;
assign TAD =((TFRAME==1'b0 && TDEVSEL==1'b1 && TTRDY == 1'b1 && TIRDY===1'b1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==0))? AD_Line_reg: 32'bz ;
				//sending ADDRESS                            //sendind DATA


initial
begin
AD_Line_reg = 32'bx;
TFRAME = 1;
TIRDY = 1;

//write
#0 TRESET=1'b0;
//#5 TRESET=1'b0;
#10 TRESET=1'b1;
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b1;
TCBE = 4'b1111;
#20
AD_Line_reg = 32'b100000000;
TCBE = 4'b1111;  
#10
TFRAME=1;
AD_Line_reg = 32'b0000011111;
TCBE = 4'b1111;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b1111;
#20 TCBE = 4'b1010;
#10 TFRAME=1;
TCBE = 4'b0000;
#10 TIRDY = 1;
TCBE = 4'bz;

////////////////
#20 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b11111111111111110000000000001111;
TCBE = 4'b1110;
#20
AD_Line_reg = 32'b111100000000;
TCBE = 4'b0010;  
#10
TFRAME=1;
AD_Line_reg = 32'b0000000000000;
TCBE = 4'b1111;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b1111;
#20 TCBE = 4'b1010;
#10 TFRAME=1;
TCBE = 4'b0000;
#10 TIRDY = 1;
TCBE = 4'bz;

end
PCI_CLK C1(TCLK);
slave I(.FRAME(TFRAME),.IRDY(TIRDY),.CLK(TCLK),.CBE(TCBE),.TRDY(TTRDY),.DEVSEL(TDEVSEL),.AD(TAD), .STOP(TSTOP),.reset(TRESET));

endmodule
module LOOP_TEST();
reg TIRDY,TFRAME;
wire[2:0] TSTATE;
reg [3:0]TCBE;
wire[31:0] TAD;
wire TDEVSEL,TTRDY,TSTOP;
reg TRESET;
///////////////////
reg[31:0] AD_Line_reg;
reg [3:0] BE;
wire [3:0] index_wire;
assign TAD =((TFRAME==1'b0 && TDEVSEL==1'b1 && TTRDY == 1'b1 && TIRDY===1'b1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==0))? AD_Line_reg: 32'bz ;
				//sending ADDRESS                            //sendind DATA


initial
begin
AD_Line_reg = 32'bx;
TFRAME = 1;
TIRDY = 1;

//write
#0 TRESET=1'b0;
//#5 TRESET=1'b0;
#10 TRESET=1'b1;
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b1;
TCBE = 4'b1111;
#20
AD_Line_reg = 32'b1111111111111111111111111111100;
TCBE = 4'b1111;  
#10
TFRAME=1;
AD_Line_reg = 32'b0000011111;
TCBE = 4'b1111;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b1111;
#20 TCBE = 4'b1010;
#30 TFRAME=1;
TCBE = 4'b0000;
#10 TIRDY = 1;
TCBE = 4'bz;

///////////////////////////////
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b1111111111111111111100000000;
TCBE = 4'b1110;
#20
AD_Line_reg = 32'b0000000000000000111111111100;
TCBE = 4'b1010;  
#10
TFRAME=1;
AD_Line_reg = 32'b111111111111111111111111111111;
TCBE = 4'b0111;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b1111;
#20 TCBE = 4'b1010;
#30 TFRAME=1;
TCBE = 4'b0000;
#10 TIRDY = 1;
TCBE = 4'bz;


end
PCI_CLK C1(TCLK);
slave I(.FRAME(TFRAME),.IRDY(TIRDY),.CLK(TCLK),.CBE(TCBE),.TRDY(TTRDY),.DEVSEL(TDEVSEL),.AD(TAD), .STOP(TSTOP),.reset(TRESET));

endmodule

module LOOP_TWOMEMS_TEST();
reg TIRDY,TFRAME;
wire[2:0] TSTATE;
reg [3:0]TCBE;
wire[31:0] TAD;
wire TDEVSEL,TTRDY,TSTOP;
reg TRESET;
///////////////////
reg[31:0] AD_Line_reg;
reg [3:0] BE;
wire [3:0] index_wire;

assign TAD =((TFRAME==1'b0 && TDEVSEL==1'b1 && TTRDY == 1'b1 && TIRDY===1'b1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==0))? AD_Line_reg: 32'bz ;
				//sending ADDRESS                            //sendind DATA


initial
begin
AD_Line_reg = 32'bz;
TFRAME = 1;
TIRDY = 1;

//write
#0 TRESET=1'b0;
//#5 TRESET=1'b0;
#10 TRESET=1'b1;
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b1;
TCBE = 4'b1111;
#20
AD_Line_reg = 32'b11111111111111111111000000000000;
TCBE = 4'b1111;  
#10
AD_Line_reg = 32'b110000000;
TCBE = 4'b1111;  
#10
AD_Line_reg = 32'b100000001;
TCBE = 4'b1111;
#20
AD_Line_reg = 32'b1111000000000001;
TCBE = 4'b1111; 
#10
TFRAME=1;
AD_Line_reg = 32'b0000011111;
TCBE = 4'b1111;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY =1'b1;
#30 TFRAME=1;
#10 TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0000;
#20
TCBE = 4'b1101;
#10
TCBE = 4'b1111;
#10
TCBE = 4'b1010;
#10
TCBE = 4'b1100;
#10
TCBE = 4'b0011;
#10
TCBE = 4'b1110;
#10
TCBE = 4'b0111;
#30 TFRAME=1;
#10 TIRDY =1;
TCBE = 4'bz;


//////////////////////
#20 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b1;
TCBE = 4'b1111;
#20
AD_Line_reg = 32'b000000000000000000000000000000;
TCBE = 4'b1011;  
#10
AD_Line_reg = 32'b111111111111111111111110000000;
TCBE = 4'b0111;  
#10
AD_Line_reg = 32'b00000000000000000000000111111;
TCBE = 4'b1110;
#20
AD_Line_reg = 32'b11110001111111111111111110001;
TCBE = 4'b0000; 
#10
TFRAME=1;
AD_Line_reg = 32'b0000011111111100011111111111;
TCBE = 4'b1101;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY =1'b1;
#30 TFRAME=1;
#10 TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0000;
#20
TCBE = 4'b1101;
#10
TCBE = 4'b1111;
#10
TCBE = 4'b1010;
#10
TCBE = 4'b1100;
#10
TCBE = 4'b0011;
#10
TCBE = 4'b1110;
#10
TCBE = 4'b0111;
#30 TFRAME=1;
#10 TIRDY =1;
TCBE = 4'bz;

end
PCI_CLK C1(TCLK);
slave I(.FRAME(TFRAME),.IRDY(TIRDY),.CLK(TCLK),.CBE(TCBE),.TRDY(TTRDY),.DEVSEL(TDEVSEL),.AD(TAD), .STOP(TSTOP),.reset(TRESET));

endmodule
module STOP_TEST();
reg TIRDY,TFRAME;
wire[2:0] TSTATE;
reg [3:0]TCBE;
wire[31:0] TAD;
wire TDEVSEL,TTRDY,TSTOP;
reg TRESET;
///////////////////
reg[31:0] AD_Line_reg;
reg [3:0] BE;
wire [3:0] index_wire;

assign TAD =((TFRAME==1'b0 && TDEVSEL==1'b1 && TTRDY == 1'b1 && TIRDY===1'b1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==0))? AD_Line_reg: 32'bz ;
				//sending ADDRESS                            //sendind DATA


initial
begin
AD_Line_reg = 32'bz;
TFRAME = 1;
TIRDY = 1;

//write
#0 TRESET=1'b0;
//#5 TRESET=1'b0;
#10 TRESET=1'b1;
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1010;
#10 TIRDY=0;
AD_Line_reg = 32'b1;
TCBE = 4'b1111;
#20
AD_Line_reg = 32'b11111111111111111111000000000000;
TCBE = 4'b1111;  
#10
AD_Line_reg = 32'b110000000;
TCBE = 4'b1111;  
#10
AD_Line_reg = 32'b100000001;
TCBE = 4'b1111;
#20
AD_Line_reg = 32'b1111000000000001;
TCBE = 4'b1111;
#10
AD_Line_reg = 32'b11111111111110000011011100001111;
TCBE = 4'b1111; 
#10
TFRAME=1;
AD_Line_reg = 32'b0000011111;
TCBE = 4'b1111;
#10 TIRDY = 1'b1;
TCBE <= 4'bz;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1010;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0000;
#60 TFRAME=1;
#10 TIRDY =1;
TCBE = 4'bz;
end
PCI_CLK C1(TCLK);
slave I(.FRAME(TFRAME),.IRDY(TIRDY),.CLK(TCLK),.CBE(TCBE),.TRDY(TTRDY),.DEVSEL(TDEVSEL),.AD(TAD), .STOP(TSTOP),.reset(TRESET));

endmodule




module ADD_TEST();
reg TIRDY,TFRAME;
reg [3:0]TCBE;
wire[31:0] TAD;
wire TDEVSEL,TTRDY,TSTOP;
reg TRESET;
///////////////////
reg[31:0] AD_Line_reg;
reg [3:0] BE;
wire [3:0] index_wire;
assign TAD =((TFRAME==1'b0 && TDEVSEL==1'b1 && TTRDY == 1'b1 && TIRDY===1'b1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==0))? AD_Line_reg: 32'bz ;
				//sending ADDRESS                            //sendind DATA


initial
begin
AD_Line_reg = 32'bx;
TFRAME = 1;
TIRDY = 1;

//write
#0 TRESET=1'b0;
//#5 TRESET=1'b0;
#10 TRESET=1'b1;
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1011;
#10 TIRDY=0;
AD_Line_reg = 32'b11111111111111110000000000001111;
TCBE = 4'b1111;
#20
TFRAME=1;
AD_Line_reg = 32'b1010100101111011111111111000111;
TCBE = 4'b1111;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1011;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0010;
#20
TCBE = 4'b1110;
TFRAME=1;

#10 TIRDY = 1;
TCBE = 4'bz;
end
PCI_CLK C1(TCLK);
slave I(.FRAME(TFRAME),.IRDY(TIRDY),.CLK(TCLK),.CBE(TCBE),.TRDY(TTRDY),.DEVSEL(TDEVSEL),.AD(TAD),.reset(TRESET), .STOP(TSTOP));

endmodule

module ADD_LOOP_TEST();
reg TIRDY,TFRAME;
reg [3:0]TCBE;
wire[31:0] TAD;
wire TDEVSEL,TTRDY,TSTOP;
reg TRESET;
///////////////////
reg[31:0] AD_Line_reg;
reg [3:0] BE;
wire [3:0] index_wire;
assign TAD =((TFRAME==1'b0 && TDEVSEL==1'b1 && TTRDY == 1'b1 && TIRDY===1'b1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==0))? AD_Line_reg: 32'bz ;
				//sending ADDRESS                            //sendind DATA


initial
begin
AD_Line_reg = 32'bx;
TFRAME = 1;
TIRDY = 1;

//write
#0 TRESET=1'b0;
//#5 TRESET=1'b0;
#10 TRESET=1'b1;
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b1011;
#10 TIRDY=0;
AD_Line_reg = 32'b11111111111111110000000000001111;
TCBE = 4'b1111;
#20
TFRAME=1;
AD_Line_reg = 32'b1010100101111011111111111000111;
TCBE = 4'b1111;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b0110;
AD_Line_reg = 32'b1011;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0010;
#30
TCBE = 4'b1110;
TFRAME=1;

#10 TIRDY = 1;
TCBE = 4'bz;
end
PCI_CLK C1(TCLK);
slave I(.FRAME(TFRAME),.IRDY(TIRDY),.CLK(TCLK),.CBE(TCBE),.TRDY(TTRDY),.DEVSEL(TDEVSEL),.AD(TAD),.reset(TRESET), .STOP(TSTOP));


endmodule
module OUTOFRANGEAD_TEST();
reg TIRDY,TFRAME;
reg [3:0]TCBE;
wire[31:0] TAD;
wire TDEVSEL,TTRDY,TSTOP;
reg TRESET;
///////////////////
reg[31:0] AD_Line_reg;
reg [3:0] BE;
wire [3:0] index_wire;
assign TAD =((TFRAME==1'b0 && TDEVSEL==1'b1 && TTRDY == 1'b1 && TIRDY===1'b1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==1) || (BE == 4'b0111 && TIRDY==1'b0 && TDEVSEL==0))? AD_Line_reg: 32'bz ;
				//sending ADDRESS                            //sendind DATA


initial
begin
AD_Line_reg = 32'bx;
TFRAME = 1;
TIRDY = 1;

//write
#0 TRESET=1'b0;
//#5 TRESET=1'b0;
#10 TRESET=1'b1;
#10 TFRAME=0;
TCBE=4'b0111;
BE = TCBE;
AD_Line_reg = 32'b0000;
#10 TIRDY=0;
AD_Line_reg = 32'b11111111111111110000000000001111;
TCBE = 4'b0111;
#20
AD_Line_reg = 32'b1000000000011000000000;
TCBE = 4'b1111;  
#10
TFRAME=1;
AD_Line_reg = 32'b1010100101111011111111111000111;
TCBE = 4'b1110;
#10
AD_Line_reg = 32'bz;
TCBE = 4'bz;
TIRDY = 1'b1;
//AD_Line_reg = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
//#5 TRESET=1'b0;

//read
#30 TFRAME=0;
TCBE=4'b1101;
AD_Line_reg = 32'b00;
BE = TCBE;
#10 TIRDY=0;
TCBE = 4'b0010;
#20
TCBE = 4'b1110;
#10 
TCBE = 4'b0101;
TFRAME=1;

#10 TIRDY = 1;
TCBE = 4'bz;
end
PCI_CLK C1(TCLK);
slave I(.FRAME(TFRAME),.IRDY(TIRDY),.CLK(TCLK),.CBE(TCBE),.TRDY(TTRDY),.DEVSEL(TDEVSEL),.AD(TAD),.reset(TRESET), .STOP(TSTOP));

endmodule

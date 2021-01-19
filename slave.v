module slave(DEVSEL,TRDY,FRAME,IRDY,CLK,CBE,AD,STOP,reset); 

input FRAME,IRDY,CLK,reset;
input [3:0] CBE;
inout [31:0] AD;
reg [31:0] AD_reg;
reg [31:0] AD_PCI;
reg add_mode;    ////////////////////////////////////////////////////
reg[3:0] BE; 
reg [3:0] OP;
reg [3:0] index;
output reg DEVSEL,TRDY;
output reg STOP;
reg [31:0] MEM[0:2];
parameter DEVICE_ADD=32'b1010;

 

//////////////////////////////////////////////
reg [31:0] MEM2 [0:2];
reg [3:0] index2;
reg overflow;
reg end_of_trdy;
//reg mem2_flag;
    //reg i;
reg device_selected;
reg MEM2_IS_USED;
//////////////////////////////////////////////

 

assign AD =( add_mode)? AD_reg: 32'bz;  

 

 

 

 

parameter IDLE=3'b000 
,ADD_DECODING=3'b001
,TURN_AROUND=3'b010
,DATA_TRNS=3'b011
,END_TRNS=3'b100
,END_OPER=3'b101;
//reg [2:0]data;
reg[2:0] STATE;

 

parameter write=4'b0111
,read=4'b0110;
//always@(reset)
//begin
//if(reset==0)
//STATE<=IDLE;
//
//end
//
always @(CLK or reset)
begin
if(reset==0) begin
    add_mode <= 0; 
    index<=0;
   DEVSEL<=1'b1;TRDY<=1'b1;index2<=0;
   index2<=0;
    overflow<=0;
    end_of_trdy <=0;
    device_selected <=0;
    MEM2_IS_USED <=0;
    STOP <= 1;
    MEM[0] <= 32'bx;
    MEM[1] <= 32'bx;
    MEM[2] <= 32'bx;
    MEM2[0] <= 32'bx;
    MEM2[1] <= 32'bx;
    MEM2[2] <= 32'bx;
    STATE <= IDLE;
   end

if(CLK==1)
begin
 
 

    case(STATE)  
    IDLE:begin
    end_of_trdy <=0;
    //device_selected <=0;
    //MEM2_IS_USED <=0;
    overflow<=0;
    index<=0;
    index2 <=0 ;
    if(reset==0)begin
    STATE<=IDLE;
     MEM[AD_PCI] <= 32'bx ;
    end
    else if(FRAME==1'b0)
    begin
    STATE<=ADD_DECODING;
    add_mode <= 0;   ///////////////////
    AD_PCI <= AD;
    OP <= CBE;
    end
    else if( FRAME==1'b1 )
    STATE<=IDLE;

 

    end
     
    ADD_DECODING:begin
    //OP <= CBE;
    if((AD_PCI<DEVICE_ADD)||(AD_PCI>=DEVICE_ADD+6))
    begin
    STATE<=IDLE;
    end
     ///////////////////////////
    else if((AD_PCI>=DEVICE_ADD)&&(AD_PCI<DEVICE_ADD+6)&&(OP==4'b0110)&&(IRDY==0))
    begin
    STATE<=TURN_AROUND;
     
    end
    else if( (AD_PCI>=DEVICE_ADD)&&(AD_PCI<DEVICE_ADD+6)&& (TRDY==0)&&(DEVSEL==0))
    begin
    STATE<=DATA_TRNS;
     
//   add_mode <= 0; 
//   MEM[32'b1010 +1] = 32'b1; 
         ////////////////////////////////////////// 
        if(CBE[0]==1'b1)MEM[AD_PCI+index-DEVICE_ADD][7:0] <= AD[7:0];
    if(CBE[1]==1'b1)MEM[AD_PCI+index-DEVICE_ADD][15:8] <= AD[15:8];
    if(CBE[2]==1'b1)MEM[AD_PCI+index-DEVICE_ADD][23:16] <= AD[23:16];
    if(CBE[3]==1'b1)MEM[AD_PCI+index-DEVICE_ADD][31:24] <= AD[31:24];  
     
    index <= index+1;
   end
    //add_mode <= 0;                          ////////////////////////////// 
   
    end

 

    TURN_AROUND:begin
    if((OP==4'b0110)&&(DEVSEL==0)&&(TRDY==0))begin
    STATE<=DATA_TRNS;
    add_mode <= 1;
end 
    end

 

    (DATA_TRNS):begin
    BE<=CBE;
    if((IRDY==1)&&(TRDY==1))begin
    STATE<=DATA_TRNS;
    //add_mode <= 0; 
     end                  ////////////// 
    else if((IRDY==0)&&(TRDY==0))
    begin
        //add_mode <= 0;           //////////
     //MEM[32'b1010 +1] = 32'b1; 
 if (OP == read)begin
	if (AD_PCI+index-DEVICE_ADD >= 3 && IRDY == 0 && MEM2_IS_USED == 0)begin index <= 0; index2 <=0; end    //looping if FRAME still =0
        if (AD_PCI+index2-DEVICE_ADD >= 3 && IRDY == 0 && MEM2_IS_USED == 1)begin index <= 0; index2 <=0; end    //looping if FRAME still =0 && we used two mems in writing

    end   
   if(OP== write)   //write//////////////////////////////////////////////////
     begin

 

    if (TRDY == 1 && end_of_trdy == 0)begin 
    overflow <=0;
     end_of_trdy <= 1; end
       if(AD_PCI+index-DEVICE_ADD == 2 && end_of_trdy == 0) begin
     overflow <= 1;
        end
       if( overflow ==0)begin
        if(CBE[0]==1'b1)
    MEM[AD_PCI+index-DEVICE_ADD][7:0] <= AD[7:0];
    if(CBE[1]==1'b1)
    MEM[AD_PCI+index-DEVICE_ADD][15:8] <= AD[15:8];
    if(CBE[2]==1'b1)
    MEM[AD_PCI+index-DEVICE_ADD][23:16] <= AD[23:16];
    if(CBE[3]==1'b1)
    MEM[AD_PCI+index-DEVICE_ADD][31:24] <= AD[31:24]; 

 

    index <= index+1; end
    else begin
        if(CBE[0]==1'b1)
    MEM2[AD_PCI+index2-DEVICE_ADD][7:0] <= AD[7:0];
    if(CBE[1]==1'b1)
    MEM2[AD_PCI+index2-DEVICE_ADD][15:8] <= AD[15:8];
    if(CBE[2]==1'b1)
    MEM2[AD_PCI+index2-DEVICE_ADD][23:16] <= AD[23:16];
    if(CBE[3]==1'b1)
    MEM2[AD_PCI+index2-DEVICE_ADD][31:24] <= AD[31:24]; 
    MEM2_IS_USED <= 1;
    index2 <= index2+1; end

 

   end
    if((IRDY==0)&&(FRAME==0)) begin
    STATE<=DATA_TRNS;
     //if (OP == 4'b0111)     add_mode <= 0;  ////////
end
    else if((FRAME==1))
    STATE<=END_OPER;
    end
    end

 

    
    
 
    END_OPER:begin
    STATE<=IDLE;
    index<=0;
    index2<=0;
    end
    
    
    endcase

 


end
if(CLK==0)
begin
case(STATE) 
    IDLE:begin
    if (STOP == 0 ) STOP <= 1;
    DEVSEL <= 1;
        TRDY <= 1;
    end

 

    ADD_DECODING:
    begin
    if((AD_PCI>=DEVICE_ADD)&&(AD_PCI<DEVICE_ADD+6))
    begin
//    if (OP == 4'b0111) add_mode <= 0;
//    else   add_mode <= 1;
    if(device_selected == 1) begin
    DEVSEL<=0;
        TRDY<=0;
       if (AD_PCI+index2-DEVICE_ADD>2 )begin DEVSEL <= 1; TRDY <= 1; end
    //STOP <= 1;
     device_selected =0;
        end
     else device_selected <= 1;

 

    end
 
    end
    
    TURN_AROUND:begin
    if(OP == 4'b0110)
    begin
////////////////////////////////
    if(device_selected == 1) begin
    DEVSEL<=0;
        TRDY<=0;
    //STOP <= 1;
     device_selected <=0;
        end
 /////////////////////////////
    add_mode <= 1;
   if (IRDY == 0)begin
    AD_reg <= MEM[AD_PCI+index-DEVICE_ADD];
    index<=index+1; end
  else AD_reg <= MEM[AD_PCI+index-DEVICE_ADD];
    end
    
    end
    
    
    DATA_TRNS:
    begin

 

    if(OP==read)
    begin

    if (IRDY == 0 ) begin
    if (AD_PCI+index-DEVICE_ADD < 3)begin
    AD_reg <= MEM[AD_PCI+index-DEVICE_ADD];
    index <= index+1; 
        end
    if (AD_PCI+index-DEVICE_ADD >= 3 && MEM2_IS_USED == 1)begin
    AD_reg <= MEM2[AD_PCI+index2-DEVICE_ADD];
    index2 <= index2+1; end
           end  ///end IRDY
   else begin   // IRDY == 1
    if (AD_PCI+index-DEVICE_ADD < 3)
    AD_reg <= MEM[AD_PCI+index-DEVICE_ADD]; 
    if (AD_PCI+index-DEVICE_ADD >= 3 && MEM2_IS_USED == 1)
    AD_reg <= MEM2[AD_PCI+index2-DEVICE_ADD];
    
      end  ////end else

 if (TRDY == 1) MEM2_IS_USED <=0;

    end  //end read

 

    else if (OP == write) begin
     if (AD_PCI+index2-DEVICE_ADD ==3)begin STOP <= 0;
        DEVSEL <= 1;
        TRDY <= 1;
    STATE <= IDLE;
            end
    if(overflow == 1 && end_of_trdy == 0) begin
    TRDY <= 1;
        end_of_trdy <= 1;
        end
    if (end_of_trdy == 1 && index2 <3)begin 
      TRDY <=0; 
  

 

        end
    end
    end
    
    END_OPER:
    begin
    device_selected <=0;
    //MEM2_IS_USED <=0;
    DEVSEL<=1;
    TRDY<=1;
    //STOP <= 1;
    AD_reg <= 32'bz;
    end
    
    

 

endcase
end
end
endmodule



module binToBCD(
    //input clk,
    //input rst,
    input [13:0] i_data_bin,
    output [15:0] o_data_bcd
);

//use add 3 then shift
reg [19:0] data_bcd;
integer i;
always @(i_data_bin) begin
    data_bcd = 20'b0;
    for(i=14;i>0;i=i-1)
    begin
        if(data_bcd[19:16]>4'd4) data_bcd[19:16] = data_bcd[19:16] + 4'b0011;
        if(data_bcd[15:12]>4'd4) data_bcd[15:12] = data_bcd[15:12] + 4'b0011;
        if(data_bcd[11:8]>4'd4) data_bcd[11:8] = data_bcd[11:8] + 4'b0011;
        if(data_bcd[7:4]>4'd4) data_bcd[7:4] = data_bcd[7:4] + 4'b0011;
        data_bcd = data_bcd << 1;
        data_bcd[0] = i_data_bin[i];
    end
end

assign o_data_bcd = data_bcd[15:0];

endmodule   




/*
module bin2bcd #(
    parameter INPUT_WIDTH = 14,
    parameter DECIMAL_DIGITS = 4
)
(
    input clk,
    input [INPUT_WIDTH - 1 : 0] i_Binary,
    input i_Start,
    output [DECIMAL_DIGITS * 4 - 1 : 0] o_BCD,
    output o_DV
 );


parameter s_IDLE = 3'b000, s_SHIFT = 3'b001, s_CHECK_SHIFT_INDEX = 3'b010, s_ADD = 3'b011,
    s_CHECK_DIGIT_INDEX = 3'b100, s_BCD_DONE = 3'b101;

reg [2:0] r_SM_Main = s_IDLE;
   
// The vector that contains the output BCD
reg [DECIMAL_DIGITS*4 - 1 : 0] r_BCD = 0;
    
// The vector that contains the input binary value being shifted.
reg [INPUT_WIDTH-1:0] r_Binary = 0;
      
// Keeps track of which Decimal Digit we are indexing
reg [DECIMAL_DIGITS-1:0] r_Digit_Index = 0;
    
// Keeps track of which loop iteration we are on.
// Number of loops performed = INPUT_WIDTH
reg [7:0] r_Loop_Count = 0;
 
wire [3:0] w_BCD_Digit;
reg r_DV = 1'b0;                       
    
always @(posedge clk) begin
    case (r_SM_Main)   
        // Stay in this state until i_Start comes along
        s_IDLE :
          begin
            r_DV <= 1'b0;
             
            if (i_Start == 1'b1)
              begin
                r_Binary  <= i_Binary;
                r_SM_Main <= s_SHIFT;
                r_BCD     <= 0;
              end
            else
              r_SM_Main <= s_IDLE;
          end
                 
  
        // Always shift the BCD Vector until we have shifted all bits through
        // Shift the most significant bit of r_Binary into r_BCD lowest bit.
        s_SHIFT :
          begin
            r_BCD     <= r_BCD << 1;
            r_BCD[0]  <= r_Binary[INPUT_WIDTH-1];
            r_Binary  <= r_Binary << 1;
            r_SM_Main <= s_CHECK_SHIFT_INDEX;
          end          
         
  
        // Check if we are done with shifting in r_Binary vector
        s_CHECK_SHIFT_INDEX :
          begin
            if (r_Loop_Count == INPUT_WIDTH-1)
              begin
                r_Loop_Count <= 0;
                r_SM_Main    <= s_BCD_DONE;
              end
            else
              begin
                r_Loop_Count <= r_Loop_Count + 1;
                r_SM_Main    <= s_ADD;
              end
          end
                 
  
        // Break down each BCD Digit individually.  Check them one-by-one to
        // see if they are greater than 4.  If they are, increment by 3.
        // Put the result back into r_BCD Vector.  
        s_ADD :
          begin
            if (w_BCD_Digit > 4)
              begin                                     
                r_BCD[(r_Digit_Index*4)+:4] <= w_BCD_Digit + 3;  
              end
             
            r_SM_Main <= s_CHECK_DIGIT_INDEX; 
          end       
         
         
        // Check if we are done incrementing all of the BCD Digits
        s_CHECK_DIGIT_INDEX :
          begin
            if (r_Digit_Index == DECIMAL_DIGITS-1)
              begin
                r_Digit_Index <= 0;
                r_SM_Main     <= s_SHIFT;
              end
            else
              begin
                r_Digit_Index <= r_Digit_Index + 1;
                r_SM_Main     <= s_ADD;
              end
          end
         
  
  
        s_BCD_DONE :
          begin
            r_DV      <= 1'b1;
            r_SM_Main <= s_IDLE;
          end
         
         
        default :
          r_SM_Main <= s_IDLE;
            
      endcase
    end // always @ (posedge i_Clock)  
 
   
  assign w_BCD_Digit = r_BCD[r_Digit_Index*4 +: 4];
       
  assign o_BCD = r_BCD;
  assign o_DV  = r_DV;
      
endmodule // Binary_to_BCD

///////////////////////////////////////
module bin2bcd  (
    input clk,
    input rst_n,
    input [15:0] data_in,//接反应时间的十进制四位数,或者直接传递fail和----
    input [1:0]disp_state,
    output reg [3:0] data_out1,data_out2,data_out3,data_out4
);//个十百千
integer i;
reg flg;
always@(posedge clk or negedge rst_n)
if(!rst_n)
begin
    data_out1=4'b0000;
    data_out2=4'b0000;
    data_out3=4'b0000;
    data_out4=4'b0000;//高位
     flg=1;
end
else
begin
    
    if(disp_state==2'b00&& flg==1)//若显示数字，则译码
    begin
    for (i =15 ;i>=0 ;i=i-1 ) begin
        if (data_out4>4) 
            data_out4=data_out4+3;
        if (data_out3>4) 
            data_out3=data_out3+3;
        if (data_out2>4) 
            data_out2=data_out2+3;
        if (data_out1>4) 
        data_out1=data_out1+3;
        data_out4=data_out4<<1;
        data_out4[0]=data_out3[3];
        data_out3=data_out3<<1;
        data_out3[0]=data_out2[3];   
        data_out2=data_out2<<1;
        data_out2[0]=data_out1[3];
        data_out1=data_out1<<1;
        data_out1[0]=data_in[i];      
    end
    flg=0;
    end
    else if(disp_state==2'b01||disp_state==2'b10 || disp_state==2'b11)
    begin
        data_out4=data_in[15:12];
        data_out3=data_in[11:8];
        data_out2=data_in[7:4];
        data_out1=data_in[3:0];
    end 
end //加三移位
endmodule
*/
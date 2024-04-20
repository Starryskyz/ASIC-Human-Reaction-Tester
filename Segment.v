module segment_display#(
    parameter CNTM = 125000 //for 125MHz clock, 1ms, generate 500Hz clock
)
(
    input clk,
    input rst,
    input [15:0] i_data_timer,
    input [2:0] state,
    output reg [3:0] sm_wei,
    output reg [7:0] sm_duan
)

wire [15:0] data;
wire [3:0] duan_ctrl;
wire [7:0] duan;

reg clk;
reg [31:0] clk_cnt;
//IDLE = 3'b000;WAIT = 3'b001;TEST = 3'b010;DONE = 3'b011;FAIL = 3'b100;


always @(*) begin
    case(state)
        3'b000: data = 16'b1111_1111_1111_1111;
        3'b001: data = 16'b1010_1010_1010_1010;
        3'b010: data = i_data_timer;
        3'b011: data = i_data_timer;
        3'b100: data = 16'b1100_1101_0001_1110;
        default: data = 16'b1111_1111_1111_1111;
    endcase
end


always @(posedge clk or posedge rst)
    if(rst) begin
        clk_cnt <= 32'b0;
        clk <= 1'b0;
    end
    else
    begin
        if(clk_cnt == CNTM)
            begin
                clk_cnt <= 32'b0;
                clk <= ~clk;
            end
        else
            clk_cnt <= clk_cnt + 1'b1;
    end

 //----------------------------------------------------------   
always @(posedge clk or posedge rst) begin
    if(rst)
        wei_ctrl <= 4'b0001;
    else
        wei_ctrl <= {wei_ctrl[2:0],wei_ctrl[3]};
end
    
always @(wei_ctrl) begin
    case(wei_ctrl)
        4'b1000:duan_ctrl = data[3:0];
        4'b0100:duan_ctrl = data[7:4];
        4'b0010:duan_ctrl = data[8:11];
        4'b0001:duan_ctrl = data[15:12];
        default:duan_ctrl = 4'hF;
    endcase
end

//----------------------------------------------------------

always @(wei_ctrl) begin
    case(duan_ctrl)
        4'd0:duan = 8'b1100_0000;//0
        4'd1:duan = 8'b1111_1001;//1 or I
        4'd2:duan = 8'b1010_0100;//2
        4'd3:duan = 8'b1011_0000;//3
        4'd4:duan = 8'b1001_1001;//4
        4'd5:duan = 8'b1001_0010;//5
        4'd6:duan = 8'b1000_0010;//6
        4'd7:duan = 8'b1111_1000;//7
        4'd8:duan = 8'b1000_0000;//8
        4'd9:duan = 8'b1001_0000;//9
        4'd10:duan = 8'b1011_1111;//-
        4'd11:duan = 8'b1100_1111;//|
        4'd12:duan = 8'b1000_1110;//F
        4'd13:duan = 8'b1000_1000;//A
        4'd14:duan = 8'b1100_0111;//L
        4'd15:duan = 8'b1111_1111;//
        default:duan = 8'b1111_1111;//0
    endcase
end


//----------------------------------------------------------
    assign sm_wei = wei_ctrl;
    assign sm_duan = duan;
    
    
endmodule
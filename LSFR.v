
module random_num_generate(
    input clk,
    input rst,
    input i_pause,
    output [12:0] o_randomNum
)

reg pause;
reg [12:0] LFSR;
reg [12:0] randomNum;

wire feedback = LFSR[12] ^ LFSR[3] ^ LFSR[2] ^ LFSR[0];
//LFSR[12] ^ LFSR[11] ^ LFSR[10] ^ LFSR[7];

always @(posedge clk or posedge rst) begin
    if(rst) begin
        pause <= 1'b0;
    end
    else if(i_pause) begin
        pause <= 1'b1;
    end
    else begin
        pause <= pause;
    end
end


always @(posedge clk or posedge rst) begin
    if(rst) begin
        LFSR <= 13'b1;
    end
    else if(pause) begin
        LFSR <= LFSR;
    end
    else begin
        LFSR <= {LFSR[11:0], feedback};
    end
end
/*
always @(posedge clk or posedge rst) begin
    if(rst) begin
        randomNum <= 13'b1;
    end
    else if(LSFR > 13'd4500) begin
        randomNum <= randomNum;
    end
    else begin
        randomNum <= LSFR + 13'd500;
    end
end

assign o_randomNum = randomNum;
*/

assign o_randomNum = LFSR + 13'd500;

endmodule
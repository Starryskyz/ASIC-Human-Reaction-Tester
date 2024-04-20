
module debouncer#(
    parameter CNTMAX = 25'd2500000 //for 125MHz clock, 20ms
)
(
    input clk,
    input rst,
    input i_signal,
    output reg o_signal
);

reg [24:0] cnt;
//reg signalAfterDebounce;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        cnt <= 25'b0;
        o_signal <= 1'b0;
    end
    else if(!i_signal) begin
        cnt <= 25'b0;
        o_signal <= 1'b0;
    end
    else if(cnt == CNTMAX) begin
        cnt <= cnt;
        o_signal <= 1'b1;
    end
    else begin
        cnt <= cnt + 25'b1;
        o_signal <= 1'b0;
    end
end

endmodule
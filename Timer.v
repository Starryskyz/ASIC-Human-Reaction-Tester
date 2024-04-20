
module timer#(
    parameter CNTM = 10'd125,
    parameter CNTM_US = 10'd999,
    parameter CNTM_MS = 10'd999,
)
(
    input clk,
    input rst,
    input i_en,
    output [14:0] o_timer_ms,
);
reg [9:0] cnt;
reg [14:0] cnt_ms;
reg [9:0] cnt_us;


always @(posedge clk or posedge rst) begin
    if(rst)
        cnt <= 10'b0;
    else if(i_en) begin
        if(cnt == CNTM)
            cnt <= 10'b0;
        else
            cnt <= cnt + 10'b1;
        end
    else
        cnt <= cnt;
end
//count for us
always @(posedge clk or posedge rst) begin
    if(rst)
        cnt_us <= 10'b0;
    else if(i_en) begin
        if(cnt == CNTM && cnt_us == CNTM_US)
            cnt_us <= 10'b0;
        else if(cnt == CNTM)
            cnt_us <= cnt_us + 10'b1;
        else
            cnt_us <= cnt_us;
        end
    else
        cnt_us <= cnt_us;
end
//count for ms
always @(posedge clk or posedge rst) begin
    if(rst)
        cnt_ms <= 15'b0;
    else if(i_en) begin
        if(cnt == CNTM && cnt_us == CNTM_US)
            cnt_ms <= cnt_ms + 15'b1;
        else
            cnt_ms <= cnt_ms;
        end
    else
        cnt_ms <= cnt_ms;
end


assign o_timer_ms = cnt_ms;

endmodule
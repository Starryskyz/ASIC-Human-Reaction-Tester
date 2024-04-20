
module topt(
    input clk,
    input rst,
    input start,
    input response,
    output [3:0] sm_wei,
    output [7:0] sm_duan
);

wire start_debounced;
wire response_debounced;
wire random_num;
wire timer_en;
wire [2:0] FSM_state;
wire [14:0] timer_ms;
wire [13:0] response_time;
wire [15:0] response_time_bcd;





debouncer inst1(
    .clk(clk),
    .rst(rst),
    .i_signal(start),
    .o_signal(start_debounced)
);

debouncer inst2(
    .clk(clk),
    .rst(rst),
    .i_signal(response),
    .o_signal(response_debounced)
);

LSFR inst3(
    .clk(clk),
    .rst(rst),
    .i_pause(start_debounced),
    .o_randomNum(random_num)
);

timer inst4(
    .clk(clk),
    .rst(rst),
    .i_en(timer_en),
    .o_timer_ms(timer_ms)
);


FSM inst5(
    .clk(clk),
    .rst(rst),
    .i_start(start_debounced),
    .i_response(response_debounced),
    .i_random_num(random_num),
    .i_timer(timer_ms),
    .o_state(FSM_state),
    .o_timer_en(timer_en),
    .o_response_time(response_time)
);

binToBCD inst6(
    //.clk(clk),
    //.rst(rst),
    .i_data_bin(response_time),
    .o_data_bcd(response_time_bcd)
);


segment_display inst7(
    .clk(clk),
    .rst(rst),
    .i_data_timer(response_time_bcd),
    .state(FSM_state),
    .sm_wei(sm_wei),
    .sm_duan(sm_duan)
);


endmodule
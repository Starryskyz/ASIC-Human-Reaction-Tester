
module FSM (
    input clk,
    input rst,
    input i_start,
    input i_response,
    input [12:0] i_random_num,
    input [12:0] i_timer,
    output [2:0] o_state,
    output o_timer_en,
    output [13:0] o_response_time,

);
    
parameter IDLE = 3'b000;
parameter WAIT = 3'b001;
parameter TEST = 3'b010;
parameter DONE = 3'b011;
parameter FAIL = 3'b100;

reg [2:0] state, nextState;

/*
reg i_start_r;
reg [12:0] randomNum;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        i_start_r <= 1'b0;
    end
    else begin
        i_start_r <= i_start;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        randomNum <= 13'b0;
    end
    else if((i_start ^ i_start_r) && i_start) begin
        randomNum <= i_random_num;
    end
    else begin
        randomNum <= randomNum;
    end
end
*/




always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
    end
    else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        //IDLE
        IDLE:
        if(i_start) begin
            nextState = WAIT;
        end
        else if(i_response) begin
            nextState = FAIL;
        end
        else begin
            nextState = IDLE;
        end
        //WAIT
        WAIT:
        if(i_timer > i_random_num) begin
            nextState = TEST;
        end
        else if(i_response) begin
            nextState = FAIL;
        end
        else begin
            nextState = WAIT;
        end
        //TEST
        TEST://need to add bit width
        if((i_response && i_timer < (i_random_num+'d100)) || i_timer > (i_random_num+'d9999)) begin
            nextState = FAIL;
        end
        else if(i_response) begin
            nextState = DONE;
        end
        else begin
            nextState = TEST;
        end
        //DONE
        DONE:
            nextState = DONE;
        //FAIL
        FAIL:
            nextState = FAIL;
        default:
            nextState = IDLE;
    endcase
end

always @(*) begin
    case(state)
        IDLE:
        begin
            o_timer_en = 1'b0;
            o_response_time = 13'b0;
        end
        WAIT:
        begin
            o_timer_en = 1'b1;
            o_response_time = 13'b0;
        end
        TEST:
        begin
            o_timer_en = 1'b1;
            o_response_time = i_timer - i_random_num;
        end
        DONE:
        begin
            o_timer_en = 1'b0;
            o_response_time = i_timer - i_random_num;
        end
        FAIL:
        begin
            o_timer_en = 1'b0;
            o_response_time = 13'b0;
        end
        default:
        begin
            o_timer_en = 1'b0;
            o_response_time = 13'b0;
        end
    endcase
end

assign o_state = state;


endmodule

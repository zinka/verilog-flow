/*
 ******************************************************************************
 * @file  	:
 * @project :
 * @brief   :
 * @creator : S. R. Zinka
 ******************************************************************************
 * This program is hereby granted to the public domain.
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.
 ******************************************************************************
 */

`default_nettype none

module txuart2 
    #(
        parameter [23:0] CLOCKS_PER_BAUD = 24'd68
    )(
    output reg o_busy,           // busy signal
    output reg o_uart_tx,        // one clock delayed version of lcl_data[0]
    input wire i_clk,            // clock
    input wire [7:0] i_data,     // input byte
    input wire i_reset,          // reset
    input wire i_wr              // write enable
);
    
    /*
    ***************************************************************************
    * state machine
    ***************************************************************************
    */

    // state indices
    localparam 
    IDLE  = 2'b00, 
    START = 2'b01, 
    TX    = 2'b10; 

    // state registers
    reg [1:0] state;
    reg [1:0] nextstate;

    // local registers
    reg baud_stb;     // baud strobe
    reg [23:0] count; // counter for baud clock
    reg [8:0] lcl_data; // internal right-shift register
    reg [3:0] tx_count; // no of bits txed

    // initial values
    initial baud_stb = 1'b0;
    initial count[23:0] = CLOCKS_PER_BAUD;
    initial lcl_data[8:0] = 9'h1ff;
    initial o_busy = 1'b0;
    initial o_uart_tx = 1'b1;
    initial tx_count[3:0] = 4'b0;
    initial state = IDLE;

    // comb always block
    always @* begin
        nextstate = 2'bxx; // default_state_is_x
        case (state)
            IDLE : if        ((i_wr) && (!o_busy))                      nextstate = START;
            START: if        (baud_stb)                                 nextstate = TX;
                     else                                               nextstate = START;
            TX   : if        ((tx_count == 10) && baud_stb && i_wr)     nextstate = START;
                     else if ((tx_count == 10) && baud_stb && (!i_wr))  nextstate = IDLE;
                     else                                               nextstate = TX;
            default :                                                   nextstate = IDLE; // undefined_states_go_here
        endcase
    end

    // state sequential always block
    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset)
            state <= IDLE;
        else
            state <= nextstate;
    end

    // datapath sequential always block
    // verilator lint_off CASEINCOMPLETE
    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin
            baud_stb <= 1'b0;
            count[23:0] <= CLOCKS_PER_BAUD;
            lcl_data[8:0] <= 9'h1ff;
            o_busy <= 1'b0;
            o_uart_tx <= 1'b1;
            tx_count[3:0] <= 4'b0;
        end
        else begin
            baud_stb <= (count== 24'h1)? 1 : 0; // default
            count[23:0] <= (!baud_stb)? (count-1) : CLOCKS_PER_BAUD; // default
            lcl_data[8:0] <= 9'h1ff; // default
            o_busy <= 1'b1; // default
            o_uart_tx <= 1'b1; // default
            tx_count[3:0] <= (baud_stb)? (tx_count+1) : tx_count; // default
            case (nextstate)
                IDLE : begin
                              baud_stb <= 1'b0;
                              count[23:0] <= CLOCKS_PER_BAUD;
                              o_busy <= 1'b0;
                              tx_count[3:0] <= 4'b0;
                end
                START: begin
                              lcl_data[8:0] <= (!o_busy)?{i_data, 1'b0} : lcl_data;
                              o_busy <= ((tx_count==10) && baud_stb)? 1'b0 : 1'b1;
                              o_uart_tx <= 1'b0;
                              tx_count[3:0] <= 4'b1;
                end
                TX   : begin
                              count[23:0] <= (!baud_stb)? (count-1) : (CLOCKS_PER_BAUD-1);
                              lcl_data[8:0] <= (baud_stb)? {1'b1, lcl_data[8:1]} : lcl_data;
                              o_uart_tx <= lcl_data[0];
                end
            endcase
        end
    end
    // verilator lint_on CASEINCOMPLETE

    // This code allows you to see state names in simulation
    // verilator lint_off UNUSED
    `ifndef SYNTHESIS
    reg [39:0] statename;
    always @* begin
        case (state)
            IDLE :   statename = "IDLE";
            START:   statename = "START";
            TX   :   statename = "TX";
            default: statename = "XXXXX";
        endcase
    end
    `endif
    // verilator lint_on UNUSED

    // fizzim code generation ends

    /*
    ***************************************************************************
    * user code
    ***************************************************************************
    */
endmodule
module ControlUnit(
    input clock,              
    input reset,            
    output reg [1:0] state  
);
    
    parameter F = 2'b00;
    parameter D = 2'b01;
    parameter E = 2'b10;
    parameter WB = 2'b11;

    always @(posedge clock) begin
        if (reset) begin
            state <= F; 
        end else begin
            case (state)
                F: state <= D;
                D: state <= E;
                E: state <= WB;
                WB: state <= F;
                default: state <= F;
            endcase
        end
    end

endmodule

module ControlUnit_tb;
    reg clock;
    reg reset;
    wire [1:0] state;
    
    reg [8*9:1] state_name;

    ControlUnit init (
        .clock(clock),
        .reset(reset),
        .state(state)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock; 
    end
    
    always @(*) begin
        state_name = get_name(state);
    end

    initial begin
        $monitor( "State: %b (%s)" , state, state_name);
        #40;
        $finish;
    end
    
    function  [8*9:1]  get_name;
    input [1:0] state;
    case (state)
        2'b00: get_name = "FETCH";
        2'b01: get_name = "DECODE";
        2'b10: get_name = "EXECUTE";
        2'b11: get_name = "WRITEBACK";  
        default: get_name = "UNKNOWN";
    endcase 
endfunction
    
    
endmodule

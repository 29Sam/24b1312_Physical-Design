module fa (
    input  wire clk,
    input  wire a,
    input  wire b,
    input  wire cin,
    output reg  sum,
    output reg  cout
);

    wire sum_c;
    wire cout_c;

    // Combinational full-adder logic
    assign {cout_c, sum_c} = a + b + cin;

    // Registered outputs
    always @(posedge clk) begin
        sum  <= sum_c;
        cout <= cout_c;
    end

endmodule

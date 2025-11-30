//As the adder is mainly composed of two units we first create them. The black and gray cell.
//---------------------------------------------------------------------
module black_cell(GP1, GP2, GPout);
    input  [1:0] GP1, GP2;
    output [1:0] GPout;

    assign GPout[0] = GP1[0] | (GP1[1] & GP2[0]);
    assign GPout[1] = GP1[1] & GP2[1];
endmodule

// --------------------------------------------------------------------
module gray_cell(GP1, GP2, Gout);
    input  [1:0] GP1, GP2;
    output Gout;

    assign Gout = GP1[0] | (GP1[1] & GP2[0]);
endmodule
// ------------------------------------------------------------------
//This is our adder, which has two 16-bit inputs 'a' and 'b' and a carry_in 'c_in'. Outputs are sum and cout
module ks_adder (
    input [15:0] a,
    input [15:0] b,
    input cin,
    input clk,
    input rst_n,
    output reg [15:0] sum,
    output reg cout
);
//Notice we are creating these registers. We will do all our work with them. The input values will be latched to them at every posedge of the clk.
    reg [15:0] a_reg;
    reg [15:0] b_reg;
    reg  cin_reg;
    wire [15:0] g;
    wire [15:0] p;
    wire [15:0] sum_int;
    wire cout_int;
    wire [1:0] stage [0:4][15:0];

//First we calculate p and g as XOR & AND of inouts

    assign p = a_reg ^ b_reg;
    assign g = a_reg & b_reg;

//

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : init_stage
            assign stage[0][i] = {p[i], g[i]};
        end
    endgenerate

    // We know ks_adder takes log2n time so for a 16-bit adder, we need log2(16) = 4 stages

    genvar k, j;
    generate
        for (k = 1; k <= 4; k = k + 1) begin : stages// k = 1 to 4 => 4 stages
            for (j = 0; j < 16; j = j + 1) begin : stage_cells
            // At each stage, a bit 'j' looks back a certain distance (2^(k-1)) to combine with other group.
            // If it's too close to the LSB, it doesn't have a group to combine with,so it just passes its value
                if (j >= (1 << (k-1))) begin
                    black_cell bc (
                        .GP1(stage[k-1][j]),
                        .GP2(stage[k-1][j-(1 << (k-1))]),
                        .GPout(stage[k][j])
                    );
                end 
                else begin
                // Pass the value to the next stage unchanged.
                    assign stage[k][j] = stage[k-1][j];
                end
            end
        end
    endgenerate


    wire carry [0:15];

    // carry[0] is the carry into bit 0 is cin (used for sum[0])
    assign carry[0] = cin_reg;

    // For bits 1 to 16, we will compute carry into bit i using prefix of i-1
    // carry[i] = stage[4][i-1].G | (stage[4][i-1].P & cin)
    generate
        for (i = 1; i < 16; i = i + 1) begin : carry_gen
            assign carry[i] = stage[4][i-1][0] | (stage[4][i-1][1] & cin_reg);
        end
    endgenerate

    // final cout is carry into bit 16 = prefix for bit 15 combined with cin
    assign cout_int = stage[4][15][0] | (stage[4][15][1] & cin_reg);

    //As we know after all the stages sum[i] = p[i] ^ carry[i]
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_gen
            assign sum_int[i] = p[i] ^ carry[i];
        end
    endgenerate


    always @(posedge clk or negedge rst_n)
    if (rst_n == 1'b0) //Active low reset
        begin
            a_reg <= 16'b0;
            b_reg <= 16'b0;
            cin_reg <= 1'b0;
            sum <= 16'b0;
            cout <= 1'b0;
        end

    else
    //if rst_n does not have negedge it means we have a clock posedge so this else statement will be used, which basically latched inouts to the registers to use.
        begin
            a_reg <= a;
            b_reg <= b;
            cin_reg <= cin;
            sum <= sum_int;
            cout <= cout_int;
        end

endmodule
//==========================================================================================

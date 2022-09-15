module ALU (
    input [7:0] a,
    input [7:0] b,
    input [3:0] SelALU,
    input aluControl,
    output [7:0] result,
    output cout,
    output zout
);

//Decare any necessary registers or wires
    reg [1:0] ALU_sel;
    reg [1:0] load_shift;
    reg [8:0] ALU_Result;
    reg Rcout;
    // reg rstoreResult;
    //reg Rzout = 0;
    //reg [8:0] Cout = 9'b100000000;
    // reg cout0;
    // reg zout0;
    // assign result = ALU_Result; // ALU out
    assign ALU_sel = SelALU[3:2];
    assign load_shift = SelALU[1:0];
    initial begin
        ALU_Result = 0;
        Rcout = 0;
    end
    //Complete this part to specify ALU behavior 
    always @(SelALU) 
    begin
    if (aluControl) 
    begin
        begin
            case (ALU_sel)
            2'b00:
            begin
                case(load_shift)
                2'b00: //RST
                begin
                    ALU_Result = 0;
                    // rstoreResult = ALU_Result;
                    Rcout = 0;

                end
                2'b01: //SHL
                begin
                    ALU_Result = a << 1;
                    // rstoreResult = ALU_Result;

                    Rcout = 0;
                end
                2'b10: //LD
                begin
                    ALU_Result = a;
                    // rstoreResult = ALU_Result;

                    Rcout = 0;
                end
                2'b11: //SHR
                begin
                    ALU_Result = a >> 1;
                    // rstoreResult = ALU_Result;

                    Rcout = 0;
                end
                endcase
            end
            2'b01://NOR
            begin
                ALU_Result = ~(a | b);
                    // rstoreResult = ALU_Result;

                Rcout = 0;
            end
            2'b10://ADD
            begin
                // {Rcout,ALU_Result} = a + b;
                ALU_Result = a + b;
                Rcout = ALU_Result[8];
                    // rstoreResult = ALU_Result;

            end
                
            2'b11://SUB
            begin
                ALU_Result = a - b;
                Rcout = ALU_Result[8];
                    // rstoreResult = ALU_Result;

            end
            endcase
        end
    end
    end
    // else 
    // begin
    //    ALU_Result = rstoreResult;
    // end


    assign result = ALU_Result[7:0];
    // assign storeResult = rstoreResult;
    assign zout = (ALU_Result == 0) ? 1'b1 : 1'b0;
    assign cout = Rcout;


endmodule
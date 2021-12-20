module test_module(); 
reg clk;
reg CLB;
wire [7:0] INST;
wire [7:0] PC;
wire [7:0] ACC;
reg [7:0] address1;
reg [7:0] address2;
reg[7:0]expectedPC;
reg[7:0] expectedACC;

reg [7:0] memory1[255:0];
reg [15:0] memory2[255:0];
initial begin
    clk = 0;
    $readmemh("test_assembly.hex", memory1);
    $readmemh("expect.txt", memory2);
	address1 = 0;
    address2 = 0;
    CLB = 0;
    #10;
    CLB = 1;

end

assign expectedPC = memory2[address2][15:8];
assign expectedACC = memory2[address2][7:0]; 
assign INST = memory1[address1];

always begin
    #5 clk = ~clk;
end

always @(posedge clk, posedge CLB) begin
    if (~CLB) begin
        address1 = 0;
        address2 = 0;
    end
    address1 = PC;
    address2 = address2 +1;
    if (expectedPC != PC ) 
        $error("WRONG PC: %h, ACC: %h, expectedPC: %h\n", PC, ACC, expectedPC);
    else if (expectedACC != ACC)
        $error("PC: %h, WRONG ACC: %h, expectedACC: %h\n", PC, ACC, expectedACC);

    else 
        $display($time,"RIGHT PC: %h, ACC: %h\n", expectedPC, expectedACC);


end


processor pror (
    .ACC(ACC),
    .PC(PC),
    .INST(INST),
    .CLK(clk),
    .CLB(CLB)
    );
endmodule


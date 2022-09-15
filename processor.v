module processor(
	output wire [7:0] ACC,
	output wire [7:0] PC,
	input wire [7:0] INST,
	input wire CLK,
	input wire CLB
);



	wire c;
	wire z;
	wire LoadIR;
	wire IncPC;
	wire SelPC;
	wire LoadPC;
	wire LoadReg;
	wire LoadAcc;
	wire aluControl;
	wire [1:0] SelAcc;
	wire [3:0] SelALU;
	wire [7:0] ALU_result;
	wire [7:0] I;
	wire [7:0] reg_out;
	wire [7:0] reg_in;
	reg [7:0] rACC;
	reg [7:0] rPC;




	always @(posedge CLK or CLB)
	begin
		if(CLB == 1'b0) begin
			rACC = 8'b0;
			rPC = 8'b0;
		end

	end
	// the first name is the module name(can't change), the second name is the variable name, (can change)
	//all the wire has to be the same name and same order 
	accmulator acc(
		.Acc(ACC),
		.aluIn(ALU_result),
		.regIn(reg_out),
		.imm(I[3:0]),
		.SelAcc(SelAcc),
		.clk(CLK),
		.CLB(CLB),	
		.LoadAcc(LoadAcc)
	);

	ALU alu1(
		.a(ACC),
		.b(reg_out),
		.SelALU(SelALU),
		.aluControl(aluControl),
		.result(ALU_result),
		.cout(c),
		.zout(z)
	);
	
	controller ctrl(
		.CLK (CLK),
		.CLB (CLB),
		.Opcode(I[7:4]),
		.z (z),
		.c (c),
		.aluControl(aluControl),
		.LoadIR(LoadIR),
		.IncPC(IncPC),
		.SelPC(SelPC),
		.LoadPC(LoadPC),
		.LoadReg(LoadReg),
		.LoadAcc(LoadAcc),
		.SelAcc(SelAcc),
		.SelALU(SelALU)

	);

	IR ir1(
		.I(I),
		.clk(CLK),
		.CLB(CLB),
		.LoadIR(LoadIR),
		.Instruction(INST)
	);

	program_counter PC1(
		.address(PC),
		.regIn(reg_out),
		.imm(I[3:0]),
		.CLB(CLB),
		.clk(CLK),
		.IncPC(IncPC),
		.LoadPC(LoadPC),
		.selPC(SelPC)
	);

	reg_file reg_file1(
		.reg_out(reg_out),
		.reg_in(ACC),
		.RegAddr(I[3:0]),
		.clk(CLK),
		.CLB(CLB),
		.LoadReg(LoadReg)
	);



endmodule
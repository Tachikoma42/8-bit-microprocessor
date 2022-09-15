//accmulator
module accmulator(
output wire [7:0] Acc,

input wire [7:0] aluIn,
input wire [7:0] regIn,
input wire [3:0] imm,
input wire [1:0] SelAcc,
input wire clk,
input wire CLB,	
input wire LoadAcc
);

reg [7:0] rAcc;

assign Acc = rAcc;

always @(posedge clk or CLB)
begin
	if(CLB == 1'b0) begin
		rAcc <= 8'b0;
	end
	else begin
		if (LoadAcc == 1'b1) begin
			//1B0A
			//When sel is high select B else select A
			rAcc <= SelAcc[1]?aluIn:SelAcc[0]?regIn:{4'b0, imm};
		end
	end
end

endmodule
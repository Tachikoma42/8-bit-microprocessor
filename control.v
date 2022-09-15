module controller(
    input wire CLK,
    input wire CLB,
    input wire [3:0]Opcode,
    input wire z,
    input wire c,
    output wire aluControl, //
    output wire LoadIR,
    output wire IncPC,
    output wire SelPC,
    output wire LoadPC,
    output wire LoadReg,
    output wire LoadAcc,
    output wire [1:0]SelAcc,
    output wire [3:0]SelALU

);
    parameter FETCH = 1'b0,EXECUTE = 1'b1;
    reg current_st, next_st;
        reg raluControl;
        reg rLoadIR;
        reg rIncPC;
        reg rSelPC;
        reg rLoadPC;
        reg rLoadReg;
        reg rLoadAcc;
        reg [1:0]rSelAcc;
        reg [3:0]rSelALU;
        reg jumpCheck;
        assign LoadIR = rLoadIR;
        assign IncPC = rIncPC;
        assign SelPC = rSelPC;
        assign LoadPC = rLoadPC;
        assign LoadReg = rLoadReg;
        assign LoadAcc = rLoadAcc;
        assign SelAcc = rSelAcc;
        assign SelALU = rSelALU;
        assign aluControl = raluControl;

        initial begin
            jumpCheck=0;
        end
    always @(posedge CLK or CLB) begin
        if (~CLB) begin
                raluControl = 0;
                rLoadIR = 0;
                rIncPC = 0;
                rSelPC = 0;
                rLoadPC = 0;
                rLoadReg = 0;
                rLoadAcc = 0;
                rSelAcc[1:0] = 2'b00;
                rSelALU[3:0] = 4'b0000;
                current_st = FETCH; 
                jumpCheck = 0;
        end
        else begin
            current_st <= next_st;

        end
    end

    always @(*) begin
        case(current_st)
            FETCH:begin
                raluControl = 0;
                rIncPC = 0;
                rSelPC = 0;
                rLoadPC = 0;
                rLoadReg = 0;
                rLoadAcc = 0;
                rSelAcc[1:0] = 2'b00;
                rSelALU[3:0] = 4'b0000;
                rLoadIR = 0;
                next_st = EXECUTE;

            end
            EXECUTE:begin
                case (Opcode)
                    4'b0000:begin
                            //nop
                        raluControl = 1;
                        
                        rIncPC = 1;
                        rSelPC = 0;
                        rLoadPC = 0;
                        rLoadReg = 0;
                        rLoadAcc = 0;
                        rSelAcc[1:0] = 2'b00;
                        rSelALU[3:0] = 4'b0000;

                        rLoadIR = 1;
                        next_st = FETCH;
                        end
                    4'b0001:begin
                            //add rs
                        raluControl = 1;

                        rIncPC = 1;
                        rSelPC = 0; // no care
                        rLoadPC = 0;
                        rLoadReg = 0;
                        rLoadAcc = 1;
                        rSelAcc[0] = 1; // no care
                        rSelAcc[1] = 1;
                        rSelALU = 4'b1000;

                        rLoadIR = 1;
                        next_st = FETCH;
                        end
                    4'b0010:begin
                        //sub rs
                        raluControl = 1;

                        
                        rIncPC = 1;
                        rSelPC = 0; // no care
                        rLoadPC = 0;
                        rLoadReg = 0;
                        rLoadAcc = 1;
                        rSelAcc[0] = 1; // no care
                        rSelAcc[1] = 1;
                        rSelALU = 4'b1100;

                        rLoadIR = 1;
                        next_st = FETCH;
                    end
                    4'b0011:begin
                        //nor
                        raluControl = 1;

                        rIncPC = 1;
                        rSelPC = 0; // no care
                        rLoadPC = 0;
                        rLoadReg = 0;
                        rLoadAcc = 1;
                        rSelAcc[0] = 1; // no care
                        rSelAcc[1] = 1;                
                        rSelALU = 4'b0100;

                        rLoadIR = 1;
                        next_st = FETCH;
                    end

                    4'b0100:begin
                        //movr
                        raluControl = 0;

                        rIncPC = 1;
                        rSelPC = 0; // no care
                        rLoadPC = 0;
                        rLoadReg = 0;
                        rLoadAcc = 1;
                        rSelAcc[0] = 1;
                        rSelAcc[1] = 0;
                        rSelALU[3:0] = 4'b0000;
                        
                        rLoadIR = 1;
                        next_st = FETCH;
                    end
                    4'b0101:begin
                        //mova
                        raluControl = 0;

                        rIncPC = 1;
                        rSelPC = 0; // no care
                        rLoadPC = 0;
                        rLoadReg = 1;
                        rLoadAcc = 0; // 
                        rSelAcc[1:0] = 2'b00;
                        rSelALU[3:0] = 4'b0000;
                        
                        rLoadIR = 1;
                        next_st = FETCH;
                    end
                    4'b0110:begin
                        //jz rs
                        if (z == 1) begin
                            raluControl = 0;

                            rSelPC = 1;
                            rLoadReg = 0;
                            rLoadAcc = 0;
                            rSelAcc[1:0] = 2'b00;
                            rSelALU[3:0] = 4'b0000;
                            if (jumpCheck==0) begin
                                rLoadPC = 1;
                                rLoadIR = 0;
                                jumpCheck = ~jumpCheck;
                                rIncPC = 0;
                                next_st = FETCH;   
                            end
                            else begin
                                rLoadPC = 0;
                                rLoadIR = 1;
                                jumpCheck = ~jumpCheck;
                                rIncPC= 1;
                                next_st = FETCH;

                            end
                        end
                        else begin
                            raluControl = 0;

                            rLoadPC = 0;
                            rIncPC = 1;
                            rSelPC = 0;
                            rLoadReg = 0;
                            rLoadAcc = 0;
                            rSelAcc[1:0] = 2'b00;
                            rSelALU[3:0] = 4'b0000;

                            rLoadIR = 1;
                            next_st = FETCH;
                        end
                    end

                    4'b0111:begin
                        //jz imm
                        if (z == 1) begin
                            raluControl = 0;

                            rSelPC = 0;
                            rLoadReg = 0;
                            rLoadAcc = 0;
                            rSelAcc[1:0] = 2'b00;
                            rSelALU[3:0] = 4'b0000;

                            if (jumpCheck==0) begin
                                rLoadIR = 0;
                                jumpCheck = ~jumpCheck;
                                rIncPC= 0;
                                rLoadPC= 1;

                                next_st = FETCH;   
                            end
                            else begin
                                rLoadPC= 0;
                                rIncPC= 1;
                                rLoadIR = 1;
                                jumpCheck = ~jumpCheck;
                                next_st = FETCH;
                            end
                        end
                        else begin
                            raluControl = 0;

                            rIncPC = 1;
                            rSelPC = 0;
                            rLoadPC = 0;
                            rLoadReg = 0;
                            rLoadAcc = 0;
                            rSelAcc[1:0] = 2'b00;
                            rSelALU[3:0] = 4'b0000;

                            rLoadIR = 1;
                            next_st = FETCH;
                        end
                    end

                    4'b1000:begin
                        //jc rs
                        if (c == 1) begin
                            raluControl = 0;

                            rSelPC= 1;
                            rLoadReg = 0;
                            rLoadAcc = 0;
                            rSelAcc[1:0] = 2'b00;
                            rSelALU[3:0] = 4'b0000;

                            if (jumpCheck==0) begin
                                rIncPC= 0;
                                rLoadPC= 1;
                                rLoadIR = 0;
                                jumpCheck = ~jumpCheck;
                                next_st = FETCH;   
                            end
                            else begin
                                rIncPC= 1;
                                rLoadPC= 0;
                                rLoadIR = 1;
                                jumpCheck = ~jumpCheck;
                                next_st = FETCH;
                            end
                        end
                        else begin
                            raluControl = 0;

                            rIncPC = 1;
                            rSelPC= 0;
                            rLoadPC = 0;
                            rLoadReg = 0;
                            rLoadAcc = 0;
                            rSelAcc[1:0] = 2'b00;
                            rSelALU[3:0] = 4'b0000;

                            rLoadIR = 1;
                            next_st = FETCH;
                        end
                    end

                    4'b1010:begin
                        //jc imm
                        if (c == 1) begin
                            raluControl = 0;

                            rSelPC = 0;
                            rLoadReg = 0;
                            rLoadAcc = 0;
                            rSelAcc[1:0] = 2'b00;
                            rSelALU[3:0] = 4'b0000;

                            if (jumpCheck==0) begin
                                rLoadIR = 0;
                                rLoadPC= 1;
                                rIncPC= 0;
                                jumpCheck = ~jumpCheck;
                                next_st = FETCH;   
                            end
                            else begin
                                rLoadIR = 1;
                                rLoadPC= 0;
                                rIncPC= 1;
                                jumpCheck = ~jumpCheck;
                                next_st <= FETCH;
                            end
                        end
                        else begin
                            raluControl = 0;

                            rIncPC = 1;
                            rSelPC= 0;
                            rLoadPC = 0;
                            rLoadReg = 0;
                            rLoadAcc = 0;
                            rSelAcc[1:0] = 2'b00;
                            rSelALU[3:0] = 4'b0000;

                            rLoadIR = 1;
                            next_st = FETCH;
                        end
                    end


                    4'b1011:begin
                        //shl      
                        raluControl = 1;

                        rIncPC = 1;
                        rSelPC = 0; // no care
                        rLoadPC = 0;
                        rLoadReg = 0;
                        rLoadAcc =1;
                        rSelAcc[0] = 1; // no care
                        rSelAcc[1] = 1;
                        rSelALU = 4'b0001;
                        rLoadIR = 1;
                        next_st = FETCH;
                    end

                    4'b1100:begin
                        //shr
                        raluControl = 1;

                        rIncPC = 1;
                        rSelPC = 0; // no care
                        rLoadPC = 0;
                        rLoadReg = 0;
                        rLoadAcc = 1;
                        rSelAcc[0] = 1; // no care
                        rSelAcc[1] = 1;
                        rSelALU = 4'b0011;

                        rLoadIR = 1;
                        next_st = FETCH;
                    end

                    4'b1101:begin
                        //ld
                        raluControl = 0;

                        rIncPC = 1;
                        rSelPC = 0;
                        rLoadPC = 0;
                        rLoadReg = 0;
                        rLoadAcc = 1;
                        rSelAcc[0] = 0;
                        rSelAcc[1] = 0;
                        rSelALU[3:0] = 4'b0000;

                        rLoadIR = 1;
                        next_st = FETCH;
                    end
                    
                    4'b1111:begin
                        //halt
                        raluControl = 0;

                        rIncPC = 0;
                        rSelPC = 0;
                        rLoadPC = 0;
                        rLoadReg = 0;
                        rLoadAcc = 0;
                        rSelAcc[1:0] = 2'b00;
                        rSelALU[3:0] = 4'b0000;
                        $stop;
                    end
                
                endcase
            end
        endcase

    end
endmodule
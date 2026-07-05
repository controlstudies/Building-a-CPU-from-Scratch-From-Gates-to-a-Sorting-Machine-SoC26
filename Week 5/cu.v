module cu(
input [23:0] opcoderes,
input [1:0] Ry,Rx,
 input flagz, flagc, flago,
output reg c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18

); 
 always @(*) begin
 c1 = 0; c2 = 0; c3 = 0; c4 = 0; c5 = 0; c6 = 0; c7 = 0; c8 = 0; c9 = 0; 
        c10= 0; c11= 0; c12= 0; c13= 0; c14= 0; c15= 0; c16= 0; c17= 0; c18= 0;
			
			case(opcoderes)
			1 : c3 = 1; // pc write en 
			2 : begin c1 = 1; c3 =1; c15 =1; end //instruct write,pc en,Alu resut mux
			4 : begin c1=1; c3=1; c4=Rx[1];c5 =Rx[0]; end
			8 : begin c3=1; c16=1; c17=1; end
			16 : begin c3=1; c4=Rx[1];c5=Rx[0]; c16=1; c17=1; end
			32 : begin c3=1; c6=Ry[1];c7=Ry[0]; c8=Rx[1];c9=Rx[0]; c10=1; end
			64 : begin c3=1; c8=Rx[1];c9=Rx[0]; c10=1; c11=1; c12=1; c13=1; c15=1; end
			128 : begin c3=1; c4=Rx[1];c5=Rx[0]; c6=Ry[1];c7=Ry[0]; c8=Rx[1];c9=Rx[0]; c10=1; c14=1; end
			256 : begin c3=1; c4=Rx[1];c5=Rx[0]; c8=Rx[1];c9=Rx[0]; c10=1; c11=1; c14=1; end
			512 : begin c3=1; c4=Rx[1];c5=Rx[0]; c6=Ry[1];c7=Ry[0]; c8=Rx[1];c9=Rx[0]; c10=1; c12=1; c14=1; end
			1024 : begin c3=1; c4=Rx[1];c5=Rx[0]; c8=Rx[1];c9=Rx[0]; c10=1; c11=1; c12=1; c14=1; end
			2048 : begin c3=1; c8=Rx[1];c9=Rx[0]; c10=1; c18=1; end
			4096 : begin c3=1; c4=Ry[1];c5=Ry[0]; c8=Rx[1];c9=Rx[0]; c10=1; c18=1;c11=1; end
			8192 : begin c3=1; c6=Rx[1];c7=Rx[0]; c17=1; end
			16384 : begin c3=1; c4=Ry[1];c5=Ry[0]; c6=Rx[1];c7=Rx[0]; c17=1;c11=1; end
			32768 : begin c3=1; c4=Rx[1];c5=Rx[0]; c8=Rx[1];c9=Rx[0]; c10=1; c12=1; c13=1; c14=1; end
			65536 : begin c3=1; c4=Rx[1];c5=Rx[0]; c8=Rx[1];c9=Rx[0]; c10=1; c12=1; c13=1; c14=1; end
			131072 : begin c3=1; c4=Rx[1];c5=Rx[0]; c6=Ry[1];c7=Ry[0]; c12=1; c14=1; end
			262144 : begin c2=1; c3=1; end
			524288 : begin if(flagz) c2=1; c3=1; end // BRE/BRZ
         1048576 : begin if(!flagz) c2=1; c3=1; end // BRNE/BRNZ
         2097152 : begin if(!flagz && !flagc) c2=1; c3=1; end // BRG 
         4194304 : begin if(!flagc) c2=1; c3=1; end // BRGE
			endcase
	end
endmodule
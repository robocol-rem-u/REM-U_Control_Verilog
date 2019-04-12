//Salidas de RGB con colores pre-programados
module ModuloControlRGB(RPM_RGB, PWM_R, PWM_G, PWM_B, FPGA_CLK1_50);

input [7:0] RPM_RGB;//Color solicitado por la base
input FPGA_CLK1_50;
output [7:0] PWM_R;//Salida R
output [7:0] PWM_G;//Salida G
output [7:0] PWM_B;//Salida B

reg apagarR = 1;//Indica si apagar el color
reg apagarG = 0;//Indica si apagar el color (inicia el verde encendido)
reg apagarB = 1;//Indica si apagar el color

reg dimmerR = 0;
reg dimmerG = 1;
reg dimmerB = 0;


dimmer dim1(FPGA_CLK1_50, apagarR, PWM_R, dimmerR);//Dimmers para cada senal, permiten parpadear con efecto los colores
dimmer dim2(FPGA_CLK1_50, apagarG, PWM_G, dimmerG);//La ultima entrada indica si se debe mantener sostenido el color o no
dimmer dim3(FPGA_CLK1_50, apagarB, PWM_B, dimmerB);


always@(posedge FPGA_CLK1_50)
begin
	if(RPM_RGB == 1)//Caso 1
	begin
		apagarR <= 0;//El rojo se mantiene encendido (tiene dimmer)
		apagarG <= 1;
		apagarB <= 1;
		dimmerR<=0;
		dimmerG<=1;
		dimmerB<=0;
	end
	else
	begin
		if(RPM_RGB == 0)//Caso 2
			begin
				apagarR <= 1;
				apagarG <= 0;//El verde se mantiene encendido
				apagarB <= 1;
				dimmerR<=0;
				dimmerG<=1;
				dimmerB<=0;
			end
		else
			begin
				if(RPM_RGB == 2)
					begin
						apagarR <= 1;
						apagarG <= 1;
						apagarB <= 0;//El azul se mantiene encendido (tiene dimmer)
						dimmerR<=0;
						dimmerG<=1;
						dimmerB<=0;
					end
				else
					begin //ROJO
					
						apagarR <= 0;//El rojo se mantiene encendido (tiene dimmer)
						apagarG <= 1;
						apagarB <= 1;
						dimmerR<=0;
						dimmerG<=1;
						dimmerB<=0;
					
					end
				
			end
	end
end



endmodule

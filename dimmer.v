//Realiza el efecto de dimmer en los RGB
module dimmer(clock, apagar, dimmerActual, sostener);

input clock;
input apagar;//Indica si apagar ese color
input sostener;//Indica si realizar el efecto o no
output [7:0] dimmerActual; //Salida a PWM


reg [7:0] dimmerActual = 0;
wire flag;
reg subiendo = 1;//Indica si la luminosidad esta subiendo o bajando (rebota)

contador c(0, clock, 300000, flag);//Contador auxiliar para modular el tiempo de rebote de la luz


always@(posedge clock)
begin

	if(flag==1'b1 && dimmerActual < 249 && subiendo)//Caso en el que la luminosidad debe subir
		dimmerActual<=dimmerActual+1;
	else
		begin
			if(flag==1'b1 && dimmerActual == 249 && subiendo && !sostener)//Caso en el que se termino de subir (si se debe sostener no sale de aqui)
				subiendo <=0;
			else
				begin
					if(flag==1'b1 && dimmerActual > 0 && !subiendo)//Caso en el que la luminosidad debe bajar
						dimmerActual<=dimmerActual-1;
					else
						begin
							if(flag==1'b1 && dimmerActual == 0 && !subiendo && !apagar)//Caso en el que se termino de bajar
								subiendo <= 1;
							else
								begin
									if(apagar==1'b1)//Caso en el que se debe apagar la luz
										begin
											dimmerActual <= 0;
											subiendo <= 1;
										end
									else//Caso default
										dimmerActual <= dimmerActual;
								end
									
						end
				end
		end
end



endmodule

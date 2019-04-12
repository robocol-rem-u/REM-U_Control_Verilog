module controladorPosicion(clock_control, ADC_actual, Angulo_objetivo, Senial_control, Dir, ON_OFF_SPEED, RELACION);

input clock_control;
input [11:0] ADC_actual;
input [11:0] Angulo_objetivo;
input [7:0] ON_OFF_SPEED;
input [7:0] RELACION;
output reg [7:0] Senial_control;
output reg Dir;

wire [11:0] Angulo_medido;
assign Angulo_medido = ( (72*ADC_actual)/(100*RELACION) ) - ( 1440/RELACION );




always @(posedge clock_control)
begin

//Controlador ON OFF con histeresis
if ((Angulo_objetivo-Angulo_medido) > 2)
	begin
		Senial_control <= ON_OFF_SPEED;
		Dir <= 0;
	end
else
	begin
		if ((Angulo_objetivo-Angulo_medido) < -2)
			begin
				Senial_control <= ON_OFF_SPEED;
				Dir <= 1;
			end
		else
			begin
				Senial_control <= 0;
				Dir <= 0;
			end
	end

end

endmodule

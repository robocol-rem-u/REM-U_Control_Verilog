//Modulo descargado de internet en emergencia antes de ERC
//Si alguien descubre como funciona, me cuenta

module control_servo(reset, clock, angulo, senial_control);


input reset;
input clock;
input [7:0] angulo;
output senial_control;


reg pwm_q, pwm_d;
reg [19:0] ctr_q, ctr_d;
assign senial_control = pwm_q;
  

always @(*)
begin
	ctr_d = ctr_q + 1'b1;
		if (angulo + 9'd165 > ctr_q[19:8])
			begin
				pwm_d = 1'b1;
			end 
		else
			begin
				pwm_d = 1'b0;
  			end
end

always @(posedge clock)
begin
	if (reset) 
		begin
			ctr_q <= 1'b0;
		end 
	else
		begin
			ctr_q <= ctr_d;
		end
	pwm_q <= pwm_d;
end



endmodule
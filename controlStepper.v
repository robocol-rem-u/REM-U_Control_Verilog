//CONTROL ANTIGUO DEL STEPPER, NO ESTA EN USO, SE UTILIZA SOLO SI NO HAY SHIELD //
//CONTROL ANTIGUO DEL STEPPER, NO ESTA EN USO, SE UTILIZA SOLO SI NO HAY SHIELD //
//CONTROL ANTIGUO DEL STEPPER, NO ESTA EN USO, SE UTILIZA SOLO SI NO HAY SHIELD //
//CONTROL ANTIGUO DEL STEPPER, NO ESTA EN USO, SE UTILIZA SOLO SI NO HAY SHIELD //

//Realiza la secuencia manual de giro en un stepper
module controlStepper(rst, clock, direccion, velocidad, senial_motor);

input rst;
input clock;
input direccion;
input [7:0] velocidad;
output [3:0] senial_motor;

reg [3:0] senial_motor;


parameter ESTADO_0=2'd0;
parameter ESTADO_1=2'd1;
parameter ESTADO_2=2'd2;
parameter ESTADO_3=2'd3;

reg [1:0] estado_actual=ESTADO_0;
reg [1:0] estado_futuro=ESTADO_0;

wire outCLK;

Prescaller pres1(rst, clock, outCLK, (25000000/velocidad));

//Logica secuencial
always@(posedge outCLK)
begin
	if(rst==1)
		estado_actual<=ESTADO_0;
	else
		begin
			if (velocidad==0)
				estado_actual<=estado_actual;
			else
				estado_actual<=estado_futuro;
		end
end

//Logica combinacional de estados
always@(*)
begin
case(estado_actual)
ESTADO_0:begin
				if(direccion==0)
					estado_futuro=ESTADO_1;
				else
					estado_futuro=ESTADO_3;
			end
ESTADO_1:begin
				if(direccion==0)
					estado_futuro=ESTADO_2;
				else
					estado_futuro=ESTADO_0;
			end
ESTADO_2:begin
				if(direccion==0)
					estado_futuro=ESTADO_3;
				else
					estado_futuro=ESTADO_1;
			end
ESTADO_3:begin
				if(direccion==0)
					estado_futuro=ESTADO_0;
				else
					estado_futuro=ESTADO_2;
			end
			

default:estado_futuro=ESTADO_0;
endcase
end

//Logica combinacional de salidas
always@(*)
begin
case(estado_actual)

ESTADO_0: senial_motor = 4'b1000;
ESTADO_1: senial_motor = 4'b0100;
ESTADO_2: senial_motor = 4'b0010;
ESTADO_3: senial_motor = 4'b0001;
default: senial_motor = 4'b0000;

endcase
end

endmodule

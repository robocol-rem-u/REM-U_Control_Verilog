//Prescaller con el caso especial del stepper (velocidad de 0, no hay division por 0 en verilog)
module prescaller_stepper(reset, clock, outCLK, cuentas);

//INPUTS AND OUTPUTS
input reset;//Reset
input clock;//Clock
input [27:0] cuentas;//cuentas a realizar (velocidad del stepper)
output outCLK;//Salida al pin de step

//REGS
reg salidaActual=0;//Salida
assign outCLK=salidaActual;//Asignacion de la salida

//WIRES
wire flag;
reg resetContador;

//MODULOS

contador contadorSubida(resetContador, clock, 2500000/cuentas, flag);//Contador de flancos, es inversamente proporcional a la velocidad del
//stepper, por lo que al aumentar la velocidad disminuye el tiempo en generar un nuevo flanco (va mas rapido el clock de salida)


//Logica secuencial MAQUINA DE ESTADOS
always@(posedge clock)
begin
	if(cuentas == 0)//Si la velocidad es 0, no envio flancos a la salida y reinicio el contador
		begin
			salidaActual<=0;
			resetContador<=1;
		end
	else //Si no, oscilo la salida para generar flancos a la velocidad deseada en el pin de step
		resetContador<=0;
			begin
				if(flag)
					salidaActual<=!salidaActual;
				else
					salidaActual<=salidaActual;
			end
end


endmodule

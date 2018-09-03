module butterfly #(parameter N = 2,
				DATA_WIDTH = 16)
				(input wire [DATA_WIDTH*2*N-1:0] cplx_data_in,
				input wire clk, en,
				output wire [DATA_WIDTH*2*N-1:0] cplx_data_out,
				output wire en_out);
reg en_o;
reg [DATA_WIDTH*2*N-1:0] data_in, data_out;
reg [DATA_WIDTH-1:0] weight_real[0:N/2-1], weight_imag[0:N/2-1];
reg [DATA_WIDTH*2-1:0] subtracted[0:N/2-1], added[0:N/2-1];
reg [DATA_WIDTH-1:0] subtracted_r[0:N/2-1], subtracted_i[0:N/2-1], added_r[0:N/2-1], added_i[0:N/2-1];

assign cplx_data_out = en_o ? data_out : {DATA_WIDTH*2*N{1'bZ}};
assign en_out = en_o;

genvar i;
generate
	for(i=0; i<N/2; i=i+1) begin : crossover
		always @(posedge clk) begin
			$display("i: %03d",i);
			$display("N: %03d",N);
			$display("DATA_WIDTH: %03d",DATA_WIDTH);
			$display(data_in[DATA_WIDTH*(2*i+1+N) -: DATA_WIDTH]);
			$display(data_in[DATA_WIDTH*(2*i+1)-1 -: DATA_WIDTH]);
			$display(data_in[3:0]);
			$display(DATA_WIDTH*(2*i+1));
			//subtracted[i] 	<= data_in[DATA_WIDTH*(2*i+1)-1 -: DATA_WIDTH] - data_in[DATA_WIDTH*(2*i+N+1)-1 -: DATA_WIDTH];
			subtracted_r[i] 	<= data_in[DATA_WIDTH*(2*i+1)-1 -: DATA_WIDTH] - data_in[DATA_WIDTH*(2*i+N+1)-1 -: DATA_WIDTH];
			subtracted_i[i]		<= data_in[DATA_WIDTH*(2*i+2)-1 -: DATA_WIDTH] - data_in[DATA_WIDTH*(2*i+N+2)-1 -: DATA_WIDTH];
			subtracted[i]   <= {subtracted_r[i], subtracted_i[i]};
			$display("subtracted[%03d] = %x", i, subtracted[i]);
			added_r[i] 		<= data_in[DATA_WIDTH*(2*i+1)-1 -: DATA_WIDTH] + data_in[DATA_WIDTH*(2*i+N+1)-1 -: DATA_WIDTH];
			added_i[i] 		<= data_in[DATA_WIDTH*(2*i+2)-1 -: DATA_WIDTH] + data_in[DATA_WIDTH*(2*i+N+2)-1 -: DATA_WIDTH];
			added[i] 		<= {added_r[i], added_i[i]};
			$display("added[%03d] = %x", i, added[i]);
			weight_real[i] <= $cos(2*3*i/N)*(2**DATA_WIDTH-1);
			weight_imag[i] <= -$sin(2*3*i/N)*(2**DATA_WIDTH-1);
			data_out[DATA_WIDTH*(4*i + 1)-1 -: DATA_WIDTH] 		<= subtracted[i][DATA_WIDTH-1:0] * weight_real[i]
																- subtracted[i][DATA_WIDTH*2-1:DATA_WIDTH] * weight_imag[i];  
			data_out[DATA_WIDTH*(4*i + 2)-1 -: DATA_WIDTH] 	<= added[i][DATA_WIDTH-1:0] * weight_imag[i]
																+ added[i][DATA_WIDTH*2-1:DATA_WIDTH] * weight_real[i];
			data_out[DATA_WIDTH*(4*i + 3)-1 -: DATA_WIDTH] 	<= subtracted[i][DATA_WIDTH-1:0] * weight_real[i]
																- subtracted[i][DATA_WIDTH*2-1:DATA_WIDTH] * weight_imag[i];  
			data_out[DATA_WIDTH*(4*i + 4)-1 -: DATA_WIDTH] 	<= added[i][DATA_WIDTH-1:0] * weight_imag[i]
																+ added[i][DATA_WIDTH*2-1:DATA_WIDTH] * weight_real[i];
		end
	end //crossover

endgenerate


always @(posedge clk)
begin
	data_in <= cplx_data_in;
	en_o <= en;
end

endmodule

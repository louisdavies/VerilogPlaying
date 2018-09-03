// -----------------------------------------------------------------------
// gain module
// 
// DESCRIPTION:
// 	apply a (signed) gain - scale between -1 and (2^(gain_width-1)-1)/2^(gain_width-1)
//  * 2^left_shift to the (signed) audio.
//  TODO - add saturation indicator
// -----------------------------------------------------------------------

module fft	#(parameter N = 1,
			DATA_WIDTH = 16)
			(input wire [DATA_WIDTH*2*N-1:0] cplx_data_in,
			input wire clk, en, n_rst,
			output wire [DATA_WIDTH*2*N-1:0] cplx_data_out,
			output wire en_out);

reg [DATA_WIDTH*2*N-1:0] data_out;
wire [DATA_WIDTH*2*N-1:0] butterfly_out;
reg en_o, en_1, en_2;
wire [DATA_WIDTH*N-1:0] data_out_t, data_out_b;
wire en_t, en_0_butterfly;

assign cplx_data_out 	= en_o ? data_out 	: {DATA_WIDTH*2*N{1'bZ}};
assign en_out			= en_o;

generate
	if (N==1) begin : trivial_fft
		always @(posedge clk)
		begin
			data_out 	<= cplx_data_in;
			en_o		<= en;
		end
	end else begin : split_fft
		//criss cross stuff
		butterfly #(.N(N), .DATA_WIDTH(DATA_WIDTH)) butterfly (.cplx_data_in(cplx_data_in),
															.clk(clk), .en(en),
															.cplx_data_out(butterfly_out),
															.en_out(en_o_butterfly));
		//split:
		//top
		fft #(.N(N/2), .DATA_WIDTH(DATA_WIDTH)) fft_top		(.cplx_data_in(butterfly_out[DATA_WIDTH*2*N-1:DATA_WIDTH*N]),
															.clk(clk), .en(en_o_butterfly), .n_rst(),
															.cplx_data_out(data_out_t),
															.en_out(en_t));
		//bottom
		fft #(.N(N/2), .DATA_WIDTH(DATA_WIDTH)) fft_bottom	(.cplx_data_in(butterfly_out[DATA_WIDTH*N-1:0]),
															.clk(clk), .en(en_o_butterfly), .n_rst(),
															.cplx_data_out(data_out_b),
															.en_out(en_b));
		always @(posedge clk)
		begin
			en_o <= en_t & en_b;
			data_out <= {data_out_t, data_out_b};
		end
	end // split_fft
endgenerate

endmodule
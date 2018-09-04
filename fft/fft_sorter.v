// -----------------------------------------------------------------------
// gain module
// 
// DESCRIPTION:
// 	apply a (signed) gain - scale between -1 and (2^(gain_width-1)-1)/2^(gain_width-1)
//  * 2^left_shift to the (signed) audio.
//  TODO - add saturation indicator
// -----------------------------------------------------------------------

module fft_sorter	#(parameter N = 1,
			DATA_WIDTH = 16)
			(input wire [DATA_WIDTH*2*N-1:0] cplx_data_in,
			output wire [DATA_WIDTH*2*N-1:0] cplx_data_out);

parameter wi = $clog2(N);

wire en_o;
wire [DATA_WIDTH*2*N-1:0] data_out;
reg [1:0] flip_i [0:3];

assign cplx_data_out 	= data_out;

assign en_o = 1;

assign data_out[DATA_WIDTH*(2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*0+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*1+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*8+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*2+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*4+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*3+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*12+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*4+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*2+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*5+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*10+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*6+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*6+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*7+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*14+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*8+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*1+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*9+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*9+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*10+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*5+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*11+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*13+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*12+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*3+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*13+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*11+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*14+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*7+2)-1 -: 2*DATA_WIDTH];
assign data_out[DATA_WIDTH*(2*15+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*15+2)-1 -: 2*DATA_WIDTH];


// assign data_out[DATA_WIDTH*(2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*0+2)-1 -: 2*DATA_WIDTH];
// assign data_out[DATA_WIDTH*(2*1+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*2+2)-1 -: 2*DATA_WIDTH];
// assign data_out[DATA_WIDTH*(2*2+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*1+2)-1 -: 2*DATA_WIDTH];
// assign data_out[DATA_WIDTH*(2*3+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*3+2)-1 -: 2*DATA_WIDTH];
// genvar i;
// generate
// 	for(i=0; i<N; i=i+1) begin : sort
// 		// for (ii=wi; ii >= 0; ii=ii-1) begin
// 		// 	flip_i[wi-ii]=i[ii];
// 		// end
// 		always @* flip_i[0] <= 2'd0;
// 		always @* flip_i[1] <= 2'd2;
// 		always @* flip_i[2] <= 2'd1;
// 		always @* flip_i[3] <= 2'd3;
// 		assign data_out[DATA_WIDTH*(2*i+2)-1 -: 2*DATA_WIDTH] = cplx_data_in[DATA_WIDTH*(2*flip_i[i]+2)-1 -: 2*DATA_WIDTH];
		
// 	end // split_fft
// endgenerate

endmodule
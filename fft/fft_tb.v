module fft_tb();

reg audio_clk_in, delay_clk, en, n_rst, go;
integer count;
reg signed [9:0] delay_cycles, left_shift;
wire audio_clk_out;
wire [23:0] left_out, right_out;

//{16'd0,4'd0,4'd0,-4'd4,4'd0,4'd0,4'd0,4'd4} gives 	08000008
//{4'd0,4'd0,4'd0,-4'd4,4'd0,4'd2,4'd0,4'd4} gives  280ee802 
parameter DATA_WIDTH=16, N=16;
wire [DATA_WIDTH*N*2-1:0] data_out, data_out_sorted;

fft #(.N(N), .DATA_WIDTH(DATA_WIDTH)) dut (.cplx_data_in({16'd0,16'd0,16'd0,-16'd1000,16'd0,16'd0,16'd0,16'd1000,16'd0,16'd0,16'd0,-16'd1000,16'd0,16'd0,16'd0,16'd1000,16'd0,16'd0,16'd0,-16'd1000,16'd0,16'd0,16'd0,16'd1000,16'd0,16'd0,16'd0,-16'd1000,16'd0,16'd0,16'd0,16'd1000}),
								.clk(delay_clk),
								.en(en),
								.n_rst(n_rst),
								.cplx_data_out(data_out),
								.en_out());

fft_sorter #(.N(N), .DATA_WIDTH(DATA_WIDTH)) outp (.cplx_data_in(data_out),
								.cplx_data_out(data_out_sorted));

reg [3:0] ram [0:63];
integer i;
reg [DATA_WIDTH-1:0] freq_out_r, freq_out_i;

initial
begin
  	// $readmemh("input_wave.txt", ram);
	left_shift = 2;
	delay_cycles = 10'h1FF;
	en = 0;
	n_rst = 1;
	audio_clk_in = 1;
	delay_clk = 1;
	#10 n_rst = 0;
	#60 n_rst = 1;
	#200 en = 1;
	count = 0;
	#50 go = 1;
	delay_clk = 0;
	audio_clk_in = 0;
	#2000 ;
	for(i=0;i<N;i=i+1) begin
		#10;
		freq_out_r = data_out_sorted[DATA_WIDTH*(2*i+1)-1 -: DATA_WIDTH];
		freq_out_i = data_out_sorted[DATA_WIDTH*(2*i+2)-1 -: DATA_WIDTH];
	end           
end

always
begin
	if (go == 1) begin
		#10 delay_clk = ~delay_clk;
		count = count + 1;
		if(count > 5*2*2*24) begin
			$stop;
			$finish;
		end
		
		if(count % (2*24) == 0) audio_clk_in = ~audio_clk_in;
	end
	else begin
		#1;
	end
end

endmodule
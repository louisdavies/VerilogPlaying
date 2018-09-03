module fft_tb();

reg audio_clk_in, delay_clk, en, n_rst, go;
wire [4*2*4-1:0] data_out;
integer count;
reg signed [9:0] delay_cycles, left_shift;
wire audio_clk_out;
wire [23:0] left_out, right_out;

fft #(.N(16), .DATA_WIDTH(4)) dut (.cplx_data_in({4'd15,4'd0,4'd13,4'd0,4'd11,4'd0,4'd8,4'd0,4'd15,4'd0,4'd13,4'd0,4'd11,4'd0,4'd8,4'd0,4'd15,4'd0,4'd13,4'd0,4'd11,4'd0,4'd8,4'd0,4'd15,4'd0,4'd13,4'd0,4'd11,4'd0,4'd8,4'd0}),
								.clk(delay_clk),
								.en(en),
								.n_rst(n_rst),
								.cplx_data_out(data_out),
								.en_out());


initial
begin
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
	#1000 delay_cycles = 10'd100;
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
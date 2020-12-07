module read_buf#(
    parameter x_w = 8,
    parameter depth = 8
)(
    input clk_i,
    input rst_i,

    input start_vi,
    output reg [x_w-1:0] d_o,
    output reg v_vo,

    input [$clog2(depth)-1:0] addr_w_i,
    input [x_w-1:0] data_w_i,
    input w_vi
);


logic [$clog2(depth):0] cnt_n;
reg [$clog2(depth):0] cnt_r;

always_comb begin
    if(cnt_r != depth) begin
        cnt_n = cnt_r + 1;
    end
    else if(start_vi) begin
        cnt_n = 0;
    end
    else cnt_n = cnt_r; 
end

always_ff @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
        cnt_r <= depth;
    end
    else cnt_r <= cnt_n;
end

reg [depth-1:0][x_w-1:0] data_r;

always_ff @(posedge clk_i or negedge rst_i)
    if(!rst_i) d_o <= '0;
    else d_o <= data_r[cnt_n[$clog2(depth)-1:0]];


always_ff @(posedge clk_i or negedge rst_i)
    if(!rst_i) v_vo <= '0;
    else v_vo <= cnt_n != depth;


always_ff @(posedge clk_i)
    if(w_vi) data_r[addr_w_i] <= data_w_i;

endmodule

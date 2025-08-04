module Memory #(
    parameter MEMORY_FILE = "",
    parameter MEMORY_SIZE = 4096
)(
    input  wire        clk,

    input  wire        rd_en_i,    // Indica uma solicitação de leitura
    input  wire        wr_en_i,    // Indica uma solicitação de escrita

    input  wire [31:0] addr_i,     // Endereço
    input  wire [31:0] data_i,     // Dados de entrada (para escrita)
    output wire [31:0] data_o,     // Dados de saída (para leitura)

    output wire        ack_o       // Confirmação da transação
);
    reg [31:0] mem [0:MEMORY_SIZE-1];
    reg [31:0] data_out_reg;
    reg ack_reg;

    wire [31:2] aligned_addr = addr_i[31:2];

    initial begin
        if (MEMORY_FILE != "") begin
            $readmemh(MEMORY_FILE, mem);
        end
    end

    always @(posedge clk) begin
        ack_reg <= 1'b0;

        if (rd_en_i) begin
            data_out_reg <= mem[aligned_addr];
            ack_reg <= 1'b1;
        end else if (wr_en_i) begin
            mem[aligned_addr] <= data_i;
            ack_reg <= 1'b1;
        end
    end

    assign data_o = rd_en_i ? data_out_reg : 32'b0;
    assign ack_o = ack_reg;

endmodule

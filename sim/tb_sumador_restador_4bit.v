`timescale 1ns / 1ps

module tb_sumador_restador_4bit;

    // Declaración de señales
    reg [3:0] A;
    reg [3:0] B;
    reg Sel;
    wire [3:0] So;
    wire Co;

    // Instanciar el circuito principal
    sumador_restador_4bit dut (
        .A(A),
        .B(B),
        .Sel(Sel),
        .So(So),
        .Co(Co)
    );

    // Estímulos de prueba
    initial begin
        // Generar archivo para ver gráficas de ondas
        $dumpfile("ondas.vcd");
        $dumpvars(0, tb_sumador_restador_4bit);

        $display("--------------------------------------------------");
        $display("Sel | A (bin) | B (bin) | Co | So (bin) | Operacion ");
        $display("--------------------------------------------------");
        $monitor(" %b  |   %b  |   %b  |  %b |   %b   ", Sel, A, B, Co, So);

        // --- 6 CASOS DE SUMA (Sel = 0) ---
        Sel = 0; 
        
        A = 4'b0011; B = 4'b0100; #10; // 1. 3 + 4 = 7
        A = 4'b0101; B = 4'b0010; #10; // 2. 5 + 2 = 7
        A = 4'b1000; B = 4'b0001; #10; // 3. 8 + 1 = 9
        A = 4'b0111; B = 4'b0111; #10; // 4. 7 + 7 = 14
        A = 4'b0000; B = 4'b0101; #10; // 5. 0 + 5 = 5
        A = 4'b1010; B = 4'b0101; #10; // 6. 10 + 5 = 15

        $display("--------------------------------------------------");

        // --- 6 CASOS DE RESTA (Sel = 1) ---
        Sel = 1; 

        A = 4'b0111; B = 4'b0101; #10; // 1. 7 - 5 = 2  (Positivo, Co=1)
        A = 4'b0011; B = 4'b0111; #10; // 2. 3 - 7 = -4 (Negativo, Compl. a 2, Co=0)
        A = 4'b1000; B = 4'b0100; #10; // 3. 8 - 4 = 4  (Positivo, Co=1)
        A = 4'b1010; B = 4'b1010; #10; // 4. 10 - 10 = 0 (Cero, Co=1)
        A = 4'b0101; B = 4'b1000; #10; // 5. 5 - 8 = -3 (Negativo, Compl. a 2, Co=0)
        A = 4'b1111; B = 4'b0001; #10; // 6. 15 - 1 = 14 (Positivo, Co=1)

        // Terminar la simulación
        $finish;
    end

endmodule
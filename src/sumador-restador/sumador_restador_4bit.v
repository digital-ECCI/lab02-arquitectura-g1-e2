// Módulo: Sumador/Restador de 4 bits
module sumador_restador_4bit (
    input [3:0] A,      // Entrada A de 4 bits
    input [3:0] B,      // Entrada B de 4 bits
    input Sel,          // Selector: 0 = Suma, 1 = Resta
    output [3:0] So,    // Resultado de 4 bits
    output Co           // Acarreo final de salida
);

    // Cables internos para las salidas de las compuertas XOR
    wire [3:0] B_xor;
    
    // Cables internos para los acarreos entre sumadores (C0, C1, C2)
    wire C0, C1, C2;

    // Compuertas XOR: Invierten B si Sel es 1 (Complemento a 1)
    // Si Sel es 0, dejan pasar B intacto.
    assign B_xor[0] = B[0] ^ Sel;
    assign B_xor[1] = B[1] ^ Sel;
    assign B_xor[2] = B[2] ^ Sel;
    assign B_xor[3] = B[3] ^ Sel;

    // Instancia 0 (Bit menos significativo)
    // Nota: El Cin de este sumador está conectado directamente a 'Sel'
    sumador_1bit sum0 (
        .A(A[0]),
        .B(B_xor[0]),
        .Cin(Sel),       // Aquí se suma el +1 para el complemento a 2 cuando Sel=1
        .So(So[0]),
        .Cout(C0)
    );

    // Instancia 1
    sumador_1bit sum1 (
        .A(A[1]),
        .B(B_xor[1]),
        .Cin(C0),        // Acarreo de la etapa anterior
        .So(So[1]),
        .Cout(C1)
    );

    // Instancia 2
    sumador_1bit sum2 (
        .A(A[2]),
        .B(B_xor[2]),
        .Cin(C1),
        .So(So[2]),
        .Cout(C2)
    );

    // Instancia 3 (Bit más significativo)
    sumador_1bit sum3 (
        .A(A[3]),
        .B(B_xor[3]),
        .Cin(C2),
        .So(So[3]),
        .Cout(Co)        // Acarreo final
    );

endmodule
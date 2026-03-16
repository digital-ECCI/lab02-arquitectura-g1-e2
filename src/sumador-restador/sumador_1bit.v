// Módulo: Sumador completo de 1 bit (Full Adder)
module sumador_1bit (
    input A,
    input B,
    input Cin,
    output So,
    output Cout
);
    // Lógica del sumador de 1 bit
    assign So = A ^ B ^ Cin;               // Suma
    assign Cout = (A & B) | (Cin & (A ^ B)); // Acarreo de salida
endmodule
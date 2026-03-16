// ==================================================================
// MÓDULO PRINCIPAL: Sumador / Restador de 4 bits
// ==================================================================
module sumador_restador (               // Declara el inicio del módulo principal y su nombre
    input  Sel,                         // Define 'Sel' como entrada de 1 bit que actúa como interruptor (0=Suma, 1=Resta)
    input  [3:0] A,                     // Define 'A' como un bus de entrada de 4 bits (representa el minuendo o primer sumando)
    input  [3:0] B,                     // Define 'B' como un bus de entrada de 4 bits (representa el sustraendo o segundo sumando)
    output Co,                          // Define 'Co' como salida de 1 bit para el acarreo final (nos dirá el signo de la resta)
    output [3:0] So                     // Define 'So' como un bus de salida de 4 bits para mostrar el resultado de la operación
);                                      // Cierra la lista de puertos del módulo

    // Cables internos para pasar el acarreo de un bit al siguiente
    wire c1, c2, c3;                    // Declara 3 cables internos de 1 bit para conectar el acarreo de salida de un sumador con la entrada del siguiente
    
    // Cables internos para la salida de las compuertas XOR
    wire [3:0] B_xor;                   // Declara un bus interno de 4 bits para guardar el valor de B después de pasar por las compuertas XOR

    // ------------------------------------------------------------------
    // Paso 1: Compuertas XOR para el complemento a 1
    // ------------------------------------------------------------------
    assign B_xor[0] = B[0] ^ Sel;       // Aplica XOR al bit 0 de B; si Sel=1, invierte el bit. Si Sel=0, lo deja igual.
    assign B_xor[1] = B[1] ^ Sel;       // Aplica XOR al bit 1 de B; realiza la inversión condicional.
    assign B_xor[2] = B[2] ^ Sel;       // Aplica XOR al bit 2 de B; realiza la inversión condicional.
    assign B_xor[3] = B[3] ^ Sel;       // Aplica XOR al bit 3 de B; con esto se completa el complemento a 1 de todo el bus B.

    // ------------------------------------------------------------------
    // Paso 2: Sumadores de 1 bit (Instancias con nombre U0, U1...)
    // ------------------------------------------------------------------

    // --- Instancia 0 (Bit 0 - LSB) ---
    sumador_1_bit U0 (                  // Llama al "plano" del sumador de 1 bit y crea una copia física llamada 'U0'
        .Cin   (Sel),                   // Conecta la señal 'Sel' al acarreo inicial (esto suma 1 en modo resta, logrando el complemento a 2)
        .A     (A[0]),                  // Conecta el bit 0 (menos significativo) de la entrada A al puerto A del sumador
        .B     (B_xor[0]),              // Conecta el bit 0 de B (ya pasado por la XOR) al puerto B del sumador
        .Count (c1),                    // El acarreo generado por esta suma se inyecta en el cable interno 'c1'
        .S     (So[0])                  // El resultado de esta suma se conecta directamente al bit 0 de la salida final So
    );                                  // Cierra las conexiones de la instancia U0

    // --- Instancia 1 (Bit 1) ---
    sumador_1_bit U1 (                  // Crea una segunda copia del sumador de 1 bit llamada 'U1'
        .Cin   (c1),                    // Recibe el acarreo 'c1' que fue generado por la etapa anterior (U0)
        .A     (A[1]),                  // Conecta el bit 1 de la entrada A
        .B     (B_xor[1]),              // Conecta el bit 1 de la entrada B (ya pasado por la XOR)
        .Count (c2),                    // El acarreo generado se inyecta en el cable interno 'c2'
        .S     (So[1])                  // El resultado se conecta al bit 1 de la salida final So
    );                                  // Cierra las conexiones de la instancia U1

    // --- Instancia 2 (Bit 2) ---
    sumador_1_bit U2 (                  // Crea una tercera copia del sumador de 1 bit llamada 'U2'
        .Cin   (c2),                    // Recibe el acarreo 'c2' que fue generado por la etapa anterior (U1)
        .A     (A[2]),                  // Conecta el bit 2 de la entrada A
        .B     (B_xor[2]),              // Conecta el bit 2 de la entrada B (ya pasado por la XOR)
        .Count (c3),                    // El acarreo generado se inyecta en el cable interno 'c3'
        .S     (So[2])                  // El resultado se conecta al bit 2 de la salida final So
    );                                  // Cierra las conexiones de la instancia U2

    // --- Instancia 3 (Bit 3 - MSB) ---
    sumador_1_bit U3 (                  // Crea la cuarta y última copia del sumador de 1 bit llamada 'U3'
        .Cin   (c3),                    // Recibe el acarreo 'c3' que fue generado por la etapa anterior (U2)
        .A     (A[3]),                  // Conecta el bit 3 (más significativo) de la entrada A
        .B     (B_xor[3]),              // Conecta el bit 3 de la entrada B (ya pasado por la XOR)
        .Count (Co),                    // Como es el último bit, el acarreo sale directamente al puerto exterior del módulo ('Co')
        .S     (So[3])                  // El resultado se conecta al bit 3 de la salida final So
    );                                  // Cierra las conexiones de la instancia U3

endmodule                               // Indica al sintetizador (Quartus) que aquí termina el diseño del módulo principal

// ==================================================================
// SUBMÓDULO: Sumador Completo de 1 bit (TU CÓDIGO)
// ==================================================================
// Módulo: Sumador Completo (Full Adder) de 1 bit para DE10-Lite
module sumador_1_bit (                  // Declara el inicio del submódulo y su nombre
    input  Cin,                         // Define 'Cin' como la entrada de acarreo proveniente de una etapa anterior
    input  A,                           // Define 'A' como la entrada del primer bit individual a sumar
    input  B,                           // Define 'B' como la entrada del segundo bit individual a sumar
    output Count,                       // Define 'Count' como la salida del acarreo generado por esta suma
    output S                            // Define 'S' como la salida del resultado de la suma
);                                      // Cierra la lista de puertos del submódulo

    // --- Lógica combinacional para el Acarreo (Majority Logic) ---
    // COMPUERTAS: XOR (^) para la diferencia, AND (&) para la coincidencia y OR (|) para la unión.
    // Esta línea decide si el resultado genera un bit que "se lleva" a la siguiente columna.
    assign Count = ((A ^ B) & Cin) | (A & B); // Evalúa la ecuación booleana; si al menos dos de las entradas son 1, el acarreo de salida es 1.

    // --- Lógica combinacional para la Suma (Parity Logic) ---
    // COMPUERTAS: Doble XOR (^) en cascada.
    // Esta línea calcula el bit de suma basándose en la paridad de las tres entradas.
    assign S = A ^ B ^ Cin;             // Evalúa la ecuación booleana; el resultado es 1 si hay una cantidad impar de unos en las entradas.

endmodule                               // Indica que aquí termina la definición matemática del sumador de 1 bit
import java.util.Scanner;

public class Main {
    // Константата L15 equ 6
    private static final int L15 = 6;
    private static final long[] n15 = new long[L15];

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        long r8 = scanner.nextLong();   // GET_DEC 8, r8
        long r9 = scanner.nextLong();   // GET_DEC 8, r9
        long r10 = scanner.nextLong();  // GET_DEC 8, r10

        r9 += r10;                 // add r9, r10

        if (r9 >= r8) return;

        long r11 = r9 - r8;            // mov r11, r9 -> sub r11, r8
        r10 += 20;                // add r10, 20

           // section .bss -> n15 resq L15
        int rdi = 0;              // Имитира указателя rdi (индекс за запис в масива)

        boolean bl = false;            // xor bl, bl (флаг за предходно число)
        long r14 = 0;                  // r14 ще пази предишното въведено число

        while (scanner.hasNextLong()) { // next:
            long r15 = scanner.nextLong(); // GET_DEC 8, r15

            // Извикване на подпрограмата tN
            boolean bh = tN(r15, r8, r9, r10);

            if (bh) {                      // test bh, bh -> jz after
                if (rdi < L15) {      // Защита от препълване на масива
                    n15[rdi] = r15;   // mov [rdi], r15
                    rdi++;            // add rdi, 8
                }
                if (rdi >= L15) {     // cmp rdi, n15 + 8 * L15 -> jae stop
                    break;
                }
            }

            // after:
            if (bl) {                      // test bl, bl -> jz jump
                if (r14 == r15) {          // cmp r14, r15 -> je stop
                    break;
                }
            }

            // jump:
            bl = true;                     // or bl, 1
            r14 = r15;                     // mov r14, r15

            if (r15 > r10) {               // cmp r15, r10 -> jg stop
                break;
            }

            // Деление: idiv r11 (остатъкът е в rdx)
            // В асемблера: jnz next (ако остатъкът НЕ е 0, върти пак. Ако Е 0, продължава надолу към stop)
            if (r15 % r11 == 0) {
                break;
            }
        }

        // stop:
        view(n15, rdi);
    }

    private static boolean tN(long r15, long r8, long r9, long r10) {
        boolean bh = r15 >= r9;        // cmp r15, r9 -> setge bh
        if (r15 < r9) {                // jl .end
            return bh;
        }
        if (r15 > r8) {                // cmp r15, r8 -> jg .end
            return bh;
        }
        bh = r15 > r10;                // cmp r15, r10 -> setg bh
        return bh;
    }

    private static void view(long[] n15, int rdi) {
        System.out.print("results: "); // PRINT_STRING [ .s1 ]

        if (rdi <= 0) {           // cmp rsi, rdi -> jae .quit
            System.out.println();
            System.out.println(0);
            System.out.println();
            return;
        }

        long rax = 0;                  // xor rax, rax (суматор за числа >= 10)
        boolean cl = false;            // xor cl, cl (флаг за разделител ";")

        for (int i = 0; i < rdi; i++) { // .view:
            if (n15[i] >= 10) {        // cmp qword [rsi], 10 -> jge .true
                rax += n15[i];         // .true: add rax, [rsi]
            } else {
                if (cl) {              // cmp cl, 0 -> je .jump
                    System.out.print(" ; "); // PRINT_STRING [ .s2 ]
                }
                cl = true;             // or cl, 1
                System.out.print(n15[i]); // PRINT_DEC 8, [rsi]
            }
        }

        // .quit:
        System.out.println();          // NEWLINE
        System.out.println(rax);       // PRINT_DEC 8, rax
        System.out.println();          // NEWLINE
    }
}
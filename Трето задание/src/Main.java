import java.util.Scanner;

public class Main {
    private static final int L15 = 6;
    private static final long[] n15 = new long[L15];

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        long r8 = scanner.nextLong();
        long r9 = scanner.nextLong();
        long r10 = scanner.nextLong();

        r9 += r10;

        if (r9 >= r8) return;

        long r11 = r9 - r8;
        r10 += 20;

        int rdi = 0;
        boolean bl = false;
        long r14 = 0;

        while (scanner.hasNextLong()) {
            long r15 = scanner.nextLong();

            boolean bh = tN(r15, r8, r9, r10);

            if (bh) {
                if (rdi < L15) {
                    n15[rdi] = r15;
                    rdi++;
                }
                if (rdi >= L15) {
                    break;
                }
            }

            if (bl) {
                if (r14 == r15) {
                    break;
                }
            }

            bl = true;
            r14 = r15;

            if (r15 > r10) {
                break;
            }

            if (r15 % r11 == 0) {
                break;
            }
        }

        view(n15, rdi);
    }

    private static boolean tN(long r15, long r8, long r9, long r10) {
        boolean bh = r15 >= r9;
        if (r15 < r9) {
            return bh;
        }
        if (r15 > r8) {
            return bh;
        }
        bh = r15 > r10;
        return bh;
    }

    private static void view(long[] n15, int rdi) {
        System.out.print("results: ");

        if (rdi <= 0) {
            System.out.println();
            System.out.println(0);
            System.out.println();
            return;
        }

        long rax = 0;
        boolean cl = false;

        for (int i = 0; i < rdi; i++) {
            if (n15[i] >= 10) {
                rax += n15[i];
            } else {
                if (cl) {
                    System.out.print(" ; ");
                }
                cl = true;
                System.out.print(n15[i]);
            }
        }

        System.out.println();
        System.out.println(rax);
        System.out.println();
    }
}
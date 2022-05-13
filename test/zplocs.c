/* Zero-page locations printer */
#include <stdio.h>

int get_sp();
int get_sreg();
int get_regsave();
int get_ptr1();
int get_ptr2();
int get_ptr3();
int get_ptr4();
int get_tmp1();
int get_tmp2();
int get_tmp3();
int get_tmp4();
int get_regbank();

int main() {
    printf("     sp: %2x\n", get_sp());
    printf("   sreg: %2x\n", get_sreg());
    printf("regsave: %2x\n", get_regsave());
    printf("   ptr1: %2x\n", get_ptr1());
    printf("   ptr2: %2x\n", get_ptr2());
    printf("   ptr3: %2x\n", get_ptr3());
    printf("   ptr4: %2x\n", get_ptr4());
    printf("   tmp1: %2x\n", get_tmp1());
    printf("   tmp2: %2x\n", get_tmp2());
    printf("   tmp3: %2x\n", get_tmp3());
    printf("   tmp4: %2x\n", get_tmp4());
    printf("regbank: %2x\n", get_regbank());
    return 0;
}

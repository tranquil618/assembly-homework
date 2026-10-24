#include<stdio.h>  /* 提供 printf 函数的声明。 */

int main()
{
    printf("The 9mul9 table:\n");

    for(int i=9;i>=1;i--){
        for(int j=1;j<=i;j++){
            int mult=i*j;  

            if(mult<10){
                printf("%d*%d=%d     ",i,j,mult);
            }
            else{
                printf("%d*%d=%d    ",i,j,mult);
            }
        }
        printf("\n");
    }

    return 0;  
}

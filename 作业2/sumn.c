#include<stdio.h>

int main()
{
    int n;
    int i;
    int sum=0;
    printf("Please input N (1-100): ");

    while(1){
        if(scanf("%d",&n)!=1){
            printf("Invalid input!\n");
            return 1;
        }

        if(n<1||n>100){
            printf("Please enter a number from 1 to 100!\n");
            return 1;
        }
        break;
    }

    for(i=1;i<=n;i++){
        sum+=i;
    }

    printf("%d\n",sum);
    return 0;
}

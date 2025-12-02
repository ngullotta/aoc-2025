#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int
main(void)
{
    unsigned long invalid_id_sum = 0;
    unsigned long start;
    unsigned long end;
    char s[16];
    while (EOF != scanf("%ld-%ld,", &start, &end)) {
        for (unsigned long id = start; id <= end; id++) {
            sprintf(s, "%ld", id);
            size_t len = strlen(s);
            if (len % 2 == 1)
                continue;
            if (!strncmp(s, s + ((len+1)/2), (len+1)/2))
                invalid_id_sum += (unsigned long)id;
        }
    }

    printf("%ld\n", invalid_id_sum);
    return 0;
}

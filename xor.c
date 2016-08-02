#include <stdio.h>

unsigned char seed = 0xA5;
#define BUFFER_SIZE 128
unsigned char buffer[BUFFER_SIZE];

int main(int argc, char* argv[]) {
    if (argc < 2){printf("Usage: %s file (decrypt)\n使用常数种子字节，异或一段文件头。文件名后面多带一个参数表示解密。\n", argv[0]); return 1;}

    FILE* file = fopen(argv[1], "rb+");
    if (file == NULL)
	{printf("Error opening file for writing.\n"); return 2;}

	fread(buffer, 1, BUFFER_SIZE, file);

	if (argc < 3){
		printf("Encrypt.\n");
		for (int i = 0; i < BUFFER_SIZE; i++){
			seed=buffer[i]^seed;
/*            printf("%04d :\t0x%x\t0x%x\n",i,buffer[i],seed);*/
			buffer[i]=seed;
		}
	} else {
		printf("Decrypt.\n");
		for (int i = BUFFER_SIZE; i > 0; i--){
			buffer[i]=buffer[i]^buffer[i-1];
		}
		buffer[0]=buffer[0]^seed;
	}

	fseek(file,0,SEEK_SET);
	fwrite(buffer, 1, BUFFER_SIZE, file);
    fclose(file);
    return 0;
}


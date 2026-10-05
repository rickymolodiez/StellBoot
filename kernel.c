
void kernel_main() {

  char *vidmem = (char *)0xB8000;
    vidmem[0]  = 'H'; vidmem[1]  = 0x0A;
    vidmem[2]  = 'e'; vidmem[3]  = 0x0A;
    vidmem[4]  = 'l'; vidmem[5]  = 0x0A;
    vidmem[6]  = 'l'; vidmem[7]  = 0x0A;
    vidmem[8]  = 'o'; vidmem[9]  = 0x0A;
    vidmem[10] = ' '; vidmem[11] = 0x0A;
    vidmem[12] = 'f'; vidmem[13] = 0x0A;
    vidmem[14] = 'r'; vidmem[15] = 0x0A;
    vidmem[16] = 'o'; vidmem[17] = 0x0A;
    vidmem[18] = 'm'; vidmem[19] = 0x0A;
    vidmem[20] = ' '; vidmem[21] = 0x0A;
    vidmem[22] = 'k'; vidmem[23] = 0x0A;
    vidmem[24] = 'e'; vidmem[25] = 0x0A;
    vidmem[26] = 'r'; vidmem[27] = 0x0A;
    vidmem[28] = 'n'; vidmem[29] = 0x0A;
    vidmem[30] = 'e'; vidmem[31] = 0x0A;
    vidmem[32] = 'l'; vidmem[33] = 0x0A;

  


  while (1)
    ;
}
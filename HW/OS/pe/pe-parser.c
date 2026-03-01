#include <stdio.h>
#include <string.h>
#include <stdint.h>

int read_on_offset(FILE* file, long offset, int start_pos, void* buffer, size_t el_size, size_t el_count) {
    if (!(!fseek(file, offset, start_pos) && fread(buffer, el_size, el_count, file))){
        fclose(file);
        return 1;
    }
    return 0;
}

void print_from_file(FILE* file){
    char c;
    while (fread(&c, 1, 1, file) && c != '\0'){
        printf("%c", c);
    }
    printf("\n");
}

int is_pe(char* filepath) {
    FILE *file = fopen(filepath, "rb");

    if (file == NULL) {
        return 1;
    }

    uint32_t pe_addr;
    unsigned char buffer[4];

    if (read_on_offset(file, 0x3C, SEEK_SET, &pe_addr, sizeof(uint32_t), 1) ||
        read_on_offset(file, pe_addr, SEEK_SET, buffer, 1, 4)){
        return 1;
    }

    fclose(file);

    if (!memcmp(buffer, "PE\0\0", 4)) {
        return 0;
    }

    return 1;
}

int import_functions(char* filepath) {
    FILE *file = fopen(filepath, "rb");

    if (file == NULL) {
        return 1;
    }

    uint32_t addr;

    if (read_on_offset(file, 0x3C, SEEK_SET, &addr, sizeof(uint32_t), 1)) {
        return 1;
    }

    addr += 24;
    uint32_t import_table_rva;
    uint32_t import_table_size;

    if (read_on_offset(file, addr + 0x78, SEEK_SET, &import_table_rva, sizeof(uint32_t), 1)) {
        return 1;
    }

    addr += 240;
    uint32_t section_virtual_size;
    uint32_t section_rva;
    uint32_t section_raw;
    uint32_t section_data[4];
    do {
        // if (read_on_offset(file, addr + 0x8, SEEK_SET, &section_virtual_size, sizeof(uint32_t), 1) ||
        //     read_on_offset(file, addr + 0xC, SEEK_SET, &section_rva, sizeof(uint32_t), 1) ||
        //     read_on_offset(file, addr + 0x14, SEEK_SET, &section_raw, sizeof(uint32_t), 1)) {
        //     return 1;
        // }
        if (read_on_offset(file, addr + 0x8, SEEK_SET, &section_data, sizeof(uint32_t), 4)){
            return 1;
        }
        section_virtual_size = section_data[0];
        section_rva = section_data[1];
        section_raw = section_data[3];
        addr += 40;
    } while (!(section_rva <= import_table_rva && import_table_rva < section_rva + section_virtual_size));

    uint32_t import_raw = section_raw + import_table_rva - section_rva;

    char info[20], last[20] = {0};
    uint32_t lib_name_rva, lib_name_addr;
    uint32_t import_lookup_table_rva, import_lookup_table_addr;
    uint32_t func_name_rva, func_name_addr;
    while(1) {
        if (read_on_offset(file, import_raw, SEEK_SET, info, 1, 20)) {
            return 1;
        }
        if (!memcmp(info, last, 20)) {
            break;
        }

        if (read_on_offset(file, import_raw + 0xC, SEEK_SET, &lib_name_rva, sizeof(uint32_t), 1) ||
            read_on_offset(file, import_raw, SEEK_SET, &import_lookup_table_rva, sizeof(uint32_t), 1)) {
            return 1;
        }

        lib_name_addr = section_raw + lib_name_rva - section_rva;
        if (fseek(file, lib_name_addr, SEEK_SET) != 0){
            return 1;
        }
        print_from_file(file);
        
        import_lookup_table_addr = section_raw + import_lookup_table_rva - section_rva;
        uint64_t info2;
        while(1) {
            if (read_on_offset(file, import_lookup_table_addr, SEEK_SET, &info2, sizeof(uint64_t), 1)) {
                return 1;
            }
            if (info2 == 0) {
                break;
            }
            if (!(info2 & (1ULL << 63))) {
                func_name_rva = info2 & ((1ULL << 31) - 1);
                func_name_addr = section_raw + func_name_rva - section_rva;
                if (fseek(file, func_name_addr + 2, SEEK_SET) != 0){
                    return 1;
                }
                /*
                сдвинуто еще на 2 байта, так как это поле Hint
                зеленая таблица Import Format поле _IMAGE_IMPORT_BY_NAME
                */
                printf("    ");
                print_from_file(file);
            }
            import_lookup_table_addr += 8;
        }
        import_raw += 20;
    }
    return 0;
}

int main(int argc, char* argv[]) {
    if (argc != 3) { 
        printf("wrong number of arguments, must be 2: command, file_path\n");
        return -1;
    }

    char* command = argv[1];

    if (!strcmp(command, "is-pe")) {
        int result = is_pe(argv[2]);
        if (result == 0){
            printf("PE\n");
        } else {
            printf("Not PE\n");
        }
        return result;
    } else if (!strcmp(command, "import-functions")) {
        return import_functions(argv[2]);
    }

    return 0;
}
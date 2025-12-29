#include "nebula_native.h"
#include <vector>

// Реализация XOR шифрования
// data: указатель на массив байт
// length: длина массива
// key: ключ (байт)
extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t native_xor_encrypt(uint8_t* data, int32_t length, uint8_t key) {
    if (data == nullptr || length <= 0) {
        return -1; // Error
    }

    for (int i = 0; i < length; ++i) {
        data[i] ^= key;
    }

    return 0; // Success
}

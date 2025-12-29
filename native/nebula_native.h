#ifndef NEBULA_NATIVE_H
#define NEBULA_NATIVE_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Простой XOR для теста связки (пока не прикрутим полноценный ChaCha20)
// В реальной версии здесь будет chacha20_encrypt и т.д.
__attribute__((visibility("default"))) __attribute__((used))
int32_t native_xor_encrypt(uint8_t* data, int32_t length, uint8_t key);

#ifdef __cplusplus
}
#endif

#endif // NEBULA_NATIVE_H

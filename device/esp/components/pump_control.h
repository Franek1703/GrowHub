#ifndef PUMP_CONTROL_H
#define PUMP_CONTROL_H

#include "esp_err.h"

// Funkcja do sprawdzenia, czy pompa jest podłączona
esp_err_t pump_init(void);

// Funkcja do aktywacji pompy na określony czas (w sekundach)
esp_err_t activate_pump(int activation_time);

#endif // PUMP_CONTROL_H

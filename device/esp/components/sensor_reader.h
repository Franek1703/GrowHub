#ifndef SENSOR_READER_H
#define SENSOR_READER_H

#include "esp_adc/adc_oneshot.h"
#include "onewire_bus.h"
#include "ds18b20.h"

// Definicje kanałów ADC dla czujników analogowych
#define TDS_SENSOR_PIN ADC_CHANNEL_7
#define PH_SENSOR_PIN ADC_CHANNEL_6

// Definicje dla OneWire
#define EXAMPLE_ONEWIRE_BUS_GPIO    4
#define EXAMPLE_ONEWIRE_MAX_DS18B20 2
#define PH_SAMPLES 15
#define TDS_SAMPLES 10

// Deklaracja funkcji
void init_adc(void);
void init_onewire(void);   // Funkcja inicjalizacji OneWire
float read_tds(void);
float read_ph(void);
float read_temperature(void); // Odczyt temperatury za pomocą OneWire

#endif // SENSOR_READER_H

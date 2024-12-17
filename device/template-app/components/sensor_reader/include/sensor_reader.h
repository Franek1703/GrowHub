#ifndef SENSOR_READER_H
#define SENSOR_READER_H

#include "driver/adc.h"

#define TDS_SENSOR_PIN ADC1_CHANNEL_0
#define PH_SENSOR_PIN ADC1_CHANNEL_1
#define TEMP_SENSOR_PIN ADC1_CHANNEL_2 

float read_tds(void);
float read_ph(void);
float read_temperature(void);

#endif // SENSOR_READER_H

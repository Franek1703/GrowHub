#include "sensor_reader.h"
#include "esp_log.h"
#include "driver/adc.h"

#define VREF 3.3

static const char *TAG = "SensorReader";

#define VREF 3.3

static const char *TAG = "SensorReader";
float read_tds() {
    int sensor_value = adc1_get_raw(TDS_SENSOR_PIN);
    float voltage = (sensor_value / 4095.0) * VREF;
    float tds_value = (133.42 * voltage * voltage * voltage - 255.86 * voltage * voltage + 857.39 * voltage) * 0.5; // Wzór na TDS w ppm
    ESP_LOGI(TAG, "TDS: %.2f ppm", tds_value);
    return tds_value;
}



float read_ph() {
    int sensor_value = adc1_get_raw(PH_SENSOR_PIN);
    float voltage = (sensor_value / 4095.0) * VREF; // Skalowanie napięcia
    float ph_value = 3.5 * voltage + 0.00; // Wzór na pH, offset = 0.00
    ESP_LOGI(TAG, "pH: %.2f", ph_value);
    return ph_value;
}


float read_temperature() {
    int sensor_value = adc1_get_raw(TEMP_SENSOR_PIN);
    float voltage = (sensor_value / 4095.0) * VREF;
    // Prosty wzór na temperaturę (skalowanie w zależności od czujnika)
    float temperature = (voltage - 0.5) * 100.0; // Zakładając, że używasz czujnika, który ma charakterystykę 10mV/°C
    ESP_LOGI(TAG, "Temperature: %.2f °C", temperature);
    return temperature;
}

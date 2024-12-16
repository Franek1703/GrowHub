#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "sensor_reader.h"
#include "http_client.h"

static const char *TAG = "Main";

void app_main() {
    init_adc();
    init_onewire();
    ESP_ERROR_CHECK(app_init());
    device_data_t device;
    get_device_id(&device);
    ESP_LOGI(TAG, "Device ID: %d", device.device_id);
    sensor_data_t temp;
    sensor_data_t tds;
    sensor_data_t ph;
    get_sensor_id("temperature", device.device_id, &temp);
    get_sensor_id("PH", device.device_id, &ph);
    get_sensor_id("TDS", device.device_id, &tds);


    get_sensor_frequency(temp.sensor_id,&temp);
    get_sensor_frequency(tds.sensor_id,&tds);
    get_sensor_frequency(ph.sensor_id,&ph);
    ESP_LOGI(TAG, "Temp: id: %d, frequency: %d", temp.sensor_id, temp.frequency);
    ESP_LOGI(TAG, "PH: id: %d, frequency: %d", ph.sensor_id, ph.frequency);
    ESP_LOGI(TAG, "TDS: id: %d, frequency: %d", tds.sensor_id, tds.frequency);

    for (int i = 0; i < PH_SAMPLES; i++) {
        read_ph(); 
    }
    while (1) {
        // Sprawdzenie Wi-Fi przed wysyłaniem danych
        if (check_wifi_connection() == ESP_OK) {
            // Połączenie Wi-Fi aktywne, można wysyłać dane
            float tds_value = read_tds();
            float ph_value = read_ph();           
            float temp_value = read_temperature();

            ESP_LOGI(TAG, "Testowanie czujników:");
            ESP_LOGI(TAG, "TDS: %.2f ppm", tds_value);
            ESP_LOGI(TAG, "pH: %.2f", ph_value);
            ESP_LOGI(TAG, "Temperature: %.2f °C", temp_value);

            ESP_ERROR_CHECK(send_sensor_data(1, "Temp", temp_value, &temp, &device));
            ESP_LOGI(TAG, "Czas aktywacji: %d sekundy", device.activation_time);
            ESP_LOGI(TAG, "Częstotliwość: %d minut", temp.frequency);
            ESP_LOGI(TAG, "Potrzebuje nawożenia: %s", device.needs_fertilization ? "TAK" : "NIE");
            vTaskDelay(pdMS_TO_TICKS(2000));

            ESP_ERROR_CHECK(send_sensor_data(2, "PH", ph_value, &ph, &device));
            ESP_LOGI(TAG, "Czas aktywacji: %d sekundy", device.activation_time);
            ESP_LOGI(TAG, "Częstotliwość: %d minut", ph.frequency);
            ESP_LOGI(TAG, "Potrzebuje nawożenia: %s", device.needs_fertilization ? "TAK" : "NIE");
            vTaskDelay(pdMS_TO_TICKS(2000));

            ESP_ERROR_CHECK(send_sensor_data(5, "TDS", tds_value, &tds, &device));
            ESP_LOGI(TAG, "Czas aktywacji: %d sekundy", device.activation_time);
            ESP_LOGI(TAG, "Częstotliwość: %d minut", tds.frequency);
            ESP_LOGI(TAG, "Potrzebuje nawożenia: %s", device.needs_fertilization ? "TAK" : "NIE");
            vTaskDelay(pdMS_TO_TICKS(2000));

            vTaskDelay(pdMS_TO_TICKS(10000));
        } else {
            wait_for_wifi_connection(); 
        }
    }
}


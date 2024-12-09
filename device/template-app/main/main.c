#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "sensor_reader.h"

static const char *TAG = "Main";

// Funkcja testująca bibliotekę do odczytu danych z czujników
void app_main() {
    // Inicjalizacja ADC
    adc1_config_width(ADC_WIDTH_BIT_12);  // Ustaw rozdzielczość ADC na 12 bitów
    adc1_config_channel_atten(TDS_SENSOR_PIN, ADC_ATTEN_DB_0);  // Ustawienia dla TDS
    adc1_config_channel_atten(PH_SENSOR_PIN, ADC_ATTEN_DB_0);   // Ustawienia dla pH
    adc1_config_channel_atten(TEMP_SENSOR_PIN, ADC_ATTEN_DB_0); // Ustawienia dla temperatury

    // Testowanie odczytu danych
    while (1) {
        float tds_value = read_tds(); // Odczyt TDS
        float ph_value = read_ph();   // Odczyt pH
        float temp_value = read_temperature(); // Odczyt temperatury

        // Logowanie wyników
        ESP_LOGI(TAG, "Testowanie czujników:");
        ESP_LOGI(TAG, "TDS: %.2f ppm", tds_value);
        ESP_LOGI(TAG, "pH: %.2f", ph_value);
        ESP_LOGI(TAG, "Temperature: %.2f °C", temp_value);

        // Czekanie przez 1 sekundę przed kolejnym odczytem
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}

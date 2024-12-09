#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "sensor_reader.h"

static const char *TAG = "Main";

// Funkcja testująca bibliotekę do odczytu danych z czujników
void app_main() {
    // Inicjalizacja ADC
    init_adc(); // Inicjalizacja ADC z nowym API
    init_onewire();

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
        vTaskDelay(pdMS_TO_TICKS(4000));
    }
}

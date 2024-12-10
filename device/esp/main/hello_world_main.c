#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "sensor_reader.h"
#include "http_client.h"

static const char *TAG = "Main";

void app_main() {
    ESP_ERROR_CHECK(app_init());
    init_adc();  // Inicjalizacja ADC
    init_onewire();  // Inicjalizacja czujników OneWire

    sensor_data_t response_data;

    // Testowanie odczytu danych
    while (1) {
        // Sprawdzenie Wi-Fi przed wysyłaniem danych
        if (check_wifi_connection() == ESP_OK) {
            // Połączenie Wi-Fi aktywne, można wysyłać dane
            float tds_value = read_tds();          // Odczyt TDS
            float ph_value = read_ph();            // Odczyt pH
            float temp_value = read_temperature(); // Odczyt temperatury

            ESP_LOGI(TAG, "Testowanie czujników:");
            ESP_LOGI(TAG, "TDS: %.2f ppm", tds_value);
            ESP_LOGI(TAG, "pH: %.2f", ph_value);
            ESP_LOGI(TAG, "Temperature: %.2f °C", temp_value);

            ESP_ERROR_CHECK(send_sensor_data(1, "Temp", temp_value, &response_data));
            ESP_LOGI(TAG, "Czas aktywacji: %d sekundy", response_data.activation_time);
            ESP_LOGI(TAG, "Częstotliwość: %d minut", response_data.frequency);
            ESP_LOGI(TAG, "Potrzebuje nawożenia: %s", response_data.needs_fertilization ? "TAK" : "NIE");
            vTaskDelay(pdMS_TO_TICKS(2000));

            ESP_ERROR_CHECK(send_sensor_data(2, "PH", ph_value, &response_data));
            ESP_LOGI(TAG, "Czas aktywacji: %d sekundy", response_data.activation_time);
            ESP_LOGI(TAG, "Częstotliwość: %d minut", response_data.frequency);
            ESP_LOGI(TAG, "Potrzebuje nawożenia: %s", response_data.needs_fertilization ? "TAK" : "NIE");
            vTaskDelay(pdMS_TO_TICKS(2000));

            ESP_ERROR_CHECK(send_sensor_data(5, "TDS", tds_value, &response_data));
            ESP_LOGI(TAG, "Czas aktywacji: %d sekundy", response_data.activation_time);
            ESP_LOGI(TAG, "Częstotliwość: %d minut", response_data.frequency);
            ESP_LOGI(TAG, "Potrzebuje nawożenia: %s", response_data.needs_fertilization ? "TAK" : "NIE");
            vTaskDelay(pdMS_TO_TICKS(2000));

            vTaskDelay(pdMS_TO_TICKS(10000));
        } else {
            // Brak połączenia Wi-Fi, czekaj na połączenie
            wait_for_wifi_connection();  // Czekaj aż urządzenie połączy się z WiFi
        }
    }
}


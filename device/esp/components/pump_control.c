#include "pump_control.h"
#include "esp_log.h"
#include "driver/gpio.h"
#include "driver/rtc_io.h"
#include "freertos/FreeRTOS.h"

static const char *TAG = "PumpControl";

#define PUMP_GPIO_PIN GPIO_NUM_12

esp_err_t pump_init(void) {
    rtc_gpio_init(PUMP_GPIO_PIN);
    rtc_gpio_set_direction(PUMP_GPIO_PIN, RTC_GPIO_MODE_OUTPUT_ONLY);
    return ESP_OK;
}

// Funkcja do aktywacji pompy na określony czas (w sekundach)
esp_err_t activate_pump(int activation_time) {
    if (activation_time <= 0) {
        ESP_LOGE(TAG, "Nieprawidłowy czas aktywacji: %d", activation_time);
        return ESP_ERR_INVALID_ARG;
    }

    // Włączamy pompę (ustawiamy GPIO na HIGH)
    rtc_gpio_set_level(PUMP_GPIO_PIN, 1);
    ESP_LOGI(TAG, "Pompa włączona na %d sekund", activation_time);
    uint32_t state =  rtc_gpio_get_level(PUMP_GPIO_PIN);
    ESP_LOGI(TAG, "Pompa jest %s", state == 1? "włączona" : "wyłączona");

    // Czekamy określony czas
    vTaskDelay(pdMS_TO_TICKS(activation_time * 1000));

    // Wyłączamy pompę (ustawiamy GPIO na LOW)
    rtc_gpio_set_level(PUMP_GPIO_PIN, 0);
    ESP_LOGI(TAG, "Pompa wyłączona");
    state =  rtc_gpio_get_level(PUMP_GPIO_PIN);
    ESP_LOGI(TAG, "Pompa jest %s", state == 1? "włączona" : "wyłączona");

    return ESP_OK;
}

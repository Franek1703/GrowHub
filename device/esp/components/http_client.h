#ifndef HTTP_CLIENT_H
#define HTTP_CLIENT_H

#include "esp_err.h"
#include "esp_wifi.h"
#include "esp_http_client.h"

typedef struct {
    int activation_time;        // Czas aktywacji w sekundach
    int frequency;              // Częstotliwość w minutach
    bool needs_fertilization;   // Informacja, czy wymaga nawożenia
} sensor_data_t;


// Funkcja inicjalizująca połączenie WiFi
esp_err_t wifi_init_sta(void);

// Funkcja inicjalizująca klienta HTTP
esp_err_t http_init(void);

// Funkcja inicjalizująca aplikację: WiFi + HTTP
esp_err_t app_init(void);

// Główna funkcja do wysyłania zapytania GET do serwera HTTP
esp_err_t send_get_request(const char *endpoint);

// Główna funkcja do wysyłania zapytania POST do serwera HTTP
esp_err_t send_post_request(const char *data);

// Funkcja do wysyłania odczytów z czujników w formacie JSON
esp_err_t send_sensor_data(int sensor_id, const char *sensor_type, float value, sensor_data_t *response_data);

esp_err_t check_wifi_connection(void);

esp_err_t wait_for_wifi_connection(void);
esp_err_t get_sensor_frequency(int sensor_id, sensor_data_t *response_data);

#endif // HTTP_CLIENT_H

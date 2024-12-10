#include "http_client.h"
#include "esp_log.h"
#include "nvs_flash.h"
#include "esp_event.h"
#include "esp_netif.h"
#include "cJSON.h"
#include <stdio.h>

// Konfiguracja WiFi
#define WIFI_SSID "GalaxyS23"
#define WIFI_PASSWORD "12345688"

// Adres URL serwera (przykład z protokołem HTTP)
#define SERVER_URL "http://192.168.163.55:5000"

// Tag do logowania
static const char *TAG = "HTTP_CLIENT";

// Struktura klienta HTTP
esp_http_client_handle_t client;

// Funkcja do połączenia z WiFi
esp_err_t wifi_init_sta(void)
{
    ESP_LOGI(TAG, "Inicjalizowanie WiFi...");

    esp_netif_init();
    esp_event_loop_create_default();

    esp_netif_create_default_wifi_sta();
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    esp_wifi_init(&cfg);

    wifi_config_t wifi_config = {
        .sta = {
            .ssid = WIFI_SSID,
            .password = WIFI_PASSWORD,
        },
    };
    esp_wifi_set_config(ESP_IF_WIFI_STA, &wifi_config);
    esp_wifi_start();
    esp_wifi_connect();

    ESP_LOGI(TAG, "Łączenie z siecią WiFi...");
    return ESP_OK;
}

// Funkcja do inicjalizacji połączenia z serwerem HTTP
esp_err_t http_init(void)
{
    esp_http_client_config_t config = {
        .url = SERVER_URL, // Adres URL serwera HTTP
        // .event_handler = NULL, // Możesz dodać odpowiednie obsługi zdarzeń, jeśli potrzebujesz
        .timeout_ms = 10000};

    // Inicjalizowanie klienta HTTP
    client = esp_http_client_init(&config);

    return ESP_OK;
}

// Funkcja do sprawdzenia, czy urządzenie jest połączone z WiFi
esp_err_t check_wifi_connection(void)
{
    wifi_ap_record_t ap_info;
    esp_err_t ret = esp_wifi_sta_get_ap_info(&ap_info);
    if (ret == ESP_OK)
    {
        ESP_LOGI(TAG, "Połączono z siecią WiFi: SSID: %s", ap_info.ssid);
        return ESP_OK;
    }
    else
    {
        ESP_LOGE(TAG, "Brak połączenia z WiFi");
        return ESP_FAIL;
    }
}

// Funkcja do ponownego łączenia z WiFi, czekając przez dłuższy czas
esp_err_t reconnect_wifi(void)
{
    ESP_LOGI(TAG, "Próba ponownego połączenia z WiFi...");

    // Rozłącz WiFi przed ponownym połączeniem
    esp_wifi_disconnect();
    esp_wifi_connect();

    // Czekaj, aż WiFi się połączy przez maksymalnie 60 sekund
    int retries = 0;
    int max_retries = 30; // 30 prób, co 2 sekundy
    while (check_wifi_connection() != ESP_OK && retries < max_retries)
    {
        retries++;
        ESP_LOGI(TAG, "Ponawianie próby połączenia z WiFi, próba: %d", retries);
        vTaskDelay(pdMS_TO_TICKS(2000)); // Czekaj 2 sekundy przed kolejną próbą
    }

    if (retries >= max_retries)
    {
        ESP_LOGE(TAG, "Nie udało się połączyć z WiFi po 60 sekundach");
        return ESP_FAIL; // Zwracamy błąd po wyczerpaniu prób
    }

    ESP_LOGI(TAG, "Połączono z WiFi!");
    return ESP_OK;
}

// Funkcja do oczekiwania na połączenie z WiFi
esp_err_t wait_for_wifi_connection(void)
{
    int retries = 0;
    int max_retries = 30; // Maksymalnie 30 prób, po 2 sekundy
    while (check_wifi_connection() != ESP_OK)
    {
        retries++;
        if (retries >= max_retries)
        {
            ESP_LOGE(TAG, "Brak połączenia z WiFi po 30 próbach");
            ESP_ERROR_CHECK(reconnect_wifi()); // Spróbuj ponownie połączyć się
        }
        ESP_LOGI(TAG, "Brak połączenia z WiFi, ponawiam próbę...");
        vTaskDelay(pdMS_TO_TICKS(2000)); // Czekaj 2 sekundy przed ponowną próbą
    }
    ESP_LOGI(TAG, "Połączono z WiFi!");
    return ESP_OK;
}

// Funkcja init - połączenie z WiFi i inicjalizacja HTTP
esp_err_t app_init(void)
{
    // Inicjalizacja NVS (często wymagane przez WiFi)
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND)
    {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    // Łączenie z WiFi
    ESP_ERROR_CHECK(wifi_init_sta());

    // Czekaj na połączenie z WiFi, ponów próbę jeśli połączenie nie jest dostępne
    ESP_ERROR_CHECK(wait_for_wifi_connection());

    // Inicjalizacja klienta HTTP
    ESP_ERROR_CHECK(http_init());

    return ESP_OK;
}

esp_err_t send_get_request(const char *endpoint)
{
    // Tworzymy pełny URL
    char url[256];
    snprintf(url, sizeof(url), "%s%s", SERVER_URL, endpoint);

    // Ustawiamy pełny URL do klienta HTTP
    esp_http_client_set_url(client, url);
    esp_err_t err = esp_http_client_perform(client);
    if (err == ESP_OK)
    {
        ESP_LOGI(TAG, "Odpowiedź z serwera: %d", esp_http_client_get_status_code(client));
    }
    else
    {
        ESP_LOGE(TAG, "Błąd wysyłania zapytania GET: %s", esp_err_to_name(err));
    }
    return err;
}

// Funkcja do wysyłania zapytania POST do serwera HTTP
esp_err_t send_post_request(const char *data)
{
    esp_http_client_set_url(client, SERVER_URL);
    esp_http_client_set_method(client, HTTP_METHOD_POST);
    esp_http_client_set_post_field(client, data, strlen(data));

    esp_err_t err = esp_http_client_perform(client);
    if (err == ESP_OK)
    {
        ESP_LOGI(TAG, "Odpowiedź z serwera: %d", esp_http_client_get_status_code(client));
    }
    else
    {
        ESP_LOGE(TAG, "Błąd wysyłania zapytania POST: %s", esp_err_to_name(err));
    }
    return err;
}

// Funkcja do wysyłania danych z czujników i odbierania odpowiedzi
esp_err_t send_sensor_data(int sensor_id, const char *sensor_type, float value, sensor_data_t *response_data)
{
    // Tworzymy obiekt JSON
    cJSON *root = cJSON_CreateObject();
    cJSON_AddNumberToObject(root, "sensor_id", sensor_id);
    cJSON_AddStringToObject(root, "sensor_type", sensor_type);
    cJSON_AddNumberToObject(root, "value", value);

    // Zamieniamy obiekt JSON na string
    char *json_data = cJSON_Print(root);

    // Tworzymy pełny URL łącząc stałą część URL z dynamiczną
    char url[256];                                                                     // Wystarczająca długość na URL
    snprintf(url, sizeof(url), "%s%s", SERVER_URL, "/device-service-api/add_reading"); // Łączymy stały URL z dynamicznym

    // Ustawiamy dane do wysłania
    esp_http_client_set_url(client, url);
    esp_http_client_set_method(client, HTTP_METHOD_POST);
    esp_http_client_set_post_field(client, json_data, strlen(json_data));

    esp_http_client_set_header(client, "Content-Type", "application/json");

    // Wykonujemy zapytanie POST
    esp_err_t err = esp_http_client_perform(client);
    ESP_LOGI(TAG, "JSON: %s", json_data);
    if (err == ESP_OK)
    {
        int status_code = esp_http_client_get_status_code(client);
        ESP_LOGI(TAG, "Odpowiedź z serwera: %d", status_code);

        if (status_code == 200)
        {
            // Przydzielamy bufor na odpowiedź
            char response[1024]; // Przydzielamy 1024 bajty na odpowiedź (można dostosować)
            int read_len = esp_http_client_read_response(client, response, sizeof(response) - 1);
            ESP_LOGI(TAG, "Response: %s", response);
            ESP_LOGI(TAG, "Response length: %d", read_len);
            if (read_len >= 0)
            {
                // Null-terminate the response
                response[read_len] = '\0';
                ESP_LOGI(TAG, "Odpowiedź serwera: %s", response);

                // Odczytanie odpowiedzi JSON
                cJSON *response_json = cJSON_Parse(response);
                // ESP_LOGI(TAG, "Response JSON: %s", response_json->string);
                if (response_json != NULL)
                {
                    // Bezpieczne wyciąganie danych z odpowiedzi JSON
                    response_data->activation_time = 5;         // Domyślna wartość, gdy brak
                    response_data->frequency = 10;              // Domyślna wartość, gdy brak
                    response_data->needs_fertilization = false; // Domyślna wartość, gdy brak

                    cJSON *item = cJSON_GetObjectItem(response_json, "activation_time");

                    if (item && cJSON_IsNumber(item))
                    {
                        response_data->activation_time = item->valueint;
                    }

                    item = cJSON_GetObjectItem(response_json, "frequency");
                    if (item && cJSON_IsNumber(item))
                    {
                        response_data->frequency = item->valueint;
                    }

                    item = cJSON_GetObjectItem(response_json, "needs_fertilization");
                    if (item && cJSON_IsBool(item))
                    {
                        // Poprawione: Boolean jest przechowywany jako int (0 = false, 1 = true)
                        response_data->needs_fertilization = item->valueint == 1;
                    }

                    cJSON_Delete(response_json);
                }
                else
                {
                    ESP_LOGE(TAG, "Błąd parsowania odpowiedzi JSON");
                }
            }
            else
            {
                ESP_LOGE(TAG, "Błąd podczas odczytu odpowiedzi z serwera");
            }
        }
        else
        {
            ESP_LOGE(TAG, "Błąd serwera, kod: %d", status_code);
        }
    }
    else
    {
        ESP_LOGE(TAG, "Błąd wysyłania danych z czujników: %s", esp_err_to_name(err));
    }

    // Czyszczenie obiektu JSON
    cJSON_Delete(root);
    free(json_data);

    return err;
}

// Funkcja do pobierania częstotliwości czujnika z serwera
esp_err_t get_sensor_frequency(int sensor_id, sensor_data_t *response_data)
{
    // Tworzymy pełny URL dla endpointu pobierającego częstotliwość czujnika
    char endpoint[128];
    snprintf(endpoint, sizeof(endpoint), "/device-service-api/get_sensor_frequency?id=%d", sensor_id);

    // Wysyłamy zapytanie GET do serwera
    esp_err_t err = send_get_request(endpoint);
    if (err != ESP_OK)
    {
        ESP_LOGE(TAG, "Błąd podczas wysyłania zapytania GET");
        return err;
    }

    // Sprawdzamy status odpowiedzi HTTP
    int status_code = esp_http_client_get_status_code(client);
    if (status_code == 200)
    {
        // Przydzielamy bufor na odpowiedź z serwera
        char response[1024];
        int read_len = esp_http_client_read_response(client, response, sizeof(response) - 1);

        if (read_len >= 0)
        {
            // Null-terminate the response
            response[read_len] = '\0';

            // Parsujemy odpowiedź JSON
            cJSON *response_json = cJSON_Parse(response);
            if (response_json != NULL)
            {
                cJSON *item = cJSON_GetObjectItem(response_json, "frequency");
                if (item && cJSON_IsNumber(item))
                {
                    response_data->frequency = item->valueint; // Zaktualizowanie częstotliwości
                }
                else
                {
                    ESP_LOGE(TAG, "Brak pola 'frequency' w odpowiedzi JSON");
                }
                cJSON_Delete(response_json);
            }
            else
            {
                ESP_LOGE(TAG, "Błąd parsowania odpowiedzi JSON");
            }
        }
        else
        {
            ESP_LOGE(TAG, "Błąd podczas odczytu odpowiedzi z serwera");
        }
    }
    else
    {
        ESP_LOGE(TAG, "Błąd odpowiedzi z serwera, kod: %d", status_code);
    }

    return ESP_OK;
}

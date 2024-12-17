#include "http_client.h"
#include "esp_log.h"
#include "nvs_flash.h"
#include "esp_event.h"
#include "esp_netif.h"
#include "cJSON.h"
#include <stdio.h>
#include "esp_mac.h"

// Konfiguracja WiFi
#define WIFI_SSID "GalaxyS23"
#define WIFI_PASSWORD "12345688"

// Adres URL serwera (przykład z protokołem HTTP)
#define SERVER_URL "http://192.168.103.55:5000"

#define RESPONSE_BUFFER_SIZE 1024
char response_buffer[RESPONSE_BUFFER_SIZE];
int response_len = 0;

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

void clear_response_buffer()
{
    memset(response_buffer, 0, sizeof(response_buffer));
    response_len = 0;
}

esp_err_t _http_event_handle(esp_http_client_event_t *evt)
{
    switch (evt->event_id)
    {
    case HTTP_EVENT_ERROR:
        ESP_LOGI(TAG, "HTTP_EVENT_ERROR");
        break;
    case HTTP_EVENT_ON_CONNECTED:
        clear_response_buffer();
        ESP_LOGI(TAG, "HTTP_EVENT_ON_CONNECTED");
        break;
    case HTTP_EVENT_HEADER_SENT:
        ESP_LOGI(TAG, "HTTP_EVENT_HEADER_SENT");
        break;
    case HTTP_EVENT_ON_HEADER:
        ESP_LOGI(TAG, "HTTP_EVENT_ON_HEADER");
        printf("%.*s", evt->data_len, (char *)evt->data);
        break;
    case HTTP_EVENT_ON_DATA:
        ESP_LOGI(TAG, "HTTP_EVENT_ON_DATA, len=%d", evt->data_len);
        if (!esp_http_client_is_chunked_response(evt->client))
        {
            if (response_len + evt->data_len < RESPONSE_BUFFER_SIZE)
            {
                memcpy(response_buffer + response_len, evt->data, evt->data_len);
                response_len += evt->data_len;
            }
            else
            {
                ESP_LOGE(TAG, "Response buffer overflow!");
            }
        }
        break;
    case HTTP_EVENT_ON_FINISH:
        ESP_LOGI(TAG, "HTTP_EVENT_ON_FINISH");
        // Null-terminate the response for safety
        if (response_len < RESPONSE_BUFFER_SIZE)
        {
            response_buffer[response_len] = '\0';
        }
        else
        {
            response_buffer[RESPONSE_BUFFER_SIZE - 1] = '\0';
        }
        ESP_LOGI(TAG, "Full response: %s", response_buffer);
        break;
    case HTTP_EVENT_DISCONNECTED:
        ESP_LOGI(TAG, "HTTP_EVENT_DISCONNECTED");
        break;
    case HTTP_EVENT_REDIRECT:
        ESP_LOGI(TAG, "HTTP_EVENT_REDIRECT");
        break;
    }
    return ESP_OK;
}

// Funkcja do inicjalizacji połączenia z serwerem HTTP
esp_err_t http_init(void)
{
    esp_err_t err = ESP_FAIL;
    esp_http_client_config_t config = {
        .url = SERVER_URL, // Adres URL serwera HTTP
        .event_handler = _http_event_handle,
        .timeout_ms = 10000};

    // Inicjalizowanie klienta HTTP
    client = esp_http_client_init(&config);
    while(err != ESP_OK){
        err = esp_http_client_perform(client);
         vTaskDelay(pdMS_TO_TICKS(2000));
    }
    
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

    // Czekaj, aż WiFi się połączy przez maksymalnie 60 sekund
    int retries = 0;
    int max_retries = 10; // 30 prób, co 2 sekundy
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
    int max_retries = 10; // Maksymalnie 30 prób, po 2 sekundy
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
    ESP_LOGI(TAG, "Endpoint: %s", url);
    // Ustawiamy pełny URL do klienta HTTP
    esp_http_client_set_url(client, url);
    esp_http_client_set_method(client, HTTP_METHOD_GET);
    esp_err_t err = esp_http_client_perform(client);
    if (err == ESP_OK)
    {
        // esp_http_client_set_method(client, HTTP_METHOD_POST);
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
esp_err_t send_sensor_data(int sensor_id, const char *sensor_type, float value, sensor_data_t *sensor_data, device_data_t *device_data)
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
            if (strlen(response_buffer) > 0)
            {
                // Odczytanie odpowiedzi JSON
                cJSON *response_json = cJSON_Parse(response_buffer);
                // ESP_LOGI(TAG, "Response JSON: %s", response_json->string);
                if (response_json != NULL)
                {
                    // Bezpieczne wyciąganie danych z odpowiedzi JSON

                    cJSON *item = cJSON_GetObjectItem(response_json, "activation_time");

                    if (item && cJSON_IsNumber(item))
                    {
                        device_data->activation_time = item->valueint;
                    }

                    item = cJSON_GetObjectItem(response_json, "frequency");
                    if (item && cJSON_IsNumber(item))
                    {
                        sensor_data->frequency = item->valueint;
                    }

                    item = cJSON_GetObjectItem(response_json, "needs_fertilization");
                    if (item && cJSON_IsBool(item))
                    {
                        // Poprawione: Boolean jest przechowywany jako int (0 = false, 1 = true)
                        device_data->needs_fertilization = item->valueint == 1;
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
    snprintf(endpoint, sizeof(endpoint), "/device-service-api/get_sensor_frequency?sensor_id=%d", sensor_id);

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
        if (strlen(response_buffer) > 0)
        {
            cJSON *response_json = cJSON_Parse(response_buffer);
            if (response_json != NULL)
            {
                cJSON *item = cJSON_GetObjectItem(response_json, "frequency");
                if (item && cJSON_IsNumber(item))
                {
                    response_data->frequency = item->valueint; // Zaktualizowanie częstotliwości
                    ESP_LOGI(TAG, "Udało się poprawnie przypisać frequency: %d", response_data->frequency);
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

esp_err_t get_device_id(device_data_t *device_data)
{
    uint8_t base_mac_addr[6] = {0};
    esp_efuse_mac_get_default(base_mac_addr);
    char mac_str[23];
    snprintf(mac_str, sizeof(mac_str), "%02x:%02x:%02x:%02x:%02x:%02x",
             base_mac_addr[0], base_mac_addr[1], base_mac_addr[2],
             base_mac_addr[3], base_mac_addr[4], base_mac_addr[5]);
    ESP_LOGI(TAG, "MAC: %s", mac_str);

    cJSON *root = cJSON_CreateObject();
    cJSON_AddStringToObject(root, "ssid", mac_str);

    // Zamieniamy obiekt JSON na string
    char *json_data = cJSON_Print(root);

    char endpoint[128];
    snprintf(endpoint, sizeof(endpoint), "/device-service-api/add_new/device");
    char url[256];
    snprintf(url, sizeof(url), "%s%s", SERVER_URL, endpoint);
    ESP_LOGI(TAG, "Endpoint: %s", url);
    // Ustawiamy pełny URL do klienta HTTP
    esp_http_client_set_url(client, url);
    esp_http_client_set_method(client, HTTP_METHOD_POST);
    esp_http_client_set_post_field(client, json_data, strlen(json_data));

    esp_http_client_set_header(client, "Content-Type", "application/json");
    esp_err_t err = esp_http_client_perform(client);
    if (err != ESP_OK)
    {
        ESP_LOGE(TAG, "Błąd podczas wysyłania zapytania GET");
        return err;
    }

    int status_code = esp_http_client_get_status_code(client);
    if (status_code == 200 || status_code == 400)
    {
        if (strlen(response_buffer) > 0)
        {
            cJSON *response_json = cJSON_Parse(response_buffer);
            if (response_json != NULL)
            {
                cJSON *item = cJSON_GetObjectItem(response_json, "device_id");
                if (item && cJSON_IsNumber(item))
                {
                    device_data->device_id = item->valueint;
                    ESP_LOGI(TAG, "Udało się poprawnie przypisać device id: %d", device_data->device_id);
                }
                else
                {
                    ESP_LOGE(TAG, "Brak pola 'device_id' w odpowiedzi JSON");
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

esp_err_t get_sensor_id(const char *sensor_type, int device_id, sensor_data_t *sensor_data_t)
{
    // Tworzymy obiekt JSON
    cJSON *root = cJSON_CreateObject();
    cJSON_AddNumberToObject(root, "device_id", device_id);
    cJSON_AddStringToObject(root, "sensor_type", sensor_type);

    // Zamieniamy obiekt JSON na string
    char *json_data = cJSON_Print(root);

    char url[256];
    snprintf(url, sizeof(url), "%s%s", SERVER_URL, "/device-service-api/add_new/sensor");
    ESP_LOGI(TAG, "Endpoint: %s", url);

    // Ustawiamy dane do wysłania
    esp_http_client_set_url(client, url);
    esp_http_client_set_method(client, HTTP_METHOD_POST);
    esp_http_client_set_post_field(client, json_data, strlen(json_data));

    esp_http_client_set_header(client, "Content-Type", "application/json");

    // Wykonujemy zapytanie POST
    esp_err_t err = esp_http_client_perform(client);
    ESP_LOGI(TAG, "JSON: %s", json_data);
    if (err != ESP_OK)
    {
        ESP_LOGE(TAG, "Błąd podczas wysyłania zapytania GET");
        return err;
    }

    int status_code = esp_http_client_get_status_code(client);
    if (status_code == 200 || status_code == 400)
    {
        if (strlen(response_buffer) > 0)
        {
            cJSON *response_json = cJSON_Parse(response_buffer);
            if (response_json != NULL)
            {
                cJSON *item = cJSON_GetObjectItem(response_json, "sensor_id");
                if (item && cJSON_IsNumber(item))
                {
                    sensor_data_t->sensor_id = item->valueint;
                    ESP_LOGI(TAG, "Udało się poprawnie przypisać sensor id: %d", sensor_data_t->sensor_id);
                }
                else
                {
                    ESP_LOGE(TAG, "Brak pola 'device_id' w odpowiedzi JSON");
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

esp_err_t get_pump_id(int device_id)
{
    // Tworzymy obiekt JSON
    cJSON *root = cJSON_CreateObject();
    cJSON_AddNumberToObject(root, "device_id", device_id);
    cJSON_AddStringToObject(root, "device_type", "Pump");

    // Zamieniamy obiekt JSON na string
    char *json_data = cJSON_Print(root);

    char url[256];
    snprintf(url, sizeof(url), "%s%s", SERVER_URL, "/device-service-api/add_new/fertilizing_device");
    ESP_LOGI(TAG, "Endpoint: %s", url);

    // Ustawiamy dane do wysłania
    esp_http_client_set_url(client, url);
    esp_http_client_set_method(client, HTTP_METHOD_POST);
    esp_http_client_set_post_field(client, json_data, strlen(json_data));

    esp_http_client_set_header(client, "Content-Type", "application/json");

    // Wykonujemy zapytanie POST
    esp_err_t err = esp_http_client_perform(client);
    ESP_LOGI(TAG, "JSON: %s", json_data);
    if (err != ESP_OK)
    {
        ESP_LOGE(TAG, "Błąd podczas wysyłania zapytania GET");
        return err;
    }

    int status_code = esp_http_client_get_status_code(client);
    if (status_code == 200 || status_code == 400)
    {
        if (strlen(response_buffer) > 0)
        {
            cJSON *response_json = cJSON_Parse(response_buffer);
            if (response_json != NULL)
            {
                cJSON *item = cJSON_GetObjectItem(response_json, "fertilizing_device_id");
                if (item && cJSON_IsNumber(item))
                {

                    ESP_LOGI(TAG, "Udało się poprawnie przypisać fertilizing_device id: %d", item->valueint);
                }
                else
                {
                    ESP_LOGE(TAG, "Brak pola 'device_id' w odpowiedzi JSON");
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

esp_err_t post_dose(device_data_t *device_data)
{
    // Tworzymy obiekt JSON
    cJSON *root = cJSON_CreateObject();
    cJSON_AddNumberToObject(root, "device_id", device_data->device_id);
    cJSON_AddNumberToObject(root, "dose", device_data->activation_time);

    // Zamieniamy obiekt JSON na string
    char *json_data = cJSON_Print(root);

    char url[256];
    snprintf(url, sizeof(url), "%s%s", SERVER_URL, "/device-service-api/add_dosage");
    ESP_LOGI(TAG, "Endpoint: %s", url);

    // Ustawiamy dane do wysłania
    esp_http_client_set_url(client, url);
    esp_http_client_set_method(client, HTTP_METHOD_POST);
    esp_http_client_set_post_field(client, json_data, strlen(json_data));

    esp_http_client_set_header(client, "Content-Type", "application/json");

    // Wykonujemy zapytanie POST
    esp_err_t err = esp_http_client_perform(client);
    ESP_LOGI(TAG, "JSON: %s", json_data);
    if (err != ESP_OK)
    {
        ESP_LOGE(TAG, "Błąd podczas wysyłania zapytania GET");
        return err;
    }

    int status_code = esp_http_client_get_status_code(client);
    if (status_code == 201)
    {
        ESP_LOGI(TAG, "Udało się poprawnie przypisać dawkę: %d", device_data->activation_time);
    }
    else
    {
        ESP_LOGE(TAG, "Błąd odpowiedzi z serwera, kod: %d", status_code);
    }

    return ESP_OK;
}
#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "sensor_reader.h"
#include "http_client.h"
#include "freertos/semphr.h"
#include "pump_control.h"

// Deklaracja semafora
SemaphoreHandle_t xSemaphore;

static const char *TAG = "Main";
void read_sensor_data_task(void *pvParameters)
{
    // Rzutujemy parametr na odpowiedni typ
    sensor_data_t *sensor_data = (sensor_data_t *)pvParameters;
    device_data_t *device = (device_data_t *)(sensor_data + 1); // Wskaźnik na kolejne dane po sensor_data_t

    while (1)
    {
        // Czekaj na dostęp do semafora
        if (xSemaphoreTake(xSemaphore, portMAX_DELAY) == pdTRUE)
        {
            // Odczyt danych z czujnika
            float sensor_value = 0;
            if (strcmp(sensor_data->sensor_type, "Temp") == 0)
            {
                sensor_value = read_temperature(); // Odczyt temperatury
            }
            else if (strcmp(sensor_data->sensor_type, "PH") == 0)
            {
                sensor_value = read_ph(); // Odczyt pH
            }
            else if (strcmp(sensor_data->sensor_type, "TDS") == 0)
            {
                sensor_value = read_tds(); // Odczyt TDS
            }

            ESP_LOGI(TAG, "Odczytano wartość z czujnika: %s = %.2f", sensor_data->sensor_type, sensor_value);
            // Próba wysłania danych do serwera z pętlą i opóźnieniem
            esp_err_t send_result;
            do
            {
                send_result = send_sensor_data(sensor_data->sensor_id, sensor_data->sensor_type, sensor_value, sensor_data, device);
                if (send_result != ESP_OK)
                {
                    ESP_LOGW(TAG, "Nie udało się wysłać danych, ponawiam próbę...");
                    vTaskDelay(pdMS_TO_TICKS(5000)); // Odczekaj 5 sekund przed ponowną próbą
                }
            } while (send_result != ESP_OK);
            ESP_LOGI(TAG, "Czas aktywacji: %d sekundy", device->activation_time);
            ESP_LOGI(TAG, "Częstotliwość: %d minut", sensor_data->frequency);
            ESP_LOGI(TAG, "Potrzebuje nawożenia: %s", device->needs_fertilization ? "TAK" : "NIE");

            if (device->needs_fertilization)
            {
                ESP_LOGI(TAG, "Aktywacja pompy na %d sekund", device->activation_time);
                esp_err_t err = activate_pump(device->activation_time);
                if (err == ESP_OK)
                {
                    do
                    {
                        send_result = post_dose(device);
                        if (send_result != ESP_OK)
                        {
                            ESP_LOGW(TAG, "Nie udało się wysłać danych, ponawiam próbę...");
                            vTaskDelay(pdMS_TO_TICKS(5000)); // Odczekaj 5 sekund przed ponowną próbą
                        }
                    } while (send_result != ESP_OK);
                }
            }

            // Zwalniamy semafor po zakończeniu operacji
            xSemaphoreGive(xSemaphore);
        }
        else
        {
            // W przypadku braku dostępu do semafora, możemy spróbować ponownie lub zakończyć wątek
            ESP_LOGW(TAG, "Nie udało się zdobyć semafora, wątek kończy działanie");
        }

        // Czekaj zgodnie z częstotliwością (w minutach)
        vTaskDelay(pdMS_TO_TICKS(sensor_data->frequency * 60 * 1000));
    }
}

// Funkcja monitorująca połączenie Wi-Fi
void wifi_monitor_task(void *pvParameters)
{
    while (1)
    {
        if (check_wifi_connection() != ESP_OK)
        {
            ESP_LOGW(TAG, "Brak połączenia z Wi-Fi! Próbuję połączyć się ponownie...");
            wait_for_wifi_connection(); // Czekaj, aż połączenie zostanie przywrócone
        }
        vTaskDelay(pdMS_TO_TICKS(1000)); // Sprawdzaj co sekundę
    }
}

void app_main()
{
    init_adc();
    init_onewire();
    pump_init();
    ESP_ERROR_CHECK(app_init());

    // Inicjalizacja semafora
    xSemaphore = xSemaphoreCreateMutex();

    device_data_t device;
    //Get device id
    esp_err_t result;
    do
    {
        result = get_device_id(&device);
        if (result != ESP_OK)
        {
            ESP_LOGW(TAG, "Nie udało się pobrać ID urządzenia, ponawiam próbę...");
            vTaskDelay(pdMS_TO_TICKS(5000));
        }
    } while (result != ESP_OK);
    ESP_LOGI(TAG, "Device ID: %d", device.device_id);

    sensor_data_t temp = {0}; // Oczyszczamy pamięć
    sensor_data_t tds = {0};
    sensor_data_t ph = {0};
    const char *sensor_types[] = {"Temp", "PH", "TDS"};
    sensor_data_t *sensors[] = {&temp, &ph, &tds};

    // Sensor id
    for (int i = 0; i < 3; i++)
    {
        do
        {
            result = get_sensor_id(sensor_types[i], device.device_id, sensors[i]);
            if (result != ESP_OK)
            {
                ESP_LOGW(TAG, "Nie udało się pobrać ID sensora %s, ponawiam próbę...", sensor_types[i]);
                vTaskDelay(pdMS_TO_TICKS(5000));
            }
        } while (result != ESP_OK);
    }
    //PUPM id
    do
    {
        result = get_pump_id(device.device_id);
        if (result != ESP_OK)
        {
            ESP_LOGW(TAG, "Nie udało się pobrać ID pompy, ponawiam próbę...");
            vTaskDelay(pdMS_TO_TICKS(5000));
        }
    } while (result != ESP_OK);

    //Sensor frequency
    for (int i = 0; i < 3; i++)
    {
        do
        {
            result = get_sensor_frequency(sensors[i]->sensor_id, sensors[i]);
            if (result != ESP_OK)
            {
                ESP_LOGW(TAG, "Nie udało się pobrać częstotliwości sensora %s, ponawiam próbę...", sensor_types[i]);
                vTaskDelay(pdMS_TO_TICKS(5000));
            }
        } while (result != ESP_OK);
    }
    ESP_LOGI(TAG, "Temp: id: %d, frequency: %d", temp.sensor_id, temp.frequency);
    ESP_LOGI(TAG, "PH: id: %d, frequency: %d", ph.sensor_id, ph.frequency);
    ESP_LOGI(TAG, "TDS: id: %d, frequency: %d", tds.sensor_id, tds.frequency);

    // Ustawienie typów sensorów
    strcpy(temp.sensor_type, "Temp");
    strcpy(ph.sensor_type, "PH");
    strcpy(tds.sensor_type, "TDS");

    for (int i = 0; i < PH_SAMPLES; i++)
    {
        read_ph();
        vTaskDelay(pdMS_TO_TICKS(100));
    }

        for (int i = 0; i < TDS_SAMPLES; i++)
    {
        read_tds();
        vTaskDelay(pdMS_TO_TICKS(100));
    }


    // Przygotowanie zadania do odczytu danych czujników
    sensor_device_data_t temp_with_device = {temp, device};
    sensor_device_data_t ph_with_device = {ph, device};
    sensor_device_data_t tds_with_device = {tds, device};

    xTaskCreate(read_sensor_data_task, "Read Temperature", 4096, &temp_with_device, 2, NULL);
    xTaskCreate(read_sensor_data_task, "Read PH", 4096, &ph_with_device, 2, NULL);
    xTaskCreate(read_sensor_data_task, "Read TDS", 4096, &tds_with_device, 2, NULL);

    // Tworzenie wątku monitorującego połączenie Wi-Fi z wyższym priorytetem
    xTaskCreate(wifi_monitor_task, "Wi-Fi Monitor", 2048, NULL, 3, NULL);

    while (1)
    {
        vTaskDelay(pdMS_TO_TICKS(1000)); // Czekaj na zakończenie zadań
    }
}

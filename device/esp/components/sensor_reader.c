#include "sensor_reader.h"
#include "esp_log.h"
#include "esp_check.h"

#define VREF 5.0 // Odniesienie napięcia dla czujników TDS i pH

static const char *TAG = "SensorReader";

// Uchwyt do DS18B20
ds18b20_device_handle_t ds18b20s[EXAMPLE_ONEWIRE_MAX_DS18B20];
int ds18b20_device_num = 0;

// Uchwyt dla ADC
adc_oneshot_unit_handle_t adc_handle;

// Parametry do zbierania próbek pH
int pHArray[PH_SAMPLES]; // Tablica do przechowywania próbek
int pHArrayIndex = 0;    // Indeks tablicy próbek

// Inicjalizacja jednostki ADC
void init_adc() {
    // Konfiguracja jednostki ADC
    adc_oneshot_unit_init_cfg_t init_config1 = {
        .unit_id = ADC_UNIT_1,
        .ulp_mode = ADC_ULP_MODE_DISABLE,
    };

    esp_err_t ret = adc_oneshot_new_unit(&init_config1, &adc_handle);
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to initialize ADC unit: %s", esp_err_to_name(ret));
        return;
    }

    // Konfiguracja kanałów ADC
    adc_oneshot_chan_cfg_t adc_chan_cfg = {
        .atten = ADC_ATTEN_DB_12,    // Ustawienia wzmocnienia
        .bitwidth = ADC_BITWIDTH_12, // Rozdzielczość 12 bitów
    };

    // Konfiguracja kanałów
    adc_oneshot_config_channel(adc_handle, TDS_SENSOR_PIN, &adc_chan_cfg);  // GPIO36
    adc_oneshot_config_channel(adc_handle, PH_SENSOR_PIN, &adc_chan_cfg);   // GPIO34
}


// Funkcja inicjalizująca OneWire i wyszukująca czujniki DS18B20
void init_onewire() {
    onewire_bus_handle_t bus;
    onewire_bus_config_t bus_config = {
        .bus_gpio_num = EXAMPLE_ONEWIRE_BUS_GPIO,
    };
    onewire_bus_rmt_config_t rmt_config = {
        .max_rx_bytes = 10, // 1byte ROM command + 8byte ROM number + 1byte device command
    };
    ESP_ERROR_CHECK(onewire_new_bus_rmt(&bus_config, &rmt_config, &bus));
    ESP_LOGI(TAG, "1-Wire bus installed on GPIO%d", EXAMPLE_ONEWIRE_BUS_GPIO);

    onewire_device_iter_handle_t iter = NULL;
    onewire_device_t next_onewire_device;
    esp_err_t search_result = ESP_OK;

    ESP_ERROR_CHECK(onewire_new_device_iter(bus, &iter));
    ESP_LOGI(TAG, "Device iterator created, start searching...");
    do {
        search_result = onewire_device_iter_get_next(iter, &next_onewire_device);
        if (search_result == ESP_OK) {
            ds18b20_config_t ds_cfg = {};
            if (ds18b20_new_device(&next_onewire_device, &ds_cfg, &ds18b20s[ds18b20_device_num]) == ESP_OK) {
                ESP_LOGI(TAG, "Found a DS18B20[%d], address: %016llX", ds18b20_device_num, next_onewire_device.address);
                ds18b20_device_num++;
                if (ds18b20_device_num >= EXAMPLE_ONEWIRE_MAX_DS18B20) {
                    ESP_LOGI(TAG, "Max DS18B20 number reached, stop searching...");
                    break;
                }
            } else {
                ESP_LOGI(TAG, "Found an unknown device, address: %016llX", next_onewire_device.address);
            }
        }
    } while (search_result != ESP_ERR_NOT_FOUND);
    ESP_ERROR_CHECK(onewire_del_device_iter(iter));
    ESP_LOGI(TAG, "Searching done, %d DS18B20 device(s) found", ds18b20_device_num);

    // Set resolution for all DS18B20s
    for (int i = 0; i < ds18b20_device_num; i++) {
        ESP_ERROR_CHECK(ds18b20_set_resolution(ds18b20s[i], DS18B20_RESOLUTION_12B));
    }
}


float read_tds() {
    int sensor_value;
    esp_err_t ret = adc_oneshot_read(adc_handle, TDS_SENSOR_PIN, &sensor_value);
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to read TDS sensor: %s", esp_err_to_name(ret));
        return -1.0; // Błąd odczytu
    }
    ESP_LOGI(TAG, "TDS: %d", sensor_value);
    float voltage = (sensor_value / 4095.0) * 3.3;
    float tds_value = (133.42 * voltage * voltage * voltage - 255.86 * voltage * voltage + 857.39 * voltage) * 0.5; // Wzór na TDS w ppm
    ESP_LOGI(TAG, "TDS: %.2f ppm", tds_value);
    return tds_value;
}

// Funkcja do obliczania średniej z próbek pH, eliminując wartości ekstremalne
double average_ph_samples(int* arr, int number) {
    int i;
    int max = arr[0], min = arr[0];
    long sum = 0;

    // Znajdź maksymalną i minimalną wartość
    for (i = 0; i < number; i++) {
        if (arr[i] > max) max = arr[i];
        if (arr[i] < min) min = arr[i];
    }

    // Oblicz sumę, pomijając maksimum i minimum
    for (i = 0; i < number; i++) {
        if (arr[i] != max && arr[i] != min) {
            sum += arr[i];
        }
    }

    // Średnia z pozostałych wartości
    return (double)sum / (number - 2);
}


float read_ph() {
    int sensor_value;
    esp_err_t ret = adc_oneshot_read(adc_handle, PH_SENSOR_PIN, &sensor_value);
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to read pH sensor: %s", esp_err_to_name(ret));
        return -1.0; // Błąd odczytu
    }
    ESP_LOGI(TAG, "PH Sensor data: %d", sensor_value);
    // Zapisz próbkowanie pH do tablicy
    pHArray[pHArrayIndex++] = sensor_value;
    if (pHArrayIndex == PH_SAMPLES) {
        pHArrayIndex = 0; // Przepełnienie tablicy
    }

    // Oblicz średnią z próbek
    double avg = average_ph_samples(pHArray, PH_SAMPLES);


    // Przekształć średnią wartość na napięcie
    float voltage = (avg / 4095.0) * VREF;  // Skalowanie napięcia

    // Dostosowanie napięcia do zakresu pH
    float ph_value = (voltage * 14.0) / 5.0;   // Wzór na pH: przekształcenie napięcia na pH

    // Zapewniamy, że pH nie wykracza poza zakres 0-14
    if (ph_value > 14.0) ph_value = 14.0;
    if (ph_value < 0.0) ph_value = 0.0;

    ESP_LOGI(TAG, "pH: %.2f", ph_value);
    return ph_value;
}

float read_temperature() {
    if (ds18b20_device_num == 0) {
        ESP_LOGE(TAG, "No DS18B20 device found");
        return -1.0; // Brak urządzenia DS18B20
    }

    float temperature;
    esp_err_t ret = ds18b20_trigger_temperature_conversion(ds18b20s[0]);
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to trigger temperature conversion");
        return -1.0; // Błąd podczas konwersji
    }

    ret = ds18b20_get_temperature(ds18b20s[0], &temperature);
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to read temperature");
        return -1.0; // Błąd odczytu temperatury
    }

    ESP_LOGI(TAG, "Temperature from DS18B20: %.2f°C", temperature);
    return temperature;
}

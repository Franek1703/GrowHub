idf_component_register(SRCS "http_client.c" "sensor_reader.c"
                       INCLUDE_DIRS "/"
                       REQUIRES esp_adc esp_wifi esp_http_client nvs_flash json
                       )
include_directories(${CMAKE_SOURCE_DIR}/managed_components/espressif__onewire_bus/include)
include_directories(${CMAKE_SOURCE_DIR}/managed_components/espressif__ds18b20/include)
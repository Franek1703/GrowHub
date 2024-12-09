idf_component_register(SRCS "sensor_reader.c"
                       INCLUDE_DIRS "/"
                       REQUIRES esp_adc
                       )
include_directories(${CMAKE_SOURCE_DIR}/managed_components/espressif__onewire_bus/include)
include_directories(${CMAKE_SOURCE_DIR}/managed_components/espressif__ds18b20/include)
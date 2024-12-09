idf_component_register(SRCS "hello_world_main.c"
                       INCLUDE_DIRS ".")


# Dodanie komponentów z katalogu 'components'
set(COMPONENTS main sensor_reader)

# Zapewnienie dostępu do katalogu 'components'
include_directories(${CMAKE_SOURCE_DIR}/components)
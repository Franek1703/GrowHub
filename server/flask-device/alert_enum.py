from enum import Enum

class AlertMessages(Enum):
    PH_HIGH = "Czujnik PH wykrył za duże wartości."
    PH_LOW = "Czujnik PH wykrył za niskie wartości."
    TNS_HIGH = "Czujnik TNS wykrył za duże wartości."
    TNS_LOW = "Czujnik TNS wykrył za niskie wartości."
    TEMP_HIGH = "Czujnik Temperatury wykrył za duże wartości."
    TEMP_LOW = "Czujnik Temperatury wykrył za niskie wartości."

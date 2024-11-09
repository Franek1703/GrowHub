from enum import Enum

class DefaultValues(Enum):
    MAX_PH = 6.5
    MIN_PH = 5.2
    MAX_TDS = 1500
    MIN_TDS = 800
    MAX_TEMP = 22
    MIN_TEMP = 18
    SENSOR_FREQUENCY = 10  # 10 minutes
    ACTIVATION_TIME = 5    # 5 seconds

    @staticmethod
    def get_max(value_type):
        if value_type.lower() == "ph":
            return DefaultValues.MAX_PH.value
        elif value_type.lower() == "tds":
            return DefaultValues.MAX_TDS.value
        elif value_type.lower() == "temperature":
            return DefaultValues.MAX_TEMP.value
        else:
            raise ValueError("Invalid type. Available types: 'ph', 'tds', 'temperature'.")

    @staticmethod
    def get_min(value_type):
        if value_type.lower() == "ph":
            return DefaultValues.MIN_PH.value
        elif value_type.lower() == "tds":
            return DefaultValues.MIN_TDS.value
        elif value_type.lower() == "temperature":
            return DefaultValues.MIN_TEMP.value
        else:
            raise ValueError("Invalid type. Available types: 'ph', 'tds', 'temperature'.")

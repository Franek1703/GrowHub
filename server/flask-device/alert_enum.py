from enum import Enum

class AlertMessages(Enum):
    PH_HIGH = "The pH sensor detected high values."
    PH_LOW = "The pH sensor detected low values."
    TNS_HIGH = "The TNS sensor detected high values."
    TNS_LOW = "The TNS sensor detected low values."
    TEMP_HIGH = "The Temperature sensor detected high values."
    TEMP_LOW = "The Temperature sensor detected low values."

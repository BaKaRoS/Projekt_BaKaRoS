uint16_t getSensorValue(CapacitiveSensor *sensor){
    return (uint16_t)sensor->capacitiveSensor(PRESSURESENSOR_SAMPLES);
}


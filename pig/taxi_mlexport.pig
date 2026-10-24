
raw = LOAD 'data/train/train.csv'
    USING PigStorage(',')
    AS (
        id:chararray,
        vendor_id:chararray,
        pickup_datetime:chararray,
        dropoff_datetime:chararray,
        passenger_count:chararray,
        pickup_longitude:chararray,
        pickup_latitude:chararray,
        dropoff_longitude:chararray,
        dropoff_latitude:chararray,
        store_and_fwd_flag:chararray,
        trip_duration:chararray
    );

data = FILTER raw BY id != 'id';

typed = FOREACH data GENERATE
    id,
    vendor_id,
    pickup_datetime,
    (int)passenger_count AS passenger_count,
    (double)pickup_longitude AS pickup_longitude,
    (double)pickup_latitude AS pickup_latitude,
    (double)dropoff_longitude AS dropoff_longitude,
    (double)dropoff_latitude AS dropoff_latitude,
    store_and_fwd_flag,
    (int)trip_duration AS trip_duration;

valid = FILTER typed BY
    passenger_count > 0
    AND trip_duration > 0
    AND pickup_longitude IS NOT NULL
    AND pickup_latitude IS NOT NULL
    AND dropoff_longitude IS NOT NULL
    AND dropoff_latitude IS NOT NULL;

ml_features = FOREACH valid GENERATE
    id,
    vendor_id,
    pickup_datetime,
    passenger_count,
    pickup_longitude,
    pickup_latitude,
    dropoff_longitude,
    dropoff_latitude,
    store_and_fwd_flag,
    trip_duration;

STORE ml_features INTO 'outputs/taxi_ml_ready'
    USING PigStorage(',');

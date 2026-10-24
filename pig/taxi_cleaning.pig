
-- 1. Load the training dataset as strings initially
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

-- 2. Remove the CSV header
no_header = FILTER raw BY id != 'id';

-- 3. Convert required columns to numeric types
typed = FOREACH no_header GENERATE
    id,
    (int)passenger_count AS passenger_count,
    (double)pickup_longitude AS pickup_longitude,
    (double)pickup_latitude AS pickup_latitude,
    (double)dropoff_longitude AS dropoff_longitude,
    (double)dropoff_latitude AS dropoff_latitude,
    (int)trip_duration AS trip_duration;

-- 4. Remove invalid records
valid_trips = FILTER typed BY
    passenger_count > 0
    AND trip_duration > 0
    AND pickup_longitude IS NOT NULL
    AND pickup_latitude IS NOT NULL
    AND dropoff_longitude IS NOT NULL
    AND dropoff_latitude IS NOT NULL
    AND trip_duration IS NOT NULL;

-- 5. Save the cleaned data
STORE valid_trips
INTO 'outputs/cleaned_taxi'
USING PigStorage(',');


-- Load the cleaned dataset
cleaned = LOAD 'outputs/cleaned_taxi'
    USING PigStorage(',')
    AS (
        id:chararray,
        passenger_count:int,
        pickup_longitude:double,
        pickup_latitude:double,
        dropoff_longitude:double,
        dropoff_latitude:double,
        trip_duration:int
    );

-- Reload pickup timestamps from the original dataset
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

-- Remove header and keep valid trip durations
no_header = FILTER raw BY id != 'id';
valid = FILTER no_header BY
    (int)passenger_count > 0
    AND (int)trip_duration > 0;

-- Extract the pickup hour from YYYY-MM-DD HH:MM:SS
hourly_rows = FOREACH valid GENERATE
    SUBSTRING(pickup_datetime, 11, 13) AS pickup_hour,
    (int)trip_duration AS trip_duration;

-- Group trips by pickup hour
grouped = GROUP hourly_rows BY pickup_hour;

-- Calculate trip count and average duration
hourly_stats = FOREACH grouped GENERATE
    group AS pickup_hour,
    COUNT(hourly_rows) AS trip_count,
    AVG(hourly_rows.trip_duration) AS average_duration_seconds;

ordered = ORDER hourly_stats BY pickup_hour ASC;

DUMP ordered;


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

no_header = FILTER raw BY id != 'id';

valid = FILTER no_header BY
    (int)passenger_count > 0
    AND (int)trip_duration > 0
    AND pickup_datetime IS NOT NULL;

hourly_rows = FOREACH valid GENERATE
    SUBSTRING(pickup_datetime, 11, 13) AS pickup_hour,
    (int)trip_duration AS trip_duration;

grouped = GROUP hourly_rows BY pickup_hour;

hourly_stats = FOREACH grouped GENERATE
    group AS pickup_hour,
    COUNT(hourly_rows) AS trip_count,
    AVG(hourly_rows.trip_duration) AS average_duration_seconds;

ordered = ORDER hourly_stats BY pickup_hour ASC;

STORE ordered INTO 'outputs/hourly_stats'
    USING PigStorage(',');

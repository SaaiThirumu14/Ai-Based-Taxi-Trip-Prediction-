
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

-- Remove the header
data = FILTER raw BY id != 'id';

-- Count input records
input_group = GROUP data ALL;
input_count = FOREACH input_group GENERATE
    'Input records' AS metric,
    COUNT(data) AS record_count;

-- Select records with valid passenger count and duration
valid = FILTER data BY
    (int)passenger_count > 0
    AND (int)trip_duration > 0;

-- Count valid records
valid_group = GROUP valid ALL;
valid_count = FOREACH valid_group GENERATE
    'Records with valid passenger count and duration' AS metric,
    COUNT(valid) AS record_count;

DUMP input_count;
DUMP valid_count;

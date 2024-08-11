CREATE OR REPLACE STORAGE INTEGRATION snowflake_nifi
    type = external_stage
    storage_provider = s3
    storage_aws_role_arn = 'your_value'
    enabled = true
    storage_allowed_locations = ( 'Your_location' );

    DESC INTEGRATION snowflake_nifi;
    
CREATE OR REPLACE FILE FORMAT csv_format
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = True
    field_optionally_enclosed_by = '"'
    error_on_column_count_mismatch = False ;

CREATE OR REPLACE STAGE nifistage
    url = 'your_location'
    storage_integration = snowflake_nifi
    file_format = csv_format;

list @nifistage;

CREATE OR REPLACE PIPE customer_s3_pipe
  auto_ingest = true
  AS
  COPY INTO customer_raw
  FROM @nifistage
  FILE_FORMAT = csv_format;

  show pipes;
select count(*) from customer_raw;

import snowflake.connector
import os
from dotenv import load_dotenv

# This line loads the variables from .env into your system's environment
load_dotenv()

# Now fetch them using os.getenv
conn = snowflake.connector.connect(
    user=os.getenv('SNOWFLAKE_USER'),
    password=os.getenv('SNOWFLAKE_PASSWORD'),
    account=os.getenv('SNOWFLAKE_ACCOUNT'),
    warehouse=os.getenv('SNOWFLAKE_WAREHOUSE'),
    database=os.getenv('SNOWFLAKE_DATABASE'),
    schema=os.getenv('SNOWFLAKE_SCHEMA')
)

cursor = conn.cursor()

# Resolve the CSV path relative to this script's location so the PUT command
# works regardless of which directory the script is invoked from
# Use forward slashes — Snowflake's PUT command does not accept Windows backslashes
CSV_PATH = os.path.dirname(os.path.abspath(__file__)).replace('\\', '/') + '/telco_customer_churn.csv'

try:
    print("Creating RAW table...")
    cursor.execute("""
        CREATE OR REPLACE TABLE RAW.TELCO_DATA_RAW (
            customerID VARCHAR, gender VARCHAR, SeniorCitizen INT, Partner VARCHAR,
            Dependents VARCHAR, tenure INT, PhoneService VARCHAR, MultipleLines VARCHAR,
            InternetService VARCHAR, OnlineSecurity VARCHAR, OnlineBackup VARCHAR,
            DeviceProtection VARCHAR, TechSupport VARCHAR, StreamingTV VARCHAR,
            StreamingMovies VARCHAR, Contract VARCHAR, PaperlessBilling VARCHAR,
            PaymentMethod VARCHAR, MonthlyCharges FLOAT,
            -- TotalCharges is VARCHAR in the source: some new customers have blank values.
            -- stg_telco_finance.sql handles the TRY_CAST to FLOAT downstream.
            TotalCharges VARCHAR, Churn VARCHAR
        )
    """)

    print("Uploading file to Internal Stage...")
    # The PUT command moves local file to Snowflake's internal storage
    # Wrap path in single quotes to handle spaces in directory names
    cursor.execute(f"PUT 'file://{CSV_PATH}' @~/stg_kaggle_data AUTO_COMPRESS=TRUE OVERWRITE=TRUE")

    print("Copying data from Stage to Table...")
    cursor.execute("""
        COPY INTO RAW.TELCO_DATA_RAW
        FROM @~/stg_kaggle_data/telco_customer_churn.csv.gz
        FILE_FORMAT = (
            TYPE = CSV
            SKIP_HEADER = 1
            FIELD_OPTIONALLY_ENCLOSED_BY = '"'
            TRIM_SPACE = TRUE
            EMPTY_FIELD_AS_NULL = TRUE
        )
    """)

    print("Success! Data is now in Snowflake.")

finally:
    cursor.close()
    conn.close()
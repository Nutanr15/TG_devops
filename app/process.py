import pandas as pd
import os

def main():
    s3 = boto3.client("s3")
    #Buckets from environment variables
    raw_bucket = os.getenv("RAW_BUCKET", "raw-data")
    processed_bucket = os.getenv("PROCESSED_BUCKET", "processed-data")
    input_key = os.getenv("INPUT_KEY", "input.csv")
    output_key = os.getenv("OUTPUT_KEY", "output.csv")

    # Download file from S3
    local_input = "/tmp/input.csv"
    s3.download_file(raw_bucket, input_key, local_input)

    # Process file
    df = pd.read_csv(local_input)
    if "name" in df.columns:
        df["name"] = df["name"].str.upper()

    # Save and upload result
    local_output = "/tmp/output.csv"
    df.to_csv(local_output, index=False)
    s3.upload_file(local_output, processed_bucket, output_key)

    print(f"Processed {input_key} to {output_key}")

if __name__ == "__main__":
    main()
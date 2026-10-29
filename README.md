# Kafka + Spark + Snowflake + dbt: End-to-End Orders Pipeline

A complete streaming data pipeline. Live orders flow from an API into Kafka, are cleaned and validated by PySpark Structured Streaming, land in Snowflake, and are modelled into tested business tables with dbt.

## Architecture

API (FastAPI /orders/live)
  → producer.py (keyed by order_id)
  → Kafka topic api_orders (3 partitions, Docker, KRaft)
  → spark_consumer.py (PySpark micro-batches every 10s)
  → Snowflake RAW: spark_orders_clean + spark_orders_rejected
  → dbt: staging → intermediate → marts, tests, snapshot

## What each part does

**Producer**
• Polls the API every 2 seconds and sends each order to Kafka
• Keys events by order_id so related events land in the same partition
• acks=all and idempotence enabled, so no events are lost or duplicated on send

**Spark consumer**
• Reads the Kafka stream from the earliest offset
• Parses JSON as strings first, then cleans prices, quantities, dates (three formats) and text
• Validates every row: bad rows go to a rejected table with a reason
• Checkpointing lets it resume exactly where it stopped after a crash

**dbt**
• stg_orders (view): removes redelivered events using kafka_partition and kafka_offset
• int_orders_enriched (ephemeral): adds total cost, profit and net revenue (returns count as zero)
• daily_sales (table): orders, units, net revenue and profit per day and region
• rejection_summary (table): count of rejected rows per reason, with first and last seen times
• product_prices (snapshot): tracks cost price changes over time (SCD Type 2)

## Tests

• not_null on order_id, order_date and quantity
• no_duplicate_events: no repeated partition and offset pairs
• positive_quantity: no orders with zero or negative quantity

All 9 models, tests and snapshots pass with dbt build.

## Design decisions

• **Dedupe by partition and offset, not order_id.** The consumer gives at-least-once delivery, so the same event can be saved twice. Partition plus offset uniquely identifies a Kafka event. The demo API restarts its order counter on each restart, so order_id alone is not unique here.
• **Cleaning in Spark, modelling in dbt.** Spark handles messy input at ingestion. dbt handles business logic inside Snowflake, so no macros or seeds were needed.
• **Rejected rows are kept, not dropped.** Nothing disappears silently, and data quality can be monitored over time.

## Results

• About 18,000 events processed
• 17,287 clean rows and 852 rejected (about 5%)
• Rejection reasons: bad quantity 346, bad selling price 309, bad order date 182

## Setup

1. Start Kafka: docker compose up -d
2. Install dependencies: uv sync
3. Add Snowflake credentials to .env
4. Run the API, then: uv run producer.pys
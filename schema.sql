create table default.case
(
    order            UInt64,
    open_time        UInt64,
    activation       UInt8,
    unused_unk       Int16,
    gw_order         Int32,
    gw_volume        Int64,
    expiration       Int64,
    commission       Decimal(38, 10),
    gw_open_price    Decimal(38, 10),
    commission_agent Decimal(38, 10),
    taxes            Decimal(38, 10),
    gw_close_price   Decimal(38, 10),
    backup_timestamp UInt64,
    server           String default 'UNKNOWN'
)
    engine = ReplacingMergeTree(backup_timestamp) PARTITION BY server ORDER BY (open_time, order) SETTINGS index_granularity = 8192;
SELECT
    DATE_TRUNC('minute', ttamp) AS timestamp_bucket,
    price,
    SUM(last_size) AS volume,
    SUM(CASE WHEN side = 'buy' THEN last_size ELSE 0 END) AS buy_volume,
    SUM(CASE WHEN side = 'sell' THEN last_size ELSE 0 END) AS sell_volume,
    SUM(CASE WHEN side = 'buy' THEN last_size ELSE -last_size END) AS delta,
    COUNT(*) AS trades
FROM new_btc_coinbase_trades_extracted
WHERE ttamp >= DATE_TRUNC('minute', NOW())
GROUP BY timestamp_bucket, price;
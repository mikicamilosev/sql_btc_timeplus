SELECT
    timestamp,
    sum(trade_count) AS trades,
    coalesce(sum(CASE WHEN side = 'buy' THEN CAST(total_amount AS DECIMAL(10,2)) ELSE CAST(0 AS DECIMAL(10,2)) END), CAST(0 AS DECIMAL(10,2))) AS buys,
    coalesce(sum(CASE WHEN side = 'sell' THEN CAST(total_amount AS DECIMAL(10,2)) ELSE CAST(0 AS DECIMAL(10,2)) END), CAST(0 AS DECIMAL(10,2))) AS sells,
    sum(CAST(total_amount AS DECIMAL(10,2))) AS volume,
    coalesce(sum(CASE WHEN side = 'buy' THEN CAST(total_amount AS DECIMAL(10,2)) ELSE CAST(0 AS DECIMAL(10,2)) END), CAST(0 AS DECIMAL(10,2)))
    -
    coalesce(sum(CASE WHEN side = 'sell' THEN CAST(total_amount AS DECIMAL(10,2)) ELSE CAST(0 AS DECIMAL(10,2)) END), CAST(0 AS DECIMAL(10,2)))
    AS delta
FROM (
    SELECT
        timestamp,
        side,
        sum(CAST(amount AS DECIMAL(10,2))) AS total_amount,
        count(*) as trade_count
    FROM btc_usd_trades
    WHERE timestamp > now() - interval 5 minute
    GROUP BY timestamp, side
)
GROUP BY timestamp
ORDER BY timestamp
EMIT PERIODIC 500ms;

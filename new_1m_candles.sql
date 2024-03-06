SELECT
    minute_start,
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
        DATE_TRUNC('minute', timestamp) AS minute_start,
        side,
        sum(CAST(amount AS DECIMAL(10,2))) AS total_amount,
        count(*) as trade_count
    FROM btc_usd_trades
    WHERE timestamp > now() - interval '5 minutes'
    GROUP BY minute_start, side
) AS minute_aggregates
GROUP BY minute_start
ORDER BY minute_start;

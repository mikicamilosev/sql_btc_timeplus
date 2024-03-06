WITH PriceClusters AS (
    SELECT
        product_id, 
        CAST(floor(price/2.0)*2.0 AS DECIMAL(10,2)) AS price_cluster,
        side,
        DATE_TRUNC('minute', ttamp) AS minute_start,
        sum(CAST(last_size AS DECIMAL(10,2))) AS total_amount,
        count(*) as trade_count
    FROM btc_coinbase_trades_extracted
    GROUP BY product_id, price_cluster, side, minute_start
    ORDER BY minute_start
)

SELECT
    product_id, 
    price_cluster,
    minute_start,
    sum(trade_count) AS trades,
    coalesce(sum(CASE WHEN side = 'buy' THEN CAST(total_amount AS DECIMAL(10,2)) ELSE CAST(0 AS DECIMAL(10,2)) END), CAST(0 AS DECIMAL(10,2))) AS buys,
    coalesce(sum(CASE WHEN side = 'sell' THEN CAST(total_amount AS DECIMAL(10,2)) ELSE CAST(0 AS DECIMAL(10,2)) END), CAST(0 AS DECIMAL(10,2))) AS sells,
    sum(CAST(total_amount AS DECIMAL(10,2))) AS volume,
    coalesce(sum(CASE WHEN side = 'buy' THEN CAST(total_amount AS DECIMAL(10,2)) ELSE CAST(0 AS DECIMAL(10,2)) END), CAST(0 AS DECIMAL(10,2)))
    -
    coalesce(sum(CASE WHEN side = 'sell' THEN CAST(total_amount AS DECIMAL(10,2)) ELSE CAST(0 AS DECIMAL(10,2)) END), CAST(0 AS DECIMAL(10,2)))
    AS delta
FROM PriceClusters
GROUP BY product_id, price_cluster, minute_start
ORDER BY product_id, price_cluster, minute_start
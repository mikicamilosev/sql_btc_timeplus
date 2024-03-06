WITH TradeCandles AS (
    SELECT
        DATE_TRUNC('minute', ttamp) AS minute_start,
        product_id,
        FLOOR(price) AS price_cluster,
        MAX(ttamp) AS max_time,
        MIN(ttamp) AS min_time,
        MAX(price) AS max_price,
        MIN(price) AS min_price,
        SUM(CASE WHEN side = 'buy' THEN last_size ELSE 0 END) AS total_buy_volume,
        SUM(CASE WHEN side = 'sell' THEN last_size ELSE 0 END) AS total_sell_volume,
        COUNT(*) AS trade_count
    FROM new_btc_coinbase_trades_extracted
    GROUP BY minute_start, price_cluster, product_id
)
SELECT
    minute_start,
    product_id,
    FIRST_VALUE(price_cluster) AS open_price,
    LAST_VALUE(price_cluster) AS close_price,
    max_price AS high_price,
    min_price AS low_price,
    total_buy_volume + total_sell_volume AS volume,
    total_buy_volume AS buy_volume,
    total_sell_volume AS sell_volume,
    total_buy_volume - total_sell_volume AS delta,
    trade_count
FROM TradeCandles
GROUP BY minute_start, max_time, min_time, max_price, min_price, total_buy_volume, total_sell_volume, trade_count, product_id
ORDER BY minute_start;
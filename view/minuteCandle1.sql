SELECT
    DATE_TRUNC('minute', ttamp) AS minute_start,
    MAX(price) AS max_price,
    MIN(price) AS min_price,
    SUM(last_size) AS volume,
    SUM(CASE WHEN side = 'buy' THEN last_size ELSE 0 END) AS buy_volume,
    SUM(CASE WHEN side = 'sell' THEN last_size ELSE 0 END) AS sell_volume,
    COUNT(*) AS trade_count
FROM new_btc_coinbase_trades_extracted
GROUP BY minute_start
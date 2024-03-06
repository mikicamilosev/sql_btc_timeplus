SELECT
raw:type AS type,
raw:sequence AS sequence,
raw:product_id AS product_id,
cast(raw:price,'decimal(20,8)') AS price,
raw:side AS side,
to_time(raw:time) AS ttamp,
raw:trade_id AS trade_id,
cast(raw:last_size,'decimal(20,8)') AS last_size
FROM
btc_coinbase_trades_extracted
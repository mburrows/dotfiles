with initial_sizes as (
  select transact_time::date as dt, symbol, auction_id, bid_size,
         ROW_NUMBER() OVER(PARTITION BY transact_time::date, symbol, auction_id
                           ORDER BY transact_time::date, collating_seq ASC) AS rk
  from auction_update
 where transact_time > '2020-01-01'
   and status = 'I'
),
final_sizes as (
  select transact_time::date as dt, symbol, auction_id, bid_size
    from auction_update
   where transact_time > '2020-01-01'
     and status = 'C'
)
select i.dt, count(*) as total_auctions, COUNT(CASE WHEN f.bid_size > i.bid_size THEN 1 END) AS increase_auctions
  from initial_sizes i
  join final_sizes f
    on i.rk = 1 and i.dt = f.dt and i.symbol = f.symbol and i.auction_id = f.auction_id
group by 1;


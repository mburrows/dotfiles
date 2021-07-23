#!/bin/bash
#
# Usage: setter_details.sh YYYY-MM-DD fix_bats???|boe_bats??? <execid-base36>

DT=$1
OH=$2
EXECID=$3
ENV=c-sea

DTU="$(echo $DT | tr - _)"
DTS="$(echo $DT | tr -d '-')"
YM=${DT:0:7}

EXECID_B10="$(wconv -b 36 $EXECID | egrep '^Base 36' | cut -d ' ' -f 6)"
UNIT=$(printf "%02d" $(wconv -ex $EXECID | grep '^Matching Unit' | cut -d ' ' -f 3))

echo "Symbol details:"
/opt/ecn/scripts/bsql.sh $ENV <<EOS
select symbol_name, matching_unit, setter_size
from symbol_daily
where effective_date='${DT}'
and symbol_name in (
  select symbol from order_fill_${DTU} where exec_id = '${EXECID}'
);
EOS

echo
echo "Order transition:"
/opt/ecn/scripts/bsql.sh ${ENV} <<EOS
select flag_value(flags, 'SubLiquidity') as SubLiq, flag_value(flags, 'FeeCode') as FeeCode, symbol, side, size, price, firm_id, firm_sub_id
from order_fill_${DTU}
where exec_id = '${EXECID}';
EOS

echo "ME Output:"
/opt/ecn/scripts/bssh ${ENV} batch <<EOS
cd /opt/ecn/archive/${YM}/${ENV}/${DT}/log/matching_${UNIT}
wgrep -M OX --executionId=${EXECID} -o --subLiquidity.notempty --feeCode.notempty matching_${UNIT}_me-${DTS}.dat.gz
EOS

echo
echo "OH Output:"
/opt/ecn/scripts/bssh ${ENV} batch <<EOS
cd /opt/ecn/archive/${YM}/${ENV}/${DT}/log/ord_hnd
if [[ $OH == fix* ]] ; then
    zgrep ${EXECID} ${OH}-*.*-*-${DTS}.fix.gz | prt_fix | egrep '(Side|9730|FeeCode)'
elif [[ $OH == boe* ]] ; then
    echo "ExecID: $EXECID_B10"
    prt_boe -s ${OH}-${DTS}.dat.gz | grep $EXECID_B10 | tr ',' '\n' | egrep '(baseLiquidityIndicator|subLiquidityIndicator|feeCode)'

fi
EOS

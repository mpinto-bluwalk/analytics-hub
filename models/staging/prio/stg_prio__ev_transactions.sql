WITH

source as (
    select
        *
    from {{ source('prio', 'ev_transactions') }} 
),

transformation as (
    
    SELECT
        CAST(IdUsage AS STRING) as transaction_id,
        CAST(TIMESTAMP(TIMESTAMP(StartDate, 'Europe/Lisbon')) AS TIMESTAMP) AS start_timestamp,
        CAST(DATETIME(StartDate) AS DATETIME) AS start_date,
        CAST(TIMESTAMP_ADD(
            CAST(TIMESTAMP(TIMESTAMP(StartDate, 'Europe/Lisbon')) AS TIMESTAMP), 
            INTERVAL CAST(CAST(TotalDuration AS NUMERIC)*60 AS INT64) SECOND
        ) AS TIMESTAMP) as stop_timestamp,
        CAST(DATETIME_ADD(
            CAST(DATETIME(StartDate) AS DATETIME), 
            INTERVAL CAST(CAST(TotalDuration AS NUMERIC)*60 AS INT64) SECOND
        ) AS DATETIME) as stop_date,
        CAST(CardCode AS STRING) as card_id,
        CAST(CONCAT('PE', LPAD(REGEXP_EXTRACT(MobileCard, r'PE(\d+)'), 6, '0')) AS STRING) AS card_name,
        CAST(MobileRegistration AS STRING) as mobile_registration,
        CAST(IdUsage AS STRING) as plug_id,
        CAST(IdChargingStation AS STRING) as charger_id,
        CAST(TotalDuration AS NUMERIC) as duration_min,
        CAST(EnergiaForaVazio AS NUMERIC) as energy_fora_vazio,
        CAST(EnergiaVazioNormal AS NUMERIC) as energy_vazio_normal,
        CAST(EnergiaPonta AS NUMERIC) as energy_ponta,
        CAST(EnergiaCheias AS NUMERIC) as energy_cheias,
        CAST(EnergiaVazio AS NUMERIC) as energy_vazio,
        CAST(ROUND(Energy, 2) AS NUMERIC) as quantity,
        CAST(PriceOPC_TEMPO AS NUMERIC) as opc_time,
        CAST(PriceOPC_ENERGIA AS NUMERIC) as opc_energy,
        CAST(PriceOPC_ATIVACAO AS NUMERIC) as opc_activation,
        CAST(PriceCDescAcesRedeForaVazio AS NUMERIC) as network_access_fora_vazio,
        CAST(PriceCDescAcesRedeVazioNorm AS NUMERIC) as network_access_vazio_normal,
        CAST(PriceComDescAcessoRedePonta AS NUMERIC) as network_access_ponta,
        CAST(PriceComDescAcessoRedeCheias AS NUMERIC) as network_access_cheias,
        CAST(PriceComDescAcessoRedeVazio AS NUMERIC) as network_access_vazio,
        CAST(ROUND(ChargingServiceValue,2) AS NUMERIC) as charging_service_value,
        CAST(ROUND(ChargingTotalValue,2) AS NUMERIC) as total_net_value,
        CAST(ROUND(TotalValueWithTaxes,2) AS NUMERIC) as total_value,
        TIMESTAMP_SECONDS(CAST(loadTimestampEpoch/1000 AS INT64)) as load_timestamp,
        CAST(loadUser AS STRING) as load_user
    FROM source
)

SELECT 
    TO_HEX(MD5(stop_timestamp || card_name || quantity)) as transaction_key,
    *
FROM transformation
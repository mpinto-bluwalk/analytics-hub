{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo_realtime', 'account_account') }}
),

transformation as (

    select
        
        *

    from source
    
)
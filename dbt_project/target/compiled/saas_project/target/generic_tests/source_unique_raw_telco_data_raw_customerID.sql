
    
    

select
    customerID as unique_field,
    count(*) as n_records

from SAAS_DB.RAW.telco_data_raw
where customerID is not null
group by customerID
having count(*) > 1



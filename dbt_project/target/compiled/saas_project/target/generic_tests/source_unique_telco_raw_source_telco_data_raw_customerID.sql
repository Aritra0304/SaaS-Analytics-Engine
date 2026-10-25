
    
    

select
    customerID as unique_field,
    count(*) as n_records

from SAAS_DB.telco_raw_source.telco_data_raw
where customerID is not null
group by customerID
having count(*) > 1



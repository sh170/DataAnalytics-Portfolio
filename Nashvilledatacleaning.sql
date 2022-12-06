----Cleaning date on Nashville Housing Data 

---Formatting Date

select SaleDate,convert(date,SaleDate)  from  portfolio.dbo.Nasho

alter table portfolio.dbo.Nasho
add Saledateconverted Date;

update portfolio.dbo.Nasho
set Saledateconverted=convert(date,saledate);


---Populating Empty Property Addresses

select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress
from portfolio.dbo.Nasho a
join portfolio.dbo.Nasho b
on a.parcelid=b.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null 

update a 
set propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
from portfolio.dbo.Nasho a
join portfolio.dbo.Nasho b
on a.parcelid=b.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null 


---breakdown of addresses of property and owner

select propertyaddress ,SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1),
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))
from portfolio.dbo.Nasho




alter table portfolio.dbo.Nasho
add HousingAdd nvarchar(255)

update portfolio.dbo.Nasho
set HousingAdd=SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

alter table portfolio.dbo.Nasho
add Housingcity nvarchar(255)

update portfolio.dbo.Nasho
set Housingcity=SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))


alter table portfolio.dbo.Nasho
add owneradd nvarchar(255)

update portfolio.dbo.Nasho
set owneradd=PARSENAME(REPLACE(owneraddress,',','.'),3)

alter table portfolio.dbo.Nasho
add ownercity nvarchar(255)

update portfolio.dbo.Nasho
set ownercity=PARSENAME(REPLACE(owneraddress,',','.'),2)

alter table portfolio.dbo.Nasho
add ownerstate nvarchar(255)

update portfolio.dbo.Nasho
set ownerstate=PARSENAME(REPLACE(owneraddress,',','.'),1)

--------Change Y to yes and N to No in soldasvacant

select distinct(soldasvacant),count(soldasvacant)
from portfolio.dbo.Nasho
group by soldasvacant


update portfolio.dbo.Nasho
set soldasvacant= case soldasvacant 
                     when 'Y' then 'Yes'
                     when 'N' then 'No'
					 else soldasvacant
					 end 


---Remove Duplicates



with rownumCTE as (
select *,
ROW_NUMBER() over (partition by parcelid,propertyaddress,saledate,saleprice,legalreference order by uniqueid) row_num
from portfolio.dbo.Nasho)
select * from  rownumCTE
where row_num>1



----Delete unused columns

select * from portfolio.dbo.Nasho

alter table portfolio.dbo.Nasho
drop column propertyaddress,saledate,owneraddress,taxdistrict













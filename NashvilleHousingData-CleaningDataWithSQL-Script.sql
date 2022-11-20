use portfolioproject

CREATE TABLE `housingdata`  (
  `UniqueID` varchar(255),
  `ParcelID` varchar(255),
  `LandUse` varchar(255),
  `PropertyAddress` varchar(255),
  `SaleDate` varchar(255),
  `SalePrice` varchar(255),
  `LegalReference` varchar(255),
  `SoldAsVacant` varchar(255),
  `OwnerName` varchar(255),
  `OwnerAddress` varchar(255),
  `Acreage` double,
  `TaxDistrict` text,
  `LandValue` varchar(255),
  `BuildingValue` varchar(255),
  `TotalValue` varchar(255),
  `YearBuilt` varchar(255),
  `Bedrooms` varchar(255),
  `FullBath` varchar(255),
  `HalfBath` varchar(255),
  primary key (UniqueID)
  );
  
load data local infile 'C:/Users/absae/Downloads/Nashville Housing Data for Data Cleaning.csv' 
into table housingdata
FIELDS terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(UniqueID, ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath);

select *
from portfolioproject.housingdata

-- POPULATE PROPERTY ADDRESS DATA -- 
select *
from portfolioproject.housingdata
where propertyaddress is null

UPDATE
    portfolioproject.housingdata
SET
    UniqueID = CASE UniqueID WHEN '' THEN NULL ELSE UniqueID END,
    ParcelID = CASE ParcelID WHEN '' THEN NULL ELSE ParcelID END,
    LandUse = CASE LandUse WHEN '' THEN NULL ELSE LandUse END,
    PropertyAddress = CASE PropertyAddress WHEN '' THEN NULL ELSE PropertyAddress END,
    SaleDate = CASE SaleDate WHEN '' THEN NULL ELSE SaleDate END,
    SalePrice = CASE SalePrice WHEN '' THEN NULL ELSE SalePrice END,
	LegalReference = CASE LegalReference WHEN '' THEN NULL ELSE LegalReference END,
    SoldAsVacant = CASE SoldAsVacant WHEN '' THEN NULL ELSE SoldAsVacant END,
    OwnerName = CASE OwnerName WHEN '' THEN NULL ELSE OwnerName END,
    OwnerAddress = CASE OwnerAddress WHEN '' THEN NULL ELSE OwnerAddress END,
    Acreage = CASE Acreage WHEN '' THEN NULL ELSE Acreage END,
    TaxDistrict = CASE TaxDistrict WHEN '' THEN NULL ELSE TaxDistrict END,
	LandValue = CASE LandValue WHEN '' THEN NULL ELSE LandValue END,
	BuildingValue = CASE BuildingValue WHEN '' THEN NULL ELSE BuildingValue END,
    TotalValue = CASE TotalValue WHEN '' THEN NULL ELSE TotalValue END,
    YearBuilt = CASE YearBuilt WHEN '' THEN NULL ELSE YearBuilt END,
    Bedrooms = CASE Bedrooms WHEN '' THEN NULL ELSE Bedrooms END,
    FullBath = CASE FullBath WHEN '' THEN NULL ELSE FullBath END,
    HalfBath = CASE HalfBath WHEN '' THEN NULL ELSE HalfBath END;
    
select *
from portfolioproject.housingdata
where propertyaddress is null

select *
from portfolioproject.housingdata
-- where propertyaddress is null
order by 2

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from portfolioproject.housingdata a
join portfolioproject.housingdata b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.propertyaddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ifnull(a.propertyaddress, b.propertyaddress)
from portfolioproject.housingdata a
join portfolioproject.housingdata b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.propertyaddress is null

update housingdata a 
join housingdata b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
set a.propertyaddress = ifnull(a.propertyaddress, b.propertyaddress)
where a.propertyaddress is null

-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE) FOR PROPERTY ADDRESS-- 

Select PropertyAddress
From portfolioproject.housingdata

Select
substring(PropertyAddress, 1, locate(',', propertyaddress)-1) as Address,
substring(PropertyAddress, locate(',', propertyaddress) +1, char_length(propertyaddress)) as Address
From portfolioproject.housingdata

Alter table portfolioproject.housingdata
add PropertySplitAddress Varchar(255)

update portfolioproject.housingdata
set PropertySplitAddress = substring(PropertyAddress, 1, locate(',', propertyaddress)-1)

Alter table portfolioproject.housingdata
add PropertySplitCity Varchar(255)

update portfolioproject.housingdata
set PropertySplitCity = substring(PropertyAddress, locate(',', propertyaddress) +1, char_length(propertyaddress))

select *
from portfolioproject.housingdata

-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE) FOR OWNER ADDRESS-- 
select owneraddress
from portfolioproject.housingdata

select
substring_index(owneraddress, ',', 1) as address,
substring_index(substring_index(owneraddress, ',', 2), ',', -1) as city,
substring_index(owneraddress, ',', -1) as state
from portfolioproject.housingdata
where owneraddress is not null

Alter table portfolioproject.housingdata
add OwnerSplitAddress Varchar(255)

update portfolioproject.housingdata
set OwnerSplitAddress = substring_index(owneraddress, ',', 1)

Alter table portfolioproject.housingdata
add OwnerSplitCity Varchar(255)

update portfolioproject.housingdata
set OwnerSplitCity = substring_index(substring_index(owneraddress, ',', 2), ',', -1)

Alter table portfolioproject.housingdata
add OwnerSplitState Varchar(255)

update portfolioproject.housingdata
set OwnerSplitState = substring_index(owneraddress, ',', -1)

select *
from portfolioproject.housingdata

-- CHANGE Y AND NO TO YES AND NO IN 'SOLD AS VACANT' COLUMN -- 
select distinct(soldasvacant), count(soldasvacant)
from portfolioproject.housingdata
group by soldasvacant
order by 2

select soldasvacant,
	case when soldasvacant = 'y' then 'Yes'
	when soldasvacant = 'n' then 'No'
    else soldasvacant
end
from portfolioproject.housingdata;

update portfolioproject.housingdata
set soldasvacant = case when soldasvacant = 'y' then 'Yes'
	when soldasvacant = 'n' then 'No'
    else soldasvacant
end;

-- REMOVING DUPLICATES WITHIN DATA -- 
WITH RowNumCTE as(
select *,
	ROW_NUMBER() over(
    partition by ParcelId,
				PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
                order by UniqueId
				)row_num
    from portfolioproject.housingdata
    )
delete
    from RowNumCTE
    where row_num > 1
    -- order by PropertyAddress
   
-- DELETING UNUSED COLUMNS -- 
   
select *
from portfolioproject.housingdata

alter table portfolioproject.housingdata
drop column OwnerAddress, 
drop column PropertyAddress, 
drop column TaxDistrict;
    
    


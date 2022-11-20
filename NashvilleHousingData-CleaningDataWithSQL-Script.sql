USE portfolioproject

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
  
LOAD DATA LOCAL INFILE 'C:/Users/absae/Downloads/Nashville Housing Data for Data Cleaning.csv' 
INTO TABLE housingdata
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(UniqueID, ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath);

SELECT 
    *
FROM
    portfolioproject.housingdata

-- POPULATE PROPERTY ADDRESS DATA -- 
SELECT 
    *
FROM
    portfolioproject.housingdata
WHERE
    propertyaddress IS NULL

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
    
SELECT 
    *
FROM
    portfolioproject.housingdata
WHERE
    propertyaddress IS NULL

SELECT 
    *
FROM
    portfolioproject.housingdata
ORDER BY 2

SELECT 
    a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM
    portfolioproject.housingdata a
        JOIN
    portfolioproject.housingdata b ON a.ParcelID = b.ParcelID
        AND a.UniqueID <> b.UniqueID
WHERE
    a.propertyaddress IS NULL

SELECT 
    a.ParcelID,
    a.PropertyAddress,
    b.ParcelID,
    b.PropertyAddress,
    IFNULL(a.propertyaddress, b.propertyaddress)
FROM
    portfolioproject.housingdata a
        JOIN
    portfolioproject.housingdata b ON a.ParcelID = b.ParcelID
        AND a.UniqueID <> b.UniqueID
WHERE
    a.propertyaddress IS NULL

UPDATE housingdata a
        JOIN
    housingdata b ON a.ParcelID = b.ParcelID
        AND a.UniqueID <> b.UniqueID 
SET 
    a.propertyaddress = IFNULL(a.propertyaddress, b.propertyaddress)
WHERE
    a.propertyaddress IS NULL

-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE) FOR PROPERTY ADDRESS-- 

SELECT 
    PropertyAddress
FROM
    portfolioproject.housingdata

SELECT 
    SUBSTRING(PropertyAddress,
        1,
        LOCATE(',', propertyaddress) - 1) AS Address,
    SUBSTRING(PropertyAddress,
        LOCATE(',', propertyaddress) + 1,
        CHAR_LENGTH(propertyaddress)) AS Address
FROM
    portfolioproject.housingdata

ALTER TABLE portfolioproject.housingdata
ADD PropertySplitAddress Varchar(255)

UPDATE portfolioproject.housingdata 
SET 
    PropertySplitAddress = SUBSTRING(PropertyAddress,
        1,
        LOCATE(',', propertyaddress) - 1)

ALTER TABLE portfolioproject.housingdata
ADD PropertySplitCity Varchar(255)

UPDATE portfolioproject.housingdata 
SET 
    PropertySplitCity = SUBSTRING(PropertyAddress,
        LOCATE(',', propertyaddress) + 1,
        CHAR_LENGTH(propertyaddress))

SELECT 
    *
FROM
    portfolioproject.housingdata

-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE) FOR OWNER ADDRESS-- 
SELECT 
    owneraddress
FROM
    portfolioproject.housingdata

SELECT 
    SUBSTRING_INDEX(owneraddress, ',', 1) AS address,
    SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress, ',', 2),
            ',', - 1) AS city,
    SUBSTRING_INDEX(owneraddress, ',', - 1) AS state
FROM
    portfolioproject.housingdata
WHERE
    owneraddress IS NOT NULL

ALTER TABLE portfolioproject.housingdata
ADD OwnerSplitAddress Varchar(255)

UPDATE portfolioproject.housingdata 
SET 
    OwnerSplitAddress = SUBSTRING_INDEX(owneraddress, ',', 1)

ALTER TABLE portfolioproject.housingdata
ADD OwnerSplitCity Varchar(255)

UPDATE portfolioproject.housingdata 
SET 
    OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress, ',', 2), ',', - 1)

ALTER TABLE portfolioproject.housingdata
ADD OwnerSplitState Varchar(255)

UPDATE portfolioproject.housingdata 
SET 
    OwnerSplitState = SUBSTRING_INDEX(owneraddress, ',', - 1)

SELECT 
    *
FROM
    portfolioproject.housingdata

-- CHANGE Y AND NO TO YES AND NO IN 'SOLD AS VACANT' COLUMN -- 
SELECT DISTINCT
    (soldasvacant), COUNT(soldasvacant)
FROM
    portfolioproject.housingdata
GROUP BY soldasvacant
ORDER BY 2

SELECT 
    soldasvacant,
    CASE
        WHEN soldasvacant = 'y' THEN 'Yes'
        WHEN soldasvacant = 'n' THEN 'No'
        ELSE soldasvacant
    END
FROM
    portfolioproject.housingdata;

UPDATE portfolioproject.housingdata 
SET 
    soldasvacant = CASE
        WHEN soldasvacant = 'y' THEN 'Yes'
        WHEN soldasvacant = 'n' THEN 'No'
        ELSE soldasvacant
    END;

-- REMOVING DUPLICATES WITHIN DATA -- 
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
    PARTITION BY ParcelId,
				PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
                ORDER BY UniqueId
				)row_num
    FROM portfolioproject.housingdata
    )
DELETE
    FROM RowNumCTE
    WHERE row_num > 1
    -- order by PropertyAddress
   
-- DELETING UNUSED COLUMNS -- 
   
SELECT 
    *
FROM
    portfolioproject.housingdata

ALTER TABLE portfolioproject.housingdata
DROP COLUMN OwnerAddress, 
DROP COLUMN PropertyAddress, 
DROP COLUMN TaxDistrict;

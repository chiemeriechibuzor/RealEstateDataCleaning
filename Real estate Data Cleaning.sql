/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
      ,[salesdateconverted]
      ,[saledateconverted]
  FROM [REAL ESTATE ANALYSIS].[dbo].[NashilleData]



  
  select *
  from nashilledata
 

	  /*
  STANDARDIZE DATE FORMAT
    */
	select saledateconverted, convert( date, saledate)
	from nashilledata

	update NashilleData
	set SaleDate = convert( date, saledate)

	ALTER table Nashilledata
	ADD saledateconverted date;

	update NashilleData
	set SaleDateconverted = convert( date, saledate)


	--populate property address data

	select saledateconverted, convert( date, saledate)
	from nashilledata  

--looking at the data above we have duplicates, so we will use the join function to merge similar cells together,note: where the parcel Id is same but different column/unique id, then populate
--that means we will join nashilledata to itself to perform this. .

select X.ParcelID, X.PropertyAddress, y.ParcelID, Y.PropertyAddress, isnull(X.PropertyAddress, Y.PropertyAddress)
from NashilleData X
join NashilleData Y
	on X.ParcelID = Y.ParcelID
	AND X.[UniqueID ] <> Y.[UniqueID ]
where x.PropertyAddress is null

 update x
 set propertyaddress = isnull(X.PropertyAddress, Y.PropertyAddress)
from NashilleData X
join NashilleData Y
	on X.ParcelID = Y.ParcelID
	AND X.[UniqueID ] <> Y.[UniqueID ]
where x.PropertyAddress is null
------------------------------------------------------------------------------------------------------------------------
--Breaking out address into individual column ( ADDRESS, CITY, STATE) 
SELECT 
substring ( propertyaddress,1, CHARINDEX(',', propertyaddress)-1) as address
,substring ( propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(propertyaddress)) as address
from NashilleData


ALTER TABLE Nashilledata
ADD propertysplitaddress nvarchar (255);

update NashilleData
set propertysplitaddress = substring ( propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)

ALTER TABLE Nashilledata
ADD propertysplitcity nvarchar (255);

update NashilleData
set propertysplitcity = substring ( propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(propertyaddress)) 

SELECT *
from NashilleData

SELECT OwnerAddress
from NashilleData

--parse looks for periods, and it starts counting backwards, so reorder it and update table after separation
SELECT 
	PARSENAME (REPLACE(OwnerAddress, ',','.') ,3)
	,PARSENAME (REPLACE(OwnerAddress, ',','.') ,2)
	,PARSENAME (REPLACE(OwnerAddress, ',','.') ,1)
from NashilleData


ALTER TABLE Nashilledata
ADD OwnersNewAddress nvarchar (255);

update NashilleData
set OwnersNewAddress = PARSENAME (REPLACE(OwnerAddress, ',','.') ,3)


ALTER TABLE Nashilledata
ADD OwnersNewCity nvarchar (255);

update NashilleData
set OwnersNewCity = PARSENAME (REPLACE(OwnerAddress, ',','.') ,2)


ALTER TABLE Nashilledata
ADD OwnersNewState nvarchar (255);

update NashilleData
set OwnersNewState = PARSENAME (REPLACE(OwnerAddress, ',','.') ,1)

SELECT *
from NashilleData

select distinct ( SoldAsVacant), count(SoldAsVacant)
from NashilleData
Group by SoldAsVacant
Order by 2

select SoldAsVacant,
CASE WHEN SoldAsVacant = 'y'THEN 'Yes'
	 WHEN SoldAsVacant = 'N'THEN 'No'
	 else SoldAsVacant 
	 END
from NashilleData

update NashilleData
     SET SoldAsVacant = CASE WHEN SoldAsVacant = 'y'THEN 'Yes'
	 WHEN SoldAsVacant = 'N'THEN 'No'
	 else SoldAsVacant 
	 END
from NashilleData

---------------------------------------------------------------------------------------
--REMOVING DUPLICATES

with RowNumCTE as(
SELECT *,
	row_number()over(
	PARTITION BY ParcelID,
			PropertyAddress,
			Saleprice,
			Saledate,
			legalreference
	ORDER BY 
			uniqueID
			) row_num
	from NashilleData
)
-----------------------------------------------------------------------------------------------------------------
--DELETE 
--from RowNumCTE
--where row_num > 1
----order by propertyaddress

SELECT *
from rownumcte
where row_num > 1
order by propertyaddress


--DELETING UNUSED COLUMNS

SELECT *
from NashilleData

ALTER TABLE Nashilledata
DROP COLUMN owneraddress, Taxdistrict,propertyaddress 

ALTER TABLE Nashilledata
DROP COLUMN newowneraddress ,ownernewcity, ownernewstate, salesdateconverted

ALTER TABLE Nashilledata
DROP COLUMN saledate

--The data is now clean for use. 

--PROJECT WALK THROUGH 

--Using the convert query we changed the date format,and populated the property address
--then separated the property address into ( Address, City and State) using the SUBSTRING,CHARINDEX AND PARSE FUNCTIONS
--then employing case statements I changed Y to Yes and N to No, 
--IN Removing duplicates I used Common tables expression (CTE), RowNumbers,and partition by functions.
--then finally I deleted inoperable columns using the Alter table and drop column function.  

--------------------------------------------Bienvenue !                    

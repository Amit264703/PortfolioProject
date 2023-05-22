/*

Cleaning data in SQL Queries

*/

select * from
PortfolioProject.dbo.NationalHousing

/* 

Standardize the date format

*/

select SalesDateConverted
from PortfolioProject.dbo.NationalHousing

--update PortfolioProject.dbo.NationalHousing
--set SaleDate = Convert(Date, SaleDate)

Alter Table PortfolioProject.dbo.NationalHousing
Add SalesDateConverted Date;

update PortfolioProject.dbo.NationalHousing
set SalesDateConverted = Convert(Date, SaleDate)



-- Populate Property Address Date

select PropertyAddress
from PortfolioProject.dbo.NationalHousing


/* Populate Property address date */


select *
from PortfolioProject.dbo.NationalHousing
--where PropertyAddress is Null
order by ParcelID



select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL( a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NationalHousing a
Join PortfolioProject.dbo.NationalHousing b 
	on a.ParcelId = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null

update a
set PropertyAddress = ISNULL( a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NationalHousing a
Join PortfolioProject.dbo.NationalHousing b 
	on a.ParcelId = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null



--- Breaking the address into individual columns

select PropertyAddress
from PortfolioProject.dbo.NationalHousing

select
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as Address
from PortfolioProject.dbo.NationalHousing


Alter Table PortfolioProject.dbo.NationalHousing
Add PropertySplitAddress Varchar(255);

update PortfolioProject.dbo.NationalHousing
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


Alter Table PortfolioProject.dbo.NationalHousing
Add PropertySplitCity Varchar(255);

update PortfolioProject.dbo.NationalHousing
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))

select *
from PortfolioProject.dbo.NationalHousing


select *
from PortfolioProject.dbo.NationalHousing

select
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NationalHousing

Alter Table PortfolioProject.dbo.NationalHousing
Add OwnerSplitAddress Varchar(255);

update PortfolioProject.dbo.NationalHousing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table PortfolioProject.dbo.NationalHousing
Add OwnerSplitCity Varchar(255);

update PortfolioProject.dbo.NationalHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table PortfolioProject.dbo.NationalHousing
Add OwnerySplitState Varchar(255);

update PortfolioProject.dbo.NationalHousing
set OwnerySplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


-- Changing the Y and N into yes and no

select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.NationalHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END
from PortfolioProject.dbo.NationalHousing

update PortfolioProject.dbo.NationalHousing 
SET SoldAsVacant = case when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END


-- Removing Duplicates

WITH RowNumCTE As(
select *,
	ROW_NUMBER() Over (
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueID
						) row_num
from PortfolioProject.dbo.NationalHousing
--Order By ParcelID
)
Delete 
from RowNumCTE
where row_num >1
--Order By PropertyAddress


--Deleting The columns
Alter table PortfolioProject.dbo.NationalHousing
Drop Column OwnerAddress, PropertyAddress, TaxDistrict

Alter table PortfolioProject.dbo.NationalHousing
Drop Column SaleDate

select * from PortfolioProject.dbo.NationalHousing
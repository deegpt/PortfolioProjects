
select * from PortfolioProject..NashvilleHousing


-------------------------------------------------------------------------------------------------
-- Standardize Date Format

Select SaleDateConverted, CONVERT(date,SaleDate)
from PortfolioProject..NashvilleHousing


ALTER Table NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)


------------------------------------------------------------------------------------------------

-- Populate Property Address Data

select *
from PortfolioProject.dbo.NashvilleHousing
-- where PropertyAddress is null
order by PropertyAddress


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]



----------------------------------------------------------------------------------------------------------

-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (Address,City, State)


select PropertyAddress
from PortfolioProject..NashvilleHousing
-- where PropertyAddress is null
-- order by PropertyAddress

-- For this we will use SUBSTRING

select
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as City

from PortfolioProject..NashvilleHousing

ALTER Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

select * 
from PortfolioProject..NashvilleHousing



------------------------------------------------------------------------------------------------------

-- Splitting Owner Address

select OwnerAddress 
from PortfolioProject..NashvilleHousing

select
PARSENAME(Replace(OwnerAddress, ',', '.') ,3)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,2)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,1)
from PortfolioProject..NashvilleHousing



ALTER Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.') ,3)

ALTER Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.') ,2)

ALTER Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.') ,1)

select * 
from PortfolioProject..NashvilleHousing



----------------------------------------------------------------------------------------------------------

-- Change Y and N to yes and no in "SoldAsVacant" column

select distinct (SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2



select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
  Else SoldAsVacant
  End
from PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject..NashvilleHousing
Set SoldAsVacant =  CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
  Else SoldAsVacant
  End



  ----------------------------------------------------------------------------------------------------

  -- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select*
From PortfolioProject.dbo.NashvilleHousing






--------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select*
From PortfolioProject.dbo.NashvilleHousing	

ALTER TABLE  PortfolioProject.dbo.NashvilleHousing	
DROP COLUMN PropertyAddress, SaleDate, TaxDistrict, OwnerAddress
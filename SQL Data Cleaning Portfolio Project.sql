/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject.dbo.NashvilleHousing


--Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate) 
From PortfolioProject.dbo.NashvilleHousing


UPDATE PortfolioProject.dbo.NashvilleHousing 
Set SaleDate = CONVERT(Date, SaleDate)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date;


UPDATE PortfolioProject.dbo.NashvilleHousing 
Set SaleDateConverted = CONVERT(Date, SaleDate)


-------------------------------------------------------------------------------------------------------------------------

--Populate Proprerty Adress Data

Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID 
	AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


UPDATE a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID 
	AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------------------
--Breaking out Address into Indidvidual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--Order by ParcelID

SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))as Address
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress nvarchar(255);


UPDATE PortfolioProject.dbo.NashvilleHousing 
Set PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity nvarchar(255);


UPDATE PortfolioProject.dbo.NashvilleHousing 
Set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.NashvilleHousing


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress nvarchar(255);


UPDATE PortfolioProject.dbo.NashvilleHousing 
Set OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity nvarchar(255);


UPDATE PortfolioProject.dbo.NashvilleHousing 
Set OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState nvarchar(255);


UPDATE PortfolioProject.dbo.NashvilleHousing 
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)


Select *
From PortfolioProject.dbo.NashvilleHousing


-------------------------------------------------------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "sold as Vacant" field


Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
,CASE When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  END
From PortfolioProject.dbo.NashvilleHousing



Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant= CASE When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  END

---------------------------------------------------------------------------------------------------------------------------------- 

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
ROW_NUMBER () OVER (
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice, 
			 SaleDate,
			 LegalReference
			 ORDER BY 
			   UniqueID
			   ) Row_Num
From PortfolioProject.dbo.NashvilleHousing
--Order By Parcel ID
)
Select*
From RowNumCTE
Where Row_Num > 1
--Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing




-------------------------------------------------------------------------------------------------------------------------------
--Delete Unused Columns


Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate
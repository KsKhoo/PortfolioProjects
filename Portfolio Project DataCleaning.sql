/* Data Cleaning

*/

SELECT * FROM NashvilleHousing;

-- Standardize Date Format

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate);

SELECT SaleDateConverted, CONVERT(DATE, SaleDate)
FROM NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address Data, so no PropertyAddress Data is NULL after updated the table

SELECT PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress IS NULL;

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashvilleHousing AS A
JOIN NashvilleHousing AS B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL;

UPDATE A  
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashvilleHousing AS A
JOIN NashvilleHousing AS B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ];

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Street, City, State) from Property Address

SELECT PropertyAddress
FROM NashvilleHousing;

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing --Add a new column PropertyStreet and input data into it
ADD PropertyStreet NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertyStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE NashvilleHousing --Add a new column PropertyCity and input data into it
ADD PropertyCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)); 

SELECT * FROM NashvilleHousing

--Looking at owner address, and using PARSENAME to breakout owneraddress into individual columns

SELECT OwnerAddress
FROM NashvilleHousing

SELECT --Breaking out owneraddress into seperate columns
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing --add column and into data
ADD OwnerStreet NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3); 

ALTER TABLE NashvilleHousing --add column and into data
ADD OwnerCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2); 

ALTER TABLE NashvilleHousing --add column and into data
ADD OwnerState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1); 

SELECT * FROM NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in 'SoldasVacant' field

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing

UPDATE NashvilleHousing --Update SoldAsVacant by using Case statement and Change Y and N to Yes and No in 'SoldasVacant' field
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicate values

SELECT * FROM NashvilleHousing

WITH RowNumCTE AS(  --DELETE duplicats
SELECT * , 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) AS RowNumber
FROM NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE RowNumber > 1;


WITH RowNumCTE AS( --Check see its removed or not
SELECT * , 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) AS RowNumber
FROM NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE RowNumber > 1;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT * 
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate



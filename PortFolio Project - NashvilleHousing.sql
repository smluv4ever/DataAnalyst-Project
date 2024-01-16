-- Cleaning the Data with SQL

-- Standardizing the Date Format
SELECT SaleDate--, CONVERT(date, SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)

-- Above command was affected, but the value didn't really change to the date format
-- Adding a new column for SaleDate with date format

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

SELECT SaleDateConverted
FROM NashvilleHousing

-- Populate Address
-- Check Null values

SELECT * 
FROM NashvilleHousing

SELECT PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM NashvilleHousing AS a
	JOIN NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing AS a
	JOIN NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null

-- Update Null values for PropertyAddress
UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing AS a
	JOIN NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing AS a
	JOIN NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null

-- Breaking out PropertyAddress into Individual Columns (Address, City)

SELECT PropertyAddress
FROM NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress+2), LEN(PropertyAddress)) AS City
FROM NashvilleHousing

-- Adding 2 new columns

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
	PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+2, LEN(PropertyAddress))
FROM NashvilleHousing

-- Breaking out OwnerAddress into Individual Columns (Address, City, State)
SELECT OwnerAddress
FROM NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing

-- ADD 3 columns for Owner Address, City, and State
ALTER TABLE NashvilleHousing
ADD 
	OwnerSplitAddress nvarchar(255),
	OwnerSplitCity nvarchar(255),
	OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)),
	OwnerSplitCity = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)),
	OwnerSplitState = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1))
FROM NashvilleHousing

SELECT * 
FROM NashvilleHousing

-- Update Values for SoldAsVacant to Yes/No
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) AS count
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY count DESC

SELECT SoldAsVacant,
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END
FROM NashvilleHousing

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) AS count
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY count DESC

-- Delete Unused Columns

SELECT * 
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate, TaxDistrict


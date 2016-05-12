-- Run GenerateQestUUID to finalise the QestUUID column on qestReverseLookup
-- This has been separated to its own file to ensure it is run after all relevant tables have had their QestUUIDs generated and copied into qestReverseLookup (where missing)
EXEC qest_GenerateQestUUID 'qestReverseLookup'
GO

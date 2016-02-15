
-- Requisites: 
--		QestID columns exists for specimen tables

IF OBJECT_ID('TR_DocumentAtterbergLimitsSpecimen_RL', 'TR') IS NOT NULL
	DROP TRIGGER TR_DocumentAtterbergLimitsSpecimen_RL
GO

CREATE TRIGGER TR_DocumentAtterbergLimitsSpecimen_RL
ON DocumentAtterbergLimitsSpecimen AFTER INSERT, DELETE
AS	
	-- Update QestID based on LiquidLimitSpecimen value
    UPDATE DocumentAtterbergLimitsSpecimen 
    SET QestID = CASE WHEN S.LiquidLimitSpecimen = 1 THEN 111000 ELSE 111001 END
    FROM DocumentAtterbergLimitsSpecimen S
    WHERE S.QestUniqueID IN (SELECT QestUniqueID FROM inserted)
GO


IF OBJECT_ID('TR_DocumentAtterbergLimitsCPSpecimens_RL', 'TR') IS NOT NULL
	DROP TRIGGER TR_DocumentAtterbergLimitsCPSpecimens_RL
GO

CREATE TRIGGER TR_DocumentAtterbergLimitsCPSpecimens_RL
ON DocumentAtterbergLimitsCPSpecimens AFTER INSERT, DELETE
AS
	-- Update QestID based on LiquidLimitSpecimen value
    UPDATE DocumentAtterbergLimitsCPSpecimens 
    SET QestID = CASE WHEN S.Flag = 1 THEN 111003 ELSE 111002 END
    FROM DocumentAtterbergLimitsCPSpecimens S
    WHERE S.QestUniqueID IN (SELECT QestUniqueID FROM inserted)
GO

-- =============================================
-- Author: Abigail Davies
-- Create date: 10/11/2021
-- Description:	Copies data from thardata.dbo.JobOperation into gardners.dbo.PlanningData and exports csv file to DocCentral.
-- SQL job running the s.proc every 12 hours at 06:00 and 18:00.
-- =============================================

CREATE PROCEDURE UpdatePlanningDataFromTharstern
	
AS
BEGIN	
		DECLARE @Todate datetime
		declare @FromDate datetime

		set @FromDate = getdate()
		SET @ToDate = dateadd(hh,12,getdate())


-- STEP 1: Copy data from tharstern into PlanningData


	SET NOCOUNT ON;

		INSERT INTO [Gardners].[dbo].[PlanningData] 
				(
					[ID],[JobID],[JobNo],[SectionID],[ResourceID],[Name],[Code],[StartOp],[EndOp],
					[Duration],[MakeReadyElement],[Status],[Type],[QtyRequired],[OrigDuration],[EstimateID],
					[OperationSplit],[Efficiency],[EstRunSpeed],[FinishedSize],[OrigCostCentre]
					)
		(
		SELECT ID,
				JobID,
				JobNo,
				SectionID,
				ResourceID,
				Name,
				Code,
				StartOp,
				EndOp,
				Duration,
				MakeReadyElement,
				Status,
				Type,
				QtyRequired,
				OrigDuration,
				EstimateID,
				OperationSplit,
				Efficiency,
				EstRunSpeed,
				FinishedSize,
				OrigCostCentre
			FROM [thardata].[dbo].[JobOperation]
			where Status = 2
			and StartOp >= @FromDate and StartOp <= @Todate
			)
	END
GO


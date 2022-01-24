Create Procedure SavePlanningDataToCSV
as
BEGIN
		DECLARE @Todate datetime
		declare @FromDate datetime
		set @FromDate = getdate()
		SET @ToDate = dateadd(hh,12,getdate())

		select * from PlanningData
		where  StartOp >= @FromDate and StartOp <= @Todate
	END
GO
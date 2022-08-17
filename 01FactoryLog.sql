DECLARE @StartShift datetime
DECLARE @EndShift datetime

SET @StartShift = '2022-01-19T06:00:00.000'
SET @EndShift = '2022-01-20T05:59:00.000'

SELECT m.MachineName,    TSE.ID AS LogID,
	(convert(varchar,tse.StartDateAndTime,103) + ' ' + substring(convert (varchar,tse.StartDateAndTime,108),1,5)) as StartDateTime, 
	(convert(varchar,tse.SysDate,103) + ' ' + substring(convert (varchar,tse.SysDate,108),1,5)) as FinishDateTime, TSE.JobNo, TSE.OperationDesc AS Operation, 
                      TSE.OperatorName, TSE.Quantity AS QuantityLogged, TSE.Comments AS OperatorComments, MED.CustomerName, MED.Ref6 AS EndCustomer, 
                      MED.JobTypeDesc AS Product, MED.Quantity AS QuantityOrdered

into #TempFactoryResults
FROM         data1.dbo.TimeSheetEntries AS TSE INNER JOIN
             data1.dbo.MainEstimateDetails AS MED ON TSE.JobNo = MED.JobCreated INNER JOIN
             data1.dbo.JobOperation AS JO ON TSE.JobOperationID = JO.ID inner join
	     data2.dbo.MachineCodes$ M on m.Code = tse.Operation

WHERE     (TSE.OperationDesc LIKE '%IDC%')
AND tse.StartDateAndTime >= @StartShift AND tse.StartDateAndTime <= @EndShift
GROUP BY m.MachineName, TSE.ID, TSE.StartDateAndTime, TSE.SysDate, TSE.OperationLength, TSE.JobNo, TSE.OperationDesc, TSE.OperatorName, TSE.Quantity, TSE.Comments, 
                      MED.CustomerName, MED.Ref6, MED.JobTypeDesc, MED.Quantity, JO.ID

alter table #TempFactoryResults
add [EstimatedTime] decimal(8,2)

update #TempFactoryResults set EstimatedTime = 
(select sum(OperationLength) as TotalTime
from data1.dbo.TimeSheetEntries T
inner join data2.dbo.MachineCodes$ M on T.Operation = m.Code AND M.CodeType='Activity'
where t.JobNo = #TempFactoryResults.JobNo
and PostingType=1
and #TempFactoryResults.MachineName = m.MachineName
group by m.OperationType,PostingType, M.MachineName
)


select * from #TempFactoryResults
order by StartDateTime
drop table #TempFactoryResults

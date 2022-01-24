use master

declare @SQL varchar(8000)

declare @FileName varchar(500)

declare @FilePath varchar(150)
set @FilePath = 'c:\adtest\'

set @FileName = 'PlanningData_' + convert(varchar,getdate(),102) + '_' + replace((RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,getdate(),100),8)),7)),':','')
set @FileName = @FilePath + @FileName + '.csv'
print @filename


set @SQL = 'bcp "exec Gardners.dbo.SavePlanningDataToCSV" queryout ' + @FileName + ' -c -t, -T -S' + @@ServerName


exec master..xp_cmdshell @sql
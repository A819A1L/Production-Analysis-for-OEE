SELECT * FROM [Gardners].dbo.[PlanningData]
where StartOp >= '2022-01-19T06:00:00.000'
	--cast(StartOp as date) = cast(getdate() as date) -- 'today' or getdate()-1 'yesterday'
order by Name

--JobOperation.Status:
--0 - Unplanned
--1 - Lifted
--2 - Planned
--3 - Started (running)
--4 - Stopped (interrupted)
--5 - Finished
--6 - External (almost never encountered)
--7 - Purged (almost never encountered)
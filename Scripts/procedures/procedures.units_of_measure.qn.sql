
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[qest_AddUnitOfMeasure]') AND type in (N'P', N'PC'))
exec('create proc [dbo].[qest_AddUnitOfMeasure] as select 0 tmp');
GO

alter proc [dbo].[qest_AddUnitOfMeasure]
  @quantity nvarchar(16),
  @code nvarchar(16),
  @slope float,
  @offset float = 0.0,
  @description nvarchar(50) = null,
  @symbol nvarchar(10) = null
as
set nocount on;
begin transaction
begin try
  if @slope <= 0
  begin
    raiserror('@factor must be > 0', 16, 1);
  end
  if @quantity in ('', 'convert')
  begin
    raiserror('Invalid quantity ''%s''', 16, 1, @quantity);
  end

  declare @altCode nvarchar(10);
  select @altCode = REPLACE(REPLACE(REPLACE(REPLACE(@code, '°', ''), '²', '2'), '³', '3'), 'µ', 'u');

  if exists (select * from QestUnitOfMeasure where Quantity = @quantity and Code = @code)
  begin
    raiserror('Updating existing unit of measure ''%s''', 10, 1, @code);
    if @altCode <> '' and exists
    (
      select * from QestUnitOfMeasure alt 
      inner join QestUnitOfMeasure orig on alt.Quantity = orig.Quantity and alt.Symbol = orig.Symbol and alt.Description = orig.Description and alt.Slope = orig.Slope and alt.Offset = orig.Offset
      where alt.Quantity = @quantity and alt.Code = @altCode and orig.Code = @code
    )
    begin
      update QestUnitOfMeasure 
        set Description = @description
          , Symbol = coalesce(@symbol, @code)
          , Slope = @slope
          , Offset = @offset
        where Quantity = @quantity and Code = @altCode;
    end

    update QestUnitOfMeasure 
      set Description = @description
        , Symbol = coalesce(@symbol, @code)
        , Slope = @slope
        , Offset = @offset
      where Quantity = @quantity and Code = @code;
  end
  else
  begin
    raiserror('Adding new unit of measure ''%s''', 10, 1, @code);
    insert into QestUnitOfMeasure(Quantity, Code, Symbol, Description, Slope, Offset) 
      values (@quantity, @code, coalesce(@symbol, @code), @description, @slope, @offset);
    
    if @altCode <> '' and not exists(select * from QestUnitOfMeasure where Quantity = @quantity and Code = @altCode)
    begin
      insert into QestUnitOfMeasure(Quantity, Code, Symbol, Description, Slope, Offset) 
        values (@quantity, @altCode, coalesce(@symbol, @code), @description, @slope, @offset);
    end
  end

  
  declare @sql_to_execute nvarchar(max);
  declare curQuantity cursor fast_forward for select distinct UPPER(SUBSTRING(Quantity, 1, 1)) + SUBSTRING(Quantity, 2, 16) from QestUnitOfMeasure where Quantity is not null;
  declare @quantityName nvarchar(16);
  open curQuantity;
  fetch next from curQuantity into @quantityName;
  while @@FETCH_STATUS = 0
  begin
    set @sql_to_execute = 
    case 
      when exists (select * from sys.objects where object_id = object_id('[dbo].' + QUOTENAME('uom' + @quantityName)) and type in (N'FN', N'IF', N'TF', N'FS', N'FT')) then 'alter'
      else 'create' 
    end + ' function [dbo].' +  QUOTENAME('uom' + @quantityName) + '
(
  @value real,
  @uom nvarchar(16)
) 
returns real
as
begin
  return (select cast((cast(@value as float) - Offset) / Slope as real) from QestUnitOfMeasure where Quantity = ''' + REPLACE(@quantityName, '''', '''''') + ''' and Code = @uom);
end'
    exec(@sql_to_execute);

    fetch next from curQuantity into @quantityName;
  end
  close curQuantity
  deallocate curQuantity
  commit
end try
begin catch
  declare @errLine int, @errMessage nvarchar(max), @errNumber int, @errProcedure sysname, @errSeverity int, @errState int;
  select @errLine = ERROR_LINE(), @errMessage = ERROR_MESSAGE(), @errNumber = ERROR_NUMBER(), @errProcedure = ERROR_PROCEDURE(), @errSeverity = ERROR_SEVERITY(), @errState = ERROR_STATE()
  rollback
  
  IF CURSOR_STATUS('global','curQuantity')>=-1
  BEGIN
    deallocate curQuantity
  END
  
  raiserror(N'Unable to add unit of measure ''%s'' - ''%s''
Error Number: %d
Error Line: %d
Error Procedure: %s
Error Message: %s', @errSeverity, @errState, @quantity, @symbol, @errNumber, @errLine, @errProcedure, @errMessage)

end catch
GO

if not exists (select * from sys.objects where object_id = object_id('[dbo].[uomConvert]') and type in (N'FN', N'IF', N'TF', N'FS', N'FT')) 
exec('create function [dbo].[uomConvert]() returns real as begin return 0.0 end;');
GO
alter function [dbo].[uomConvert]
(
  @value real,
  @quantity nvarchar(16),
  @from nvarchar(16) = null,
  @to nvarchar(16) = null
) 
returns real
as
begin
  --converts a value from one unit of measure to another.
  --e.g. select [dbo].[uomConvert](35, 'length', 'mm', default); --converts 35mm to SI base units
  --e.g. select [dbo].[uomConvert](40.6, 'length', 'mm', 'in'); --converts 40.6 millimetres to inches
  
  declare @fromSlope float, @fromOffset float, @toSlope float, @toOffset float;
  if @from is null
    select @fromSlope = 1.0, @fromOffset = 0.0;
  else
    select @fromSlope = Slope, @fromOffset = Offset from QestUnitOfMeasure where Quantity = @quantity and Code = @from;
  if @to is null
    select @toSlope = 1.0, @toOffset = 0.0;
  else
    select @toSlope = Slope, @toOffset = Offset from QestUnitOfMeasure where Quantity = @quantity and Code = @to;

  return cast((( cast(@value as float) * @fromSlope ) + @fromOffset - @toOffset) / @toSlope as real);
end
GO

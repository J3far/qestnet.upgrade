exec dbo.qest_AddUnitOfMeasure @quantity = 'length', @code = 'nm', @slope = 0.000000001, @description = 'nanometre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'length', @code = 'µm', @slope = 0.000001, @description = 'micrometre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'length', @code = 'mm', @slope = 0.001, @description = 'millimetre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'length', @code = 'cm', @slope = 0.01, @description = 'centimetre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'length', @code = 'dm', @slope = 0.1, @description = 'decimetre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'length', @code = 'm', @slope = 1, @description = 'metre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'length', @code = 'km', @slope = 1000, @description = 'kilometre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'length', @code = 'in', @slope = 0.0254, @description = 'inch';
exec dbo.qest_AddUnitOfMeasure @quantity = 'length', @code = 'ft', @slope = 0.3048, @description = 'foot';
exec dbo.qest_AddUnitOfMeasure @quantity = 'length', @code = 'yd', @slope = 0.9144, @description = 'yard';

exec dbo.qest_AddUnitOfMeasure @quantity = 'area', @code = 'mm²', @slope = 0.000001, @description = 'square millimetre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'area', @code = 'cm²', @slope = 0.0001, @description = 'square centimetre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'area', @code = 'dm²', @slope = 0.01, @description = 'square decimetre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'area', @code = 'm²', @slope = 1, @description = 'square metre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'area', @code = 'in²', @slope = 0.00064516, @description = 'square inch';         -- 0.0254 * 0.0254
exec dbo.qest_AddUnitOfMeasure @quantity = 'area', @code = 'ft²', @slope = 0.09290304, @description = 'square foot';         -- 0.3048 * 0.3048
exec dbo.qest_AddUnitOfMeasure @quantity = 'area', @code = 'yd²', @slope = 0.83612736, @description = 'square yard';         -- 0.9144 * 0.9144

exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'cm³', @slope = 0.000001, @description = 'cubic centimetre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'dm³', @slope = 0.001, @description = 'cubic decimetre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'm³', @slope = 1, @description = 'cubic metre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'ml', @slope = 0.000001, @description = 'millilitre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'l', @slope = 0.001, @description = 'litre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'kl', @slope = 1, @description = 'kilolitre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'in³', @slope = 0.000016387064, @description = 'cubic inch';     -- 0.0254 * 0.0254 * 0.0254
exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'ft³', @slope = 0.0283168, @description = 'cubic foot';          -- 0.3048 * 0.3048 * 0.3048
exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'yd³', @slope = 0.764554858, @description = 'cubic yard';        -- 0.9144 * 0.9144 * 0.9144
exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'floz', @slope = 0.000029573529562, @description = 'ounce (US)'; -- 231 * 0.0254 * 0.0254 * 0.0254 / (8 * 16) (16 ounces in a pint)
exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'pt', @slope = 0.000473176473, @description = 'pint (US)';       -- 231 * 0.0254 * 0.0254 * 0.0254 / 8        (8 pints in a gallon)
exec dbo.qest_AddUnitOfMeasure @quantity = 'volume', @code = 'gal', @slope = 0.003785411784, @description = 'gallon (US)';    -- 231 * 0.0254 * 0.0254 * 0.0254            (231 cubic inches)

exec dbo.qest_AddUnitOfMeasure @quantity = 'mass', @code = 'g', @slope = 0.001, @description = 'gram';
exec dbo.qest_AddUnitOfMeasure @quantity = 'mass', @code = 'kg', @slope = 1, @description = 'kilogram';
exec dbo.qest_AddUnitOfMeasure @quantity = 'mass', @code = 'T', @slope = 1000, @description = 'tonne (metric)';
exec dbo.qest_AddUnitOfMeasure @quantity = 'mass', @code = 'lb', @slope = 0.45359237, @description = 'pound';                 -- 0.45359237 by definition
exec dbo.qest_AddUnitOfMeasure @quantity = 'mass', @code = 'oz', @slope = 0.02834952312, @description = 'ounce';              -- 0.45359237 / 16
exec dbo.qest_AddUnitOfMeasure @quantity = 'mass', @code = 'st', @slope = 907.18474, @description = 'short ton (US)';         -- 2000 * 0.45359237

exec dbo.qest_AddUnitOfMeasure @quantity = 'density', @code = 'kg/m³', @slope = 1, @description = 'kilograms per cubic metre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'density', @code = 'Mg/m³', @slope = 1000, @description = 'megagrams per cubic metre';
exec dbo.qest_AddUnitOfMeasure @quantity = 'density', @code = 'lb/ft³', @slope = 16.01846337396013957965507, @description = 'pounds per cubic foot'; --(0.45359237 / (0.3048 * 0.3048 * 0.3048))
exec dbo.qest_AddUnitOfMeasure @quantity = 'density', @code = 'pcf', @slope = 16.01846337396013957965507, @description = 'pounds per cubic foot'; --(0.45359237 / (0.3048 * 0.3048 * 0.3048))

exec dbo.qest_AddUnitOfMeasure @quantity = 'temperature', @code = 'K', @slope = 1, @description = 'Kelvin';
exec dbo.qest_AddUnitOfMeasure @quantity = 'temperature', @code = '°C', @slope = 1, @offset = 273.15, @description = 'degrees Celsius';              --slope = 1, offset = 273.15 by definition
exec dbo.qest_AddUnitOfMeasure @quantity = 'temperature', @code = '°F', @slope = 0.55555555555555555555555555555555555556, @offset = 255.37222222222222222222222222222222222, @description = 'degrees Fahrenheit';   -- offset: 32°F == 0°C, slope : 1°C / 1.8°F

exec dbo.qest_AddUnitOfMeasure @quantity = 'force', @code = 'N', @slope = 1, @description = 'newton';
exec dbo.qest_AddUnitOfMeasure @quantity = 'force', @code = 'kN', @slope = 1000, @description = 'kilonewton';
exec dbo.qest_AddUnitOfMeasure @quantity = 'force', @code = 'lbf', @slope = 4.4482216152605, @description = 'pound (force)';    -- 0.45359237 * 9.80665 (pound mass * gravitational constant)

exec dbo.qest_AddUnitOfMeasure @quantity = 'pressure', @code = 'Pa', @slope = 1, @description = 'pascal';
exec dbo.qest_AddUnitOfMeasure @quantity = 'pressure', @code = 'kPa', @slope = 1000, @description = 'kilopascal';
exec dbo.qest_AddUnitOfMeasure @quantity = 'pressure', @code = 'MPa', @slope = 1000000, @description = 'megapascal';
exec dbo.qest_AddUnitOfMeasure @quantity = 'pressure', @code = 'psi', @slope = 6894.75729316836133672267344, @description = 'pounds per square inch';        -- (0.45359237 * 9.80665) / (0.0254 * 0.0254)
exec dbo.qest_AddUnitOfMeasure @quantity = 'pressure', @code = 'ksf', @slope = 47880.25898033584261612967670, @description = 'kilopounds per square foot';    -- (1000 * 0.45359237 * 9.80665) / (0.3048 * 0.3048)

exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'ms', @slope = 0.001, @description = 'millisecond';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 's', @slope = 1, @description = 'second';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'sec', @symbol = 's', @slope = 1, @description = 'second';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'second', @symbol = 's', @slope = 1, @description = 'second';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'min', @symbol = 'min', @slope = 60, @description = 'minute';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'minute', @symbol = 'min', @slope = 60, @description = 'minute';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'h', @symbol = 'h', @slope = 3600, @description = 'hour';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'hr', @symbol = 'h', @slope = 3600, @description = 'hour';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'hour', @symbol = 'h', @slope = 3600, @description = 'hour';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'd', @symbol = 'day', @slope = 86400, @description = 'day';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'day', @symbol = 'day', @slope = 86400, @description = 'day';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'yr', @symbol = 'yr', @slope = 31536000, @description = '''normal'' year (365 days)';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'year', @symbol = 'yr', @slope = 31536000, @description = '''normal'' year (365 days)';
exec dbo.qest_AddUnitOfMeasure @quantity = 'time', @code = 'year365', @symbol = 'yr', @slope = 31536000, @description = '''normal'' year (365 days)';

declare @pi float, @deg float, @grad float, @gradSymbol nvarchar(6);
set @pi = 3.1415926535897932384626433832795028842;
set @deg = 2 * @pi / 360;
set @grad = 2 * @pi / 400;
set @gradSymbol = NCHAR(0x1DA2);
exec dbo.qest_AddUnitOfMeasure @quantity = 'angle', @code = 'rad', @slope = 1, @description = 'radian';
exec dbo.qest_AddUnitOfMeasure @quantity = 'angle', @code = 'deg', @slope = @deg, @description = 'degree';
exec dbo.qest_AddUnitOfMeasure @quantity = 'angle', @code = '°', @slope = @deg, @description = 'degree';
exec dbo.qest_AddUnitOfMeasure @quantity = 'angle', @code = 'g', @symbol=@gradSymbol, @slope = @grad, @description = 'gradian';
exec dbo.qest_AddUnitOfMeasure @quantity = 'angle', @code = 'gon', @symbol=@gradSymbol, @slope = @grad, @description = 'gradian';

exec dbo.qest_AddUnitOfMeasure @quantity = 'rate', @code = '/s', @slope = 1, @description = 'unit per second';
exec dbo.qest_AddUnitOfMeasure @quantity = 'rate', @code = '/hr', @slope = 0.000277777777777777777777777777777778, @description = 'unit per hour';        -- 1 / (60 * 60)
exec dbo.qest_AddUnitOfMeasure @quantity = 'rate', @code = '%/hr', @slope = 0.00000277777777777777777777777777777778, @description = 'percent per hour';  -- 1 / (60 * 60 * 100)


--parts-per notation (percent etc)
declare @permilleSymbol nvarchar(6), @permyriadSymbol nvarchar(6);
set @permilleSymbol = nchar(0x2030)
set @permyriadSymbol = nchar(0x2031);
exec dbo.qest_AddUnitOfMeasure @quantity = 'ratio', @code = '%', @slope = 0.01, @description = 'parts per hundred (percent)';
exec dbo.qest_AddUnitOfMeasure @quantity = 'ratio', @code = @permilleSymbol, @slope = 0.001, @description = 'parts per thousand  (permille)';
exec dbo.qest_AddUnitOfMeasure @quantity = 'ratio', @code = @permyriadSymbol, @slope = 0.0001, @description = 'parts per ten thousand  (permyriad)';
exec dbo.qest_AddUnitOfMeasure @quantity = 'ratio', @code = 'ppm', @slope = 0.000001, @description = 'parts per million';

exec dbo.qest_AddUnitOfMeasure @quantity = 'speed', @code = 'in/min', @slope = 1.52400000155448, @description = 'Inches per minute'; -- 2362.2047244094
exec dbo.qest_AddUnitOfMeasure @quantity = 'speed', @code = 'mm/min', @slope = 0.06, @description = 'Millimetres per minute'; --60000

exec dbo.qest_AddUnitOfMeasure @quantity = 'revrate', @code = '°/min', @slope =0.00004629630357142857 , @description = 'Degrees per minute';

exec dbo.qest_AddUnitOfMeasure @quantity = 'torque', @code = 'N·m', @slope = 1, @description = 'Newton metres';
exec dbo.qest_AddUnitOfMeasure @quantity = 'torque', @code = 'lbf·ft', @slope = 1.35581795, @description = 'Foot pounds';

declare @NmPerDegree float, @lbftPerDegree float;
set @NmPerDegree = 180 / @pi;
set @lbftPerDegree = 1.35581795 * 180 / @pi;
exec dbo.qest_AddUnitOfMeasure @quantity = 'torque', @code = 'N·m/°', @slope = @NmPerDegree, @description = 'Newton metres per degree'; --'base unit 'N.m/rad'
exec dbo.qest_AddUnitOfMeasure @quantity = 'torque', @code = 'lbf·ft/°', @slope = @lbftPerDegree, @description = 'Foot pounds per degree';

--Miscellanous units of measure -- these are NOT units of measure for the same quantity, so be careful when converting from one unit in this group to another.
exec dbo.qest_AddUnitOfMeasure @quantity = 'miscellaneous', @code = 'm²/yr', @slope = 0.0000000317097919837645865043125, @description = 'Coefficient of Consolidation (m²/yr)';       -- 1 / 31536000
exec dbo.qest_AddUnitOfMeasure @quantity = 'miscellaneous', @code = 'ft²/yr', @slope = 0.0000000002945936073059360730593607, @description = 'Coefficient of Consolidation (ft²/yr)';  -- (0.3048 * 0.3048) / 31536000
exec dbo.qest_AddUnitOfMeasure @quantity = 'miscellaneous', @code = 'm²/MN', @slope = 0.000001, @description = 'Coefficient of Volume Compressibility (m²/MN)';                       -- 1 / 1000000
exec dbo.qest_AddUnitOfMeasure @quantity = 'miscellaneous', @code = 'ft²/lbf', @slope = 0.020885434233150126982210, @description = 'Coefficient of Compressibility (ft²/lbf)';        -- (0.3048 * 0.3048) / (0.45359237 * 9.80665)
exec dbo.qest_AddUnitOfMeasure @quantity = 'miscellaneous', @code = '°/kPa', @slope = 57295.7795, @description = 'Millimetres per minute';
exec dbo.qest_AddUnitOfMeasure @quantity = 'miscellaneous', @code = '°/ksf', @slope = 2743321.92246, @description = 'Millimetres per minute';




GO

/*

select [Usage] = 'select dbo.uom' + upper(substring(Quantity, 1, 1)) + substring(Quantity, 2, 16) + '(' + cast(CAST( ABS(CHECKSUM(NewId())) % 1000 / 100.0 as float) as nvarchar(4)) +  ', ''' + Code + ''')' from QestUnitOfMeasure 

*/


# TODO



# Data File Formats

## Key

$ - String
& - Boolean ("true" (not case sensitive) or 1 for true,
    anything else for false)
# - Number

Note: Commas are not necessary if you are excluding a variable.
Also, variables must appear in this order, so if you specify a
time or frames, you must specify everything preceding.

## Animation Set

<animname$>, [loopStart#], [loopEnd#], [bounces&]
<sourceX#>, <sourceY#>, [sourceWidth#], [sourceHeight#], [time#], [frames#]

Note: sourceWidth and sourceHeight should be set at least once.
Afterwards, the last values will be used respectively. If not
set, they will default to 16 and 16

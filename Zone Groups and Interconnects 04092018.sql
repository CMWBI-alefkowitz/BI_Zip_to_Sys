-----Relevant Tables-----
----mapping of local zones for zone group and interconnect spreading
--dbo.sys_to_zip_0409
----MLIZ mapping file for interconnect spreading
--dbo.mliz_mapping_0409
----zip code to citystate mapping
--select top 10 * from [dbo].[zipcode_mappings_0323]
----syscode to citystate mapping
--select top 10 * from [dbo].[System_Mappings_0322]


-----Zone Groups------

select zz.primary_zone_id
,z.code as primary_syscode
,z.name as primary_zone_name 
,zz.secondary_zone_id
,z2.code as secondary_syscode
,z2.name as secondary_zone_name 
--into #zg
from MEDIA_MONTHS MM
JOIN dbo.uvw_zone_universe z on (Z.start_date<=mm.start_date AND (Z.end_date>=mm.start_date OR Z.end_date IS NULL))
join [dbo].[uvw_zonezone_universe] zz on zz.primary_zone_id = z.ZONE_id AND (ZZ.start_date<=mm.start_date AND (ZZ.end_date>=mm.start_date OR ZZ.end_date IS NULL))
JOIN dbo.uvw_zone_universe z2 on z2.zone_id = zz.secondary_zone_id  and (z2.start_date<=mm.start_date AND (Z2.end_date>=mm.start_date OR Z2.end_date IS NULL))
where z.active = 1
and mm.id = 439
order by secondary_zone_id

--select top 10 * from dbo.sys_to_zip_0409

select distinct sz.dma_name
--,zg.primary_zone_id
,zg.primary_syscode
,zg.primary_zone_name
,sz.zipcode
from dbo.sys_to_zip_0409 sz
join #zg zg on zg.secondary_syscode = sz.syscode
--where sz.syscode = '0069'
order by zg.primary_syscode

-----Interconnects------

--select top 10 * from dbo.mliz_mapping_0409


select
m.[primary syscode] as primary_syscode
,z.name as primary_zone_name 
,m.[secondary syscode] as secondary_syscode
,z2.name as secondary_zone_name 
--into #ic
from MEDIA_MONTHS MM
JOIN dbo.uvw_zone_universe z on (Z.start_date<=mm.start_date AND (Z.end_date>=mm.start_date OR Z.end_date IS NULL))
join dbo.mliz_mapping_0409 m on m.[primary syscode] = z.code
JOIN dbo.uvw_zone_universe z2 on z2.code =  m.[secondary syscode]  and (z2.start_date<=mm.start_date AND (Z2.end_date>=mm.start_date OR Z2.end_date IS NULL))
where z.active = 1
and mm.id = 439
order by m.[secondary syscode]


select distinct sz.dma_name
,ic.primary_syscode
,ic.primary_zone_name
,sz.zipcode
from dbo.sys_to_zip_0409 sz
join #ic ic on ic.secondary_syscode = sz.syscode
--where sz.syscode = '0069'
order by ic.primary_syscode


select * from #ic where primary_syscode = '0284'


select * from zones where active=1 and type='Interconnect'

-----Checking to find if the missing citystate for a mapping exists in the data or not------
select * from 
[dbo].[zipcode_mappings_0323] where citystate like '%district%'


select * from zones z
join zone_dmas zd on z.id=zd.zone_id
join dmas d on d.id = zd.dma_id
where z.name like '%district%'
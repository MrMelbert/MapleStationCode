//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\generic\CentCom.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\debug\multiz.dmm"
		#include "map_files\debug\runtimestation.dmm"
		#include "map_files\Deltastation\DeltaStation2.dmm"
		#include "map_files\IceBoxStation\IceBoxStation.dmm"
		#include "map_files\KiloStation\KiloStation.dmm"
		#include "map_files\Limastation\limastation.dmm"
		#include "map_files\MetaStation\MetaStation.dmm"
		#include "map_files\Mining\Lavaland.dmm"
		#include "map_files\NebulaStation\NebulaStation.dmm"
		#include "map_files\NorthStar\north_star.dmm"
		#include "map_files\PubbyStation\PubbyStation.dmm"
		#include "map_files\tramstation\tramstation.dmm"
	#endif
	#ifdef ALL_TEMPLATES
		#include "templates.dm"
	#endif
#endif
